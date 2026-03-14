//
//  MIDIManager.swift
//  Torso S4 Controller
//
//  MIDI device enumeration, selection, and message sending
//

import Foundation
import CoreMIDI

@MainActor
class MIDIManager: ObservableObject {
    @Published var outputDevices: [MIDIDevice] = []
    @Published var inputDevices: [MIDIDevice] = []
    @Published var isConnected: Bool = false
    @Published var selectedOutputID: Int?
    @Published var selectedOutputName: String = "None"

    private var midiClient: MIDIClientRef = 0
    private var outputPort: MIDIPortRef = 0

    struct MIDIDevice: Identifiable, Equatable {
        let id: Int
        let name: String
        let endpointRef: MIDIEndpointRef
    }

    init() {
        setupMIDI()
    }

    private func setupMIDI() {
        var client: MIDIClientRef = 0
        let clientStatus = MIDIClientCreate("S4Controller" as CFString, nil, nil, &client)

        guard clientStatus == noErr else {
            print("Failed to create MIDI client: \(clientStatus)")
            return
        }

        midiClient = client

        var port: MIDIPortRef = 0
        let portStatus = MIDIOutputPortCreate(midiClient, "S4Controller Out" as CFString, &port)

        guard portStatus == noErr else {
            print("Failed to create MIDI output port: \(portStatus)")
            return
        }

        outputPort = port
        updateDeviceList()
    }

    func updateDeviceList() {
        var outputs: [MIDIDevice] = []
        var inputs: [MIDIDevice] = []

        let destCount = MIDIGetNumberOfDestinations()
        for i in 0..<destCount {
            let endpoint = MIDIGetDestination(i)
            if endpoint != 0, let name = getMIDIDeviceName(endpoint) {
                outputs.append(
                    MIDIDevice(
                        id: Int(endpoint),
                        name: name,
                        endpointRef: endpoint
                    )
                )
            }
        }

        let sourceCount = MIDIGetNumberOfSources()
        for i in 0..<sourceCount {
            let endpoint = MIDIGetSource(i)
            if endpoint != 0, let name = getMIDIDeviceName(endpoint) {
                inputs.append(
                    MIDIDevice(
                        id: Int(endpoint),
                        name: name,
                        endpointRef: endpoint
                    )
                )
            }
        }

        outputDevices = outputs.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        inputDevices = inputs.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }

        print("MIDI outputs found:")
        outputDevices.forEach { print(" - \($0.name) [\($0.id)]") }

