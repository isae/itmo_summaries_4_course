package com.samborskiy.charpter7;

/**
 * Created by sambo on 1/8/2016.
 */
public class SystemSolver {

    private final GaloisField field;
    private final int[][] a;
    private final int[] b;
    private final int n;

    public SystemSolver(GaloisField field, int n, int[][] a, int[] b) {
        this.field = field;
        this.n = n;
        this.a = a;
        this.b = b;
    }

    public int[] solve() {
        for (int i = 0; i < a.length; i++) {
            int pow = n - a[i][i];
            for (int j = i; j < a[i].length; j++) {
                a[i][j] = (a[i][j] + pow) % n;
            }
            b[i] = (b[i] + pow) % n;

            for (int j = i + 1; j < a.length; j++) {
                int diffPow = a[j][i] - a[i][i];
                for (int k = i; k < a[j].length; k++) {
                    int[] tmp = add(field.getPolynomial((a[i][k] + diffPow) % n), field.getPolynomial(a[j][k]));
                    a[j][k] = field.getPower(tmp);
                }
                int[] tmp = add(field.getPolynomial((b[i] + diffPow) % n), field.getPolynomial(b[j]));
                b[j] = field.getPower(tmp);
            }
        }

        for (int i = a.length - 1; i >= 0; i--) {
            for (int j = 0; j < i; j++) {
                int pow = a[j][i];
                a[j][i] = -1;
                int[] tmp = add(field.getPolynomial((b[i] + pow) % n), field.getPolynomial(b[j]));
                b[j] = field.getPower(tmp);
            }
        }

        return b;
    }


    private int[] add(int[] a, int[] b) {
        int[] c = new int[a.length];
        for (int i = 0; i < a.length; i++) {
            c[i] = (a[i] + b[i]) % 2;
        }
        return c;
    }
}
