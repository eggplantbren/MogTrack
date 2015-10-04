import numpy as np

class Gaussian:
	"""
	An object of this class is a 2D elliptical gaussian
	"""
	def __init__(self):
		"""
		Constructor sets up a standard gaussian
		"""
		self.xc, self.yc, self.mass, self.width, self.q, self.theta =\
						0., 0., 1., 1., 1., 0.
		self.cos_theta, self.sin_theta = np.cos(self.theta), np.sin(self.theta)

	def evaluate(self, x, y):
		"""
		Evaluate the density.
		"""
		xx =  (x - self.xc)*self.cos_theta + (y - self.yc)*self.sin_theta
		yy = -(x - self.xc)*self.sin_theta + (y - self.yc)*self.cos_theta
		rsq = self.q*xx**2 + yy**2/self.q
		f = np.exp(-0.5*rsq/(self.width**2)**2)
		f *= self.mass/(2.*np.pi*self.width**2)
		return f

if __name__ == '__main__':
	pass

