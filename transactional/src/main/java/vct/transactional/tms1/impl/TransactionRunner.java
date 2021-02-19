package vct.transactional.tms1.impl;

import vct.transactional.tms1.ex.*;
import vct.transactional.tms1.*;
import vct.transactional.tms1.impl.operation.*;

import java.util.List;

public class TransactionRunner implements Runnable {

    private final Transaction transaction;
    private final SharedMemory sharedMemory;
    private final List<InvOperation> invOps;

    public TransactionRunner(Transaction transaction, SharedMemory sharedMemory, List<InvOperation> invOperations) {
        this.transaction = transaction;
        this.sharedMemory = sharedMemory;
        this.invOps = List.copyOf(invOperations);
    }

    @Override
    public void run() {
        try {
            transaction.begin();
            transaction.beginOk();

            for (InvOperation invOp : invOps) {
                if (invOp instanceof InvWriteOperation iwo) {
                    transaction.inv(invOp);
                    sharedMemory.set(iwo.address(), iwo.value());
                    transaction.resp(Operation.respWriteOp());
                } else if (invOp instanceof InvReadOperation iro) {
                    transaction.inv(invOp);
                    int value = sharedMemory.get(iro.address());
                    transaction.resp(Operation.respReadOp(value));
                }
            }

            transaction.commit();
            transaction.commitOk();
        } catch (InvalidStatus invalidStatus) {
            //should never occur!
            invalidStatus.printStackTrace();
        } catch (InvalidCommit | InvalidResp invalidResponseOrCommit) {
            try {
                transaction.abort();
            } catch (InvalidFail invalidFail) {
                //should also not occur, but is more delicate.
                throw new RuntimeException("invalid abort", invalidFail);
            } catch (InvalidStatus invalidStatus) {
                //could not abort yet? should never occur!
                invalidStatus.printStackTrace();
            }
        }
    }

}
