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
        this.tms1.addTransaction(this);
    }

    final Status getStatus() {
        return status;
    }

    @SuppressWarnings({"unchecked", "rawtypes"})
    final <I, R> List<Tuple<I, R>> getOps() {
        return (List<Tuple<I, R>>) (List) ops;
    }

    @SuppressWarnings("unchecked")
    final <I> I getPendingOp() {
        return (I) pendingOp;
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
        for (Transaction doneTransaction : tms1.doneTransactions()) {
            tms1.extOrder.add(doneTransaction, this);
        }
    }

    public void beginOk() {
        assert getStatus() == beginPending;

        status = ready;
    }

    public <I> void inv(I i) {
        assert getStatus() == ready;

        status = opPending;
        pendingOp = i;
    }

    public <R> void resp(R r) {
        assert getStatus() == opPending;
        assert tms1.validResp(this, pendingOp, r);

        status = ready;
        ops.add(new Tuple<>(pendingOp, r));
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

