package com.samborskiy.charpter2;

import org.jblas.DoubleMatrix;

import java.io.IOException;

public class Task11 {

    private static final int D = 5;

    public static void main(String[] args) throws IOException {
        // find all (n, k)-code for k \in [3, 10] and n \in [1, k * d] where d = 5
        for (int k = 3; k <= 10; k++) {
            for (int n = 1; n < k * D; n++) {
                Vector vector = new Vector(n);
                while (vector.hasNextVector()) {
                    vector.nextVector();
                    DoubleMatrix matrix = MatrixUtils.buildQuasiCyclicCode(vector.getData(), n, k, 1);
                    int distance = new MinCodeDistance(matrix).evaluate();
                    if (distance == D) {
                        System.out.format("d = %d\n%s\n\n", distance, MatrixUtils.toString(matrix));
                    }
                }
            }
        }
    }
}
