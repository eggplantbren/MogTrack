@doc """
A class defining a 2D elliptical gaussian
""" ->
type Gaussian
	# All of the parameters
	mass::Float64
	q::Float64
	xc::Float64
	yc::Float64
	width::Float64
	theta::Float64

	# Derived parameters
	qinv::Float64
	width2inv::Float64
	sin_theta::Float64
	cos_theta::Float64
	coeff::Float64
end

@doc """
Constructor taking a vector of five parameters
""" ->
function Gaussian(params::Vector{Float64})
	gaussian = Gaussian(params[1], params[2], params[3], params[4], params[5],
							params[6], 0.0, 0.0, 0.0, 0.0, 0.0)
	calculate_derived!(gaussian)
	return gaussian
end

@doc """
Calculate the derived parameters
""" ->
function calculate_derived!(gaussian::Gaussian)
	gaussian.qinv = 1.0/gaussian.q
	gaussian.width2inv = 1.0/gaussian.width^2
	gaussian.sin_theta = sin(gaussian.theta)
	gaussian.cos_theta = cos(gaussian.theta)
	gaussian.coeff = gaussian.mass*gaussian.width2inv/(2*pi)
end


@doc """
Evaluate the gaussian at the position (x, y)
""" ->
function evaluate(gaussian::Gaussian, x::Float64, y::Float64)
	xx =  (x - gaussian.xc)*gaussian.cos_theta +
			(y - gaussian.yc)*gaussian.sin_theta
	yy = -(x - gaussian.xc)*gaussian.sin_theta +
			(y - gaussian.yc)*gaussian.cos_theta
	rsq = gaussian.q*xx^2 + yy^2*gaussian.qinv
	f = gaussian.coeff*exp(-0.5*rsq*gaussian.width2inv)
	return f
end


