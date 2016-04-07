#
# Copyright (c) 2015, Nikolay Polyarnyi
# All rights reserved.
#

import numpy as np


def to_diagonal_ones(G):
    """
    >>> G = np.array([[1, 1, 0, 0, 0],\
                      [1, 0, 1, 0, 1],\
                      [1, 0, 0, 1, 0]], np.uint8)
    >>> to_diagonal_ones(G)
    array([[1, 0, 0, 1, 0],
           [0, 1, 0, 1, 0],
           [0, 0, 1, 1, 1]], dtype=uint8)

    >>> G = np.array([[0, 0, 0, 1, 0],\
                      [0, 0, 1, 0, 0],\
                      [0, 0, 0, 0, 1]], np.uint8)
    >>> to_diagonal_ones(G)
    array([[1, 0, 0, 0, 0],
           [0, 1, 0, 0, 0],
           [0, 0, 1, 0, 0]], dtype=uint8)

    :param G: generating matrix
    :return: generating matrix in systematic form
    """
    k, n = G.shape
    assert k <= n
    assert np.linalg.matrix_rank(G) == k

    G = G.copy()
    for j in range(k):
        non_zero_column = j + np.nonzero(np.any(G[j:, j:] > 0, axis=0))[0][0]
        G[:, j], G[:, non_zero_column] = G[:, non_zero_column].copy(), G[:, j].copy()
        non_zero_row = j + np.nonzero(G[j:, j])[0][0]
        G[j], G[non_zero_row] = G[non_zero_row].copy(), G[j].copy()

        for i in range(k):
            if i == j:
                continue
            G[i] = (G[i] + G[j] * G[i, j]) % 2
    return G


def build_check_matrix(G):
    """
    >>> G = np.array([[1, 1, 0, 0, 0],\
                      [1, 0, 1, 0, 1],\
                      [1, 0, 0, 1, 0]], np.uint8)
    >>> build_check_matrix(G)
    array([[1, 1, 1, 1, 0],
           [0, 0, 1, 0, 1]], dtype=uint8)

    :param G: generating matrix
    :return: checking matrix
    """
    k, n = G.shape
    r = n - k
    G = to_diagonal_ones(G)
    Ik, P = G[:, :k], G[:, k:]
    H = np.hstack([P.T, np.eye(r, dtype=np.uint8)])
    assert np.all(np.dot(G, H.T) % 2 == 0)
    return H


def build_generating_matrix(H):
    """
    >>> H = np.array([[1, 1, 1, 1, 0],\
                      [0, 0, 1, 0, 1]], np.uint8)
    >>> build_check_matrix(H)
    array([[1, 0, 1, 0, 0],
           [1, 0, 0, 1, 0],
           [1, 1, 0, 0, 1]], dtype=uint8)

    :param H: checking matrix
    :return: generating matrix
    """
    r, n = H.shape
    k = n - r
    H = to_diagonal_ones(H)
    Ir, PT = H[:, :r], H[:, r:]
    G = np.hstack([np.eye(k, dtype=np.uint8), PT.T])
    return G


def calc_min_dist(H):
    """
    >>> H = np.array([[1, 1, 1, 1, 0],\
                      [0, 0, 1, 0, 1]], dtype=np.uint8)
    >>> calc_min_dist(H)
    2

    :param H: checking matrix
    :return: minimum distance for given checking matrix (d = min w (mG))
    """
    r, n = H.shape
    wmin = None
    for i in range(1, 2 ** n):
        vi = np.unpackbits(np.array([i], np.int64).view(np.uint8).reshape(-1, 1), axis=-1)[:, ::-1].ravel()[:n]
        if not np.all(np.dot(H, vi) % 2 == 0):
            continue
        w = np.sum(vi)
        wmin = min(wmin or w, w)
    return wmin


def build_syndrom_table(H):
    """
    >>> H = np.array([[0, 1, 1, 0, 1],\
                      [1, 1, 1, 1, 0],\
                      [1, 0, 0, 1, 0]], np.uint8)
    >>> for a, b in build_syndrom_table(H):\
            print("{}: {}".format(a, b))
    [0 1 1]: [0 0 0 1 0]
    [1 1 0]: [0 0 1 0 0]
    [1 0 1]: [0 0 1 1 0]
    [1 0 0]: [0 0 0 0 1]
    [1 1 1]: [0 0 0 1 1]
    [0 1 0]: [0 0 1 0 1]
    [0 0 1]: [0 0 1 1 1]
    """
    r, n = H.shape
    table = []
    already = set()
    for y in range(0, 2 ** n):
        y = np.unpackbits(np.array([y], np.int64).view(np.uint8).reshape(-1, 1), axis=-1)[:, ::-1].ravel()[:n]
        s = np.dot(y, H.T) % 2
        if np.all(s == 0) or str(s) in already:
            continue
        already.add(str(s))
        best_e = None
        for e in range(0, 2 ** n):
            e = np.unpackbits(np.array([e], np.int64).view(np.uint8).reshape(-1, 1), axis=-1)[:, ::-1].ravel()[:n]
            if not np.all(s == np.dot(e, H.T) % 2):
                continue
            if best_e is None or np.sum(e) <= np.sum(best_e):
                best_e = e
        table.append((s, best_e))
    return table


if __name__ == '__main__':
    H = np.array([
        [1, 0, 1, 0, 1, 0, 1, 0, 0, 1],
        [0, 1, 1, 1, 1, 1, 0, 0, 0, 0],
        [0, 1, 1, 1, 1, 0, 0, 1, 1, 1],
        [1, 0, 1, 1, 0, 0, 0, 0, 1, 1]
    ], np.uint8)
    G = build_generating_matrix(H)
    k, n = G.shape
    r = n - k
    speed_R = k / n
    min_dist = calc_min_dist(H)

    print("k={} n={} r={}".format(k, n, r))
    print("Min dist={}".format(min_dist))
    print("Information speed R={}".format(speed_R))
    print("Checking matrix H:")
    print(H)
    print("Generating matrix G:")
    print(G)

    print("Syndrom table:")
    table = build_syndrom_table(H)
    for a, b in table:
        print("{}: {}".format(a, b))
