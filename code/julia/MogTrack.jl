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

@doc """
Generate a MogTrack from the prior.
""" ->
function from_prior!(mogtrack::MogTrack)
	calculate_C!(mogtrack.log_mass)
	calculate_C!(mogtrack.logit_q)
	calculate_C!(mogtrack.xc)
	calculate_C!(mogtrack.yc)
	calculate_C!(mogtrack.log_width)
	calculate_C!(mogtrack.theta)

	generate_y!(mogtrack.log_mass)
	generate_y!(mogtrack.logit_q)
	generate_y!(mogtrack.xc)
	generate_y!(mogtrack.yc)
	generate_y!(mogtrack.log_width)
	generate_y!(mogtrack.theta)

	return nothing
end


