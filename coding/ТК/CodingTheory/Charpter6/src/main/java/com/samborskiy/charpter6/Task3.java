package com.samborskiy.charpter6;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.stream.IntStream;

public class Task3 {

    private static final int N = 31;
    private static final BCHCode BCH_CODE = new BCHCode(N);

    private static final int[] BEST_D_31 = {
            -1, 31, -1, 17, 16, 16, 15, 13, 12, 12, 12, 11, 10, 9, 8, 8, 8, 7, 6, 6, 6,
            5, 4, 4, 4, 4, 3, 2, 2, 2, 2, 1
    };

    private static final TableCell[] COLUMNS = {
            new TableCell<Integer>("n", String::valueOf),
            new TableCell<>("Generator polynomial", BCH_CODE::generatorPolynomial),
            new TableCell<>("k_min", BCH_CODE::getMinK),
            new TableCell<>("d", String::valueOf),
//            new TableCell<Integer>("d_best", d -> String.valueOf(BEST_D_31[Integer.parseInt(BCH_CODE.getMinK(d))]))
            new TableCell<Integer>("d_best", String::valueOf)
    };

    public static void main(String[] args) throws IOException {
        System.out.println(BCH_CODE.getCyclotomicClasses());

        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("Table");
        int rowNumber = 0;
        HSSFRow header = sheet.createRow(rowNumber++);
        IntStream.range(0, COLUMNS.length)
                .forEach(i -> header.createCell(i).setCellValue(COLUMNS[i].getHeader()));

        for (int d = 0; d <= N; d++) {
            if (BCH_CODE.generatorPolynomial(d) != null) {
                HSSFRow row = sheet.createRow(rowNumber++);
                row.createCell(0).setCellValue(COLUMNS[0].getValue(N));
                row.createCell(1).setCellValue(COLUMNS[1].getValue(d));
                row.createCell(2).setCellValue(COLUMNS[2].getValue(d));
                row.createCell(3).setCellValue(COLUMNS[3].getValue(d));
                row.createCell(4).setCellValue(COLUMNS[4].getValue(0));
            }
        }

        try (FileOutputStream fileOut = new FileOutputStream("temp.xls")) {
            wb.write(fileOut);
        }
    }
}
