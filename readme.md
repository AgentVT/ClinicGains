# Clinic Gains - Complete Godot Setup Guide

## Part 1: Project Setup

### 1. Create New Godot Project
1. Open Godot 4.x
2. Create a new project called "ClinicGains"
3. Choose a folder location
4. Click "Create & Edit"

### 2. Configure Project Settings

**Go to Project > Project Settings**

#### Display Settings
- **Window Width**: 1280
- **Window Height**: 720
- **Window Mode**: Windowed (or Fullscreen)
- **Stretch Mode**: viewport
- **Stretch Aspect**: keep

#### Input Map
Add these actions in **Project > Project Settings > Input Map**:

| Action Name | Key/Button |
|------------|-----------|
| `move_left` | A, Left Arrow |
| `move_right` | D, Right Arrow |
| `move_up` | W, Up Arrow |
| `move_down` | S, Down Arrow |
| `use_syringe` | E |
| `gym_action` | Space |

**How to add:**
1. Type action name in "Add New Action" field
2. Click "Add"
3. Click the "+" button next to the action
4. Press the key you want to assign
5. Click "OK"

---

## Part 2: File Structure

Create this folder structure in your project:

```
res://
├── scripts/
│   ├── Player.gd
│   ├── GameManager.gd
│   ├── Emergency.gd
│   ├── Syringe.gd
│   ├── GymMinigame.gd
│   └── GameUI.gd
├── scenes/
│   ├── player.tscn
│   ├── emergency.tscn
│   ├── syringe.tscn
│   ├── gym_minigame.tscn
│   ├── game_ui.tscn
│   └── main.tscn (main level)
└── sprites/
    └── (your pixel art goes here)
```

**Copy all the GDScript files I provided into the `scripts/` folder.**

---

## Part 3: Scene Creation

### Scene 1: Player (player.tscn)

1. **Create New Scene**: Scene > New Scene
2. **Root Node**: CharacterBody2D (name it "Player")
3. **Attach Script**: Click Player node > Attach Script > Select `res://scripts/Player.gd`

**Add these child nodes:**

```
Player (CharacterBody2D)
├── Sprite2D
├── CollisionShape2D
└── AnimationPlayer
```

**Configure nodes:**

- **Sprite2D**: 
  - Create a simple colored rectangle as placeholder
  - Right-click in FileSystem > Create New > Resource > Image
  - Or add Modulate color (Green for normal Nick)
  - Scale: (1, 1)

- **CollisionShape2D**:
  - Inspector > Shape > New RectangleShape2D
  - Size: (40, 60) - adjust to fit sprite

- **AnimationPlayer**: We'll add animations later (optional)

**Save Scene**: Ctrl+S → save as `res://scenes/player.tscn`

---

### Scene 2: Emergency (emergency.tscn)

1. **Root Node**: Area2D (name it "Emergency")
2. **Attach Script**: `res://scripts/Emergency.gd`

**Add child nodes:**

```
Emergency (Area2D)
├── Sprite2D
├── CollisionShape2D
├── Label
└── ProgressBar
```

**Configure:**

- **Sprite2D**: Red circle (placeholder)
  - Modulate: Red color
  
- **CollisionShape2D**:
  - Shape: New CircleShape2D
  - Radius: 50

- **Label**:
  - Position: Above the sprite (Y: -70)
  - Text: "EMERGENCY"
  - Horizontal Alignment: Center
  - Add new Theme override > Font Size: 20

- **ProgressBar**:
  - Position: Below sprite (Y: 60)
  - Size: (100, 20)
  - Center it using anchors or offset

**Save as**: `res://scenes/emergency.tscn`

---

### Scene 3: Syringe (syringe.tscn)

1. **Root Node**: Area2D (name it "Syringe")
2. **Attach Script**: `res://scripts/Syringe.gd`

**Add child nodes:**

```
Syringe (Area2D)
├── Sprite2D
└── CollisionShape2D
```

**Configure:**

- **Sprite2D**: Yellow rectangle (20x30 pixels)
  - Modulate: Yellow

- **CollisionShape2D**:
  - Shape: New RectangleShape2D
  - Size: (20, 30)

**Save as**: `res://scenes/syringe.tscn`

---

