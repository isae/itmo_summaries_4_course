package com.samborskiy.charpter7;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class PolynomialUtil {

    private static final String POWER_SIGN = "^";
    private static final String DEFAULT_LETTER = "x";

    private PolynomialUtil() {
    }

    public static String sequenceToPolynomial(int[] sequence) {
        return sequenceToPolynomial(Arrays.stream(sequence)
                .mapToObj(i -> i)
                .collect(Collectors.toList()));
    }

    public static String sequenceToPolynomial(List<Integer> sequence) {
        return sequenceToPolynomial(sequence, DEFAULT_LETTER);
    }

    public static String sequenceToPolynomial(List<Integer> sequence, String letter) {
        return IntStream.range(0, sequence.size())
                .filter(i -> sequence.get(i) != 0)
                .mapToObj(i -> letter + POWER_SIGN + i)
                .collect(Collectors.joining(" + "));
    }
}
