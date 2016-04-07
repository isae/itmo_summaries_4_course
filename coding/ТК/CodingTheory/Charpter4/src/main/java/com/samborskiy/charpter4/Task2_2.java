package com.samborskiy.charpter4;

import org.apache.commons.math3.distribution.NormalDistribution;

public class Task2_2 {

    private static final NormalDistribution DISTRIBUTION = new NormalDistribution(0, 1);

    public static void main(String[] args) {
        double answer = findNeededProbability(0.6, 10, 1E-7, 1E-5);
        System.out.println(10 * Math.log10(answer));
    }

    private static double findNeededProbability(double left, double right, double eps, double probability) {
        double middle = (left + right) / 2;
        if (right - left < eps) {
            return middle;
        }
        double value = countP(middle);
        if (probability > value) {
            return findNeededProbability(left, middle, eps, probability);
        } else {
            return findNeededProbability(middle, right, eps, probability);
        }
    }

    /**
     * Counts {@code p} by x = E_b / N_0.
     */
    private static double countP(double x) {
        return 1 - DISTRIBUTION.cumulativeProbability(Math.sqrt(2 * x));
    }
}
