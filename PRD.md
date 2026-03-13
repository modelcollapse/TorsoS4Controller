# S4 MIDI Controller - Product Requirements Document

**Version**: 2.0
**Date**: 2026-03-13
**Status**: ACTIVE - PLATFORM INDEPENDENT

---

## 1. Executive Summary

The S4 is a comprehensive MIDI controller interface for the Torso Electronics S-4 synthesizer. The application provides intuitive control over 60+ synthesizer parameters through 9 distinct workspace tabs, supporting complex modulation, sequencing, and automation workflows.

**Key Mission**: Enable musicians to map, sequence, and modulate synthesizer parameters with an intuitive visual interface supporting complex parameter assignments, LFO modulation, and song-length automation.

**Target Users**:
- Electronic musicians and producers
- Live performance artists
- Synthesizer enthusiasts using Torso S-4 hardware
- MIDI-capable DAW operators

---

## 2. Product Overview

### 2.1 What is S4?

S4 is a **MIDI controller companion application** that:
- Provides real-time parameter control for 60+ synthesizer parameters
- Manages complex CC assignments and per-track routing
- Enables LFO modulation with visual feedback
- Supports song-length automation and step sequencing
- Saves/loads snapshots and presets

**NOT a synthesizer emulator** - S4 outputs MIDI only; actual sound comes from hardware.

### 2.2 Core Architecture

#### Hardware Sections (14 total)
- **3 Material Engines**: Disc, Tape, Poly (selectable per track)
- **5 Processor Modules**: Mosaic, Ring, Deform, Vast, Wave
- **3 Modulation Sources**: ADSR, Random, Wave oscillators
- **3 Utility Sections**: Mix, Perform, Sends
- **4 Tracks**: T1-T4 with independent material/module selection

#### Parameter Control Methods
1. **Knob/Slider Control**: Direct parameter adjustment via UI knobs
2. **Step Sequencer**: 16 steps × 16 tracks for CC sequencing
3. **LFO Modulation**: 16 independent LFOs with waveform/rate/depth
4. **Song Automation**: Multi-bar curves for smooth parameter evolution
5. **Macro Knobs**: 16 mapped controls for complex parameter binding
6. **XY Pad**: 2D spatial control for expressive performance
7. **Field Control**: 4-node spatial panning and distribution

---

## 3. User Interface Design

### 3.1 Layout Structure

```
┌─────────────────────────────────────────────────┐
│               HEADER (92px)                      │
│  Logo | Transport | BPM | MIDI Status | Utils   │
│       | Snapshots (S1-S8)                       │
├─────────────────────────────────────────────────┤
│  Navigation Tabs (9 tabs, 32px height)          │
├─────────────────────────────────────────────────┤
│                                                 │
│         WORKSPACE CONTENT (Dynamic)             │
│                                                 │
│    [Control | Sequencer | LFOs | Knobs |       │
│     Macros | XY Pad | Song | Field | Settings] │
│                                                 │
└─────────────────────────────────────────────────┘
```

### 3.2 The 9 Workspace Tabs

#### Tab 1: CONTROL (Primary Workspace)
**Purpose**: Main synthesis parameter control

**Layout**:
- Track toggles (ALL, T1-T4)
- Helper text: "Drag knobs · Double-click reset · Shift+drag fine"
- 14 collapsible sections:
  - **Materials**: Disc, Tape, Poly (1 visible at a time based on track selection)
  - **Modules**: Mosaic, Ring, Deform, Vast, Wave (toggle per track)
  - **Modulators**: ADSR, Random, Wave
  - **Utility**: Mix, Perform

**Per-Parameter Display**:
- Knob visualization (56×56px SVG arc)
- Value slider underneath
- Parameter name + CC number
- Optional: Modulation badge (LFO indicator)

**Interactions**:
- Click section header → expand/collapse
- Drag knob → adjust value
- Double-click knob → reset to 64
- Shift+drag → fine control (0.5 increments)
- Change triggers MIDI CC output immediately

---

#### Tab 2: SEQUENCER (CC Step Grid)
**Purpose**: Create rhythmic CC parameter changes

**Grid**: 16 tracks × 16 steps

**Controls**:
- Track assignment dropdown (select section/parameter)
- Sync options: Rate, Direction (FWD/REV/P-P/RAND)
- Transport: Play, Stop, Reset buttons
- Label: "16 tracks · 16 steps"

**Step States**:
- **Blue**: Currently playing step
- **Gray**: Step enabled, waiting
- **Off**: Step disabled

**Workflow**:
1. Select target parameter
2. Click steps to enable
3. Click Play to start sequencing
4. Steps trigger CC output at tempo

---

#### Tab 3: LFOs (Modulation Editor)
**Purpose**: Configure independent LFO sources

**Architecture**: 16 available LFOs (add/remove dynamically)

