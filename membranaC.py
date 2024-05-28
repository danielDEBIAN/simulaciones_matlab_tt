import numpy as np
from scipy.spatial import Delaunay
import matplotlib.pyplot as plt
# import sounddevice as sd

# FORMATION OF THE MESH
R = np.array([[0, 0, 0]])
numGrados = 20
for r in np.arange(0.1, 1.1, 0.1):
    intervalo = np.arange(0, 2 * np.pi, 2 * np.pi / numGrados)
    x = r * np.cos(intervalo)
    y = r * np.sin(intervalo)
    z = np.zeros_like(x)
    R = np.concatenate((R, np.column_stack((x, y, z))))

# Initialization
tri = Delaunay(R[:, :2])
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.plot_trisurf(R[:, 0], R[:, 1], R[:, 2], triangles=tri.simplices)

N = len(R)
p = [None] * N
for k in range(N):
    p[k] = {
        'r': R[k],
        'v': [0, 0, 0],
        'f': [0, 0, 0],
        'vec': [],
        'deq': []
    }
    fil, col = np.where(tri.simplices == k)
    ele = tri.simplices[fil, :]
    ele = np.unique(ele)
    ele = ele[ele > k]
    p[k]['vec'] = ele
    for j in range(len(ele)):
        p[k]['deq'].append(np.linalg.norm(R[k] - R[ele[j]]) * 0.9)

for k in range(numGrados + 1):
    p[k]['r'][2] = 1

DT = 0.001
K = 100  # spring constant
K2 = 1  # damping constant

y = np.zeros(1000)
for i in range(1000):
    for k in range(N - numGrados - 1):
        numVec = len(p[k]['vec'])
        for j in range(numVec):
            indVec = p[k]['vec'][j]
            DR = np.array(p[indVec]['r']) - np.array(p[k]['r'])
            modulo = np.linalg.norm(DR)
            U = DR / modulo
            F = K * (modulo - p[k]['deq'][j]) * U
            p[k]['f'] = np.add(p[k]['f'], F)
            p[indVec]['f'] = np.subtract(p[indVec]['f'], F)
        p[k]['v'] = np.add(np.multiply(np.subtract(p[k]['f'], np.multiply(K2, p[k]['v'])), DT), p[k]['v'])
        p[k]['r'] = np.add(np.multiply(p[k]['v'], DT), p[k]['r'])

    y[i] = p[0]['r'][2]

    for k in range(N):
        R[k] = p[k]['r']
        p[k]['f'] = [0, 0, 0]

    ax.cla()
    ax.plot_trisurf(R[:, 0], R[:, 1], R[:, 2], triangles=tri.simplices)
    ax.set_xlim(-1, 1)
    ax.set_ylim(-1, 1)
    ax.set_zlim(-2, 2)
    plt.pause(0.000001)

# Sound
plt.figure(2)
plt.plot(y)
# sd.play(y, 10000)
plt.show()