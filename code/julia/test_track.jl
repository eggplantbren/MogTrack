using PyCall
@pyimport matplotlib.pyplot as plt
include("Track.jl")

# Create a Track
track = Track(1, 100)
calculate_C!(track)
generate_y!(track)

# Explore the prior
plt.ion()
for(i in 1:1000)
	# Do a Metropolis proposal (prior is implicit)
	perturb!(track, theta=0.2)

	plt.hold(false)
	plt.plot(track.y)
	plt.ylim([-3.0, 3.0])
	plt.draw()
end

plt.ioff()
plt.show()

