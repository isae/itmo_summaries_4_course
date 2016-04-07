import math


# Entropy of binary assembly
def h(x):
    return (-x) * math.log(x, 2) - (1 - x) * math.log(1 - x, 2)


# muuu
def mu(x):
    assert (1 - 2 * x) >= 0, "Res: {}, where x = {}".format(1 - 2 * x, x)
    return h(0.5 - 0.5 * math.sqrt(1 - 2 * x))


# Varshamov-Gilbert function
def r_vg(delta, q=2):
    return math.log(q, 2) - h(delta) - delta * math.log(q - 1, 2)


# McElise-Rodemich-Ramsey-Welch function
def B(u, delta):
    return 1 + mu(u * u) - mu(u * u + 2 * delta * u + 2 * delta)


# Bassalsky-Ellayes
def B_E(delta):
    return 1 - mu(delta)


# Graismer bound - minimal length 'n' of code for known 'k' and 'd'
def graismer(k, d):
    acc = 0
    for i in range(k - 1):
        acc += math.ceil(d / 2 ^ i)
    return acc


# Hamming upper bound
def hamming_bound(delta, q=2):
    return math.log(q, 2) - h(delta / 2) - (delta / 2) * math.log(q - 1, 2)


def double_range(start, stop, step):
    r = start
    while r < stop:
        yield r
        r += step


n = 24
k = 16
d = 11
delta = d / n

lower_bound = r_vg(delta) * n
# only hamming upper bound is applicable as (1 - 2 * delta < 0)
upper_bound = hamming_bound(delta) * n


# Chapter 3, task 3
# possible k:
def get_possible_k():
    for i in range(math.ceil(lower_bound), math.floor(upper_bound) + 1):
        yield i


# Chapter 3, task 4
# with given 'n' and 'k' find possible 'd':

# From Varshamov-Gilbert and wolframalpha =):
d_range = range(2, 25)  # 2 <= d <= 24
# From MERRV: 1 - 2 * delta >= 0 -> d <= n / 2 = 13. Then
d_range = range(2, 14)  # 2 <= d <= 13

if __name__ == '__main__':
    print("K: ", get_possible_k());


# now check MERRV:
def check_mervv(values):
    min_val = 1
    for d in values:
        delta = d / n
        print("delta = {}, d = {}".format(delta, d))
        for u in double_range(0.01, 1 - 2 * delta, 0.005):
            try:
                print("``` u = {}".format(u))
                cur = B(u, delta)
                if min_val > cur:
                    min_val = cur
                    print("``` -> value changed")
            except AssertionError:
                pass

        if min_val != 1 and min_val >= (k / n):
            yield d
        min_val = 1


# check B_E:
def check_B_E(values):
    for d in values:
        delta = d / n
        if B_E(delta) >= (k / n):
            yield d


# check Plotkin:
def check_plotkin(values):
    for d in values:
        delta = d / n
        if (1 - 2 * delta) >= (k / n):
            print("plotkin = {}, R = {}".format(1 - 2 * delta, k / n))
            yield d


# check Hamming:
def check_hamming(values):
    for d in values:
        delta = d / n
        if hamming_bound(delta) >= (k / n):
            print("hamming = {}, R = {}".format(hamming_bound(delta), k / n))
            yield d


# check Varshamov-Gilbert:
def check_lower_vg():
    for d in range(1, n):
        if -(d * math.log(d, 2) + (n - d) * math.log(n - d, 2)) >= n - k - n * math.log(n, 2):
            yield d

            # res: d = [2]
