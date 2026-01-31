#!/bin/bash
set -e

ARCH=$1
if [ -z "$ARCH" ]; then
    echo "Usage: $0 <arm64|x86_64>"
    exit 1
fi

BUILD_DIR="build-${ARCH}"
INSTALL_DIR="$(pwd)/${BUILD_DIR}"

cd ffmpeg

# 配置选项
CONFIGURE_FLAGS=(
    --prefix="${INSTALL_DIR}"
    --enable-shared
    --disable-static
    --enable-pic
    --disable-doc
    --disable-htmlpages
    --disable-manpages
    --disable-podpages
    --disable-txtpages
    --disable-avdevice
    --disable-indevs
    --disable-outdevs
    --disable-programs
    --disable-network
    --disable-protocols
    --enable-protocol=file

    # 解码器
    --disable-decoders
    --enable-decoder=png
    --enable-decoder=mjpeg
    --enable-decoder=jpeg2000
    --enable-decoder=webp
    --enable-decoder=bmp
    --enable-decoder=tiff
    --enable-decoder=gif
    --enable-decoder=ppm
    --enable-decoder=pgm
    --enable-decoder=rawvideo
    --enable-decoder=h264
    --enable-decoder=hevc
    --enable-decoder=vp8
    --enable-decoder=vp9
    --enable-decoder=av1
    --enable-decoder=mpeg4
    --enable-decoder=mpeg2video
    --enable-decoder=prores

    # 编码器
    --disable-encoders
    --enable-encoder=png
    --enable-encoder=mjpeg
    --enable-encoder=rawvideo

    # 解复用器
    --disable-demuxers
    --enable-demuxer=image2
    --enable-demuxer=image2pipe
    --enable-demuxer=png_pipe
    --enable-demuxer=jpeg_pipe
    --enable-demuxer=gif
    --enable-demuxer=mov
    --enable-demuxer=matroska
    --enable-demuxer=avi
    --enable-demuxer=mp4
    --enable-demuxer=webm
    --enable-demuxer=mpegts
    --enable-demuxer=mpegvideo
    --enable-demuxer=rawvideo

    # 复用器
    --disable-muxers
    --enable-muxer=image2
    --enable-muxer=image2pipe
    --enable-muxer=rawvideo
    --enable-muxer=null
    --enable-muxer=mp4
    --enable-muxer=mov
    --enable-muxer=matroska

    # 解析器
    --disable-parsers
    --enable-parser=h264
    --enable-parser=hevc
    --enable-parser=vp8
    --enable-parser=vp9
    --enable-parser=av1
    --enable-parser=mpeg4video
    --enable-parser=mjpeg
    --enable-parser=png

    # 滤镜
    --disable-filters
    --enable-filter=v360
    --enable-filter=fps
    --enable-filter=select
    --enable-filter=thumbnail
    --enable-filter=setpts
    --enable-filter=scale
    --enable-filter=crop
    --enable-filter=pad
    --enable-filter=format
    --enable-filter=transpose
    --enable-filter=hflip
    --enable-filter=vflip
    --enable-filter=rotate
    --enable-filter=buffer
    --enable-filter=buffersink
    --enable-filter=null
    --enable-filter=copy
    --enable-filter=colorspace
    --enable-filter=eq
    --enable-filter=hwupload
    --enable-filter=hwdownload
    --enable-filter=hwmap

    # BSF
    --disable-bsfs
    --enable-bsf=null
    --enable-bsf=h264_mp4toannexb
    --enable-bsf=hevc_mp4toannexb
    --enable-bsf=extract_extradata

    # 性能优化
    --enable-pthreads
    --enable-hardcoded-tables
    --enable-optimizations
    --enable-runtime-cpudetect
    --enable-stripping
    --disable-debug
    --enable-lto

    # macOS 特定选项
    --enable-videotoolbox
    --enable-audiotoolbox
    --enable-hwaccel=h264_videotoolbox
    --enable-hwaccel=hevc_videotoolbox
    --enable-hwaccel=vp9_videotoolbox
    --enable-hwaccel=av1_videotoolbox
    --enable-hwaccel=mpeg2_videotoolbox
    --enable-hwaccel=mpeg4_videotoolbox
    --enable-hwaccel=prores_videotoolbox
    --enable-encoder=h264_videotoolbox
    --enable-encoder=hevc_videotoolbox
    --enable-encoder=prores_videotoolbox
    --enable-asm
    --enable-inline-asm
)

# 架构特定选项
if [ "$ARCH" = "arm64" ]; then
    CONFIGURE_FLAGS+=(--arch=aarch64 --enable-neon --enable-vfp)
else
    CONFIGURE_FLAGS+=(--arch=x86_64)
fi

# 清理（只有在之前配置过的情况下）
if [ -f Makefile ]; then
    make clean || true
    make distclean || true
fi

./configure "${CONFIGURE_FLAGS[@]}"

# 编译并安装
make -j$(sysctl -n hw.ncpu)
make install

echo "FFmpeg build complete for ${ARCH}!"
ls -la "${INSTALL_DIR}/lib"