**Per-LFO Controls**:
- Enable toggle (on/off)
- Waveform menu: Sine, Square, Triangle, Saw
- Rate slider (0-127)
- Depth slider (0-127)
- Phase offset (0-127 = 0-360°)
- BPM sync toggle (fixed or tempo-based)
- Target indicator (shows assigned parameters)
- Color badge (unique color per LFO)

**Workflow**:
1. Add new LFO (+ button)
2. Select waveform
3. Adjust rate and depth
4. Toggle BPM sync if needed
5. Return to Control view → modulation badges appear on affected knobs

---

#### Tab 4: KNOBS (DJ Recorder)
**Purpose**: 8 independent hands-on control knobs

**Features**:
- Record mode toggle
- 8 knobs in adaptive grid
- Visual arc design matching Control view
- Labels: K1-K8
- Optional: Gesture recording/playback

**Use Case**: Real-time performance recording and expression

---

#### Tab 5: MACROS (Macro Control)
**Purpose**: Mapped multi-parameter control

**Features**:
- 16 macro knobs
- Each maps to 2 target parameters
- Min/max scaling per target
- Purple accent color
- Labels: M1-M16

**Workflow**:
1. Assign parameter to macro 1
2. Assign second parameter to macro 1
3. Adjust min/max scaling for each
4. Drag macro knob → both parameters scale proportionally

---

#### Tab 6: XY PAD (2D Spatial Control)
**Purpose**: Two-dimensional real-time control

**Features**:
- Draggable cyan point in 300×300px space
- X/Y axis assignment (different parameters per axis)
- X output: 0-127 (continuous CC)
- Y output: 0-127 (continuous CC)
- Center button to reset
- Optional: Record/playback gestures

**Use Cases**:
- Morphing between sound states
- Crossfading parameters
- Live expressive performance control

---

#### Tab 7: SONG (Automation Curves)
**Purpose**: Create smooth parameter automation over time

**Controls**:
- Length input: 1-512 bars (editable)
- Loop toggle (repeat or play once)
- Target selector: Pick section/parameter
- Clear button (reset automation)

**Visual**:
- 4 track lanes (T1-T4) with canvas area
- Drag to draw curves
- Right-click to erase
- Visual timeline markers

**Workflow**:
1. Select target parameter
2. Set length (bars)
3. Click/drag in lane to draw automation
4. Play back → automation controls parameters

---

#### Tab 8: FIELD (Spatial Panning)
**Purpose**: 4-node spatial control

**Features**:
- 4 draggable orange nodes
- Node assignments: Pan X, Pan Y, Volume, Spread (customizable)
- 2D spatial grid visualization
- Position = current parameter value

**Use Cases**:
- Distribute tracks in stereo field
- Dynamic spatial effects
- Multi-parameter spatial automation

---

#### Tab 9: SETTINGS (Configuration)
**Purpose**: Application preferences and device setup

**Sections**:

1. **Theme**
   - Dark/Light/Natural/Color mode selection
   - Updates UI colors immediately

2. **MIDI I/O**
   - Input device dropdown (for future MIDI learn)
   - Output device dropdown (hardware selection)
   - Connection status display

3. **Safety**
   - "Protect MIX" toggle (prevent accidental changes)
   - All Sound Off on panic (CC 120/123)
   - Reset CC on startup option

4. **Presets**
   - Import button (.s4 file)
   - Export button (save current state)
   - Clear All button (reset to defaults, with confirmation)

5. **Info**
   - Version number
   - Build info
   - Help/documentation links

---

## 4. Technical Architecture

### 4.1 MIDI Specification

#### Channel Mapping
- **Channels 0-3**: Tracks 1-4 (material engines & modules)
- **Channel 14**: Perform/Macro knobs (CC 46-53)
- **Channel 15**: Mix section (CC 46-61)
- **Channels 4-13**: Reserved for expansion

#### Parameter Types
1. **CC Parameters** (most common)
   - CC number: 0-127
   - Value: 0-127 (7-bit)
   - Sent immediately on change

2. **Note Parameters** (for sequencer)
   - Note number: 0-127
   - Velocity: 0-127
   - Sent on step trigger

3. **Modulation Sources**
   - LFO depth modulates CC range
   - Formula: `output = base_value + (lfo_depth / 127) * lfo_signal`

### 4.2 Data Model

#### Core Objects
```
Parameter
├── id: String
├── section: String
├── name: String
├── cc: Number (0-127)
├── channel: Number (0-15)
└── value: Number (0-127)

Section
├── id: String
├── name: String
├── parameters: [Parameter]
├── isExpanded: Boolean
└── category: String

Snapshot
├── id: UUID
├── name: String
├── parameterValues: {String: Number}
├── createdAt: Date
└── metadata: Object

LFOAssignment
├── paramId: String
├── lfoIndex: Number (0-15)
├── depth: Number (0-127)
└── enabled: Boolean

Modulation
├── target: String (param ID)
├── source: String (LFO index)
├── depth: Number (0-127)
└── active: Boolean
```

