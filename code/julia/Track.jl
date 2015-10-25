@doc """
A class defining a trajectory in n-dimensional space
with an AR(1) prior distribution and periodic boundary
conditions.
""" ->
type Track
	# Number of dimensions
	num_dimensions::Int64

	# Number of points in the trajectory
	num_points::Int64

	# Hyperparameters
	amplitude::Float64
	period::Float64
	length_scale::Float64

	# The trajectory itself
	y::Array{Float64, 1}
end

@doc """
Constructor. Input: num_dimensions, num_points
""" ->
function Track(num_dimensions::Int64, num_points::Int64)
	return Track(num_dimensions, num_points, 1.0, 1.0, 0.1,
						Array(Float64, (num_points, )))
end

# Old idea: use numerical solver for stochastic PDE
# with periodic BCs as a proposal.
# New idea: use periodic GP kernel.

track = Track(1, 100)

