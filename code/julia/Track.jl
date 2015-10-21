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

	# The trajectory itself
	y::Array{Float64, 2}
end

@doc """
Constructor. Input: num_dimensions, num_points
""" ->
function Track(num_dimensions::Int64, num_points::Int64)
	return Track(num_dimensions, num_points,
						Array(Float64, (num_points, num_dimensions)))
end

