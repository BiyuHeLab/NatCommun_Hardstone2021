function ouNoise = createOrnsteinUhlenbeckNoise(params)
%Creates noise using OrnsteinUhlenbeck process (see methods)
whiteNoise = randn(params.nTimesteps,1);
ouNoise = zeros(params.nTimesteps,1);

for i = 2:params.nTimesteps
    drift = -(ouNoise(i-1)/params.noise.tau);
    diffusion = params.noise.sigma * ((2/params.noise.tau)^0.5) * whiteNoise(i-1);
    ouNoise(i) = ouNoise(i-1) + (params.euler.dt * (drift + diffusion));
end

