package com.samborskiy.charpter7;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.IntStream;

public class BerlekampMassey {

    private static final String TEMP_FILENAME = "temp.xls";

    private static final TableCell[] COLUMNS = {
            new TableCell<Integer>("r", "0", String::valueOf),
            new TableCell<Integer>("s", "-", String::valueOf),
            new TableCell<Long>("\\delta", "0", String::valueOf),
            new TableCell<List<Integer>>("B(x)", "1", PolynomialUtil::sequenceToPolynomial),
            new TableCell<List<Integer>>("\\Lambda(x)", "1", PolynomialUtil::sequenceToPolynomial),
            new TableCell<Integer>("L", "0", String::valueOf)
    };

    private int[] syndrome;

    private int registerLength;
    private List<Integer> locators;
    private List<Integer> residual;

    public BerlekampMassey(int[] syndrome) {
        this.syndrome = syndrome;
        this.registerLength = 0;
        this.locators = new ArrayList<>(Arrays.asList(new Integer[]{1}));
        this.residual = new ArrayList<>(Arrays.asList(new Integer[]{1}));
    }

    public List<Integer> eval() throws IOException {
        return eval(TEMP_FILENAME);
    }

    public List<Integer> eval(String xlsFilename) throws IOException {
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("Table");
        HSSFRow header = sheet.createRow(0);
        IntStream.range(0, COLUMNS.length)
                .forEach(i -> header.createCell(i).setCellValue(COLUMNS[i].getHeader()));
        HSSFRow initialValue = sheet.createRow(1);
        IntStream.range(0, COLUMNS.length)
                .forEach(i -> initialValue.createCell(i).setCellValue(COLUMNS[i].getInitialValue()));

        for (int i = 0; i < syndrome.length; i++) {
            int r = i + 1;
            long delta = IntStream.range(0, registerLength + 1)
                    .mapToLong(j -> locators.get(j) * syndrome[r - j - 1])
                    .sum() % 2;
            residual.add(0, 0);
            if (delta != 0) {
                List<Integer> temp;
                if (residual.size() > locators.size()) {
                    temp = residual;
                    IntStream.range(0, locators.size())
                            .forEach(j -> temp.set(j, (temp.get(j) + locators.get(j)) % 2));
                } else {
                    temp = locators;
                    IntStream.range(0, locators.size())
                            .forEach(j -> temp.set(j, (temp.get(j) + residual.get(j)) % 2));
                }
                if (2 * registerLength <= i) {
                    residual = locators;
                    registerLength = r - registerLength;
                }
                locators = temp;
            }

            HSSFRow row = sheet.createRow(i + 2);
            row.createCell(0).setCellValue(COLUMNS[0].getValue(r));
            row.createCell(1).setCellValue(COLUMNS[1].getValue(syndrome[i]));
            row.createCell(2).setCellValue(COLUMNS[2].getValue(delta));
            row.createCell(3).setCellValue(COLUMNS[3].getValue(residual));
            row.createCell(4).setCellValue(COLUMNS[4].getValue(locators));
            row.createCell(5).setCellValue(COLUMNS[5].getValue(registerLength));
        }

        if (xlsFilename != null) {
            try (FileOutputStream fileOut = new FileOutputStream(xlsFilename)) {
                wb.write(fileOut);
            }
        }

        return locators;
    }

    public int[] continueSequence(int size) {
        for (int i = 0; i < size; i++) {
            int x = IntStream.range(0, registerLength)
                    .map(j -> locators.get(j + 1) * syndrome[syndrome.length - j - 1])
                    .sum() % 2;
            int[] newSyndrome = new int[syndrome.length + 1];
            System.arraycopy(syndrome, 0, newSyndrome, 0, syndrome.length);
            newSyndrome[syndrome.length] = x;
            syndrome = newSyndrome;
        }
        return syndrome;
    }
}
