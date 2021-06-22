package vct.transactional.tms1.impl;

import vct.transactional.tms1.*;

import static vct.transactional.tms1.impl.operation.Operation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Main {

    public static void main(String[] args) {

        SharedMemoryType memoryType = new SharedMemoryType();
        SharedMemory sharedMemory = new SharedMemory(10);
        TMS1 tms = new TMS1(memoryType);

        List<InvOperation> t1Ops = new ArrayList<>();
        t1Ops.addAll(IntStream.rangeClosed(1, 5).mapToObj(i -> invWriteOp(i, i)).collect(Collectors.toList()));
        t1Ops.addAll(IntStream.rangeClosed(1, 5).mapToObj(i -> invReadOp(i)).collect(Collectors.toList()));
        Transaction t1 = new Transaction(tms);

        List<InvOperation> t2Ops = new ArrayList<>();
        t2Ops.addAll(IntStream.rangeClosed(1, 5).mapToObj(i -> invWriteOp(i, i+1)).collect(Collectors.toList()));
        t2Ops.addAll(IntStream.rangeClosed(1, 5).mapToObj(i -> invReadOp(i)).collect(Collectors.toList()));
        Transaction t2 = new Transaction(tms);

        System.out.println("t1 ops = " + t1Ops);
        System.out.println("t2 ops = " + t2Ops);

        TransactionRunner tr1 = new TransactionRunner(t1, sharedMemory, t1Ops);
        TransactionRunner tr2 = new TransactionRunner(t2, sharedMemory, t2Ops);

        Thread thread1 = new Thread(tr1);
        Thread thread2 = new Thread(tr2);

        thread1.start();
        thread2.start();

        try {
            thread1.join();
            thread2.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        //when transactions access the tms1 shared variable, they always synchronize on it first,
        //making sure that they see an updated view of the global state.
        //deadlocks cannot occur, because no thread locks the tms1 monitor after locking on the transaction itself.
        //all synchronized methods on the TMS1 class can't be called by other classes, because they are package-private.
        //gotta love concurrency in java!
    }
}
