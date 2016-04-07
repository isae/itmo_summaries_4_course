import numpy as np
import itertools

H = [
    [1, 0, 1, 0, 1, 0, 1, 0, 0, 1],
    [0, 1, 1, 1, 1, 1, 0, 0, 0, 0],
    [0, 1, 1, 1, 1, 0, 0, 1, 1, 1],
    [1, 0, 1, 1, 0, 0, 0, 0, 1, 1]
]

n = len(H[0])
k = n - len(H)

H_trans = list(np.transpose(H))
error_vectors = list(itertools.product([0, 1], repeat=n))


def dot(vec, matrix):
    assert len(vec) == len(matrix)
    res = []
    for i in range(len(matrix[0])):
        acc = 0
        for j in range(len(vec)):
            acc = add(acc, vec[j] * matrix[j][i])
        res.append(acc)
    return tuple(res)


def add(e1, e2):
    if e1 == 0:
        return e2
    if e2 == 0:
        return e1
    return 0


def get_weight(vec):
    return sum(e for e in vec)


syndrome_to_error = {}
for e in error_vectors:
    synd = dot(e, H_trans)
    if synd in syndrome_to_error:
        if get_weight(e) >= get_weight(syndrome_to_error[synd]):
            continue
    syndrome_to_error[synd] = e

for k, v in syndrome_to_error.items():
    print(k, " : ", v, "\n")
