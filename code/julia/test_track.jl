using PyCall
@pyimport matplotlib.pyplot as plt

include("Track.jl")

track = Track(1, 100)
initialise!(track)

plt.imshow(track.C, interpolation="nearest")
plt.show()

