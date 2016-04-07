package com.samborskiy.charpter3;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;

public class Task5 {

    public static void main(String[] args) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader("the_best_nkd"))) {
            HSSFWorkbook wb = new HSSFWorkbook();
            HSSFSheet sheet = wb.createSheet("nkd table");

            int rowNumber = 0;
            String line;
            while ((line = reader.readLine()) != null) {
                String[] tokens = line.split(" ");
                int n = Integer.parseInt(tokens[0]);
                int k = Integer.parseInt(tokens[1]);
                putValue(sheet, rowNumber++, n, k, tokens[2],
                        GilbertVarshamovBound.findD(n, k), HammingBound.findD(n, k));
            }

            try (FileOutputStream fileOut = new FileOutputStream("d_bounds.xls")) {
                wb.write(fileOut);
            }
        }
    }

    private static void putValue(HSSFSheet sheet, int rowNumber, int n, int k, String d, int min, int max) {
        HSSFRow row = sheet.createRow(rowNumber);

        HSSFCell nCell = row.createCell(0);
        nCell.setCellValue(n);

        HSSFCell kCell = row.createCell(1);
        kCell.setCellValue(k);

        HSSFCell dCell = row.createCell(2);
        dCell.setCellValue(d);

        HSSFCell minCell = row.createCell(3);
        minCell.setCellValue(min);

        HSSFCell maxCell = row.createCell(4);
        maxCell.setCellValue(max);
    }
}