### 4.3 State Management

#### Global State
- Parameter values (all 60+ params)
- Snapshots (8 quick slots + unlimited named)
- Active tracks (which tracks visible)
- Expanded sections (UI state)
- Playback state (playing/stopped)
- Playback BPM
- LFO assignments and data
- Current snapshot selection
- MIDI connection status

#### Persistence
- **Snapshots**: JSON files in user library
- **Preferences**: Local storage (theme, MIDI device, window state)
- **Auto-save**: Current session state on close
- **Format**: JSON for portability

---

## 5. Design System

### 5.1 Color Palette

#### Theme Colors (Dark Mode - Default)
| Element | Hex | RGB |
|---------|-----|-----|
| Background | #0f1114 | 15, 17, 20 |
| Surface | #15181d | 21, 24, 29 |
| Surface Raised | #1b1f25 | 27, 31, 37 |
| Border | #2a2f36 | 42, 47, 54 |
| Text Primary | #e7e7e7 | 231, 231, 231 |
| Text Secondary | #a8adb5 | 168, 173, 181 |
| Accent | #f2f2f2 | 242, 242, 242 |
| Status Green | #22c55e | 34, 197, 94 |
| Status Red | #ef4444 | 239, 68, 68 |

#### Track Colors (Identification)
- **Track 1**: Cyan (#00d9ff)
- **Track 2**: Magenta (#ff00ff)
- **Track 3**: Yellow (#ffff00)
- **Track 4**: Lime (#44ff44)

#### LFO Colors (16 Distinct)
Cyan, Magenta, Yellow, Lime, Orange, Cyan Variant, Rose, Purple, Light Yellow, Spring Green, Turquoise, Orchid, Light Cyan, Gold, Cornflower, Salmon

### 5.2 Typography

All text uses **monospaced system font** for technical precision:

| Size | Weight | Use |
|------|--------|-----|
| 10px | Medium | Labels, CC numbers, helper text |
| 11px | Semibold | Control labels, button text |
| 12px | Bold | Headers, section names, tab labels |
| 13px | Bold | Large values (knob display) |

### 5.3 Component Sizing

| Component | Dimensions | Notes |
|-----------|-----------|-------|
| Header | Full width × 92px | Logo, transport, snapshots |
| Tab buttons | Full width × 32px | 9 tabs total |
| Knob (Control) | 56×56px | SVG arc design |
| Knob (Macro) | 80×80px | Larger for easier targeting |
| Slider | Full width × 4px | Below each knob |
| Section header | Full width × 32px | Collapsible button |
| Sequencer cell | 40×40px | 16×16 grid |
| LFO card | 240×280px | Adaptive grid |
| XY Pad | 300×300px | Squared aspect ratio |
| Transport button | 32×32px | Consistent height |
| Snapshot button | 36×24px | S1-S8 in header |

### 5.4 Animations

All transitions use **ease-in-out, 150ms duration**:
- Section collapse/expand
- Tab transitions
- Knob value changes
- Slider adjustments
- Badge fades
- MIDI indicator pulses

---

## 6. Key Features

### Must-Have (MVP)
- ✅ Parameter display and control (all 9 views)
- ✅ MIDI CC output on parameter change
- ✅ Snapshot save/load (8 quick slots)
- ✅ LFO modulation with depth control
- ✅ Sequencer grid with step editing
- ✅ Dark theme color system
- ✅ Transport controls (play/stop/panic)
- ✅ Per-track material selection
- ✅ Module enable/disable per track

### Should-Have (Phase 2)
- Song automation with curve drawing
- Gesture recording (XY pad)
- Macro parameter mapping UI
- Full preset import/export
- MIDI learn for custom mapping
- Real-time MIDI monitoring

### Nice-to-Have (Phase 3+)
- Undo/redo functionality
- Per-track snapshots
- Modulation depth envelopes
- Hardware CC feedback (bidirectional)
- OSC support for networked control
- iPad/mobile version
- Plugin format (AU, VST3 for DAW)

---

## 7. User Workflows

### Workflow 1: Basic Sound Sculpting
1. Open Control tab
2. Expand Disc section
3. Drag "Speed" knob left/right
4. MIDI CC 46 sent to hardware synth
5. Sound updates in real-time

### Workflow 2: LFO Modulation
1. Go to LFOs tab
2. Add new LFO (+ button)
3. Set waveform (Sine)
4. Adjust rate and depth sliders
5. Return to Control, modulation badge appears on affected parameters
6. Click badge to adjust depth

### Workflow 3: Step Sequencing
1. Go to Sequencer tab
2. Select target parameter
3. Click steps to toggle on/off
4. Click Play button
5. Sequencer plays in sync with tempo
6. Adjust sync direction if needed

### Workflow 4: Song Automation
1. Go to Song tab
2. Select target parameter
3. Set length (16, 32, 64 bars)
4. Click/drag in lane to draw automation
5. Right-click to erase
6. Play song to hear automation

### Workflow 5: Snapshot Management
1. Configure sound with knobs
2. Click snapshot button (S1-S8) in header
3. Save to snapshot slot
4. Later: Click slot to restore

---

## 8. Success Criteria

### Functional Requirements
- [ ] All 60+ parameters controllable via knobs/sliders
- [ ] MIDI CC output correct for all parameters
- [ ] Snapshots save/restore complete state
- [ ] LFO modulation affects target parameters correctly
- [ ] Sequencer steps trigger at correct timing
- [ ] XY pad outputs continuous CC values
- [ ] Song automation curves playback correctly
- [ ] All 9 tabs accessible and functional

### UX Requirements
- [ ] Parameter changes visible immediately
- [ ] No lag on knob drag (< 50ms latency)
- [ ] Snapshots load in < 500ms
- [ ] MIDI errors don't crash app
- [ ] Clear visual feedback for all interactions
- [ ] Help text accessible throughout

### Design Requirements
- [ ] Dark theme applied throughout
- [ ] Monospaced font for all parameters
- [ ] Proper spacing (4-8px grid)
- [ ] Color contrast meets accessibility standards
- [ ] Responsive layout (minimum 1280×800)

### Performance Requirements
- [ ] App launch < 2 seconds
- [ ] Parameter updates < 10ms
- [ ] No memory leaks over 1-hour session
- [ ] CPU usage < 5% at idle
- [ ] Smooth rendering (60fps)

---

## 9. Technical Specifications

### Technology Stack
- **Framework**: Platform-agnostic (TBD)
- **MIDI**: Native MIDI API per platform
- **State Management**: Reactive/observable pattern
- **Persistence**: JSON file format
- **Storage**: Local file system + application preferences

### Known Limitations
1. **MIDI Only**: No audio synthesis; requires hardware synth
2. **One-Way MIDI**: Can't receive CC from hardware (output only)
3. **No Undo/Redo**: State changes permanent until snapshot restore
4. **Fixed Channels**: MIDI channel routing hardcoded per section
5. **No OSC**: MIDI only; no network control

### Platform Requirements
- Desktop application (macOS, Windows, Linux)
- Native MIDI API access required
- Display minimum 1280×800 pixels
- Light/dark mode support
- Accessibility support (keyboard nav, screen readers)

---

## 10. Parameter Mapping Reference

### Disc Section (Channel 0)
- Speed: CC 46
- Tempo: CC 47
- Start: CC 48
- Length: CC 49
- Offset: CC 52
- Xfade: CC 53
- Glide: CC 54
- Level: CC 56

### Tape Section (Channel 0)
- Speed: CC 46
- Rotate: CC 48
- Length: CC 49
- Level: CC 52

### Poly Section (Channel 0)
- Pitch: CC 46
- Start: CC 48
- Length: CC 49
- Level: CC 50

### Modules (Channel 0)
- **Mosaic**: CC 62-69
- **Ring**: CC 78-85
- **Deform**: CC 94-101
- **Vast**: CC 110-117
- **Wave**: CC 14-15

### Mix Section (Channel 15)
- T1 Level: CC 46
- T1 Filter: CC 50
- T1 Pan: CC 54
- T2 Level: CC 47
- T2 Filter: CC 51
- T2 Pan: CC 55
- Master Compress: CC 58
- Master Level: CC 61

### Perform/Macros (Channel 14)
- Macro 1-8: CC 46-53

---

## 11. Glossary

- **CC**: Control Change (MIDI parameter message)
- **LFO**: Low-Frequency Oscillator (modulation source)
- **MIDI**: Musical Instrument Digital Interface
- **Snapshot**: Saved parameter state (preset)
- **Section**: Group of related parameters (Disc, Tape, Mix, etc.)
- **Material**: Playback engine choice (Disc, Tape, or Poly)
- **Module**: Processor unit (Mosaic, Ring, Deform, Vast)
- **Modulation**: Parameter variation from LFO or sequencer
- **Automation**: Parameter change over time (song mode)
- **Macro**: Mapped control affecting multiple parameters

---

## 12. Appendix: Version History

| Version | Date | Status |
|---------|------|--------|
| 2.0 | 2026-03-13 | Current - Platform Independent |
| 1.0 | 2026-03-12 | Legacy - Framework-specific |

---

**Document Status**: APPROVED FOR DEVELOPMENT
**Maintained By**: Product Team
**Last Updated**: 2026-03-13 00:00:00

