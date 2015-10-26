include("Track.jl")
include("Gaussian.jl")

@doc """
A class representing a set of Tracks
which define the parameters of gaussians
""" ->
type MogTrack
	# Number of points in each track
	num_points::Int64

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
	return MogTrack(num_points,
					Track(num_points), Track(num_points), Track(num_points),
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


@doc """
Evaluate a MogTrack at position (x, y)
""" ->
function evaluate(mogtrack::MogTrack, x::Float64, y::Float64)
	f = 0.0
	params = Array(Float64, (6, ))

	# Loop over the tracks
	for(i in 1:mogtrack.num_points)
		params[1] = exp(mogtrack.log_mass.y[i])
		params[2] = exp(mogtrack.logit_q.y[i])/(1.0 + exp(mogtrack.logit_q.y[i]))
		params[3] = mogtrack.xc.y[i]
		params[4] = mogtrack.yc.y[i]
		params[5] = exp(mogtrack.log_width.y[i])
		params[6] = mogtrack.theta.y[i]

		gaussian::Gaussian = Gaussian(params)
		f += evaluate(gaussian, x, y)
	end

	return f
end

@doc """
Do a Metropolis proposal.
""" ->
function perturb!(mogtrack::MogTrack)
	which = rand(1:6)

	if(which == 0)
		track = mogtrack.log_mass
	elseif(which == 1)
		track = mogtrack.logit_q
	elseif(which == 2)
		track = mogtrack.xc
	elseif(which == 3)
		track = mogtrack.yc
	elseif(which == 4)
		track = mogtrack.log_width
	else
		track = mogtrack.theta
	end
	perturb!(track)
	return nothing
end

