package vct.transactional.tms1;

import java.util.*;

import static vct.transactional.tms1.Transaction.Status.*;
import vct.transactional.util.Tuple;

public class Transaction<I, R> {

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

    final TMS1<I, R, ? extends ObjectType<I, R>> tms1;

    private Status status = notStarted;
    private final List<Tuple<I, R>> ops;
    private I pendingOp;   //initially arbitrairy
    private boolean invokedCommit = false;

    public Transaction(TMS1<I, R, ? extends ObjectType<I,R>> tms1, List<Tuple<I, R>> operations) {
        this.tms1 = Objects.requireNonNull(tms1, "tms1 cannot be null");
        this.tms1.addTransaction(this);
        this.ops = List.copyOf(operations);
    }

    final Status getStatus() {
        return status;
    }

    final List<Tuple<I, R>> getOps() {
        return Collections.unmodifiableList(ops); //TODO copy the tuples too or make an unmodifiable wrapper
    }

    final I getPendingOp() {
        return pendingOp;
    }

    final public boolean hasInvokedCommit() {
        return invokedCommit;
    }

    //
    // aggregate processes:
    // total = begin * afterBegin
    // afterBegin = abort + (beginOk * afterRead)
    // afterReady = (cancel * abort) + (commit * afterCommit) + (inv * afterInv)
    // afterInv = abort + (resp * afterReady)
    // afterCommit = abort + commitOk
    //
    // unfortunately non-deterministic choice is not implementable with java methods. do we have any alternatives?
    //

    //
    // actions (processes):
    //
    //

    public void begin() {
        assert getStatus() == notStarted;

        status = beginPending;
        for (Transaction<I, R> doneTransaction : tms1.doneTransactions()) {
            tms1.extOrder.add(doneTransaction, this);
        }
    }

    public void beginOk() {
        assert getStatus() == beginPending;

        status = ready;
    }

    public void inv(I i) {
        assert getStatus() == ready;

        status = opPending;
        pendingOp = i;
    }

    public void resp(R r) {
        assert getStatus() == opPending;
        assert tms1.validResp(this, getPendingOp(), r);

        status = ready;
        ops.add(new Tuple<>(getPendingOp(), r));
    }

    public void commit() {
        assert getStatus() == ready;

        status = commitPending;
        invokedCommit = true;
    }

    public void commitOk() {
        assert getStatus() == commitPending;
        assert tms1.validCommit(this);

        status = committed;
    }

    public void cancel() {
        assert getStatus() == ready;

        status = cancelPending;
    }

    public void abort() {
        assert Set.of(beginPending, opPending, commitPending, cancelPending).contains(getStatus());
        assert tms1.validFail(this);

        status = aborted;
    }

}

