using DiskArrays
import SlideDiskArrays.LibOpenSlide:
    openslide_t, openslide_get_level_dimensions, openslide_read_region, openslide_close

mutable struct SlideDiskArray{T,N} <: DiskArrays.AbstractDiskArray{T,N}
    osr::Ptr{openslide_t}
    level::Int
    size::NTuple{N,Int}

    function SlideDiskArray(osr::Ptr{openslide_t}, level::Int)
        # Allocate the w, h
        w = Ref{Int64}()
        h = Ref{Int64}()

        openslide_get_level_dimensions(osr, level, w, h)

        if w[] <= 0 || h[] <= 0
            throw(ArgumentError("Invalid level $level for the given slide."))
        end

        # This is nessecary since data read by openslide is in ARGB format
        # The data returned by read_region is in UInt32 format so the associated Colors.jl type
        # is RGB24
        T = RGB24

        slide_disk_array = new{T,2}(osr, level, (w[], h[]))

        finalizer(slide_disk_array) do s
            if s.osr != C_NULL
                openslide_close(s.osr)
            end
        end
        return slide_disk_array
        # return slide_disk_array
    end
end

Base.unsafe_convert(::Type{Ptr{openslide_t}}, engine::SlideDiskArray) = engine.ptr


# DiskArrays interface

Base.size(A::SlideDiskArray) = A.size
DiskArrays.haschunks(A::SlideDiskArray) = DiskArrays.Chunked()
DiskArrays.eachchunk(A::SlideDiskArray) = DiskArrays.GridChunks(A, (1024,1024))

function DiskArrays.readblock!(
    A::SlideDiskArray{T,2},
    aout,
    r::Vararg{AbstractUnitRange,2},
) where {T}
    xrange, yrange = r
    x = first(xrange) - 1
    y = first(yrange) - 1
    w = length(xrange)
    h = length(yrange)

    # We need to scale the coords since openslide_read_region expects coordinates in level 0
    factor = SlideDiskArrays.LibOpenSlide.openslide_get_level_downsample(A.osr, A.level)
    x = Int(floor(x * factor))
    y = Int(floor(y * factor))


    # Reshape the input array to be a UInt32 view to pass to openslide
    aout_view = reinterpret(reshape, UInt32, aout)

    # Shift the view to be 1D
    aout_view = reshape(aout_view, :)

    openslide_read_region(A.osr, aout_view, x, y, A.level, w, h)

    return aout_view
end

