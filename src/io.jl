function load(filepath::AbstractString; level::Int = 0)
    osr = openslide_open(filepath)
    return SlideDiskArray(osr, level)
end
