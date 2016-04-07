import numpy.matlib
from common import *


def find_one(m, i):  # put non-null element to m[i, i]
    if m[i, i] == 0:
        # search for rows
        for j in range(i + 1, m.shape[0]):
            if m[j, i] != 0:
                m[[i, j], :] = m[[j, i], :]
                return None, None
        # search for columns
        for j in range(i + 1, m.shape[1]):
            if m[i, j] != 0:
                m[:, [i, j]] = m[:, [j, i]]
                return i, j
    return None, None


def gauss(m):
    permutations = []
    for i, row in enumerate(m):
        pi, pj = find_one(m, i)
        if pi is not None and pj is not None:
            permutations.append((pi, pj))  # remember what columns were swapped
        for j in range(i + 1, m.shape[0]):
            m[j] = abs(m[j] - m[i] * m[j, i])
    for i, row in reversed(list(enumerate(m))):
        for j in reversed(range(i)):
            m[j] = abs(m[j] - m[i] * m[j, i])
    return permutations


def ones_indices(x):  # construct list of indices of ones in binary representation of integer
    indices = []
    i = 0
    while x != 0:
        if x % 2 != 0:
            indices.append(i)
        x //= 2
        i += 1
    return indices


def find_min_d(h):
    for d in range(1, h.shape[0] + 2):
        # p is a set of columns of size d that we are going to check for linear independence
        for p in filter(lambda x: weight(x) == d, range(1, pow(2, h.shape[1]))):
            p_list = ones_indices(p)
            s = np.sum(h[:, p_list], axis=1) % 2
            if np.all(s == np.matlib.zeros((h.shape[0], 1))):
                return d


def get_syndrome_table(h):
    r = h.shape[0]
    n = h.shape[1]
    max_vector = np.matrix([1 for i in range(n)])
    table = [max_vector for i in range(pow(2, r))]
    for e in range(1, pow(2, n)):
        e_mat = np.matrix(to_list(e, n))
        s = e_mat * h.transpose() % 2
        ind = to_int(list(np.nditer(s)))
        if np.sum(table[ind]) > np.sum(e_mat):
            table[ind] = e_mat
    return table


def get_gen_matrix(h):
    n = h.shape[1]
    k = n - h.shape[0]
    g = h.copy()
    permutations = gauss(g)
    g = np.concatenate((g[:, range(n - k, n)].transpose(), np.identity(k)), axis=1)
    for i, j in permutations:
        g[:, [i, j]] = g[:, [j, i]]
    return g


def main():
    h = read_matrix('input.txt')
    n = h.shape[1]  # code length
    k = n - h.shape[0]  # code dimensionality
    print('r = ' + str(k / n))  # code speed
    print('d = ' + str(find_min_d(h)))  # min code distance

    g = get_gen_matrix(h)
    print('G = ')
    print(g)

    # calculate syndrome table
    syn = get_syndrome_table(h)
    for i, val in enumerate(syn):
        syndrome = rev_concat(to_list(i, n - k))
        print(syndrome + ': ' + rev_concat(list(np.nditer(val))))


if __name__ == "__main__":
    main()