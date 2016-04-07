package com.samborskiy.charpter2;

import org.jblas.DoubleMatrix;

import java.util.Arrays;
import java.util.stream.Collectors;

public class MatrixUtils {

    private MatrixUtils() {
    }

    public static String toString(DoubleMatrix matrix) {
        StringBuilder humanreadableMatrix = new StringBuilder();
        matrix.rowsAsList().forEach(
                row -> {
                    String rowString = Arrays.stream(row.data)
                            .mapToObj(value -> String.valueOf((int) value))
                            .collect(Collectors.joining(" ", "", "\n"));
                    humanreadableMatrix.append(rowString);
                }
        );
        return humanreadableMatrix.toString().trim();
    }

    /**
     * Counts weight of vector.
     */
    public static int weight(String vector) {
        return vector.chars().filter(value -> value != ' ').map(value -> value - '0').sum();
    }

    /**
     * Builds matrix for quasi-cyclic code with params {@code n}, {@code k}, {@code shift} for {@code sequence}.<br>
     * NB: if {@code shift} is 1 than it is cyclic code.
     */
    public static DoubleMatrix buildQuasiCyclicCode(double[] sequence, int n, int k, int shift) {
        double[][] matrix = new double[k][n];
        for (int c = 0; c < n; c++) {
            matrix[0][c] = sequence.length > c ? sequence[c] : 0;
        }
        for (int r = 1; r < k; r++) {
            System.arraycopy(matrix[r - 1], n - shift, matrix[r], 0, shift);
            System.arraycopy(matrix[r - 1], 0, matrix[r], shift, n - shift);
        }
        return new DoubleMatrix(matrix);
    }

    /**
     * Builds conventional code with param {@code k} for {@code sequence}.
     */
    public static DoubleMatrix buildConventionalCode(double[] sequence, int k) {
        double[][] matrix = new double[k][sequence.length + 2 * (k - 1)];
        for (int r = 0; r < k; r++) {
            System.arraycopy(sequence, 0, matrix[r], r * 2, sequence.length);
        }
        return new DoubleMatrix(matrix);
    }
}
