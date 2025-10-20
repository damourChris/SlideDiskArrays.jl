module LibOpenSlide

using OpenSlide_jll
export OpenSlide_jll

using CEnum: CEnum, @cenum

function _openslide_give_prefetch_hint_UNIMPLEMENTED()
    @ccall libopenslide._openslide_give_prefetch_hint_UNIMPLEMENTED()::Cint
end

function _openslide_cancel_prefetch_hint_UNIMPLEMENTED()
    @ccall libopenslide._openslide_cancel_prefetch_hint_UNIMPLEMENTED()::Cvoid
end

mutable struct _openslide end

"""
The main OpenSlide type.
"""
const openslide_t = _openslide

"""
    openslide_detect_vendor(filename)

Quickly determine whether a whole slide image is recognized.

If OpenSlide recognizes the file referenced by `filename`, return a string identifying the slide format vendor. This is equivalent to the value of the #[`OPENSLIDE_PROPERTY_NAME_VENDOR`](@ref) property. Calling [`openslide_open`](@ref)() on this file will return a valid OpenSlide object or an OpenSlide object in error state.

Otherwise, return NULL. Calling [`openslide_open`](@ref)() on this file will also return NULL.

\\since 3.4.0

# Arguments
* `filename`: The filename to check.
# Returns
An identification of the format vendor for this file, or NULL.
"""
function openslide_detect_vendor(filename)
    @ccall libopenslide.openslide_detect_vendor(filename::Cstring)::Cstring
end

"""
    openslide_open(filename)

Open a whole slide image.

This function can be expensive; avoid calling it unnecessarily. For example, a tile server should not call [`openslide_open`](@ref)() on every tile request. Instead, it should maintain a cache of OpenSlide objects and reuse them when possible.

# Arguments
* `filename`: The filename to open.
# Returns
On success, a new OpenSlide object. If the file is not recognized by OpenSlide, NULL. If the file is recognized but an error occurred, an OpenSlide object in error state.
"""
function openslide_open(filename)
    @ccall libopenslide.openslide_open(filename::Cstring)::Ptr{openslide_t}
end

"""
    openslide_get_level_count(osr)

Get the number of levels in the whole slide image.

\\since 3.3.0

# Arguments
* `osr`: The OpenSlide object.
# Returns
The number of levels, or -1 if an error occurred.
"""
function openslide_get_level_count(osr)
    @ccall libopenslide.openslide_get_level_count(osr::Ptr{openslide_t})::Int32
end

"""
    openslide_get_level0_dimensions(osr, w, h)

Get the dimensions of level 0 (the largest level). Exactly equivalent to calling [`openslide_get_level_dimensions`](@ref)(osr, 0, w, h).

\\since 3.3.0

# Arguments
* `osr`: The OpenSlide object.
* `w`:\\[out\\] The width of the image, or -1 if an error occurred.
* `h`:\\[out\\] The height of the image, or -1 if an error occurred.
"""
function openslide_get_level0_dimensions(osr, w, h)
    @ccall libopenslide.openslide_get_level0_dimensions(osr::Ptr{openslide_t}, w::Ptr{Int64}, h::Ptr{Int64})::Cvoid
end

"""
    openslide_get_level_dimensions(osr, level, w, h)

Get the dimensions of a level.

\\since 3.3.0

# Arguments
* `osr`: The OpenSlide object.
* `level`: The desired level.
* `w`:\\[out\\] The width of the image, or -1 if an error occurred or the level was out of range.
* `h`:\\[out\\] The height of the image, or -1 if an error occurred or the level was out of range.
"""
function openslide_get_level_dimensions(osr, level, w, h)
    @ccall libopenslide.openslide_get_level_dimensions(osr::Ptr{openslide_t}, level::Int32, w::Ptr{Int64}, h::Ptr{Int64})::Cvoid
end

"""
    openslide_get_level_downsample(osr, level)

Get the downsampling factor of a given level.

\\since 3.3.0

# Arguments
* `osr`: The OpenSlide object.
* `level`: The desired level.
# Returns
The downsampling factor for this level, or -1.0 if an error occurred or the level was out of range.
"""
function openslide_get_level_downsample(osr, level)
    @ccall libopenslide.openslide_get_level_downsample(osr::Ptr{openslide_t}, level::Int32)::Cdouble
