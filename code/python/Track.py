import numpy as np
import numpy.random as rng

class Track:
	"""
	A trajectory in space
	"""
	def __init__(self, num=10, ndim=5):
		"""
		num = number of points in the track
		ndim = dimensionality of the space
		"""
		self.num, self.ndim = num, ndim
		self.pos = np.empty((num, ndim))

	def from_prior(self, L=5.):
		"""
		Generate a track from a standard AR(1) prior
		"""
		alpha = np.exp(-1./L)
		beta = np.sqrt(1. - alpha**2)
		self.pos[0, :] = rng.randn(self.ndim)
		for i in range(1, self.num):
			self.pos[i, :] = alpha*self.pos[i-1, :] + beta*rng.randn(self.ndim)

if __name__ == '__main__':
	import matplotlib.pyplot as plt

	track = Track(100)
	track.from_prior(L=20.)
	plt.plot(track.pos[:,0])
	plt.show()

