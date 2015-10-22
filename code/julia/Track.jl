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
Set initial conditions for the track
""" ->
function initialise!(track::Track)
	for(j in 1:track.num_dimensions)
		for(i in 1:track.num_points)
			track.y[i, j] = 0.0
		end
	end
	track.y[1, 1] = 1.0
	return nothing
end


@doc """
Update (solve the diffusion equation driven by white noise with periodic
boundary conditions)
""" ->
function update!(track::Track; dt::Float64=0.01)
	# Second spatial derivative
	d2 = Array(Float64, size(track.y))
	for(j in 1:size(d2)[2])
		for(i in 2:size(d2)[1]-1)
			d2[i, j] = track.y[i+1, j] + track.y[i-1, j] - 2*track.y[i, j]
		end
		# Boundary points
		d2[1, j] = track.y[2, j] + track.y[end, j] - 2*track.y[1, j]
		d2[end, j] = track.y[1, j] + track.y[end-1, j] - 2*track.y[end, j]
	end

	# Do the update
	for(j in 1:size(d2)[2])
		for(i in 1:size(d2)[1])
			track.y[i, j] += dt*d2[i, j]
		end
	end
	return nothing
end




using PyCall
@pyimport matplotlib.pyplot as plt

# Initialise with a spike
track = Track(1, 100)
initialise!(track)

# Solve diffusion equation
plt.ion()
for(i in 1:1000)
	update!(track, dt=0.05)
	plt.hold(false)
	plt.plot(track.y)
	plt.draw()
end

plt.ioff()
plt.show()

