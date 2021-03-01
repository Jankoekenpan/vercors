package vct.transactional.tms1;

import java.util.*;

import static vct.transactional.tms1.Transaction.Status.*;
import vct.transactional.tms1.ex.InvalidCommit;
import vct.transactional.tms1.ex.InvalidFail;
import vct.transactional.tms1.ex.InvalidResp;
import vct.transactional.tms1.ex.InvalidStatus;
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
    private final List<Tuple<InvOperation, RespOperation>> ops = new ArrayList<>();
    private InvOperation pendingOp;   //initially arbitrairy
    private boolean invokedCommit = false;

    public Transaction(TMS1 tms1) {
        this.tms1 = Objects.requireNonNull(tms1, "tms1 cannot be null");
        this.tms1.addTransaction(this);
    }

    synchronized final Status getStatus() {
        return status;
    }

    synchronized final List<Tuple<InvOperation, RespOperation>> getOps() {
        return Collections.unmodifiableList(ops); //TODO copy the tuples too or make an unmodifiable wrapper
    }

    synchronized final InvOperation getPendingOp() {
        return pendingOp;
    }

    synchronized final boolean hasInvokedCommit() {
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

    public synchronized void begin() throws InvalidStatus {
        if (getStatus() != notStarted)
            throw new InvalidStatus("beginOk() expected status notStarted.");

        status = beginPending;
        System.out.println("status updated to beginPending");
        System.out.println("done transactions = " + tms1.doneTransactions());
        for (Transaction doneTransaction : tms1.doneTransactions()) {
            System.out.println("doneTransaction: " + doneTransaction);
            //TODO another thread has claimed the monitor of tms1.extOrder o.0??
            tms1.extOrder.add(doneTransaction, this);
        }
        System.out.println("end of begin()");
    }

    public synchronized void beginOk() throws InvalidStatus {
        if (getStatus() != beginPending)
            throw new InvalidStatus("beginOk() expected status beginPending.");

        status = ready;
    }

    public synchronized void inv(InvOperation i) throws InvalidStatus {
        if (getStatus() != ready)
            throw new InvalidStatus("inv(i) expected status ready.");

        status = opPending;
        pendingOp = i;
    }

    public synchronized void resp(RespOperation r) throws InvalidStatus, InvalidResp {
        if (getStatus() != opPending)
            throw new InvalidStatus("resp(r) expected status opPending.");

        if (tms1.validResp(this, getPendingOp(), r))
            throw new InvalidResp("cannot make a legal serialized history using response: " + r + ".");

        status = ready;
        ops.add(new Tuple<>(getPendingOp(), r));
    }

    public synchronized void commit() throws InvalidStatus {
        if (getStatus() != ready)
            throw new InvalidStatus("commit() expected status ready.");

        status = commitPending;
        invokedCommit = true;
    }

    public synchronized void commitOk() throws InvalidStatus, InvalidCommit {
        if (getStatus() != commitPending)
            throw new InvalidStatus("commitOk() expected status commitPending.");

        if (!tms1.validCommit(this))
            throw new InvalidCommit("cannot call commitOk() because there is no legal serial history of operations.");

        status = committed;
    }

    public synchronized void cancel() throws InvalidStatus {
        if (getStatus() != ready)
            throw new InvalidStatus("cancel() expected status ready.");

        status = cancelPending;
    }

    public synchronized void abort() throws InvalidStatus, InvalidFail {
        if (!Set.of(beginPending, opPending, commitPending, cancelPending).contains(getStatus()))
            throw new InvalidStatus("abort() expected status beginPending, opPending, commitPending or cancelPending.");

        if (!tms1.validFail(this))
            throw new InvalidFail("cannot call abort() because there is a legal serial history of operations.");

        status = aborted;
    }

}

