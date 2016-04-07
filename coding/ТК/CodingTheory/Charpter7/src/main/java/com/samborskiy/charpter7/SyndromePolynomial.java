package com.samborskiy.charpter7;

import java.util.stream.IntStream;

public class SyndromePolynomial {

    private final GaloisField field;
    private final int n;
    private final int d;
    private final int[] powers;

    public SyndromePolynomial(GaloisField field, int n, int d, int... powers) {
        this.field = field;
        this.n = n;
        this.d = d;
        this.powers = powers;
    }

    public int[] build() {
        return IntStream.rangeClosed(1, d - 1)
                .map(i -> {
                    int[] a = new int[field.getPolynomial(-1).length];
                    for (int power : powers) {
                        addi(a, field.getPolynomial((power * i) % n));
                    }
                    return field.getPower(a);
                })
                .toArray();
    }

    private void addi(int[] a, int[] b) {
        for (int i = 0; i < a.length; i++) {
            a[i] = (a[i] + b[i]) % 2;
        }
    }
}
