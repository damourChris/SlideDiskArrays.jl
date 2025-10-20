# SlideDiskArrays

[![Stable Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://damourChris.github.io/SlideDiskArrays.jl/stable)
[![Development documentation](https://img.shields.io/badge/docs-dev-blue.svg)](https://damourChris.github.io/SlideDiskArrays.jl/dev)
[![Test workflow status](https://github.com/damourChris/SlideDiskArrays.jl/actions/workflows/Test.yml/badge.svg?branch=main)](https://github.com/damourChris/SlideDiskArrays.jl/actions/workflows/Test.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/damourChris/SlideDiskArrays.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/damourChris/SlideDiskArrays.jl)
[![Docs workflow Status](https://github.com/damourChris/SlideDiskArrays.jl/actions/workflows/Docs.yml/badge.svg?branch=main)](https://github.com/damourChris/SlideDiskArrays.jl/actions/workflows/Docs.yml?query=branch%3Amain)
[![BestieTemplate](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/JuliaBesties/BestieTemplate.jl/main/docs/src/assets/badge.json)](https://github.com/JuliaBesties/BestieTemplate.jl)

This is a simple julia package that use `libopenslide` to read data from Slide files. It
implements the `AbstractDiskArray` from DiskArrays.jl to not have to load all data in memory.

Open an slide with `load(slide_path)` and pass a level if needed. You can then index the
returned `SlideDiskArray` to read data from the slide.

Each pixel is represented as an `RGB24` value from the Images.jl package.

Good luck!
