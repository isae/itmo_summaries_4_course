import poly
from common import *


class Galois:
    x = 0
    p = 0

    def __init__(self, x, p):
        self.x = x
        self.p = p

    def __add__(self, other):
        assert(self.p == other.p)
        return Galois(self.x ^ other.x, self.p)

    def __mul__(self, other):
        assert(self.p == other.p)
        res = Galois(0, self.p)
        if self.x == 0 or other.x == 0:
            return Galois(0, self.p)
        for i in range(self.deg() + 1):
            if self.x & (1 << i):
                res += other << i
        q = self.p ^ (1 << deg(self.p))
        while res.x != 0 and res.deg() >= deg(self.p):
            dr = res.deg()
            res.x ^= 1 << dr
            res.x ^= q << (dr - deg(self.p))
        return res

    def __pow__(self, power, modulo=None):
        res = Galois(1, self.p)
        for i in range(power):
            res *= self
        return res

    def __lshift__(self, other):
        return Galois(self.x << other, self.p)

    def __rshift__(self, other):
        return Galois(self.x >> other, self.p)

    def __eq__(self, other):
        return self.p == other.p and self.x == other.x

    def __str__(self):
        return str(poly.from_int(self.x))

    def inverse(self):
        for inv in iterate(self.p):
            product = self * inv
            if product.x == 1:
                return inv
        return None

    def copy(self):
        return Galois(self.x, self.p)

    def weight(self):  # number of ones in binary representation of integer
        return weight(self.x)

    def deg(self):
        return deg(self.x)


def one(p):
    return Galois(1, p)


def zero(p):
    return Galois(0, p)


def iterate(p):
    for x in range(2 ** deg(p)):
        yield Galois(x, p)
