package com.samborskiy.charpter2;

import org.jblas.DoubleMatrix;

import java.io.IOException;

public class Task13 {

    private static final double[] SEQUENCE = {1, 1, 0, 1, 1, 1};

    public static void main(String[] args) throws IOException {
        // find min code distance for all quasi-cyclic code for SEQUENCE with k \in [1, 10] with c = 2
        for (int k = 2; k <= 20; k++) {
            DoubleMatrix matrix = MatrixUtils.buildQuasiCyclicCode(SEQUENCE, 2 * k, k, 2);
            System.out.println("k = " + k + " d = " + new MinCodeDistance(matrix).evaluate());
        }
    }
}
