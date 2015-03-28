b0 = -1.5
b = c(3, -0.5)
x = c(1, 5)

logit = b0 + sum(b*x)
exp(logit)
p = 1 / (1 + exp(-logit))
p