end

"""
    openslide_get_best_level_for_downsample(osr, downsample)

Get the best level to use for displaying the given downsample.

\\since 3.3.0

# Arguments
* `osr`: The OpenSlide object.
* `downsample`: The downsample factor.
# Returns
The level identifier, or -1 if an error occurred.
"""
function openslide_get_best_level_for_downsample(osr, downsample)
    @ccall libopenslide.openslide_get_best_level_for_downsample(osr::Ptr{openslide_t}, downsample::Cdouble)::Int32
end

"""
    openslide_read_region(osr, dest, x, y, level, w, h)

Copy pre-multiplied ARGB data from a whole slide image.

This function reads and decompresses a region of a whole slide image into the specified memory location. `dest` must be a valid pointer to enough memory to hold the region, at least (`w` * `h` * 4) bytes in length. If an error occurs or has occurred, then the memory pointed to by `dest` will be cleared.

# Arguments
* `osr`: The OpenSlide object.
* `dest`: The destination buffer for the ARGB data.
* `x`: The top left x-coordinate, in the level 0 reference frame.
* `y`: The top left y-coordinate, in the level 0 reference frame.
* `level`: The desired level.
* `w`: The width of the region. Must be non-negative.
* `h`: The height of the region. Must be non-negative.
"""
function openslide_read_region(osr, dest, x, y, level, w, h)
    @ccall libopenslide.openslide_read_region(osr::Ptr{openslide_t}, dest::Ptr{UInt32}, x::Int64, y::Int64, level::Int32, w::Int64, h::Int64)::Cvoid
end

"""
    openslide_close(osr)

Close an OpenSlide object. No other threads may be using the object. After this call returns, the object cannot be used anymore.

# Arguments
* `osr`: The OpenSlide object.
"""
function openslide_close(osr)
    @ccall libopenslide.openslide_close(osr::Ptr{openslide_t})::Cvoid
end

"""
    openslide_get_error(osr)

Get the current error string.

For a given OpenSlide object, once this function returns a non-NULL value, the only useful operation on the object is to call [`openslide_close`](@ref)() to free its resources.

\\since 3.2.0

# Arguments
* `osr`: The OpenSlide object.
# Returns
A string describing the original error that caused the problem, or NULL if no error has occurred.
"""
function openslide_get_error(osr)
    @ccall libopenslide.openslide_get_error(osr::Ptr{openslide_t})::Cstring
end

"""
    openslide_get_property_names(osr)

Get the NULL-terminated array of property names.

Certain vendor-specific metadata properties may exist within a whole slide image. They are encoded as key-value pairs. This call provides a list of names as strings that can be used to read properties with [`openslide_get_property_value`](@ref)().

# Arguments
* `osr`: The OpenSlide object.
# Returns
A NULL-terminated string array of property names, or an empty array if an error occurred.
"""
function openslide_get_property_names(osr)
    @ccall libopenslide.openslide_get_property_names(osr::Ptr{openslide_t})::Ptr{Cstring}
end

"""
    openslide_get_property_value(osr, name)

Get the value of a single property.

Certain vendor-specific metadata properties may exist within a whole slide image. They are encoded as key-value pairs. This call provides the value of the property given by `name`.

# Arguments
* `osr`: The OpenSlide object.
* `name`: The name of the desired property. Must be a valid name as given by [`openslide_get_property_names`](@ref)().
# Returns
The value of the named property, or NULL if the property doesn't exist or an error occurred.
"""
function openslide_get_property_value(osr, name)
    @ccall libopenslide.openslide_get_property_value(osr::Ptr{openslide_t}, name::Cstring)::Cstring
end

"""
    openslide_get_associated_image_names(osr)

Get the NULL-terminated array of associated image names.

Certain vendor-specific associated images may exist within a whole slide image. They are encoded as key-value pairs. This call provides a list of names as strings that can be used to read associated images with [`openslide_get_associated_image_dimensions`](@ref)() and [`openslide_read_associated_image`](@ref)().

# Arguments
* `osr`: The OpenSlide object.
# Returns
A NULL-terminated string array of associated image names, or an empty array if an error occurred.
"""
function openslide_get_associated_image_names(osr)
    @ccall libopenslide.openslide_get_associated_image_names(osr::Ptr{openslide_t})::Ptr{Cstring}
