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

