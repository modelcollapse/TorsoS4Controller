# Torso S4 Controller — Development Notes

## GOLD BASELINE (Session Checkpoint)

Version checkpoint:

v1.0.2_navigation-knob-foundation

This version establishes the core UI and control architecture of the S4 Controller app.

The following systems are considered stable.

---

# Core UI Structure

Tabs:

Blocks  
Controller  
CC Sequencer  
Knob Record  
Macros  
Song  
LFOs  
Spatial  
XY Pad  
Settings

Navigation lives in:

TabNavigation.swift

Tab state handled by:

AppState.selectedTab

---

# Shared Knob System

All numeric controls should use the shared knob component.

File:

KnobView.swift

Variants:

KnobView  
CompactKnobView  
MacroKnobView

Capabilities:

• drag vertical control  
• double-click reset  
• bipolar mode support  
• scalable sizes  
• consistent styling

This knob system is the **primary numeric UI control** across the app.

---

# Parameter Controls

ParameterControl.swift combines:

KnobView  
SliderView  
Parameter label  
CC number

All parameter sections should use this component.

---

# Control Tab Architecture

ControlTabView.swift

Sections:

Disc  
Tape  
Poly  
Mosaic  
Ring  
Deform  
Vast  
Wave  
ADSR  
Random  
Wave Mod  
Mix  
Perform  
Sends

Each section loads parameters from:

Constants.getParametersBySection()

Displayed in:

LazyVGrid parameter layout.

---

# AppState Responsibilities

AppState handles:

selectedTab

parameter values

parameter updates

getParameterValue(paramID)

setParameterValue(paramID,value)

---

# Development Rules

1. Prefer **whole-file updates** rather than partial patches.

2. Maintain **shared components** whenever possible.

3. Numeric parameters must use **KnobView** unless there is a strong reason not to.

4. Internal parameter IDs must remain stable.

5. Display names can change freely.

6. UI should mirror **musical workflow** rather than technical structure.

---

# Backup Workflow

Before major changes:

1. Build project

2. Zip working state

Example:

zip -r s4_controller_backup.zip "Torso S4 Controller"

3. Commit notes in DEV_NOTES.md

---

# Future Work

Parameter architecture cleanup

Preset system

Macro routing matrix

XY modulation pad expansion

Hardware S-4 sync layer


---

## v1.0.3_parameter-architecture

Changes

- moved parameter definitions out of Constants.swift into ParameterRegistry.swift
- made Constants.swift a thinner wrapper around ParameterRegistry
- connected ParameterRegistry to S4CCMap.swift where possible
- updated SequencerTabView to use registry-driven section and parameter lookup
- updated ControlTabView to use ParameterRegistry display helpers
- added ParameterDefaults.swift to centralize default parameter IDs used by AppState
- updated AppState.swift to read default parameter IDs from ParameterDefaults

Result

- reduced duplicated parameter knowledge across tabs
- improved consistency between Constants, ParameterRegistry, and S4CCMap
- prepared the project for future MIDI translation and routing cleanup

Next

- MIDI translation / routing cleanup
- connect more UI actions to typed parameter + CC flow
- reduce remaining hardcoded parameter references where appropriate


---

## v1.0.4_midi-routing-live

Changes

- confirmed macOS sees Torso S-4 over USB and MIDI
- MIDIManager now enumerates outputs and auto-selects S-4
- S4MIDITranslator is active in the send path
- AppState has live MIDI test methods
- Settings tab now exposes MIDI refresh and test controls
- confirmed successful note and CC sends to S-4

Verified

- device auto-detect works
- selected output can be S-4
- Play / Stop test sends note 24 on channel 16 to S-4
- Mix Main Level test sends CC 61 on channel 16 to S-4
- MIDI send ok confirmed in console

Next

- make S-4 sticky as the preferred output
- remove invalid Picker binding warnings
- clean up bus-selection behavior
- continue wiring real controls to live MIDI sends

