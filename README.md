# Kromx

[![Build Status](https://dev.azure.com/luboslenco/armory/_apis/build/status/armory3d.Kromx?branchName=master)](https://dev.azure.com/luboslenco/armory/_build/latest?definitionId=3&branchName=master)

Krom Experiment

```bash
git clone --recursive https://github.com/armory3d/Kromx
cd Kromx
```
```bash
# Windows
# Unpack `V8\Libraries\win32\release\v8_monolith.7z` using 7-Zip (exceeds 100MB)
node Kinc/make -g direct3d11 --noshaders
# Open generated Visual Studio project
# Build for x64 & release
```
```bash
# Linux
node Kinc/make -g opengl --noshaders --compiler clang --compile
cd Deployment
strip Krom
```
```bash
# macOS
node Kinc/make -g opengl --noshaders
# Open generated Xcode project
# Add `path/to/Kromx/V8/Libraries/macos/release` into Library Search Paths
# Build
```
