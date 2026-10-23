import SlideDiskArrays.LibOpenSlide: openslide_open

# This could be registered with FileIO registry
"""
    load_slide(filepath::AbstractString; level::Int = 0)

Load a slide using `openslide_open`.

Throws if `openslide_open` returns null.
"""
function load_slide(filepath::AbstractString; level::Int = 0)
    osr = openslide_open(filepath)

    if osr == C_NULL
        throw(ErrorException("Failed to open slide image at $filepath"))
    end

    return SlideDiskArray(osr, level)
end
