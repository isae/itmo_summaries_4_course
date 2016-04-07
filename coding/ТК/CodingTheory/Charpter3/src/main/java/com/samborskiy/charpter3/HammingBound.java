package com.samborskiy.charpter3;

import java.util.stream.IntStream;

public class HammingBound {

    private static final int MAX_D = 20;

    private HammingBound() {
    }

    /**
     * Finds upper bound of d using Hamming bound.
     */
    public static int findD(int n, int k) {
        for (int t = 0; t < MAX_D; t++) {
            double denominator = IntStream.range(0, t + 1).mapToDouble(i -> combinations(n, i)).sum();
            if (Math.pow(2, k) > Math.pow(2, n) / denominator) {
                int d = (t - 1) * 2 + 1;
                return d % 2 == 0 ? d : d + 1;
            }
        }
        return -1;
    }

    /**
     * Counts C_k^n.
     */
    private static double combinations(int n, int k) {
        if (n / 2. > k) {
            return combinations(n, n - k);
        }
        return mul(k + 1, n) / mul(1, n - k);
    }

    /**
     * Returns the result of multiplying all the numbers {@code from} to {@code to}.
     */
    private static double mul(int from, int to) {
        double mul = 1.;
        for (int i = from; i <= to; i++) {
            mul *= i;
        }
        return mul;
    }
}
