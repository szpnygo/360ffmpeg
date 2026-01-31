#!/bin/bash
# 本地构建脚本 - 检测平台并调用相应的构建脚本

set -e

FFMPEG_VERSION="${1:-n8.0.1}"

echo "======================================"
echo "FFmpeg Prebuilt Library Builder"
echo "Version: ${FFMPEG_VERSION}"
echo "======================================"

# 检测操作系统
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    PLATFORM="windows"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PLATFORM="linux"
else
    echo "Unsupported platform: $OSTYPE"
    exit 1
fi

echo "Detected platform: $PLATFORM"

# 下载 FFmpeg 源码
if [ ! -d "ffmpeg" ]; then
    echo "Downloading FFmpeg ${FFMPEG_VERSION}..."
    if command -v wget &> /dev/null; then
        wget -q --show-progress "https://github.com/FFmpeg/FFmpeg/archive/refs/tags/${FFMPEG_VERSION}.tar.gz"
    elif command -v curl &> /dev/null; then
        curl -L -o "${FFMPEG_VERSION}.tar.gz" "https://github.com/FFmpeg/FFmpeg/archive/refs/tags/${FFMPEG_VERSION}.tar.gz"
    else
        echo "Error: Neither wget nor curl is available"
        exit 1
    fi

    echo "Extracting..."
    tar -xf "${FFMPEG_VERSION}.tar.gz"
    mv "FFmpeg-${FFMPEG_VERSION}" ffmpeg
    rm "${FFMPEG_VERSION}.tar.gz"
    echo "Download complete!"
else
    echo "FFmpeg source directory already exists, skipping download."
fi

# 根据平台执行构建
case $PLATFORM in
    macos)
        echo ""
        echo "Building for macOS (ARM64)..."
        bash scripts/build_macos.sh arm64

        # 将 build-arm64 重命名为 build
        rm -rf build
        mv build-arm64 build

        echo ""
        echo "======================================"
        echo "Build complete! Output in ./build/"
        echo "Include: $(ls -1 build/include | wc -l | tr -d ' ') header directories"
        echo "Libraries: $(ls -1 build/lib/*.dylib 2>/dev/null | wc -l | tr -d ' ') dylib files"
        echo "======================================"
        ;;

    windows)
        echo ""
        echo "Building for Windows..."
        bash scripts/build_windows.sh

        echo ""
        echo "======================================"
        echo "Build complete! Output in ./build/"
        echo "Include: $(ls -1 build/include | wc -l | tr -d ' ') header directories"
        echo "Libraries: $(ls -1 build/lib/*.dll 2>/dev/null | wc -l | tr -d ' ') dll files"
        echo "======================================"
        ;;

    linux)
        echo ""
        echo "Building for Linux..."
        bash scripts/build_linux.sh

        echo ""
        echo "======================================"
        echo "Build complete! Output in ./build/"
        echo "Include: $(ls -1 build/include | wc -l | tr -d ' ') header directories"
        echo "Libraries: $(ls -1 build/lib/*.so* 2>/dev/null | wc -l | tr -d ' ') so files"
        echo "======================================"
        ;;
esac

# 显示构建结果
echo ""
echo "Build output:"
ls -lh build/lib/ 2>/dev/null || echo "No build output found"
