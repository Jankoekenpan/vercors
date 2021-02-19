package vct.transactional.tms1.impl.operation;

import vct.transactional.tms1.RespOperation;

public class RespWriteOperation implements RespOperation {

    static final RespWriteOperation INSTANCE = new RespWriteOperation();

    private RespWriteOperation() {
    }

    @Override
    public boolean equals(Object o) {
        return o == this || o instanceof RespWriteOperation;
    }

    @Override
    public int hashCode() {
        return -1;
    }

    @Override
    public String toString() {
        return "RespWriteOperation()";
    }

}