end

"""
    openslide_get_associated_image_dimensions(osr, name, w, h)

Get the dimensions of an associated image.

This function returns the width and height of an associated image associated with a whole slide image. Once the dimensions are known, use [`openslide_read_associated_image`](@ref)() to read the image.

# Arguments
* `osr`: The OpenSlide object.
* `name`: The name of the desired associated image. Must be a valid name as given by [`openslide_get_associated_image_names`](@ref)().
* `w`:\\[out\\] The width of the associated image, or -1 if an error occurred.
* `h`:\\[out\\] The height of the associated image, or -1 if an error occurred.
"""
function openslide_get_associated_image_dimensions(osr, name, w, h)
    @ccall libopenslide.openslide_get_associated_image_dimensions(osr::Ptr{openslide_t}, name::Cstring, w::Ptr{Int64}, h::Ptr{Int64})::Cvoid
end

"""
    openslide_read_associated_image(osr, name, dest)

Copy pre-multiplied ARGB data from an associated image.

This function reads and decompresses an associated image associated with a whole slide image. `dest` must be a valid pointer to enough memory to hold the image, at least (width * height * 4) bytes in length. Get the width and height with [`openslide_get_associated_image_dimensions`](@ref)(). This call does nothing if an error occurred.

# Arguments
* `osr`: The OpenSlide object.
* `dest`: The destination buffer for the ARGB data.
* `name`: The name of the desired associated image. Must be a valid name as given by [`openslide_get_associated_image_names`](@ref)().
"""
function openslide_read_associated_image(osr, name, dest)
    @ccall libopenslide.openslide_read_associated_image(osr::Ptr{openslide_t}, name::Cstring, dest::Ptr{UInt32})::Cvoid
end

"""
    openslide_get_version()

Get the version of the OpenSlide library.

\\since 3.3.0

# Returns
A string describing the OpenSlide version.
"""
function openslide_get_version()
    @ccall libopenslide.openslide_get_version()::Cstring
end

"""
    openslide_can_open(filename)

Return whether [`openslide_open`](@ref)() will succeed.

This function returns `true` if [`openslide_open`](@ref)() will return a valid openslide_t, or `false` if it will return NULL or an openslide_t in error state. As such, there's no reason to use it; just call [`openslide_open`](@ref)(). For a less-expensive test that provides weaker guarantees, see [`openslide_detect_vendor`](@ref)().

Before version 3.4.0, this function could be slightly faster than calling [`openslide_open`](@ref)(), but it could also erroneously return `true` in some cases where [`openslide_open`](@ref)() would fail.

!!! compat "Deprecated"

    Use [`openslide_detect_vendor`](@ref)() to efficiently check whether a slide file is recognized by OpenSlide, or just call [`openslide_open`](@ref)().

# Arguments
* `filename`: The filename to check.
# Returns
If [`openslide_open`](@ref)() will succeed.
"""
function openslide_can_open(filename)
    @ccall libopenslide.openslide_can_open(filename::Cstring)::Bool
end

"""
    openslide_get_layer_count(osr)

Get the number of levels in the whole slide image.

!!! compat "Deprecated"

    Use [`openslide_get_level_count`](@ref)() instead.

# Arguments
* `osr`: The OpenSlide object.
# Returns
The number of levels, or -1 if an error occurred.
"""
function openslide_get_layer_count(osr)
    @ccall libopenslide.openslide_get_layer_count(osr::Ptr{openslide_t})::Int32
end

"""
    openslide_get_layer0_dimensions(osr, w, h)

Get the dimensions of level 0 (the largest level). Exactly equivalent to calling [`openslide_get_level_dimensions`](@ref)(osr, 0, w, h).

!!! compat "Deprecated"

    Use [`openslide_get_level0_dimensions`](@ref)() instead.

# Arguments
* `osr`: The OpenSlide object.
* `w`:\\[out\\] The width of the image, or -1 if an error occurred.
* `h`:\\[out\\] The height of the image, or -1 if an error occurred.
"""
function openslide_get_layer0_dimensions(osr, w, h)
    @ccall libopenslide.openslide_get_layer0_dimensions(osr::Ptr{openslide_t}, w::Ptr{Int64}, h::Ptr{Int64})::Cvoid
