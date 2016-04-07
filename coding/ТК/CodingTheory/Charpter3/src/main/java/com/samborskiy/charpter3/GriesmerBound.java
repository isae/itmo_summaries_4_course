package com.samborskiy.charpter3;

import java.util.stream.IntStream;

public class GriesmerBound {

    private GriesmerBound() {
    }

    /**
     * Finds lower bound of n using Griesmer bound.
     */
    public static int findN(int k, int d) {
        return IntStream.range(0, k)
                .map(i -> (int) Math.ceil((double) d / Math.pow(2, i)))
                .sum();
    }
}
