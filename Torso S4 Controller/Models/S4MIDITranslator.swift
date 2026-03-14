//
//  S4MIDITranslator.swift
//  Torso S4 Controller
//
//  Typed MIDI translation layer for Torso S-4 mappings
//

import Foundation

struct S4TranslatedCCMessage {
    let channel: UInt8
    let cc: UInt8
    let value: UInt8
    let label: String
}

struct S4TranslatedNoteMessage {
    let channel: UInt8
    let note: UInt8
    let velocity: UInt8
    let label: String
}

struct S4MIDITranslator {

    static func resolveChannel(
        for behavior: S4ChannelBehavior,
        selectedTrackChannel: Int
    ) -> UInt8 {
        switch behavior {
        case .selectedTrack:
            return sanitizeMIDIChannel(selectedTrackChannel)

        case .fixed(let channel):
            return sanitizeMIDIChannel(channel)
        }
    }

    static func makeCCMessage(
        binding: S4CCBinding,
        value: Int,
        selectedTrackChannel: Int
    ) -> S4TranslatedCCMessage {
        S4TranslatedCCMessage(
            channel: resolveChannel(
                for: binding.channelBehavior,
                selectedTrackChannel: selectedTrackChannel
            ),
            cc: sanitize7Bit(binding.cc),
            value: sanitize7Bit(value),
            label: binding.label
        )
    }

    static func makeNoteMessage(
        binding: S4NoteBinding,
        velocity: Int = 127,
        selectedTrackChannel: Int
    ) -> S4TranslatedNoteMessage {
        S4TranslatedNoteMessage(
            channel: resolveChannel(
                for: binding.channelBehavior,
                selectedTrackChannel: selectedTrackChannel
            ),
            note: sanitize7Bit(binding.note),
            velocity: sanitize7Bit(velocity),
            label: binding.label
        )
    }

    // MARK: - Convenience helpers

    static func mixMessage(
        parameter: S4MixParameter,
        value: Int,
        selectedTrackChannel: Int = S4CCMap.mixChannel
    ) -> S4TranslatedCCMessage? {
        guard let binding = S4CCMap.mix[parameter] else { return nil }
        return makeCCMessage(
            binding: binding,
            value: value,
            selectedTrackChannel: selectedTrackChannel
        )
    }

    static func transportMessage(
        note: S4TransportNote,
        velocity: Int = 127,
        selectedTrackChannel: Int = S4CCMap.mixChannel
    ) -> S4TranslatedNoteMessage? {
        guard let binding = S4CCMap.transportNotes[note] else { return nil }
        return makeNoteMessage(
            binding: binding,
            velocity: velocity,
            selectedTrackChannel: selectedTrackChannel
        )
    }

    static func tapeMessage(
        parameter: S4TapeParameter,
        value: Int,
        selectedTrackChannel: Int
    ) -> S4TranslatedCCMessage? {
        guard let binding = S4CCMap.tape[parameter] else { return nil }
        return makeCCMessage(
            binding: binding,
            value: value,
            selectedTrackChannel: selectedTrackChannel
        )
    }

    static func polyMessage(
        parameter: S4PolyParameter,
        value: Int,
        selectedTrackChannel: Int
    ) -> S4TranslatedCCMessage? {
        guard let binding = S4CCMap.poly[parameter] else { return nil }
        return makeCCMessage(
            binding: binding,
            value: value,
            selectedTrackChannel: selectedTrackChannel
        )
    }

    static func message(
        for parameter: Constants.Parameter,
        value: Int,
        selectedTrackChannel: Int
    ) -> S4TranslatedCCMessage {
        let channel = resolveLegacyChannel(
            parameter.channel,
            selectedTrackChannel: selectedTrackChannel
        )

        return S4TranslatedCCMessage(
            channel: channel,
            cc: sanitize7Bit(parameter.cc),
            value: sanitize7Bit(value),
            label: parameter.name
        )
    }

    // MARK: - Internal helpers

    private static func resolveLegacyChannel(
        _ channel: Constants.MIDIChannel,
        selectedTrackChannel: Int
    ) -> UInt8 {
        switch channel {
        case .track1:
            return 1
        case .track2:
            return 2
        case .track3:
            return 3
        case .track4:
            return 4
        case .perform:
            return 15
        case .mix:
            return 16
        }
    }

    private static func sanitize7Bit(_ value: Int) -> UInt8 {
        UInt8(max(0, min(127, value)))
    }

    private static func sanitizeMIDIChannel(_ value: Int) -> UInt8 {
        UInt8(max(1, min(16, value)))
    }
}
