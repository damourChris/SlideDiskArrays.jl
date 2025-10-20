import SlideDiskArrays.LibOpenSlide: openslide_open

function load(filepath::AbstractString; level::Int = 0)
    osr = openslide_open(filepath)

    if osr == C_NULL
        throw(ErrorException("Failed to open slide image at $filepath"))
    end

    return SlideDiskArray(osr, level)
end
