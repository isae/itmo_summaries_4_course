package com.samborskiy.charpter2;

import org.jblas.DoubleMatrix;

import java.io.IOException;

public class Task12 {

    private static final double[] SEQUENCE = {1, 1, 0, 1, 1, 1};

    public static void main(String[] args) throws IOException {
        // find min code distance for all conventional code for SEQUENCE with k \in [1, 10]
        for (int k = 1; k <= 10; k++) {
            DoubleMatrix matrix = MatrixUtils.buildConventionalCode(SEQUENCE, k);
            System.out.println(new MinCodeDistance(matrix).evaluate());
        }
    }
}
