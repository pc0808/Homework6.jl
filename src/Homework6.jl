module Homework6

using HashCode2014
using BenchmarkTools
include("functions.jl")


dist = randomWalkDistance()
println(dist)
@btime randomWalkDistance()
# HashCode2014.plot_streets(city, solution)

end
