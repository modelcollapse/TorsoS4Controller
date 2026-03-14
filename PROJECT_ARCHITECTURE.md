# Torso S4 Controller — Project Architecture

## Core Philosophy
This controller mirrors the Torso S-4 hardware workflow while expanding it into a visual control surface.

The system is built around **clear musical modules** rather than technical abstractions.

Everything should map cleanly to:

Tracks  
Devices  
Modulation  
Composition  
Mixing  

---

## Main Tabs

### Tracks
Per-track controls

• Pitch  
• Velocity  
• Length  
• Gate  
• Chance  
• Timing

Each track represents one S-4 lane.

---

### Devices
Sound shaping modules.

Examples:

• LFO  
• CC Sequencer  
• Euclidean generator  
• Randomizer  
• Probability tools

These act like **modular blocks** that can target parameters.

---

### Modulation
Routing and movement.

Examples:

• LFO assignments  
• Macro mapping  
• modulation depth  
• modulation targets

---

### Compose
Pattern generation.

Examples:

• Step patterns  
• Euclidean rhythms  
• Markov chains (optional)  
• generative sequencing

---

### Mix
Performance layer.

Examples:

• Track mute  
• Track level  
• Track pan  
• global macros

---

## UI System

### KnobView
Unified knob component for all numeric parameters.

Supports:

• bipolar parameters  
• drag control  
• double-tap reset  
• scalable sizes

---

### Macro System

Macros allow **one control to move multiple parameters**.

Example:

Macro 1  
→ filter cutoff  
→ LFO depth  
→ velocity scaling

---

## Future Expansion

• XY modulation pads  
• modulation matrix  
• preset system  
• MIDI learn  
• hardware S-4 sync
