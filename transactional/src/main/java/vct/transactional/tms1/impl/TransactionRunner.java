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

            //TMS1 allows us the abort the transaction at the point, but we never do that in this implementation.
            //throw new InvalidBegin("can't begin this transaction");

            System.out.println("before-beginOk()");
            transaction.beginOk();

            //TMS1 allows us to cancel the transaction at this point, but we never do that in this implementation.
            //transaction.cancel();

            for (InvOperation invOp : invOps) {
                if (invOp instanceof InvWriteOperation iwo) {
                    System.out.println("before inv(" + invOp + ")");
                    transaction.inv(invOp);
                    sharedMemory.set(iwo.address(), iwo.value());
                    System.out.println("before resp(writeOk)");
                    transaction.resp(Operation.respWriteOp());
                    //TMS1 allows us to cancel the transaction at this point, but we never do that in this implementation.
                } else if (invOp instanceof InvReadOperation iro) {
                    System.out.println("before inv(" + invOp + ")");
                    transaction.inv(invOp);
                    int value = sharedMemory.get(iro.address());
                    System.out.println("before resp(read(" + value + "))");
                    transaction.resp(Operation.respReadOp(value));
                    //TMS1 allows us to cancel the transaction at this point, but we never do that in this implementation.
                } else {
                    //this branch is never taken, but it stops the compiler from complaining later on where we catch Cancel
                    transaction.cancel();
                }
            }

            System.out.println("before commit()");
            transaction.commit();
            System.out.println("before commitOk()");
            transaction.commitOk();
        } catch (InvalidStatus invalidStatus) {
            //should never occur!
            invalidStatus.printStackTrace();
        } catch (InvalidCommit | InvalidResp | InvalidBegin | Cancel invalidResponseOrCommit) {
            try {
                transaction.abort();
            } catch (InvalidFail invalidFail) {
                //should also not occur, but is more delicate.
                invalidFail.printStackTrace();
            } catch (InvalidStatus invalidStatus) {
                //could not abort yet? should never occur!
                invalidStatus.printStackTrace();
            }
        }
        System.out.println("done!");
    }

}
