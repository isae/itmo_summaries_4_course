package com.samborskiy.charpter2;

import org.jblas.DoubleMatrix;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

public class Task14 {

    public static void main(String[] args) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader("matrix14_5"))) {
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

            // find syndromes
            Syndrome syndrome = new Syndrome(new DoubleMatrix(values));
            syndrome.build();

            // count coverage radius
            int coverageRadius = Integer.MIN_VALUE;
            Vector syndromeVector = new Vector(values.length);
            while (syndromeVector.hasNextVector()) {
                syndromeVector.nextVector();
                coverageRadius = Math.max(coverageRadius, // \rho = max_s (\rho, error vector of syndrome s)
                        MatrixUtils.weight(syndrome.getErrorVector(syndromeVector.toString())));
            }
            System.out.println(coverageRadius);
        }
    }
}
