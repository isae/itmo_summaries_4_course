package com.samborskiy.charpter6;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class BCHCode {

    private static final String C_CLASS = "C_%d = {";
    private static final String M_CLASS = "M_%d";

    private final int n;
    private final List<List<Integer>> cyclotomicClasses;

    public BCHCode(int n) {
        this.n = n;
        this.cyclotomicClasses = new ArrayList<>();
        initializeCyclotomicClasses();
    }

    private void initializeCyclotomicClasses() {
        boolean[] used = new boolean[n];
        for (int i = 0; i < n; i++) {
            if (!used[i]) {
                List<Integer> cyclotomicClass = initializeCyclotomicClasses(i);
                for (int element : cyclotomicClass) {
                    used[element] = true;
                }
                cyclotomicClasses.add(cyclotomicClass);
            }
        }
    }

    public List<Integer> getCyclotomicClass(int index) {
        return cyclotomicClasses.stream()
                .filter(list -> list.get(0) == index)
                .findFirst()
                .orElse(null);
    }

    private List<Integer> initializeCyclotomicClasses(int base) {
        List<Integer> cyclotomicClass = new ArrayList<>();
        cyclotomicClass.add(base);
        while (!cyclotomicClass.contains(2 * cyclotomicClass.get(cyclotomicClass.size() - 1) % n)) {
            cyclotomicClass.add(2 * cyclotomicClass.get(cyclotomicClass.size() - 1) % n);
        }
        return cyclotomicClass;
    }

    public String getCyclotomicClasses() {
        StringBuilder builder = new StringBuilder();
        for (List<Integer> cyclotomicClass : cyclotomicClasses) {
            builder.append(cyclotomicClass.stream()
                    .map(String::valueOf)
                    .collect(Collectors.joining(", ", String.format(C_CLASS, cyclotomicClass.get(0)), "}\n")));
        }
        return builder.toString();
    }

    public String generatorPolynomial(int d) {
        Vector vector = findVector(d);
        if (vector != null) {
            return IntStream.range(0, vector.getData().length)
                    .filter(i -> vector.getData()[i] != 0)
                    .mapToObj(i -> String.format(M_CLASS, cyclotomicClasses.get(i).get(0)))
                    .collect(Collectors.joining());
        } else {
            return null;
        }
    }

    public String getMinK(int d) {
        Vector vector = findVector(d);
        if (vector != null) {
            Set<Integer> elements = cyclotomicClassesUnion(vector);
            return String.valueOf(n - elements.size());
        } else {
            return null;
        }
    }

    private Vector findVector(int d) {
        int minK = n;
        Vector minVector = null;

        Vector vector = new Vector(cyclotomicClasses.size());
        while (vector.hasNextVector()) {
            vector.nextVector();
            Set<Integer> elements = cyclotomicClassesUnion(vector);
            if (isCorrectPolynomial(elements, d) && minK > elements.size()) {
                minK = elements.size();
                minVector = new Vector(vector);
            }
        }

        return minVector;
    }

    private boolean isCorrectPolynomial(Set<Integer> elements, int d) {
        int max = 1;
        for (Integer element : elements) {
            int count = 1;
            for (int i = element + 1; i < n; i++) {
                if (!elements.contains(i)) {
                    break;
                }
                count++;
            }
            max = Math.max(max, count);
        }
        return d - 1 == max;
    }

    private Set<Integer> cyclotomicClassesUnion(Vector vector) {
        Set<Integer> elements = new TreeSet<>(Integer::compareTo);
        for (int i = 0; i < vector.getData().length; i++) {
            if (vector.getData()[i] != 0) {
                elements.addAll(cyclotomicClasses.get(i));
            }
        }
        return elements;
    }
}
