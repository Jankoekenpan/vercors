package vct.transactional.tms1.impl.operation;

import vct.transactional.tms1.InvOperation;
import vct.transactional.tms1.RespOperation;

public class Operation {

    private Operation() {}

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
