package com.samborskiy.charpter7;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class Task1 {

    private static int[] SYNDROME = {0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1};

    public static void main(String[] args) throws IOException {
        BerlekampMassey algorithm = new BerlekampMassey(SYNDROME);
        List<Integer> minLFRS = algorithm.eval();
        System.out.println(PolynomialUtil.sequenceToPolynomial(minLFRS));

        int[] newSyndrome = algorithm.continueSequence(10);
        System.out.println(Arrays.stream(newSyndrome)
                .mapToObj(String::valueOf)
                .collect(Collectors.joining(", ", "(", ")")));
    }
}
