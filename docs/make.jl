using Homework6
using Documenter

DocMeta.setdocmeta!(Homework6, :DocTestSetup, :(using Homework6); recursive=true)

makedocs(;
    modules=[Homework6],
    authors="Promia Chowdhury <promia@mit.edu> and contributors",
    repo="https://github.com/pc0808/Homework6.jl/blob/{commit}{path}#{line}",
    sitename="Homework6.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://pc0808.github.io/Homework6.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/pc0808/Homework6.jl",
    devbranch="main",
)