end

"""
    openslide_get_layer_dimensions(osr, level, w, h)

Get the dimensions of a level.

!!! compat "Deprecated"

    Use [`openslide_get_level_dimensions`](@ref)() instead.

# Arguments
* `osr`: The OpenSlide object.
* `level`: The desired level.
* `w`:\\[out\\] The width of the image, or -1 if an error occurred or the level was out of range.
* `h`:\\[out\\] The height of the image, or -1 if an error occurred or the level was out of range.
"""
function openslide_get_layer_dimensions(osr, level, w, h)
    @ccall libopenslide.openslide_get_layer_dimensions(osr::Ptr{openslide_t}, level::Int32, w::Ptr{Int64}, h::Ptr{Int64})::Cvoid
end

"""
    openslide_get_layer_downsample(osr, level)

Get the downsampling factor of a given level.

!!! compat "Deprecated"

    Use [`openslide_get_level_downsample`](@ref)() instead.

# Arguments
* `osr`: The OpenSlide object.
* `level`: The desired level.
# Returns
The downsampling factor for this level, or -1.0 if an error occurred or the level was out of range.
"""
function openslide_get_layer_downsample(osr, level)
    @ccall libopenslide.openslide_get_layer_downsample(osr::Ptr{openslide_t}, level::Int32)::Cdouble
end

"""
    openslide_get_best_layer_for_downsample(osr, downsample)

Get the best level to use for displaying the given downsample.

!!! compat "Deprecated"

    Use [`openslide_get_best_level_for_downsample`](@ref)() instead.

# Arguments
* `osr`: The OpenSlide object.
* `downsample`: The downsample factor.
# Returns
The level identifier, or -1 if an error occurred.
"""
function openslide_get_best_layer_for_downsample(osr, downsample)
    @ccall libopenslide.openslide_get_best_layer_for_downsample(osr::Ptr{openslide_t}, downsample::Cdouble)::Int32
end

"""
    openslide_get_comment(osr)

Get the comment (if any) for this image. Exactly equivalent to calling [`openslide_get_property_value`](@ref)() with #[`OPENSLIDE_PROPERTY_NAME_COMMENT`](@ref).

!!! compat "Deprecated"

    Call [`openslide_get_property_value`](@ref)() with #[`OPENSLIDE_PROPERTY_NAME_COMMENT`](@ref) instead.

# Arguments
* `osr`: The OpenSlide object.
# Returns
The comment for this image, or NULL if an error occurred.
"""
function openslide_get_comment(osr)
    @ccall libopenslide.openslide_get_comment(osr::Ptr{openslide_t})::Cstring
end

const OPENSLIDE_PROPERTY_NAME_COMMENT = "openslide.comment"

const OPENSLIDE_PROPERTY_NAME_VENDOR = "openslide.vendor"

const OPENSLIDE_PROPERTY_NAME_QUICKHASH1 = "openslide.quickhash-1"

const OPENSLIDE_PROPERTY_NAME_BACKGROUND_COLOR = "openslide.background-color"

const OPENSLIDE_PROPERTY_NAME_OBJECTIVE_POWER = "openslide.objective-power"

const OPENSLIDE_PROPERTY_NAME_MPP_X = "openslide.mpp-x"

const OPENSLIDE_PROPERTY_NAME_MPP_Y = "openslide.mpp-y"

const OPENSLIDE_PROPERTY_NAME_BOUNDS_X = "openslide.bounds-x"

const OPENSLIDE_PROPERTY_NAME_BOUNDS_Y = "openslide.bounds-y"

const OPENSLIDE_PROPERTY_NAME_BOUNDS_WIDTH = "openslide.bounds-width"

const OPENSLIDE_PROPERTY_NAME_BOUNDS_HEIGHT = "openslide.bounds-height"

end # module
