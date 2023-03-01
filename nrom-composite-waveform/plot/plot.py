import numpy as np
import matplotlib.pyplot as plt
import argparse
import struct

parser = argparse.ArgumentParser(description="Plots an array of single precision floating point numbers into a plot.")
parser.add_argument("floatarray", help="path to input single precision float array", type=str)
args = parser.parse_args()

with open(args.floatarray, mode="rb") as floatarray_file:
    plt.figure(figsize=(30, 10), dpi=55)
    plt.title(floatarray_file.name)
    floatarray_data = floatarray_file.read()
    floatarray_actual = np.frombuffer(floatarray_data, dtype=np.float32);
    x = np.array(range(0, floatarray_actual.size))
    y = floatarray_actual

    plt.xlabel("Sample count")
    plt.ylabel("Voltage")
    plt.plot(x, y, color = "red", linewidth=1)
    plt.tight_layout()
    plt.savefig(floatarray_file.name + ".png")
