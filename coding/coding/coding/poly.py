from common import *


class Poly:
    l = []

    def __init__(self, l):
        self.l = l

    def __add__(self, other):
        b, a = _sort_by_len(self.l, other.l)

        for i, bi in enumerate(b):
            a[i] += bi
        return Poly(a)

    def __mul__(self, other):
        a, b = _sort_by_len(self.l, other.l)
        result = Poly([])
        for i, bi in enumerate(b):
            for j, ai in enumerate(a):
                t = ai * bi
                if len(result.l) > i + j:
                    result.l[i + j] += ai * bi
                else:
                    result.l.append(t)
        return result

    def dot(self, other):
        if len(self.l) == 0 or len(other.l) == 0:
            return None
        result = self.l[0] * other.l[0]
        for i in range(1, len(other.l)):
            result += self.l[i] * other.l[i]
        return result

    def factor(self, other):
        return Poly(list(map(lambda x: x * other, self.l)))

    def __str__(self):
        return to_polynomial(self.l)

    def copy(self):
        return Poly(list(self.l))

    def __call__(self, x):
        if len(self.l) == 0:
            return None
        coef_iter = iter(enumerate(self.l))
        _, result = next(coef_iter)
        for (i, coef) in coef_iter:
            result += coef * (x ** i)
        return result


def from_int(x):
    res = []
    while x != 0:
        res.append(x % 2)
        x //= 2
    return Poly(res)


def _sort_by_len(a, b):
    if len(a) < len(b):
        return a, b
    else:
        return b, a