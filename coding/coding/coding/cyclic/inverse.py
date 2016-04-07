import galois as gal
from common import *


if __name__ == "__main__":
    with open("input.txt", "r") as input_file:
        p = to_int(parse_row(input_file.readline()))
    for x in gal.iterate(p):
        print(str(x) + " -> " + str(x.inverse()))
