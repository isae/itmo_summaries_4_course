package com.samborskiy.charpter7;

import java.util.Arrays;

/**
 * Created by sambo on 1/6/2016.
 */
public class Task6 {

    private static final int N = 31;
    private static final int D = 7;
    private static final int ERROR_NUMBER = 3;

    private static final int[] INPUT = {0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 13, 14, 15};

    public static void main(String[] args) {
        GaloisField field = new GaloisField(new int[]{1, 0, 1, 0, 0, 1});
        field.build(new int[]{0, 0, 0, 0, 1});
//        System.out.println(field);

        GeneratedPolynomial polynomial = new GeneratedPolynomial(N, field);
        polynomial.build(1, 3, 5);

        SyndromePolynomial syndromePolynomial = new SyndromePolynomial(field, N, D, INPUT);
        int[] syndromeCoef = syndromePolynomial.build();
        System.out.println("SYNDROME: " + Arrays.toString(syndromeCoef));

        int[][] a = new int[ERROR_NUMBER][ERROR_NUMBER];
        int[] b = new int[ERROR_NUMBER];
        for (int i = 0; i < ERROR_NUMBER; i++) {
            System.arraycopy(syndromeCoef, i, a[i], 0, ERROR_NUMBER);
            b[i] = syndromeCoef[ERROR_NUMBER + i];
        }

        SystemSolver solver = new SystemSolver(field, N, a, b);
        int[] locatorCoefReverse = solver.solve();
        int[] locatorCoef = new int[locatorCoefReverse.length + 1];
        locatorCoef[0] = 0;
        for (int i = 0; i < locatorCoefReverse.length; i++) {
            locatorCoef[i + 1] = locatorCoefReverse[locatorCoefReverse.length - 1 - i];
        }
        System.out.println("LOCATOR: " + Arrays.toString(locatorCoef));

        FindLocatorErrors finder = new FindLocatorErrors(field, N);
        int[] locatorErrors = finder.solve(locatorCoef);
        System.out.println("LOCATOR ERRORS: " + Arrays.toString(locatorErrors));

        a = new int[ERROR_NUMBER][ERROR_NUMBER];
        b = new int[ERROR_NUMBER];
        for (int i = 0; i < ERROR_NUMBER; i++) {
            for (int j = 0; j < ERROR_NUMBER; j++) {
                a[i][j] = locatorErrors[j] * (i + 1) % N;
            }
            b[i] = syndromeCoef[i];
        }

        solver = new SystemSolver(field, N, a, b);
        int[] errorValues = solver.solve();
        System.out.println("ERROR VALUES: " + Arrays.toString(errorValues));
    }
}
