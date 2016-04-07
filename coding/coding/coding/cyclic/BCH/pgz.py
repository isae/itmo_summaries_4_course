from galois import *
from poly import *


def solve_system(a, c, p):
    b = [0, 0, 0]
    for b[0] in iterate(p):
        for b[1] in iterate(p):
            for b[2] in iterate(p):
                if all(Poly(a[i]).dot(Poly(b)) == c[i] for i in range(3)):
                    return b


def pgz(s):
    print("PGZ:")
    p = s[0].p
    l = list(reversed(solve_system([[s[0], s[1], s[2]],
                                    [s[1], s[2], s[3]],
                                    [s[2], s[3], s[4]]],
                                   [s[3], s[4], s[5]],
                                   p)))
    return Poly([Galois(1, p)] + l)
