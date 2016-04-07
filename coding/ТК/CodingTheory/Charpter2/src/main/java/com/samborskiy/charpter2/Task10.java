package com.samborskiy.charpter2;

import java.io.IOException;

public class Task10 {

    private static final double[] SEQUENCE = {1, 1, 1, 0, 1};

    public static void main(String[] args) throws IOException {
        // build table of min code distance for every (n, k)-code (k \in [1, 10], n \in [SEQUENCE.length, 20]
        for (int k = 1; k <= 10; k++) {
            for (int n = SEQUENCE.length; n <= 20; n++) {
                System.out.print(" " + new MinCodeDistance(MatrixUtils.buildQuasiCyclicCode(SEQUENCE, n, k, 1)).evaluate());
            }
            System.out.println();
        }
    }
}
