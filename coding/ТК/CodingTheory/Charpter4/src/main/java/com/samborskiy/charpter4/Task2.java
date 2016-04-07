package com.samborskiy.charpter4;

import org.apache.commons.math3.distribution.NormalDistribution;
import org.jblas.DoubleMatrix;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Task2 {

    private static final int N = 100000;
    private static final Random RANDOM = new Random();
    private static final NormalDistribution DISTRIBUTION = new NormalDistribution(0, 1);
    private static final double STEP = 0.1;
    private static final double LEFT_BOARD = 0.6;
    private static final double RIGHT_BOARD = 6.6;

    public static void main(String[] args) throws IOException {
        System.out.println(new File(".").getAbsolutePath());
        try (BufferedReader reader = new BufferedReader(new FileReader("matrix_G2"))) {
            // read data from file
            List<String[]> rows = reader.lines()
                    .map(line -> line.split(" "))
                    .collect(Collectors.toList());
            double[][] matrixData = new double[rows.size() - 3][rows.get(0).length];

            // read matrix
            for (int i = 0; i < matrixData.length; i++) {
                String[] row = rows.get(i);
                for (int j = 0; j < matrixData[0].length; j++) {
                    matrixData[i][j] = Double.parseDouble(row[j]);
                }
            }
            DoubleMatrix g = new DoubleMatrix(matrixData);

            double[] xValues = IntStream.range(0, (int) ((RIGHT_BOARD - LEFT_BOARD) / STEP))
                    .mapToDouble(l -> 10 * Math.log10(LEFT_BOARD + l * STEP)) // convert to DB
                    .toArray();
            double[] yValues = IntStream.range(0, xValues.length)
                    .parallel()
                    .mapToDouble(l -> bitErrorProbability(l, g))
                    .toArray();

            Plot2DBuilder plot2DBuilder = new Plot2DBuilder("E_b / N_0", "Bit error probability");
            plot2DBuilder.addPlot("", xValues, yValues);
            plot2DBuilder.show();
        }
    }

    private static double bitErrorProbability(int i, DoubleMatrix g) {
        double x = LEFT_BOARD + i * STEP;
        double p = countP(x);
        MLDecoder decoder = new MLDecoder(g, p);  // create maximum-likelihood decoder

        int k = g.getRows();
        int diff = 0;
        for (int j = 0; j < N; j++) {
            DoubleMatrix sequence = MatrixUtils.generateSequence(k); // generate random sequence k-th length
            DoubleMatrix codeWord = sequence.mmul(g); // coding sequence by g
            modi(codeWord, 2);
            spoilSequence(codeWord, p); // spoil code word with p probability
            diff += diff(sequence, decoder.decode(codeWord)); // count number different bits
        }

        double ans = ((double) diff) / (N * k);
        System.out.println(10 * Math.log10(x) + " --> " + ans);
        return ans;
    }

    /**
     * Counts number of different bits.
     */
    private static int diff(DoubleMatrix sequence, DoubleMatrix decodedSequence) {
        int diff = 0;
        for (int i = 0; i < sequence.getColumns(); i++) {
            diff += sequence.get(i) != decodedSequence.get(i) ? 1 : 0;
        }
        return diff;
    }

    /**
     * Counts {@code p} by x = E_b / N_0.
     */
    private static double countP(double x) {
        return 1 - DISTRIBUTION.cumulativeProbability(Math.sqrt(2 * x));
    }

    private static void spoilSequence(DoubleMatrix sequence, double p) {
        for (int i = 0; i < sequence.getColumns(); i++) {
            if (RANDOM.nextDouble() < p) {
                sequence.put(i, sequence.get(i) == 1 ? 0 : 1);
            }
        }
    }

    protected static void modi(DoubleMatrix vector, int radix) {
        for (int i = 0; i < vector.getRows(); i++) {
            for (int j = 0; j < vector.getColumns(); j++) {
                vector.put(i, j, ((int) vector.get(i, j)) % radix);
            }
        }
    }
}
