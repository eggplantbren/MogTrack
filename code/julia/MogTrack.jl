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
	tracks::Vector{Track}

	# Shift and scale tracks
	mu::Vector{Float64}
	sig::Vector{Float64}
end

@doc """
Constructor, takes Track parameters as input
""" ->
function MogTrack(num_points::Int64)
	return MogTrack(num_points, fill(Track(num_points), 6), zeros(6), ones(6))
end

@doc """
Generate a MogTrack from the prior.
""" ->
function from_prior!(mogtrack::MogTrack)
	for(i in 1:size(mogtrack.tracks)[1])
		calculate_C!(mogtrack.tracks[i])
		generate_y!(mogtrack.tracks[i])
	end
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
		for(j in 1:size(mogtrack.tracks)[1])
			params[j] = mogtrack.mu[j] + mogtrack.sig[j]*mogtrack.tracks[j].y[i]
		end

		params[1] = exp(params[1])
		params[2] = exp(params[2])/(1.0 + exp(params[2]))
		params[5] = exp(params[5])

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
	logH = perturb!(mogtrack.tracks[6])
	return logH
end

