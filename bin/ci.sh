#!/bin/bash

set -ex

echo "Build project"
rojo build test-model.project.json --output model.rbxmx
echo "Remove .luaurc from dev dependencies"
find Packages/Dev -name "*.luaurc" | xargs rm -f
find Packages/_Index -name "*.luaurc" | xargs rm -f
echo "Run static analysis"
selene src/init.lua src/__tests__ 
stylua -c src/init.lua src/__tests__ 
roblox-cli analyze test-model.project.json
echo "Run tests"
roblox-cli run --load.model model.rbxmx --run bin/spec.lua
