import numpy as np

class Gaussian:
	"""
	An object of this class is a 2D elliptical gaussian
	"""
	def __init__(self, params=[0., 0., 1., 1., 1., 0.]):
		"""
		Constructor sets up a standard gaussian
		"""
		self.xc, self.yc, self.mass, self.width, self.q, self.theta = params

	def evaluate(self, x, y):
		"""
		Evaluate the density.
		"""
		xx =  (x - self.xc)*np.cos(self.theta) + (y - self.yc)*np.sin(self.theta)
		yy = -(x - self.xc)*np.sin(self.theta) + (y - self.yc)*np.cos(self.theta)
		rsq = self.q*xx**2 + yy**2/self.q
		f = np.exp(-0.5*rsq/(self.width**2)**2)
		f *= self.mass/(2.*np.pi*self.width**2)
		return f

if __name__ == '__main__':
	import matplotlib.pyplot as plt

	# Set up cartesian coordinate grid
	x = np.linspace(-5., 5., 1001)
	[x, y] = np.meshgrid(x, x[::-1])

	# Make a gaussian
	gaussian = Gaussian()
	gaussian.q = 0.5
	gaussian.theta = 30.*np.pi/180.
	f = gaussian.evaluate(x, y)
	print(f.sum()*(x[0, 1] - x[0, 0])**2)

	plt.imshow(f, interpolation='nearest')
	plt.show()

