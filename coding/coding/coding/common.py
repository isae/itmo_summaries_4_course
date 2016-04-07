import numpy as np
import math


def parse_row(r):
    return list(map(lambda c: ord(c) - ord('0'), r.split()))


def read_matrix(f_name):
    # list that will be used to construct a matrix
    h_list = []
    with open(f_name, 'r') as input_file:
        for s in input_file.readlines():
            h_list.append(parse_row(s))
    return np.matrix(h_list)  # constructing a matrix


def to_list(x, l):  # construct binary vector out of integer
    res = []
    for i in range(l):
        res.append(x % 2)
        x //= 2
    return res


def rev_concat(l):
    return "".join(map(lambda x: str(x), reversed(l)))


def to_polynomial(l):
    res = ""
    for (i, c) in enumerate(l):
        if str(c) != "0":
            if res != "":
                res += " + "
            if i == 0:
                res += str(c)
            else:
                if str(c) != "1":
                    res += str(c)
                res += "x"
                if i != 1:
                    res += to_superscript(i)
    if not res:
        res = "0"
    return res


def to_superscript(x):
    power = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]
    res = ""
    while x != 0:
        res = power[x % 10] + res
        x //= 10
    return res


def to_int(l):  # make integer from binary vector
    x = 0
    for i in reversed(l):
        x *= 2
        x += int(i)
    return x


def deg(x):
    if x == 0:
        return 0
    return int(math.log(x, 2))


def weight(x):  # number of ones in binary representation of integer
    w = 0
    while x != 0:
        w += x % 2
        x //= 2
    return w
