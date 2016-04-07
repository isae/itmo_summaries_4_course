from scipy.stats import norm
import random
import json
import math
from multiprocessing import Pool
from linear import *
from common import *
from plots import *


def words(length):
    for i in range(pow(2, length)):
        yield to_list(i, length)


def apply_noise(w, p, n):
    noisy = w
    d = 1
    for i in range(n):
        if random.random() < p:
            noisy = noisy ^ d
        d *= 2
    return noisy


def ones_count(x):
    count = 0
    while x != 0:
        count += 1
        x &= x - 1
    return count


def diff(x, y):
    return ones_count(x ^ y)


def likelihood(y, c, p, n):
    d = diff(y, c)
    return (p ** d) * ((1 - p) ** (n - d))


def max_likelihood(y, code_words, p, n):
    return code_words.index(max(code_words, key=lambda c: likelihood(y, c, p, n)))


def soft_decision(y, i, code_words, p, n):
    d = 2 ** i
    zero_words = filter(lambda c: c & d == 0, code_words)
    one_words = filter(lambda c: c & d != 0, code_words)

    def sum_likelihoods(l):
        return sum(map(lambda c: likelihood(c, y, p, n), l))
    return sum_likelihoods(one_words) - sum_likelihoods(zero_words)


def max_posterior_probability(y, code_words, p, n):
    word = 0
    for i in range(n):
        if soft_decision(y, i, code_words, p, n) > 0:
            word += 2 ** i
    return code_words.index(min(code_words, key=lambda c: diff(word, c)))


def matrix_to_list(m):
    return np.array(m)[0].tolist()


def model_sending(cnt, en, code_words, n, k):
    p = 1 - norm.cdf(math.sqrt(2 * 10 ** (en / 10)))
    errors = 0
    for i in range(cnt):
        i_sent = random.randrange(len(code_words))
        word = code_words[i_sent]
        y = apply_noise(word, p, n)
        i_got = max_likelihood(y, code_words, p, n)
        errors += diff(i_sent, i_got)
    e_for_bit = errors / cnt / k
    print(str(en) + ": " + str(e_for_bit))
    return en, e_for_bit


def main():
    transmits_count = 100000
    en_range = np.arange(0, 7, 0.1)

    h = read_matrix('input.txt')
    g = get_gen_matrix(h)
    k = g.shape[0]
    n = g.shape[1]
    inf_words = list(words(k))
    code_words = list(map(lambda t: to_int(matrix_to_list(t * g % 2)), inf_words))
    random.seed()
    pool = Pool()
    results = []
    for en in en_range:  # Eb / N0 in dB
        results.append(pool.apply_async(model_sending, [transmits_count, en, code_words, n, k]))
    pool.close()
    plot_data = dict()
    for res in results:
        en, e_for_bit = res.get()
        plot_data[en] = e_for_bit
    with open('data.json', 'w') as out_file:
        json.dump(plot_data, out_file, sort_keys=True)
    draw_plot(plot_data)


if __name__ == "__main__":
    main()
