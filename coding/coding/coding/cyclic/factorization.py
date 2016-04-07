from common import *


def divide_pol(dividend, divider):
    q = 0
    while dividend != 0 and deg(dividend) >= deg(divider):
        d = deg(dividend) - deg(divider)
        q += 1 << d
        dividend ^= divider << d
    return q, dividend


def factorize_pol(pol):
    for f in range(2, 2 ** (deg(pol))):
        q, r = divide_pol(pol, f)
        if r == 0:
            return factorize_pol(f) + factorize_pol(q)
    return [pol]


def do_main():
    with open("input.txt", "r") as input_file:
        pol = parse_row(input_file.readline())
    for f in factorize_pol(to_int(pol)):
        print(to_polynomial(to_list(f, deg(f) + 1)))


if __name__ == "__main__":
    do_main()
