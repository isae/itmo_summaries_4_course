package com.samborskiy.charpter7;

import java.util.function.Function;

public class TableCell<T> {

    private final String header;
    private final String initialValue;
    private final Function<T, String> value;

    public TableCell(String header, String initialValue, Function<T, String> value) {
        this.header = header;
        this.initialValue = initialValue;
        this.value = value;
    }

    public String getHeader() {
        return header;
    }

    public String getInitialValue() {
        return initialValue;
    }

    public String getValue(T obj) {
        return value.apply(obj);
    }
}
