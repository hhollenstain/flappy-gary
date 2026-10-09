# Flappy Gary

A Godot-based game inspired by Flappy Bird, featuring your dog Gary!

Flappy Gary is a mobile-style game where players control a character named Gary (your 25-pound Chihuahua-Greyhound mix) navigating through obstacles. The goal is to help Gary fly as far as possible without hitting pipes or the ground.

## Features 

- Mobile-friendly gameplay
- Character controlled by simple taps or clicks
- Randomly generated obstacle patterns
- Score tracking and high score system
- Simple, cute visual style

## Development Progress

This project is being developed using Godot engine with the goal of being a proof-of-concept showcasing local GPU usage and automation through agent-loco.

## Project Structure

- `/scenes` - Game scenes (main menu, game, etc.)
- `/scripts` - GDScript files for game logic
- `/assets` - Images, sounds, fonts, etc.
- `/export_presets.cfg` - Export settings for different platforms

## Development Status

- [x] Initial project setup
- [x] Basic gameplay mechanics
- [ ] Character design and animation
- [x] Obstacle generation system
- [ ] UI implementation
- [ ] Sound effects
- [ ] Particle effects
- [ ] Save/load high scores

## Linting and Validation

This project includes automated linting and validation to ensure Godot files are valid and the game compiles correctly:

- `validate_godot_files.sh` - Validates all project files including scenes, scripts, and project structure
- `.github/workflows/godot-validate.yml` - CI workflow that runs validation on every commit
- The validation checks:
  - All required files exist
  - Scene files have proper Godot format headers
  - GDScript files contain valid syntax
  - Project compiles successfully

## License

This project is currently in development and will be licensed once finalized.

## Working on this Project

### Development Setup
1. Clone the repository
2. Ensure Godot 4.x is installed and accessible from your terminal
3. Run `bash validate_godot_files.sh` to verify the project structure and validate all files

### Testing the Game
- **Manual Testing**: Open the project in Godot editor (`godot`) and test different scenes:
  - `scenes/menu_scene.tscn` - Main menu with start/play button
  - `scenes/main_scene.tscn` - Gameplay scene
  - `scenes/settings_scene.tscn` - Settings menu with volume slider and difficulty toggle

- **Automated Testing**: Run the validation script that checks:
  - All Godot files exist with proper format
  - Scripts pass syntax validation
  - Project compiles without errors
  - Tests in `scripts/test.gd` pass successfully

### Playing Test Instructions
1. Launch Godot from terminal: `godot`
2. Open project `project.godot`
3. Navigate to scenes using the scene tree or Scene menu:
   - Play `scenes/menu_scene.tscn` to start
   - Use settings button in menu to access `scenes/settings_scene.tscn`  
   - Test volume and difficulty controls in settings
4. Test gameplay by starting from main menu and controlling Gary with tap/keyboard input

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Test your changes with `validate_godot_files.sh`
4. Submit a pull request with clear commit messages