using hw6
using Documenter

DocMeta.setdocmeta!(hw6, :DocTestSetup, :(using hw6); recursive=true)

makedocs(;
    modules=[hw6],
    authors="Rom Fradkin <fradkin.rom@gmail.com> and contributors",
    repo="https://github.com/rfradkin/hw6.jl/blob/{commit}{path}#{line}",
    sitename="hw6.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://rfradkin.github.io/hw6.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/rfradkin/hw6.jl",
    devbranch="main",
)
