package com.samborskiy.charpter3;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;

public class Task7 {

    private static final int D = 8;

    public static void main(String[] args) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader("the_best_kn"))) {
            HSSFWorkbook wb = new HSSFWorkbook();
            HSSFSheet sheet = wb.createSheet("kn table");

            int rowNumber = 0;
            String line;
            while ((line = reader.readLine()) != null) {
                String[] tokens = line.split(" ");
                int k = Integer.parseInt(tokens[0]);
                putValue(sheet, rowNumber++, k, tokens[1], GriesmerBound.findN(k, D));
            }

            try (FileOutputStream fileOut = new FileOutputStream("n_lower_bound.xls")) {
                wb.write(fileOut);
            }
        }
    }

    private static void putValue(HSSFSheet sheet, int rowNumber, int k, String n, int min) {
        HSSFRow row = sheet.createRow(rowNumber);

        HSSFCell kCell = row.createCell(0);
        kCell.setCellValue(k);

        HSSFCell nCell = row.createCell(1);
        nCell.setCellValue(n);

        HSSFCell minCell = row.createCell(2);
        minCell.setCellValue(min);
    }
}