        autoSelectPreferredOutput()
    }

    func selectOutputDevice(id: Int?) {
        guard let id else {
            selectedOutputID = nil
            selectedOutputName = "None"
            isConnected = false
            print("Cleared MIDI output selection")
            return
        }

        guard let device = outputDevices.first(where: { $0.id == id }) else {
            selectedOutputID = nil
            selectedOutputName = "None"
            isConnected = false
            print("Failed to select MIDI output for id \(id)")
            return
        }

        selectedOutputID = device.id
        selectedOutputName = device.name
        isConnected = true
        print("Selected MIDI output: \(device.name) [\(device.id)]")
    }

    func sendControlChange(cc: UInt8, value: UInt8, channel: UInt8, toDeviceID deviceID: Int? = nil) {
        guard let endpoint = endpointForDevice(id: deviceID ?? selectedOutputID) else {
            print("No MIDI destination selected for CC send")
            return
        }

        let status = UInt8(0xB0 | channelNibble(channel))
        print("Sending CC -> device: \(selectedOutputName), channel: \(channel), cc: \(cc), value: \(value)")
        sendMessage(status: status, data1: sanitize7Bit(cc), data2: sanitize7Bit(value), to: endpoint)
    }

    func sendNoteOn(note: UInt8, velocity: UInt8, channel: UInt8, toDeviceID deviceID: Int? = nil) {
        guard let endpoint = endpointForDevice(id: deviceID ?? selectedOutputID) else {
            print("No MIDI destination selected for Note On send")
            return
        }

        let status = UInt8(0x90 | channelNibble(channel))
        print("Sending Note On -> device: \(selectedOutputName), channel: \(channel), note: \(note), velocity: \(velocity)")
        sendMessage(status: status, data1: sanitize7Bit(note), data2: sanitize7Bit(velocity), to: endpoint)
    }

    func sendNoteOff(note: UInt8, velocity: UInt8 = 0, channel: UInt8, toDeviceID deviceID: Int? = nil) {
        guard let endpoint = endpointForDevice(id: deviceID ?? selectedOutputID) else {
            print("No MIDI destination selected for Note Off send")
            return
        }

        let status = UInt8(0x80 | channelNibble(channel))
        print("Sending Note Off -> device: \(selectedOutputName), channel: \(channel), note: \(note), velocity: \(velocity)")
        sendMessage(status: status, data1: sanitize7Bit(note), data2: sanitize7Bit(velocity), to: endpoint)
    }

    private func autoSelectPreferredOutput() {
        if let selectedOutputID,
           let existing = outputDevices.first(where: { $0.id == selectedOutputID }) {
            selectedOutputName = existing.name
            isConnected = true
            print("Keeping MIDI output: \(existing.name)")
            return
        }

        if let s4 = outputDevices.first(where: {
            $0.name.localizedCaseInsensitiveContains("s-4")
            || $0.name.localizedCaseInsensitiveContains("torso")
        }) {
            selectedOutputID = s4.id
            selectedOutputName = s4.name
            isConnected = true
            print("Auto-selected MIDI output: \(s4.name) [\(s4.id)]")
            return
        }

        if let first = outputDevices.first {
            selectedOutputID = first.id
            selectedOutputName = first.name
            isConnected = true
            print("Auto-selected first MIDI output: \(first.name) [\(first.id)]")
            return
        }

        selectedOutputID = nil
        selectedOutputName = "None"
        isConnected = false
        print("No MIDI outputs available")
    }

    private func endpointForDevice(id: Int?) -> MIDIEndpointRef? {
        guard let id,
              let device = outputDevices.first(where: { $0.id == id }) else {
            return nil
        }
        return device.endpointRef
    }

    private func getMIDIDeviceName(_ ref: MIDIEndpointRef) -> String? {
        var unmanagedName: Unmanaged<CFString>?
        let status = MIDIObjectGetStringProperty(ref, kMIDIPropertyName, &unmanagedName)

        guard status == noErr, let unmanagedName else {
            return nil
        }

        return unmanagedName.takeRetainedValue() as String
    }

    private func sendMessage(status: UInt8, data1: UInt8, data2: UInt8, to endpoint: MIDIEndpointRef) {
        let bytes: [UInt8] = [status, data1, data2]
        let bufferSize = 1024

        let packetListPointer = UnsafeMutablePointer<MIDIPacketList>.allocate(capacity: 1)
        defer { packetListPointer.deallocate() }

        let packet = MIDIPacketListInit(packetListPointer)

        bytes.withUnsafeBufferPointer { buffer in
            guard let baseAddress = buffer.baseAddress else { return }

            _ = MIDIPacketListAdd(
                packetListPointer,
                bufferSize,
                packet,
                0,
                bytes.count,
                baseAddress
            )
        }

        let sendStatus = MIDISend(outputPort, endpoint, packetListPointer)
        if sendStatus != noErr {
            print("Failed to send MIDI message: \(sendStatus)")
        } else {
            print("MIDI send ok")
        }
    }

    private func sanitize7Bit(_ value: UInt8) -> UInt8 {
        min(value, 127)
    }

    private func channelNibble(_ channel: UInt8) -> UInt8 {
        let clamped = max(UInt8(1), min(UInt8(16), channel))
        return clamped - 1
    }

    deinit {
        if outputPort != 0 {
            MIDIPortDispose(outputPort)
        }

        if midiClient != 0 {
            MIDIClientDispose(midiClient)
        }
    }
}
