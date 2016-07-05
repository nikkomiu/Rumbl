#!/bin/bash

PORT=8080

echo "Compiling Application..."
MIX_ENV=prod mix compile

echo "Adding Digest to Assets..."
MIX_ENV=prod mix phoenix.digest

echo "Creating Release..."
MIX_ENV=prod mix release
