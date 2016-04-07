package com.samborskiy.charpter7;

import com.samborskiy.charpter6.BCHCode;

import java.util.*;

public class GeneratedPolynomial {

    private final int n;
    private final BCHCode bchCode;
    private final GaloisField field;

    public GeneratedPolynomial(int n, GaloisField field) {
        this.n = n;
        this.field = field;
        this.bchCode = new BCHCode(n);
    }

    public void build(int... indexes) {
        Stack<List<List<Integer>>> stack = new Stack<>();
        for (int index : indexes) {
            for (Integer i : bchCode.getCyclotomicClass(index)) {
                List<List<Integer>> coef = new ArrayList<>();
                coef.add(new ArrayList<>(Collections.singletonList(i)));
                coef.add(new ArrayList<>(Collections.singletonList(0)));
                stack.add(coef);
            }
        }

        while (stack.size() != 1) {
            stack.push(mul(stack.pop(), stack.pop()));
        }

        List<List<Integer>> coef = stack.pop();
        for (int i = 0; i < coef.size(); i++) {
            int[] a = new int[field.getPolynomial(-1).length];
            for (Integer pow : coef.get(i)) {
                addi(a, field.getPolynomial(pow % n));
            }
            if (isNotZero(a)) {
                System.out.print("x^" + i + " + ");
            }
        }
        System.out.println();
    }

    private boolean isNotZero(int[] arr) {
        for (int elem : arr) {
            if (elem != 0) {
                return true;
            }
        }
        return false;
    }

    public List<List<Integer>> mul(List<List<Integer>> coef1, List<List<Integer>> coef2) {
        List<List<Integer>> coef = new ArrayList<>();
        for (int i = 0; i < coef1.size() + coef2.size() - 1; i++) {
            coef.add(new ArrayList<>());
        }

        for (int i = 0; i < coef1.size(); i++) {
            List<Integer> pows1 = coef1.get(i);
            for (int j = 0; j < coef2.size(); j++) {
                List<Integer> pows2 = coef2.get(j);
                List<Integer> pows = coef.get(i + j);
                for (Integer pow1 : pows1) {
                    for (Integer pow2 : pows2) {
                        pows.add(pow1 + pow2);
                    }
                }
            }
        }

        return coef;
    }

    private void addi(int[] a, int[] b) {
        for (int i = 0; i < a.length; i++) {
            a[i] = (a[i] + b[i]) % 2;
        }
    }
}
