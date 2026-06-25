#!/usr/bin/env bash
#
# Batch convert images (JPG, PNG) to WebP using cwebp with high quality and compression settings.
# Recursively searches directories.
#
# Requirements:
#   - cwebp (from WebP):  brew install webp        (macOS)
#   - OR ffmpeg:           brew install ffmpeg       (macOS)
#
# The script auto-detects which tool is available (prefers cwebp).
#
# Settings:
#   - Quality: 80 (High visual fidelity)
#   - Compression Level: 6 (Maximum compression effort)
#
# Usage:
#   ./scripts/convert-images.sh                  # defaults to public/images
#   ./scripts/convert-images.sh src/content/posts

set -euo pipefail

TARGET_PATH="${1:-public/images}"

if [ ! -d "$TARGET_PATH" ]; then
    echo "Error: Directory '$TARGET_PATH' does not exist."
    exit 1
fi

# --- Detect available encoder ---
ENCODER=""
if command -v cwebp &>/dev/null; then
    ENCODER="cwebp"
elif command -v ffmpeg &>/dev/null; then
    ENCODER="ffmpeg"
else
    echo "Error: No WebP encoder found."
    echo "  macOS:  brew install webp        (recommended, lightweight)"
    echo "          brew install ffmpeg      (full-featured, larger)"
    echo "  Linux:  sudo apt install webp    /  sudo dnf install libwebp-tools"
    exit 1
fi

echo "Using encoder: $ENCODER"
echo "Target directory: $TARGET_PATH"
echo ""

count=0
total_saved=0

# Find all JPG, JPEG, PNG, BMP files recursively
while IFS= read -r -d '' img; do
    webp_path="${img%.*}.webp"

    if [ -f "$webp_path" ]; then
        echo -e "\033[90mSkipping (WebP exists): $img\033[0m"
        continue
    fi

    printf "Converting: %s ..." "$img"

    original_size=$(stat -f%z "$img" 2>/dev/null || stat -c%s "$img" 2>/dev/null)

    # Encode
    if [ "$ENCODER" = "cwebp" ]; then
        cwebp -q 80 -m 6 "$img" -o "$webp_path" &>/dev/null
    else
        ffmpeg -i "$img" -c:v libwebp -lossless 0 -compression_level 6 -q:v 80 -y "$webp_path" &>/dev/null
    fi

    if [ $? -eq 0 ] && [ -f "$webp_path" ]; then
        new_size=$(stat -f%z "$webp_path" 2>/dev/null || stat -c%s "$webp_path" 2>/dev/null)
        saved=$((original_size - new_size))
        ratio=$(echo "scale=1; $new_size * 100 / $original_size" | bc)
        saved_kb=$(echo "scale=1; $saved / 1024" | bc)

        total_saved=$((total_saved + saved))
        count=$((count + 1))

        echo -e " \033[32mDone. Ratio: ${ratio}% (Saved ${saved_kb} KB)\033[0m"
    else
        echo -e " \033[31mFailed.\033[0m"
        rm -f "$webp_path"
    fi
done < <(find "$TARGET_PATH" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" \) -print0)

echo ""
echo -e "\033[36mConversion Complete!\033[0m"
echo "Converted $count files."
if [ "$count" -gt 0 ]; then
    saved_mb=$(echo "scale=2; $total_saved / 1048576" | bc)
    echo "Total space saved: ${saved_mb} MB"
fi
