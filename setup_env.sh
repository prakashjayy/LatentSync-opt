#!/bin/bash

# LatentSync environment setup using uv
# Prerequisites: uv (https://docs.astral.sh/uv/getting-started/installation/)
# Optional: ffmpeg (install via conda, apt, or brew)

set -e

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "uv is not installed. Please install it first:"
    echo "  curl -LsSf https://astral.sh/uv/install.sh | sh"
    echo "  # or: pip install uv"
    exit 1
fi

# Create virtual environment and install dependencies with uv
echo "Creating virtual environment and installing dependencies..."
uv sync

# Optional: Install ffmpeg if not present (Linux)
if command -v apt-get &> /dev/null && ! command -v ffmpeg &> /dev/null; then
    echo "Installing ffmpeg via apt..."
    sudo apt-get update && sudo apt-get install -y ffmpeg
fi

# Optional: OpenCV dependencies (Linux)
if command -v apt-get &> /dev/null; then
    echo "Installing OpenCV system dependencies..."
    sudo apt-get install -y libgl1
fi

# Download the checkpoints required for inference from HuggingFace
echo "Downloading checkpoints from HuggingFace..."
uv run huggingface-cli download ByteDance/LatentSync-1.6 whisper/tiny.pt --local-dir checkpoints
uv run huggingface-cli download ByteDance/LatentSync-1.6 latentsync_unet.pt --local-dir checkpoints

echo ""
echo "Setup complete! Activate the environment with:"
echo "  source .venv/bin/activate"
echo ""
echo "Or run commands directly with uv:"
echo "  uv run python gradio_app.py"
echo "  uv run ./inference.sh"
