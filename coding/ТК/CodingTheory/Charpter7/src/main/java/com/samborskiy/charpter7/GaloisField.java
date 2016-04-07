package com.samborskiy.charpter7;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

public class GaloisField {

    private final int n;
    private final int[] mod;
    private final Map<Integer, int[]> powerToPolynomial;

    public GaloisField(int[] polynomial) {
        this.n = (int) Math.pow(2, polynomial.length - 1);
        this.mod = new int[polynomial.length - 1];
        System.arraycopy(polynomial, 1, mod, 0, mod.length);
        this.powerToPolynomial = new HashMap<>();

        int[] zero = new int[mod.length];
        powerToPolynomial.put(-1, zero);

        int[] one = new int[mod.length];
        one[mod.length - 1] = 1;
        powerToPolynomial.put(0, one);
    }

    public void build(int[] generatePolynomial) {
        for (int i = 1; i <= n - 2; i++) {
            int[] c = mul(powerToPolynomial.get(i - 1), generatePolynomial);
            powerToPolynomial.put(i, c);
        }
    }

    public int[] getPolynomial(int index) {
        return powerToPolynomial.get(index);
    }

    public int getPower(int[] polynomial) {
        for (int power : powerToPolynomial.keySet()) {
            if (Arrays.equals(powerToPolynomial.get(power), polynomial)) {
                return power;
            }
        }
        return -2;
    }

    @Override
    public String toString() {
        return powerToPolynomial.keySet().stream()
                .sorted(Integer::compareTo)
                .map(powerToPolynomial::get)
                .map(Arrays::toString)
                .collect(Collectors.joining("\n"));
    }

    private int[] mul(int[] a, int[] b) {
        int[] c = new int[a.length];
        for (int i = b.length - 1; i >= 0; i--) {
            if (b[i] == 1) {
                for (int j = a.length - 1; j >= 0; j--) {
                    if (a[j] == 1) {
                        int k = c.length - ((b.length - i) + (a.length - j));
                        if (k >= 0) {
                            c[k] = (c[k] + a[j]) % 2;
                        } else {
                            addi(c, mod);
                        }
                    }
                }
            }
        }
        return c;
    }

    private void addi(int[] a, int[] b) {
        for (int i = 0; i < a.length; i++) {
            a[i] = (a[i] + b[i]) % 2;
        }
    }
}
