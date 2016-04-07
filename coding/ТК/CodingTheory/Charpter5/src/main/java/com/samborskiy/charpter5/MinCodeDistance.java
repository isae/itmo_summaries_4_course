package com.samborskiy.charpter5;

import org.jblas.DoubleMatrix;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.IntStream;

public class MinCodeDistance {

    private final DoubleMatrix matrix;

    public MinCodeDistance(DoubleMatrix matrix) {
        this.matrix = matrix;
    }

    /**
     * Returns minimum code distance - {@code d}.
     */
    public int evaluate() {
        Vector coordVector = new Vector(matrix.getRows()); // 000..00 (n-times)
        List<DoubleMatrix> codeWords = new ArrayList<>(); // set of code words
        while (coordVector.hasNextVector()) {
            coordVector.nextVector(); // get next vector (eg 000..00 -> 000..01)
            DoubleMatrix coord = coordVector.row();
            DoubleMatrix codeWord = coord.mmul(matrix); // m * G
            modi(codeWord, 2);
            codeWords.add(codeWord);
        }

        int minDistance = Integer.MAX_VALUE;
        for (DoubleMatrix matrix : codeWords) {
            minDistance = Math.min(minDistance, weight(matrix)); // find min_c w(c)
        }
        return minDistance;
    }

    /**
     * Counts number of {@code 1} in vector.
     */
    private int weight(DoubleMatrix vector) {
        return IntStream.range(0, vector.getColumns())
                .map(i -> (int) vector.get(i))
                .sum();
    }

    /**
     * {@code s[i] = s[i] mod radix} (default value of {@code radix} is {@code 2}).
     */
    private void modi(DoubleMatrix syndrome, int radix) {
        for (int i = 0; i < syndrome.getRows(); i++) {
            for (int j = 0; j < syndrome.getColumns(); j++) {
                syndrome.put(i, j, ((int) syndrome.get(i, j)) % radix);
            }
        }
    }
}
