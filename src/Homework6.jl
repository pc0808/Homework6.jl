module Homework6

using HashCode2014
using BenchmarkTools
include("functions.jl")

# dist = randomWalkDistance()
# println(dist)
# @btime randomWalkDistance()


c = city()
c = change_duration(c, 18000)
soln = smartRandomWalk(c)
smart_dist = getSolnDistance(soln, c)
println(smart_dist)
@btime smartRandomWalk(c)
# println(smart_dist)
# smartRandomWalkDistance() ## @btime smartRandomWalkDistance()
end