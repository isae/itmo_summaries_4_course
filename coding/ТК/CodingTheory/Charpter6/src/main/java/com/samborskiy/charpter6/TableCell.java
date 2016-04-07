package com.samborskiy.charpter6;

import java.util.function.Function;

public class TableCell<T> {

    private final String header;
    private final Function<T, String> value;

    public TableCell(String header, Function<T, String> value) {
        this.header = header;
        this.value = value;
    }

    public String getHeader() {
        return header;
    }

    public String getValue(T obj) {
        return value.apply(obj);
    }
}
