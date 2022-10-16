import numpy as np
import matplotlib.pyplot as plt
import pandas as pd


blur_sizes = [15, 23, 30]
num_threads = [1, 2, 3, 4]
  
data = np.array([
    [0.48, 0.27, 0.25, 0.26],
    [1.03, 0.60, 0.56, 0.55],
    [2.00, 1.06, 1.01, 0.95]
])

fig, ax = plt.subplots()
im = ax.imshow(data)
ax.set_xticks(np.arange(len(num_threads)), labels=num_threads)
ax.set_yticks(np.arange(len(blur_sizes)), labels=blur_sizes)
plt.setp(ax.get_xticklabels(), ha="right",
         rotation_mode="anchor")



ax.set_title("running time")
fig.tight_layout()
plt.show()
