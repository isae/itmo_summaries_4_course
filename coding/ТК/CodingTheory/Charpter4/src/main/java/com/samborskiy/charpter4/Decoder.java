package com.samborskiy.charpter4;

import org.jblas.DoubleMatrix;

import java.util.HashMap;
import java.util.Map;

public abstract class Decoder {

    protected final DoubleMatrix g;
    protected final double p;
    protected final Map<DoubleMatrix, DoubleMatrix> codeWords;

    public Decoder(DoubleMatrix g, double p) {
        this.g = g;
        this.p = p;
        this.codeWords = new HashMap<>((int) Math.pow(2, g.getRows()));
        Vector vector = new Vector(g.getRows());
        codeWords.put(new Vector(g.getColumns()).row(), vector.row());
        while (vector.hasNextVector()) {
            vector.nextVector();
            DoubleMatrix coord = vector.row();
            DoubleMatrix codeWord = coord.mmul(g);
            modi(codeWord, 2);
            codeWords.put(codeWord, coord);
        }
    }

    public abstract DoubleMatrix decode(DoubleMatrix y);

    protected void modi(DoubleMatrix vector, int radix) {
        for (int i = 0; i < vector.getRows(); i++) {
            for (int j = 0; j < vector.getColumns(); j++) {
                vector.put(i, j, ((int) vector.get(i, j)) % radix);
            }
        }
    }
}
