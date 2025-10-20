using SlideDiskArrays
using Documenter

DocMeta.setdocmeta!(SlideDiskArrays, :DocTestSetup, :(using SlideDiskArrays); recursive = true)

const page_rename = Dict("developer.md" => "Developer docs") # Without the numbers
const numbered_pages = [
    file for file in readdir(joinpath(@__DIR__, "src")) if
    file != "index.md" && splitext(file)[2] == ".md"
]

makedocs(;
    modules = [SlideDiskArrays],
    authors = "Chris Damour <damourchris@pm.me>",
    repo = "https://github.com/damourChris/SlideDiskArrays.jl/blob/{commit}{path}#{line}",
    sitename = "SlideDiskArrays.jl",
    format = Documenter.HTML(; canonical = "https://damourChris.github.io/SlideDiskArrays.jl"),
    pages = ["index.md"; numbered_pages],
)

deploydocs(; repo = "github.com/damourChris/SlideDiskArrays.jl")
