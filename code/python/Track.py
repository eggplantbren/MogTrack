import numpy as np
import numpy.random as rng
from Gaussian import Gaussian

class Track:
	"""
	A trajectory in space
	"""
	def __init__(self, num=10, ndim=6):
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

	def evaluate_mog(self, x, y):
		"""
		Make a mixture of gaussians from this track
		and evaluate it
		"""
		f = np.zeros(x.shape)
		params = self.pos.copy()
		params[:,2] = np.exp(params[:,2])
		params[:,3] = np.exp(params[:,3])
		params[:,4] = np.exp(0.5*params[:,4])

		for i in range(self.num):
			gaussian = Gaussian(params=params[i, :])
			f += gaussian.evaluate(x, y)
		return f

if __name__ == '__main__':
	import matplotlib.pyplot as plt

	track = Track(100)
	track.from_prior(L=20.)
	plt.plot(track.pos[:,0])
	plt.show()

	# Set up cartesian coordinate grid
	x = np.linspace(-5., 5., 1001)
	[x, y] = np.meshgrid(x, x[::-1])

	# Make a gaussian
	gaussian = Gaussian()
	f = track.evaluate_mog(x, y)

	plt.imshow(f, interpolation='nearest')
	plt.show()

