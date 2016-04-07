package com.samborskiy.charpter4;

import org.jblas.DoubleMatrix;

public class MLDecoder extends Decoder {

    public MLDecoder(DoubleMatrix g, double p) {
        super(g, p);
    }

    @Override
    public DoubleMatrix decode(DoubleMatrix y) {
        double maxProbability = 0;
        DoubleMatrix decodedWord = null;
        for (DoubleMatrix codeWord : codeWords.keySet()) {
            double probability = countProbability(p, y, codeWord);
            if (probability > maxProbability) {
                maxProbability = probability;
                decodedWord = codeWord;
            }
        }
        return codeWords.get(decodedWord);
    }

    private double countProbability(double p, DoubleMatrix y, DoubleMatrix codeWord) {
        double probability = 1.;
        for (int i = 0; i < codeWord.getColumns(); i++) {
            probability *= codeWord.get(i) == y.get(i) ? (1 - p) : p;
        }
        return probability;
    }
}
