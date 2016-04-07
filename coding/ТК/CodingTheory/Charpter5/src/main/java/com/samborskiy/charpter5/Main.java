package com.samborskiy.charpter5;

import org.jblas.DoubleMatrix;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class Main {

    public static void main(String[] args) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader("matrix_test"))) {
            // read table from file
            List<String[]> rows = reader.lines()
                    .map(line -> line.split(" "))
                    .collect(Collectors.toList());
            double[][] values = new double[rows.size()][rows.get(0).length];
            for (int i = 0; i < values.length; i++) {
                String[] row = rows.get(i);
                for (int j = 0; j < values[0].length; j++) {
                    values[i][j] = Double.parseDouble(row[j]);
                }
            }
            DoubleMatrix matrix = new DoubleMatrix(values);

            List<DoubleMatrix> codeWords = new ArrayList<>();
            Vector vector = new Vector(matrix.getRows());
            while (vector.hasNextVector()) {
                vector.nextVector();
                DoubleMatrix codeWord = vector.row().mmul(matrix);
                modi(codeWord, 2);
                codeWords.add(codeWord);
            }

            for (DoubleMatrix codeWord : codeWords) {
                for (int i = 0; i < codeWord.getColumns(); i++) {
                    DoubleMatrix shiftedWord = shift(codeWord, i);
                    boolean find = false;
                    for (DoubleMatrix codeWord2 : codeWords) {
                        find |= codeWord2.equals(shiftedWord);
                    }
                    if (!find) {
                        System.out.println("it is NOT cycling code");
                        return;
                    }
                }
            }

            System.out.format("(%1$d, %2$d)\nR = %2$d / %1$d\nd = %3$d", matrix.getColumns(), matrix.getRows(), new MinCodeDistance(matrix).evaluate());
        }
    }

    private static DoubleMatrix shift(DoubleMatrix vector, int k) {
        DoubleMatrix matrix = new DoubleMatrix(vector.getRows(), vector.getColumns());
        for (int i = 0; i < vector.getColumns(); i++) {
            matrix.put(0, (i + k) % vector.getColumns(), vector.get(0, i));
        }
        return matrix;
    }

    private static void modi(DoubleMatrix syndrome, int radix) {
        for (int i = 0; i < syndrome.getRows(); i++) {
            for (int j = 0; j < syndrome.getColumns(); j++) {
                syndrome.put(i, j, ((int) syndrome.get(i, j)) % radix);
            }
        }
    }
}
