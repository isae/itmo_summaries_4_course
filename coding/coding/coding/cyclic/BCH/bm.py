import sys

from cyclic.BCH.decoding import *
from galois import one, zero


def calc_d(loc, s, l, r):
    p = s[0].p
    d = zero(p)
    for j in range(l + 1):
        d += loc.l[j] * s[r - j - 1]
    return d


def bm(s):
    print("BM:")
    p = s[0].p
    field = get_field_elements(p)
    l = 0

    loc = Poly([one(p)])
    b = Poly([one(p)])
    for r in range(1, len(s) + 1):
        b.l = [zero(p)] + b.l
        d = calc_d(loc, s, l, r)
        if d != zero(p):
            t = loc + b.factor(d)
            if 2 * l <= r - 1:
                b = loc.factor(d.inverse())
                l = r - l
            loc = t
        print("Step %d:" % r)
        sys.stdout.write("\tΔ = ")
        if d == zero(p):
            print(0)
        elif d == one(p):
            print(1)
        else:
            print("a" + to_superscript(field.index(d)))
        print("\tΛ(x) = " + gal_poly_str(loc, field))
        print("\tL = %d" % l)
        print("\tB(x) = " + gal_poly_str(b, field))
        print()

    if len(loc.l) - 1 == l:
        return loc
    else:
        return None
