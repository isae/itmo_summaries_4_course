package com.samborskiy.charpter7;

import java.util.stream.IntStream;

/**
 * Created by sambo on 1/8/2016.
 */
public class FindLocatorErrors {

    private final GaloisField field;
    private final int n;

    public FindLocatorErrors(GaloisField field, int n) {
        this.field = field;
        this.n = n;
    }

    public int[] solve(int[] coefs) {
        return IntStream.range(0, n)
                .filter(i -> {
                    int[] tmp = new int[field.getPolynomial(-1).length];
                    for (int j = 0; j < coefs.length; j++) {
                        if (coefs[j] != -1) {
                            addi(tmp, field.getPolynomial((coefs[j] + i * j) % n));
                        }
                    }
                    return isRoot(tmp);
                })
                .map(i -> n - i)
                .toArray();
    }

    private boolean isRoot(int[] result) {
        for (int val : result) {
            if (val != 0) {
                return false;
            }
        }
        return true;
    }

    private void addi(int[] a, int[] b) {
        for (int i = 0; i < a.length; i++) {
            a[i] = (a[i] + b[i]) % 2;
        }
    }
}
