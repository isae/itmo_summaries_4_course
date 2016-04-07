package com.samborskiy.charpter3;

import java.util.stream.IntStream;

public class GilbertVarshamovBound {

    private static final int MAX_D = 20;

    private GilbertVarshamovBound() {
    }

    /**
     * Finds lower bound of d using Gilbert-Varshamov bound.
     */
    public static int findD(int n, int k) {
        for (int d = 0; d < MAX_D; d++) {
            double denominator = IntStream.range(0, d - 1).mapToDouble(i -> combinations(n - 1, i)).sum();
            if (Math.pow(2, n - k) <= denominator) {
                return d - 1;
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
