package vct.transactional.tms1.impl;

public interface Operation {

    public static InvOperation invReadOp(int address) {
        return new InvReadOperation(address);
    }

    public static InvOperation invWriteOp(int address, int value) {
        return new InvWriteOperation(address, value);
    }

    public static RespOperation respReadOp(int value) {
        return new RespReadOperation(value);
    }

    public static RespOperation respWriteOp() {
        return RespWriteOperation.INSTANCE;
    }

}

interface InvOperation extends Operation {
}

interface RespOperation extends Operation {
}

record InvReadOperation(int address) implements InvOperation {
}

record InvWriteOperation(int address, int value) implements InvOperation {
}

record RespReadOperation(int value) implements RespOperation {
}

class RespWriteOperation implements RespOperation {

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
