package vct.transactional.tms1;

import java.util.*;

import static vct.transactional.tms1.Transaction.Status.*;
import vct.transactional.util.Tuple;

public class Transaction {

    enum Status {
        notStarted,
        beginPending,
        ready,
        opPending,
        commitPending,
        cancelPending,
        committed,
        aborted;
    }

    final TMS1 tms1;

    private Status status = notStarted;
    private List<Tuple<?, ?>> ops = new ArrayList<>();
    private Object pendingOp;   //initially arbitrairy
    private boolean invokedCommit = false;

    public Transaction(TMS1 tms1) {
        this.tms1 = Objects.requireNonNull(tms1, "tms1 cannot be null");
    }

    Status getStatus() {
        return status;
    }

    @SuppressWarnings({"unchecked", "rawtypes"})
    <I, R> List<Tuple<I, R>> getOps() {
        return (List<Tuple<I, R>>) (List) ops;
    }

    @SuppressWarnings("unchecked")
    <I> I getPendingOp() {
        return (I) pendingOp;
    }

    public boolean hasInvokedCommit() {
        return invokedCommit;
    }


}

