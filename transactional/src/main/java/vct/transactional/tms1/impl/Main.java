package vct.transactional.tms1.impl;

import vct.transactional.tms1.TMS1;
import vct.transactional.tms1.Transaction;
import vct.transactional.util.Tuple;

import static vct.transactional.tms1.impl.Operation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Main {

    public static void main(String[] args) {

        SharedMemoryType memoryType = new SharedMemoryType();
        TMS1<InvOperation, RespOperation, SharedMemoryType> tms = new TMS1<>(memoryType);

        List<Tuple<InvOperation, RespOperation>> t1Ops = new ArrayList<>();
        t1Ops.addAll(IntStream.range(0, 5).mapToObj(i -> new Tuple<>(invWriteOp(i, i), respWriteOp())).collect(Collectors.toList()));
        t1Ops.addAll(IntStream.range(0, 5).mapToObj(i -> new Tuple<>(invReadOp(i), respReadOp(i))).collect(Collectors.toList()));
        Transaction<InvOperation, RespOperation> t1 = new Transaction<>(tms, t1Ops);

        List<Tuple<InvOperation, RespOperation>> t2Ops = new ArrayList<>();
        t2Ops.addAll(IntStream.range(0, 5).mapToObj(i -> new Tuple<>(invWriteOp(i, i+1), respWriteOp())).collect(Collectors.toList()));
        t2Ops.addAll(IntStream.range(0, 5).mapToObj(i -> new Tuple<>(invReadOp(i), respReadOp(i+1))).collect(Collectors.toList()));
        Transaction<InvOperation, RespOperation> t2 = new Transaction<>(tms, t2Ops);

        //TODO start transactions in separate threads (should actually need to implement proper synchronization for the Transaction and TMS1 classes first)

    }
}
