using HashCode
using CustomType
using Documenter

DocMeta.setdocmeta!(HashCode, :DocTestSetup, :(using HashCode); recursive=true)

makedocs(;
    modules=[HashCode, CustomType],
    authors="Rom Fradkin <fradkin.rom@gmail.com> and contributors",
    repo="https://github.com/rfradkin/HashCode.jl/blob/{commit}{path}#{line}",
    sitename="HashCode.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://rfradkin.github.io/HashCode.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/rfradkin/HashCode.jl",
    devbranch="main",
)
