include("Track.jl")
include("Gaussian.jl")

@doc """
A class representing a set of Tracks
which define the parameters of gaussians
""" ->
type MogTrack
	# Tracks which determine gaussian parameters
	log_mass::Track
	logit_q::Track
	xc::Track
	yc::Track
	log_width::Track
	theta::Track
end

@doc """
Constructor, takes Track parameters as input
""" ->
function MogTrack(num_points::Int64)
	return MogTrack(Track(num_points), Track(num_points), Track(num_points),
					Track(num_points), Track(num_points), Track(num_points))
end

