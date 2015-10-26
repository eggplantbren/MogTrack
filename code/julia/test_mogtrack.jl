include("MogTrack.jl")

mogtrack = MogTrack(50)
from_prior!(mogtrack)

println(evaluate(mogtrack, 0.0, 0.0))

