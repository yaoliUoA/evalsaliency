function y = sigmoid(x, sigma)
y = 1./(1+exp(-sigma*x));
end