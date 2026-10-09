# Agent Development Guide for Flappy Gary

This document describes how to work on, test, and play the Flappy Gary game project using the agent development workflow.

## Project Overview

Flappy Gary is a Godot-based game inspired by Flappy Bird, featuring your dog Gary navigating through obstacles. The goal of this project is to provide a complete playable game with settings functionality and automated testing.

## Setting Up the Development Environment

### Prerequisites
- Godot 4.x engine installed
- Bash-compatible shell environment 
- Git for version control

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