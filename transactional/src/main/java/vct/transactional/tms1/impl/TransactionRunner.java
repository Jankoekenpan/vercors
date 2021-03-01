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
            System.out.println("before-begin()");
            transaction.begin();
            System.out.println("before-beginOk()");
            transaction.beginOk();

            for (InvOperation invOp : invOps) {
                if (invOp instanceof InvWriteOperation iwo) {
                    System.out.println("before inv(" + invOp + ")");
                    transaction.inv(invOp);
                    sharedMemory.set(iwo.address(), iwo.value());
                    System.out.println("before resp(writeOk)");
                    transaction.resp(Operation.respWriteOp());
                } else if (invOp instanceof InvReadOperation iro) {
                    System.out.println("before inv(" + invOp + ")");
                    transaction.inv(invOp);
                    int value = sharedMemory.get(iro.address());
                    System.out.println("before resp(read(" + value + "))");
                    transaction.resp(Operation.respReadOp(value));
                }
            }

            System.out.println("before commit()");
            transaction.commit();
            System.out.println("before commitOk()");
            transaction.commitOk();
        } catch (InvalidStatus invalidStatus) {
            //should never occur!
            invalidStatus.printStackTrace();
        } catch (InvalidCommit | InvalidResp invalidResponseOrCommit) {
            try {
                System.out.println("invalid commit or response");
                invalidResponseOrCommit.printStackTrace();
                System.out.println("before abort()");
                transaction.abort();
            } catch (InvalidFail invalidFail) {
                //should also not occur, but is more delicate.
                invalidFail.printStackTrace();
            } catch (InvalidStatus invalidStatus) {
                //could not abort yet? should never occur!
                invalidStatus.printStackTrace();
            }
        }
    }

}
