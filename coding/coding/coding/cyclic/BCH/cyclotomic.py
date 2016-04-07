def print_set(name, s):
    print(name + " = {", end="")
    for (i, x) in enumerate(s):
        if i != 0:
            print(", ", end="")
        print(str(x), end="")
    print("}\n", end="")


def do_main():
    n = 31
    p = 2
    used_words = set()
    for i in range(n):
        if i not in used_words:
            s = []
            x = i
            while x not in used_words:
                used_words.add(x)
                s.append(x)
                x = (x * p) % n
            print_set("C" + str(i), s)


if __name__ == "__main__":
    do_main()