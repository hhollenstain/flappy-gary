# Agent Development Guide for Flappy Gary

This document describes how to work on, test, and play the Flappy Gary game project using the agent development workflow.

## Project Overview

Flappy Gary is a Godot-based game inspired by Flappy Bird, featuring your dog Gary navigating through obstacles. The goal of this project is to provide a complete playable game with settings functionality and automated testing.

## Setting Up the Development Environment

### Prerequisites
- Godot 4.4-stable engine installed
- Bash-compatible shell environment 
- Git for version control

### Version Management Note
When updating the Godot version:
1. Update the version in `.github/workflows/godot-validate.yml` (currently 4.4-stable)
2. Update this documentation to reflect the new version
3. Both local and CI builds must use the same Godot version for consistency

### Local Setup
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd flappy-gary
   ```

2. Verify that Godot is properly installed and accessible:
   ```bash
   godot --version
   ```

3. Run the project validation:
   ```bash
   bash validate_godot_files.sh
   ```

## Working on the Project

### Development Workflow
1. Make changes to the codebase (scripts, scenes, etc.)
2. Test your changes by running `bash validate_godot_files.sh`
3. Commit changes with clear messages:
   ```bash
   git add .
   git commit -m "Add feature description"
   git push origin <your-branch>
   ```

### Project Structure
- `/scenes` - Game scenes (main menu, game, settings, etc.)
- `/scripts` - GDScript files for game logic and UI
- `/assets` - Images, sounds, fonts, etc.
- `/validate_godot_files.sh` - Validation script to check Godot files
- `/scripts/test.gd` - Automated test script for the project

The script that runs is the one named in the scene's `ext_resource`. Do not add a second copy of a script at the repo root. `scenes/main_scene.tscn` uses `scripts/player.gd`, `scripts/main_game.gd`, and `scripts/pipe_manager.gd`.

## Godot 4 scenes, scripts, and types

Match every attached script to the node it is on, and write scene files in Godot 4 format. A script that loads and a scene that displays are not enough: the node type, the script base type, and the properties stored in the `.tscn` all have to agree.

### Script base type must match the node
The class after `extends` must be the node type (or a subclass of it) in the `.tscn`. Godot refuses to attach the script otherwise (`Script inherits from native type 'Control', so it can't be assigned to an object of type 'Node2D'`).

| Scene role | Root node | Script |
| --- | --- | --- |
| Menu, settings, game over | `Control` | `extends Control` |
| Gameplay world | `Node2D` | `extends Node2D` |
| Gary | `CharacterBody2D` | `extends CharacterBody2D` |
| Pipe | `Node2D` | `extends Node2D` |

Check both files before saving. Changing a script to `extends Control` requires changing that scene node to `type="Control"`, and the reverse is also required.

### Control nodes use Godot 4 layout properties
`Label`, `Button`, `ColorRect`, and other `Control` nodes do not use Godot 3 `position` or `size` keys. Those keys are ignored, so backgrounds stay tiny and the game does not fill the window.

Use this shape, as in `scenes/menu_scene.tscn`:

```
[node name="Background" type="ColorRect" parent="."]
offset_right = 800.0
offset_bottom = 600.0
mouse_filter = 2
color = Color(0.7, 0.8, 1.0, 1)
```

Full-window UI roots also set `layout_mode`, `anchors_preset = 15`, `anchor_right = 1.0`, and `anchor_bottom = 1.0`.

### Playfield must fill the 800x600 view
- Viewport is 800 by 600 (`project.godot`).
- `window/stretch/mode` is `canvas_items` and `window/stretch/aspect` is `keep`, so that view scales to the window.
- `Camera2D` stays at the center of the playfield, `Vector2(400, 300)`. A camera at the origin shows only the bottom-right quarter.
- The background `ColorRect` covers `offset_right = 800` and `offset_bottom = 600`.
- Score and level labels live on a `CanvasLayer` named `UI`, using offsets, and scripts reach them as `UI/ScoreLabel` and `UI/LevelLabel`.

### One owner for player physics
Gary's gravity and flap live only in `scripts/player.gd`. `jump()` sets `velocity.y` to `jump_force` so each flap climbs again. Do not also add a second velocity onto `position` from `scripts/main_game.gd`. A second integrator keeps accumulating downward speed, and after a few flaps Gary can no longer rise.

## Manual Testing for Users

### How to Play Test the Game
1. Run the Godot editor:
   ```bash
   godot
   ```
2. Open the project file `project.godot`
3. Navigate to scenes:
   - `scenes/menu_scene.tscn` - Main menu
   - `scenes/main_scene.tscn` - Gameplay scene  
   - `scenes/settings_scene.tscn` - Settings menu

### Test Scenarios
1. **Gameplay Testing**:
   - Open main menu and start a new game
   - Verify that you can control Gary (tap/press spacebar)
   - Check that obstacles spawn correctly
   - Test scoring system
   - Test game over detection and screen

2. **Settings Testing**:
   - Access settings from the main menu
   - Verify volume slider functionality
   - Test difficulty toggle functionality
   - Ensure proper navigation between scenes

3. **Validation Testing**:
   Run validation script to ensure project integrity:
   ```bash
   bash validate_godot_files.sh
   ```

### Troubleshooting Common Issues
- If Godot fails to load textures, check file paths in project settings
- If scripts fail to run, verify syntax using `validate_godot_files.sh`
- If a scene fails to instance, compare the node `type` with the script `extends` line
- If the playfield sits in a corner or the background is a small rectangle, the camera is not centered or a `Control` is using `position`/`size` instead of offsets
- If Gary flaps and then only sinks, look for a second gravity being applied outside `scripts/player.gd`
- If scenes don't appear correctly, ensure scene files have proper Godot headers
- Make sure all referenced resources exist and have correct paths

## Automated Testing

The project uses automated validation through `validate_godot_files.sh` which:
- Checks that all required files exist (project.godot, scenes, scripts)
- Validates scene file formats with proper Godot headers
- Ensures GDScript files pass syntax validation  
- Tests that the entire project compiles correctly in Godot
- Runs automated tests defined in `scripts/test.gd`

## CI/CD Integration

The project includes a GitHub Actions workflow (.github/workflows/godot-validate.yml) that automatically runs validation on every commit, ensuring code quality and preventing broken builds.

## Contributing Guidelines

1. Always run `validate_godot_files.sh` before committing
2. Add tests for new functionality 
3. Keep changes focused on single features or fixes
4. Document any breaking changes in commit messages
5. Ensure all scenes have proper Godot format headers
6. Test that existing functionality still works after your changes
7. Keep each script's `extends` type identical to the scene node it is attached to, and use Godot 4 Control offsets instead of `position`/`size`