# Old idea: use numerical solver for stochastic PDE
# with periodic BCs as a proposal.
# New idea: use periodic GP kernel.

@doc """
A class defining a trajectory in 1-D space
with a GP prior distribution and periodic boundary
conditions.
""" ->
type Track
	# Number of points in the trajectory
	num_points::Int64

	# Hyperparameters
	amplitude::Float64
	length_scale::Float64

	# Covariance matrix and its cholesky decomposition
	C::Array{Float64, 2}
	L::Array{Float64, 2}

	# The trajectory itself
	y::Array{Float64, 1}
end

@doc """
Constructor. Input: num_dimensions, num_points
""" ->
function Track(num_points::Int64)
	return Track(num_points, 1.0, 0.3,
						Array(Float64, (num_points, num_points)),
						Array(Float64, (num_points, num_points)),
						Array(Float64, (num_points, )))
end

@doc """
Calculate covariance matrix
""" ->
function calculate_C!(track::Track)
	A2 = track.amplitude^2
	pinv = 1.0/track.num_points
	l2inv = 1.0/track.length_scale^2

	# Fill covariance matrix
	for(j in 1:track.num_points)
		for(i in 1:track.num_points)
			track.C[i, j] = A2*exp(-2*sin(pi*abs(i-j)*pinv)^2*l2inv)
			if(i == j)
				# Small term for positive definiteness
				track.C[i, j] += 1E-6*A2
			else
				track.C[j, i] = track.C[i, j]
			end
		end
	end

	# Do Cholesky decomposition
	track.L = chol(track.C)'

	return nothing
end

@doc """
Generate realisation of trajectory
""" ->
function generate_y!(track::Track)
	# Generate realisation
	track.y = track.L*randn(track.num_points)
	return nothing
end


@doc """
Metropolis proposal, holding hyperparameters fixed and just
moving the realisation.
""" ->
function perturb!(track::Track; theta=nothing)
	# Make backup of old track
	y_old = copy(track.y)

	# Generate totally new track
	generate_y!(track)

	# Step size
	if(theta == nothing)
		theta = 2*pi*10.0^(-6.0*rand())
	end
	cos_theta = cos(theta)
	sin_theta = sin(theta)

	# AR(1) proposal
	for(i in 1:track.num_points)
		track.y[i] = cos_theta*y_old[i] + sin_theta*track.y[i]
	end

	return nothing
end

