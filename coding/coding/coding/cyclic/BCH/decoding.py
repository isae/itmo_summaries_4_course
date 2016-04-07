from cyclic.BCH.bm import *
from cyclic.BCH.pgz import *
from galois import *
from poly import *


def get_field_elements(p):
    elements = [Galois(1, p)]
    x = Galois(2, p)
    e = x
    while e.x != 1:
        elements.append(e)
        e *= x
    return elements


def calc_min_polynomial(c, p, field):
    result = Poly([Galois(1, p)])
    for ci in c:
        el = field[ci]
        result *= Poly([el, Galois(1, p)])
    return result


def to_galois(l, p):
    return list(map(lambda x: Galois(x, p), l))


def print_column(c, name, field):
    for i, ci in enumerate(c):
        if ci.x == 0:
            print(name + str(i) + " = 0")
        else:
            num = field.index(ci)
            print(("%s%d = a%s = " + str(ci)) % (name, i + 1, to_superscript(num)))


def find_roots(pol, p):
    roots = []
    for x in iterate(p):
        if pol(x).x == 0:
            roots.append(x)
    return roots


def gal_poly_str(pol, field):
    res = ""
    for i, coef in enumerate(pol.l):
        if coef.x == 0:
            continue
        if res != "":
            res += " + "
        num = field.index(coef)
        if num > 0:
            res += "a" + to_superscript(num)
        elif i == 0:
            res += "1"
        if i > 0:
            res += "x"
            if i > 1:
                res += to_superscript(i)
    return res


def decode(l):
    p = l.l[0].p
    field = get_field_elements(p)
    print("Λ(x) = " + gal_poly_str(l, field))
    l_roots = find_roots(l, p)
    print_column(l_roots, "x⁻¹", field)
    x = list(map(lambda a: a.inverse(), l_roots))
    print_column(x, "x", field)
    print()


def do_main():
    p = to_int([1, 0, 1, 0, 0, 1])
    field = get_field_elements(p)
    for i, el in enumerate(field):
        print(str(i) + " -> " + str(el))
    print()

    c1 = [1, 2, 4, 8, 16]
    m1 = calc_min_polynomial(c1, p, field)
    c3 = [3, 6, 12, 24, 17]
    m3 = calc_min_polynomial(c3, p, field)
    c5 = [5, 10, 20, 9, 18]
    m5 = calc_min_polynomial(c5, p, field)

    print("M1(x) = " + str(m1))
    print("M3(x) = " + str(m3))
    print("M5(x) = " + str(m5))
    print()

    g = m1 * m3 * m5
    print("g(x) = " + str(g))

    m = Poly(to_galois([1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0], p))

    print("m(x) = " + str(m))
    c = m * g
    print("c(x) = " + str(c))

    errors = [1, 16, 29]
    for i in range(len(m.l), 31):
        m.l.append(0)
    v = c.copy()
    for e in errors:
        x = v.l[e].x
        v.l[e] = Galois(1 - x, p)
    print("v(x) = " + str(v))
    print()

    s = []
    for i in range(6):
        s.append(v(field[i + 1]))
    print_column(s, "S", field)
    print()
    l = pgz(s)
    decode(l)

    l = bm(s)
    decode(l)

if __name__ == "__main__":
    do_main()
