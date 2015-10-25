using PyCall
@pyimport matplotlib.pyplot as plt
include("Track.jl")

# Create a Track
track = Track(1, 100)
calculate_C!(track)
generate_y!(track)

# Explore the prior
plt.ion()
steps = 1000
for(i in 1:steps)
	# Do a Metropolis proposal (prior is implicit)
	perturb!(track, theta=0.2)

	plt.hold(false)
	plt.plot(track.y, "bo-")
	plt.xlim([-0.5, track.num_points - 0.5])
	plt.ylim([-3.0, 3.0])
	plt.title("Step $i/$steps")
	plt.draw()
end

plt.ioff()
plt.show()

