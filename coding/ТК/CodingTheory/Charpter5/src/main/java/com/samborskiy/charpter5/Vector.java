package com.samborskiy.charpter5;

import org.jblas.DoubleMatrix;

public class Vector {

    private final double[] vector;

    public Vector(int length) {
        this.vector = new double[length];
    }

    public double[] getData() {
        return vector;
    }

    public DoubleMatrix row() {
        return new DoubleMatrix(vector).transpose();
    }

    public DoubleMatrix column() {
        return new DoubleMatrix(vector);
    }

    public boolean hasNextVector() {
        for (double value : vector) {
            if (value == 0) {
                return true;
            }
        }
        return false;
    }

    public Vector nextVector() {
        for (int i = vector.length - 1; i >= 0; i--) {
            if (vector[i] == 0) {
                vector[i] = 1;
                break;
            } else {
                vector[i] = 0;
            }
        }
        return this;
    }

    @Override
    public String toString() {
        return MatrixUtils.toString(row());
    }
}
