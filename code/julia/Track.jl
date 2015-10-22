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

@doc """
Update (solve the diffusion equation driven by white noise with periodic
boundary conditions)
""" ->
function update!(track::Track; dt::Float64=0.01)
	# Second spatial derivative
	d2 = Array(Float64, size(track.y))
	for(j in 1:size(d2)[2])
		for(i in 2:size(d2)[1])
			d2[i, j] = track.y[i+1, j] + track.y[i-1, j] - 2*track.y[i, j]
		end
		# Boundary points
		d2[1, j] = track.y[2, j] + track.y[end, j] - 2*track.y[1, j]
		d2[end, j] = track.y[1, j] + track.y[end-1, j] - 2*track.y[end, j]
	end

	return d2
end



