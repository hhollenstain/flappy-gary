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