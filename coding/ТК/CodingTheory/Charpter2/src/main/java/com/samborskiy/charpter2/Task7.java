package com.samborskiy.charpter2;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.jblas.DoubleMatrix;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

public class Task7 {

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
            Vector coordVector = new Vector(matrix.getRows()); // 000..00 (n-times)
            while (coordVector.hasNextVector()) {
                coordVector.nextVector(); // get next vector (eg 000..00 -> 000..01)
                DoubleMatrix coord = coordVector.row();
                DoubleMatrix codeWord = coord.mmul(matrix); // m * G
                modi(codeWord, 2);
                String prefix = "0 0 0 0 1 ";
                String word = MatrixUtils.toString(codeWord);
                if (word.startsWith(prefix)) {
                    System.out.println(word);
                }
            }

            /*// find syndromes
            Syndrome syndrome = new Syndrome(new DoubleMatrix(values));
            syndrome.build();

            // generate xls file with table
            HSSFWorkbook wb = new HSSFWorkbook();
            HSSFSheet sheet = wb.createSheet("Syndrome table");
            int rowNumber = 0;

            Vector syndromeVector = new Vector(values.length);
            putValue(sheet, rowNumber++, syndromeVector.toString(),
                    syndrome.getErrorVector(syndromeVector.toString()));
            while (syndromeVector.hasNextVector()) {
                syndromeVector.nextVector();
                putValue(sheet, rowNumber++, syndromeVector.toString(),
                        syndrome.getErrorVector(syndromeVector.toString()));
            }

            try (FileOutputStream fileOut = new FileOutputStream("syndrome_table.xls")) {
                wb.write(fileOut);
            }*/
        }
    }

    private static void modi(DoubleMatrix syndrome, int radix) {
        for (int i = 0; i < syndrome.getRows(); i++) {
            for (int j = 0; j < syndrome.getColumns(); j++) {
                syndrome.put(i, j, ((int) syndrome.get(i, j)) % radix);
            }
        }
    }

    private static void putValue(HSSFSheet sheet, int rowNumber, String syndrome, String errorVector) {
        HSSFRow row = sheet.createRow(rowNumber);

        HSSFCell syndromeCell = row.createCell(0);
        syndromeCell.setCellValue(syndrome);

        HSSFCell errorCell = row.createCell(1);
        errorCell.setCellValue(errorVector);
    }
}
