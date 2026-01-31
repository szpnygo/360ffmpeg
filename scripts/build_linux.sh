#!/bin/bash
set -e

INSTALL_DIR="$(pwd)/build"
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

    # Linux 特定选项
    --enable-asm
    --enable-x86asm
)

# 清理（只有在之前配置过的情况下）
if [ -f Makefile ]; then
    make clean || true
    make distclean || true
fi

./configure "${CONFIGURE_FLAGS[@]}"

# 编译并安装
make -j$(nproc)
make install

echo "FFmpeg build complete for Linux!"
ls -la "${INSTALL_DIR}/lib"
