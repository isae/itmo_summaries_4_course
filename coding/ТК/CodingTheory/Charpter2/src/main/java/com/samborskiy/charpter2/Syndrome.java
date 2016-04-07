package com.samborskiy.charpter2;

import org.jblas.DoubleMatrix;

import java.util.HashMap;
import java.util.Map;

public class Syndrome {

    private final DoubleMatrix checkMatrixTranspose;
    private final Map<String, String> syndromeToErrorVector;
    private final int k;
    private final int n;

    public Syndrome(DoubleMatrix checkMatrix) {
        this.checkMatrixTranspose = checkMatrix.transpose();
        this.k = checkMatrix.getRows();
        this.n = checkMatrix.getColumns();
        this.syndromeToErrorVector = new HashMap<>((int) Math.pow(2, k));
    }

    public String getErrorVector(String syndrome) {
        return syndromeToErrorVector.get(syndrome);
    }

    /**
     * Builds table of syndromes.
     */
    public void build() {
        build(new Vector(n));
    }

    /**
     * Finds syndrome for error vector.
     */
    private void build(Vector errorVector) {
        DoubleMatrix errVector = errorVector.row();
        DoubleMatrix sindrom = errVector.mmul(checkMatrixTranspose); // e * H^T
        modi(sindrom, 2);
        String errorString = MatrixUtils.toString(errVector);
        String syndromeString = MatrixUtils.toString(sindrom);
        if (!syndromeToErrorVector.containsKey(syndromeString) || // find error vector with min weight for same syndrome
                MatrixUtils.weight(syndromeToErrorVector.get(syndromeString)) > MatrixUtils.weight(errorString)) {
            syndromeToErrorVector.put(syndromeString, errorString);
        }
        if (errorVector.hasNextVector()) {
            build(errorVector.nextVector()); // find syndrome for next error vector
        }
    }

    /**
     * {@code s[i] = s[i] mod radix} (default value of {@code radix} is {@code 2}).
     */
    private void modi(DoubleMatrix syndrome, int radix) {
        for (int i = 0; i < syndrome.getRows(); i++) {
            for (int j = 0; j < syndrome.getColumns(); j++) {
                syndrome.put(i, j, ((int) syndrome.get(i, j)) % radix);
            }
        }
    }
}