### Scene 4: Gym Minigame UI (gym_minigame.tscn)

1. **Root Node**: Control (name it "GymMinigame")
2. **Attach Script**: `res://scripts/GymMinigame.gd`
3. **Layout**: Set to Full Rect (Anchors: 0,0,1,1)

**Add child nodes:**

```
GymMinigame (Control)
├── Background (ColorRect)
└── VBoxContainer
    ├── TitleLabel
    ├── InstructionLabel
    ├── ScoreLabel
    ├── TimerLabel
    └── ProgressBar
```

**Configure:**

- **Background (ColorRect)**:
  - Layout: Full Rect
  - Color: Dark gray/black (RGB: 20, 20, 20)

- **VBoxContainer**:
  - Layout: Center
  - Alignment: Center
  - Separation: 20

- **TitleLabel**:
  - Text: "GYM TIME!"
  - Font Size: 72
  - Horizontal Alignment: Center

- **InstructionLabel**:
  - Text: "MASH SPACE TO LIFT!"
  - Font Size: 36

- **ScoreLabel**:
  - Text: "REPS: 0"
  - Font Size: 36

- **TimerLabel**:
  - Text: "TIME: 3.0"
  - Font Size: 36

- **ProgressBar**:
  - Custom Minimum Size: (400, 40)
  - Max Value: 50

**Save as**: `res://scenes/gym_minigame.tscn`

---

### Scene 5: Game UI (game_ui.tscn)

1. **Root Node**: CanvasLayer (name it "GameUI")
2. **Attach Script**: `res://scripts/GameUI.gd`

**Add child nodes:**

```
GameUI (CanvasLayer)
├── MarginContainer
│   └── VBoxContainer
│       ├── StressLabel
│       ├── StressBar
│       ├── SyringeLabel
│       └── PowerXPLabel
├── ControlsLabel
└── GameOverPanel (Panel)
    └── VBoxContainer
        ├── GameOverLabel
        └── RestartButton
```

**Configure:**

- **MarginContainer**:
  - Anchors: Top Left
  - Custom Constants: All margins = 20

- **VBoxContainer** (under MarginContainer):
  - Separation: 10

- **StressLabel**:
  - Text: "Stress: 0/100"
  - Font Size: 24

- **StressBar** (ProgressBar):
  - Min Value: 0
  - Max Value: 100
  - Custom Minimum Size: (300, 30)

- **SyringeLabel**:
  - Text: "Syringes: 0"
  - Font Size: 24

- **PowerXPLabel**:
  - Text: "Power XP: 0"
  - Font Size: 24

- **ControlsLabel**:
  - Anchors: Bottom Left
  - Position: (20, -40)
  - Text: "WASD: Move | E: Use Syringe | SPACE: Gym Action"
  - Font Size: 18

- **GameOverPanel**:
  - Layout: Center
  - Size: (500, 300)
  - Visible: OFF (uncheck in Inspector)
  - Add Panel StyleBox with background color

- **GameOverLabel** (inside panel):
  - Text: "GAME OVER"
  - Font Size: 48
  - Horizontal Alignment: Center

- **RestartButton**:
  - Text: "Restart"
  - Custom Minimum Size: (200, 50)

**Save as**: `res://scenes/game_ui.tscn`

---

### Scene 6: Main Game Scene (main.tscn)

1. **Root Node**: Node2D (name it "Main")
2. **Do NOT attach GameManager yet**

**Add child nodes:**

```
Main (Node2D)
├── GameManager (Node) - ADD THIS FIRST
├── Camera2D
├── Background (ColorRect)
├── Player (instance of player.tscn)
├── GymMinigame (instance of gym_minigame.tscn)
└── GameUI (instance of game_ui.tscn)
```

**Step-by-step:**

1. **Add GameManager Node**:
   - Click Main > Add Child Node
   - Choose "Node"
   - Rename to "GameManager"
   - Attach Script: `res://scripts/GameManager.gd`
   - **Inspector Settings**:
     - Emergency Scene: Drag `emergency.tscn` into this field
     - Syringe Scene: Drag `syringe.tscn` into this field

2. **Add Camera2D**:
   - Position: (640, 360) - center of screen
   - Enable "Current" (check the box)

