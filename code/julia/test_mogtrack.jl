using PyCall
@pyimport matplotlib.pyplot as plt
include("MogTrack.jl")

# Make a MogTrack
mogtrack = MogTrack(50)
from_prior!(mogtrack)

# Define a grid
xmin, xmax, ymin, ymax = -5.0, 5.0, -5.0, 5.0
ni, nj = 201, 201
x = Array(linspace(xmin, xmax, nj))
y = Array(linspace(ymax, ymin, ni))

# Evaluate the MogTrack on the grid
f = Array(Float64, (ni, nj))

plt.ion()
steps = 1000
for(k in 1:steps)
	perturb!(mogtrack)

	for(j in 1:nj)
		for(i in 1:ni)
			f[i, j] = evaluate(mogtrack, x[j], y[i])
		end
	end

	plt.hold(false)
	plt.imshow(-f, interpolation="nearest", cmap="gray")
	plt.title("Model $k/$steps")
	plt.gca()[:set_xticks]([])
	plt.gca()[:set_yticks]([])
	plt.draw()
end

plt.ioff()
plt.show()

