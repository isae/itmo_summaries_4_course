import json

import matplotlib.pyplot as plot
import math
from operator import itemgetter

import sys


def draw_plot(dct):
    x = []; y = []
    for k, v in sorted(dct.items(), key=itemgetter(0)):
        x.append(k)
        if v == 0:
            y.append(-math.inf)
        else:
            y.append(math.log(v, 10))
    plot.plot(x, y)
    plot.xlabel('Eb / N0, dB')
    plot.ylabel('log(errors / symbol)')
    plot.grid(True)
    plot.savefig("plot.png")
    plot.show()

if __name__ == "__main__":
    with open(sys.argv[1], 'r') as f:
        dct = json.load(f)
        draw_plot(dct)
