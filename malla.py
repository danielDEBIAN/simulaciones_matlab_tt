import numpy as np
import matplotlib.pyplot as plt

vec = 2  # Number of neighbors considered in calculation
K = 5  # Spring constant between masses
K2 = 0.5  # Damping
T = 0.01  # Time step
D = 60  # Dimension
H = np.zeros((D, D))  # Position
Hf = np.zeros((D, D))  # Auxiliary
V = np.zeros((D, D))  # Velocity

H[D // 4 - 1:D // 4 + 2, D // 4 - 1:D // 4 + 2] = 1  # Impulse
H[3 * D // 4 - 1:3 * D // 4 + 2, 3 * D // 4 - 1:3 * D // 4 + 2] = 1  # Impulse

for m in range(1000):  # Calculations
    plt.imshow(H, cmap='hot', extent=[0, D, 0, D])
    plt.colorbar()
    plt.show()
    plt.pause(0.001)

    for j in range(vec, D - vec):
        for i in range(vec, D - vec):
            Hm = np.sum(H[i - vec:i + vec + 1, j - vec:j + vec + 1]) - H[i, j]
            X = ((2 * vec + 1) ** 2) * H[i, j] - Hm
            V[i, j] = V[i, j] - (K * X + K2 * V[i, j]) * T
            Hf[i, j] = H[i, j] + V[i, j] * T

    H = Hf
