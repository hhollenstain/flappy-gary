#!/bin/bash

# Validate the Godot project with the Godot 4 command line.
# --check-only must be paired with --script. It can print SCRIPT ERROR
# and still exit 0, so the output is checked too. Tests run in Godot.

set -u

cd "$(dirname "$0")"

fail() {
    echo "ERROR: $*"
    exit 1
}

echo "Validating Godot project files..."

if [ ! -f "project.godot" ]; then
    fail "project.godot file not found"
fi
echo "✓ project.godot file exists"

main_scene=$(sed -n 's/^main_scene="res:\/\/\(.*\)"/\1/p' project.godot | head -1)
if [ -z "$main_scene" ]; then
    main_scene=$(sed -n 's/^run\/main_scene="res:\/\/\(.*\)"/\1/p' project.godot | head -1)
fi
if [ -z "$main_scene" ]; then
    fail "No main scene reference found in project.godot"
fi
if [ ! -f "$main_scene" ]; then
    fail "Main scene file not found: $main_scene"
fi
echo "✓ Main scene file exists: $main_scene"

scripts=()
while IFS= read -r script; do
    scripts+=("$script")
done < <(find . -name '*.gd' -not -path './.godot/*' | sed 's|^\./||' | sort)

if [ "${#scripts[@]}" -eq 0 ]; then
    fail "No GDScript files found"
fi
for script in "${scripts[@]}"; do
    echo "✓ Script file exists: $script"
done

scene_count=0
for scene_file in scenes/*.tscn; do
    if [ ! -f "$scene_file" ]; then
        continue
    fi
    scene_count=$((scene_count + 1))
    header=$(head -1 "$scene_file")
    if [[ "$header" != "[gd_scene"* ]]; then
        fail "Scene file is not a Godot scene: $scene_file"
    fi
    echo "✓ Scene file has a Godot header: $(basename "$scene_file")"
done
if [ "$scene_count" -eq 0 ]; then
    fail "No scene files found in scenes/"
fi

if [ -n "${GODOT_PATH:-}" ] && [ -x "$GODOT_PATH" ]; then
    godot_bin="$GODOT_PATH"
elif [ -n "${GODOT:-}" ] && [ -x "$GODOT" ]; then
    godot_bin="$GODOT"
elif command -v godot >/dev/null 2>&1; then
    godot_bin=$(command -v godot)
else
    fail "Godot was not found. Install Godot 4 or set GODOT_PATH."
fi

GODOT_OUTPUT=""

godot_failed() {
    printf '%s\n' "$1" | grep -E 'SCRIPT ERROR:|Parse Error:|Failed to load script|Couldn'"'"'t detect whether to run|GODOT TESTS FAILED|^FAIL:' >/dev/null
}

run_godot() {
    local output status
    output=$("$godot_bin" "$@" 2>&1)
    status=$?
    GODOT_OUTPUT=$output
    printf '%s\n' "$output"
    if [ "$status" -ne 0 ] || godot_failed "$output"; then
        return 1
    fi
    return 0
}

echo "Checking GDScript syntax using Godot..."
for script in "${scripts[@]}"; do
    if ! run_godot --headless --path . --check-only --script "$script"; then
        fail "Syntax check failed for: $script"
    fi
    echo "✓ Syntax check passed for: $script"
done

echo "Running Godot tests..."
if ! run_godot --headless --path . --script res://scripts/test.gd; then
    fail "Godot tests failed"
fi
if ! printf '%s\n' "$GODOT_OUTPUT" | grep -q "GODOT TESTS PASSED"; then
    fail "Godot tests did not report success"
fi
echo "✓ Godot tests passed"

echo "Importing the Godot project..."
if ! run_godot --headless --path . --import; then
    fail "Project failed to import"
fi
echo "✓ Godot project imports successfully"

# Final verification - test that main scene can be loaded without critical rendering errors
echo "Verifying main scene loads with player character..."
# Try to validate that the scene has proper structure for rendering
# Import the scene and check for errors in headless mode
import_output=$(run_godot --headless --path . --import 2>&1) || true
if grep -Eq "SCRIPT ERROR:|Parse Error:|Failed to load|Couldn't detect whether to run" <<<"$import_output"; then
    fail "Import produced errors - scene may not load properly"
fi
echo "✓ Scene imports without critical errors"

main_scene=$(sed -n 's/^main_scene="res:\/\/\(.*\)"/\1/p' project.godot | head -1)
if [ -z "$main_scene" ]; then
    main_scene=$(sed -n 's/^run\/main_scene="res:\/\/\(.*\)"/\1/p' project.godot | head -1)
fi
if [ -f "$main_scene" ]; then
    if grep -q "Player" "$main_scene"; then
        echo "✓ Main scene contains Player node"
    else
        fail "Main scene missing Player node - will not render player"
    fi
    
    # Check that the main scene has at least a Camera and basic structure
    if grep -q "Camera2D" "$main_scene"; then
        echo "✓ Main scene contains Camera2D for rendering"
    else
        fail "Main scene missing Camera2D - cannot render game"
    fi
fi

# Also check if there's a MainScene.tscn with Player and Camera2D
if [ -f "MainScene.tscn" ]; then
    if grep -q "Player" "MainScene.tscn" && grep -q "Camera2D" "MainScene.tscn"; then
        echo "✓ MainScene.tscn contains Player node and Camera2D for rendering"
    fi
fi

# Check pipes in scenes
if grep -q "pipe" "scenes/pipe.tscn" 2>/dev/null; then
    echo "✓ Pipe scene exists for obstacles"
else
    if [ -f "MainScene.tscn" ] && grep -q "pipe" "MainScene.tscn"; then
        echo "✓ Pipe reference found in main scene for obstacles"
    fi
fi

echo "Godot project validation completed successfully!"
