using PyCall
@pyimport matplotlib.pyplot as plt
include("Gaussian.jl")

# Make a gaussian
gaussian = Gaussian([1.0, 0.5, 0.0, 0.0, 1.0, pi/6])

# Define a grid
xmin, xmax, ymin, ymax = -5.0, 5.0, -5.0, 5.0
ni, nj = 201, 201
x = Array(linspace(xmin, xmax, nj))
y = Array(linspace(ymax, ymin, ni))
dx, dy = (xmax - xmin)/(nj - 1), (ymax - ymin)/(ni - 1)
dA = dx*dy

# Evaluate the gaussian on the grid
f = Array(Float64, (ni, nj))
for(j in 1:nj)
	for(i in 1:ni)
		f[i, j] = evaluate(gaussian, x[j], y[i])
	end
end

println(sum(f)*dA)

plt.imshow(f, interpolation="nearest")
plt.show()