3. **Add Background**:
   - Type: ColorRect
   - Layout: Full Rect
   - Color: Light blue/clinic color (RGB: 180, 200, 210)

4. **Instance Player**:
   - Right-click Main > Instantiate Child Scene
   - Select `player.tscn`
   - Position: (400, 400)

5. **Instance GymMinigame**:
   - Right-click Main > Instantiate Child Scene
   - Select `gym_minigame.tscn`
   - Should already be hidden by script

6. **Instance GameUI**:
   - Right-click Main > Instantiate Child Scene
   - Select `game_ui.tscn`

**Save as**: `res://scenes/main.tscn`

---

## Part 4: Set Main Scene

1. Go to **Project > Project Settings > Application > Run**
2. Set **Main Scene** to `res://scenes/main.tscn`
3. Click "Close"

---

## Part 5: Testing

### Run the Game
Press **F5** or click the Play button

**What You Should See:**
- ✅ Player (green box) that moves with WASD
- ✅ Yellow syringes spawning
- ✅ Red emergency circles appearing
- ✅ Stress bar in top-left
- ✅ Pick up syringe → Press E → Gym minigame appears
- ✅ Mash SPACE in gym → Return to clinic in SWOLE MODE (red, bigger)
- ✅ Swole mode lets you resolve emergencies by touching them
- ✅ Game over when stress reaches 100

---

## Part 6: Adding Visual Polish (Optional)

### Replace Placeholder Sprites

1. Create pixel art sprites (16x16, 32x32, etc.)
2. Export as PNG
3. Drag into `res://sprites/` folder
4. Drag sprite into Sprite2D nodes' Texture property

**Recommended Sprites:**
- Nick normal (16x32 pixels)
- Nick swole (32x48 pixels)  
- Syringe (8x16 pixels)
- Emergency icon (32x32 pixels)

### Add Animations (Optional)

In Player scene:
1. Select AnimationPlayer node
2. Create new animations:
   - "idle_normal"
   - "walk_normal"
   - "idle_swole"
   - "walk_swole"
   - "transformation"

---

## Part 7: Troubleshooting

### Common Issues:

**"Invalid get index 'modulate' on base: 'Node'"**
- Make sure node references in scripts match your scene hierarchy
- Check that @onready variables point to correct node paths

**Syringes/Emergencies not spawning**
- Verify GameManager has Emergency Scene and Syringe Scene set in Inspector
- Check console for errors (Output tab)

**Player not moving**
- Verify Input Map actions are set up correctly
- Check Player script is attached

**Gym minigame not appearing**
- Make sure GymMinigame node is in scene
- Check it's properly grouped ("gym_minigame")

**Player can't pick up syringes**
- Verify Syringe has CollisionShape2D
- Check Area2D signals are connected

---

## Part 8: Next Steps

### Expand the Game:

1. **Add Sound Effects**:
   - Import audio files
   - Add AudioStreamPlayer nodes
   - Play sounds on events

2. **Multiple Clinic Rooms**:
   - Create separate scenes for rooms
   - Add door transitions

3. **NPC Coworkers**:
   - Create NPC scene with dialogue
   - Add interaction system

4. **Side Effects**:
   - Add visual shaders for hallucinations
   - Screen shake effects
   - Distortion filters

5. **Save System**:
   - Use ConfigFile or JSON
   - Save progress, XP, endings unlocked

6. **Multiple Endings**:
   - Track stats (syringes used, emergencies resolved)
   - Create ending scenes for each path

---

## Part 9: Controls Reference

| Action | Key |
|--------|-----|
| Move | WASD or Arrow Keys |
| Use Syringe | E |
| Gym Action | Space (when in gym) |
| Pause | ESC |

---

## Need Help?

Check these resources:
- **Godot Docs**: https://docs.godotengine.org
- **GDScript Basics**: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
- **Signals Tutorial**: https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html

---

## Project Complete! 🎮

You now have a fully functional prototype of Clinic Gains with:
- ✅ Player movement and state system
- ✅ Syringe pickup and transformation
- ✅ Gym minigame
- ✅ Emergency spawning and resolution
- ✅ Stress management
- ✅ Game over condition
- ✅ Full UI system

Time to add your pixel art and expand the gameplay! 💪
