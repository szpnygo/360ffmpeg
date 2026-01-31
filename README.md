# FFmpeg Prebuilt Libraries

预编译的 FFmpeg 动态库，专为 360 全景视频处理优化。

## 功能特性

- **360 全景处理**: v360 滤镜支持
- **视频解码**: H264, HEVC, VP8/VP9, AV1, MPEG4, ProRes
- **图片格式**: PNG, JPEG, WebP, BMP, TIFF, GIF
- **硬件加速**:
  - macOS: VideoToolbox
  - Windows: D3D11VA, DXVA2, MediaFoundation
  - Linux: 可选 VA-API
- **LGPL 许可**: 无 GPL 依赖，可用于闭源项目

## 下载预编译库

从 [Releases](https://github.com/yourusername/360ffmpeg/releases) 下载对应平台的预编译包。

| 平台 | 文件名 |
|------|--------|
| macOS (ARM64) | `ffmpeg-macos-arm64-v*.tar.gz` |
| Windows (x86_64) | `ffmpeg-windows-x86_64-v*.zip` |
| Linux (x86_64) | `ffmpeg-linux-x86_64-v*.tar.gz` |

## 目录结构

解压后的目录结构：

```
ffmpeg-prebuilt/
├── include/
│   ├── libavcodec/
│   ├── libavfilter/
│   ├── libavformat/
│   ├── libavutil/
│   ├── libswresample/
│   ├── libswscale/
│   └── libavcodec/
│       ├── codec.h
│       ├── codec_id.h
│       └── ...
└── lib/
    ├── macOS: *.dylib
    ├── Windows: *.dll + *.dll.a
    └── Linux: *.so
```

## 在项目中使用

### CMake 配置示例

```cmake
# 设置 FFmpeg 路径
set(FFMPEG_ROOT "${CMAKE_SOURCE_DIR}/third_party/ffmpeg-prebuilt")

# 包含目录
include_directories("${FFMPEG_ROOT}/include")

# 链接目录
link_directories("${FFMPEG_ROOT}/lib")

# 链接库
if(APPLE)
    target_link_libraries(your_target
        "${FFMPEG_ROOT}/lib/libavcodec.dylib"
        "${FFMPEG_ROOT}/lib/libavfilter.dylib"
        "${FFMPEG_ROOT}/lib/libavformat.dylib"
        "${FFMPEG_ROOT}/lib/libavutil.dylib"
        "${FFMPEG_ROOT}/lib/libswresample.dylib"
        "${FFMPEG_ROOT}/lib/libswscale.dylib"
        # macOS 框架
        "-framework CoreFoundation"
        "-framework CoreMedia"
        "-framework CoreVideo"
        "-framework VideoToolbox"
        "-framework AudioToolbox"
    )
elseif(WIN32)
    target_link_libraries(your_target
        "${FFMPEG_ROOT}/lib/libavcodec.dll.a"
        "${FFMPEG_ROOT}/lib/libavfilter.dll.a"
        "${FFMPEG_ROOT}/lib/libavformat.dll.a"
        "${FFMPEG_ROOT}/lib/libavutil.dll.a"
        "${FFMPEG_ROOT}/lib/libswresample.dll.a"
        "${FFMPEG_ROOT}/lib/libswscale.dll.a"
    )
    # 复制 DLL 到输出目录
    add_custom_command(TARGET your_target POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${FFMPEG_ROOT}/lib"
        $<TARGET_FILE_DIR:your_target>
        COMMENT "Copying FFmpeg DLLs"
    )
else()
    target_link_libraries(your_target
        "${FFMPEG_ROOT}/lib/libavcodec.so"
        "${FFMPEG_ROOT}/lib/libavfilter.so"
        "${FFMPEG_ROOT}/lib/libavformat.so"
        "${FFMPEG_ROOT}/lib/libavutil.so"
        "${FFMPEG_ROOT}/lib/libswresample.so"
        "${FFMPEG_ROOT}/lib/libswscale.so"
    )
endif()
```

## 本地编译

### macOS

```bash
# 下载 FFmpeg
wget https://github.com/FFmpeg/FFmpeg/archive/refs/tags/n8.0.1.tar.gz
tar -xf n8.0.1.tar.gz
mv FFmpeg-n8.0.1 ffmpeg

# 编译 ARM64
bash scripts/build_macos.sh arm64
```

### Windows (MSYS2/UCRT64)

```bash
# 在 MSYS2 UCRT64 环境中
pacman -S base-devel git gcc yasm nasm make python

# 下载 FFmpeg
wget https://github.com/FFmpeg/FFmpeg/archive/refs/tags/n8.0.1.tar.gz
tar -xf n8.0.1.tar.gz
mv FFmpeg-n8.0.1 ffmpeg

# 编译
bash scripts/build_windows.sh
```

### Linux

```bash
# 安装依赖
sudo apt-get install yasm nasm build-essential

# 下载 FFmpeg
wget https://github.com/FFmpeg/FFmpeg/archive/refs/tags/n8.0.1.tar.gz
tar -xf n8.0.1.tar.gz
mv FFmpeg-n8.0.1 ffmpeg

# 编译
bash scripts/build_linux.sh
```

## 发布新版本

1. 更新版本号：
   - `.github/workflows/build.yml` 中的 `FFMPEG_VERSION`
   - 推送标签：`git tag v1.0.0 && git push origin v1.0.0`

2. GitHub Actions 自动构建并创建 Release

## 许可证

FFmpeg 使用 LGPL 许可证。本项目的预编译库配置为 LGPL 模式，可用于闭源项目（需保留 FFmpeg 版权声明）。
