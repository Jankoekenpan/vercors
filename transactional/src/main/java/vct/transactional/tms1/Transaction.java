package vct.transactional.tms1;

import java.util.*;

import static vct.transactional.tms1.Transaction.Status.*;
import vct.transactional.tms1.ex.*;
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
    private InvOperation pendingOp;   //initially arbitrary
    private boolean invokedCommit = false;

    public Transaction(TMS1 tms1) {
        this.tms1 = Objects.requireNonNull(tms1, "tms1 cannot be null");
        this.tms1.addTransaction(this);
    }

    public synchronized String toString() {
        return "Transaction(status=" + getStatus() + ", ops=" + getOps() + ", pendingOp=" + getPendingOp() + ", invokedCommit=" + hasInvokedCommit() + ")";
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

    public void begin() throws InvalidStatus {
        if (getStatus() != notStarted)
            throw new InvalidStatus("begin() expected status notStarted.");

        synchronized (tms1) {
            synchronized (this) {
                status = beginPending;
                for (Transaction doneTransaction: tms1.doneTransactions()) {
                    tms1.addExtOrder(doneTransaction, this);
                }
            }
        }
    }

    public void beginOk() throws InvalidStatus, InvalidBegin {
        if (getStatus() != beginPending)
            throw new InvalidStatus("beginOk() expected status beginPending.");

        synchronized (this) {
            status = ready;
        }
    }

    public void inv(InvOperation i) throws InvalidStatus {
        if (getStatus() != ready)
            throw new InvalidStatus("inv(i) expected status ready.");

        synchronized (this) {
            status = opPending;
            pendingOp = i;
        }
    }

    public void resp(RespOperation r) throws InvalidStatus, InvalidResp {
        if (getStatus() != opPending)
            throw new InvalidStatus("resp(r) expected status opPending.");

        synchronized (tms1) {
            if (tms1.validResp(this, getPendingOp(), r))
                throw new InvalidResp("cannot make a legal serialized history using response: " + r + ".");

            synchronized (this) {
                status = ready;
                ops.add(new Tuple<>(getPendingOp(), r));
            }
        }
    }

    public void commit() throws InvalidStatus {
        if (getStatus() != ready)
            throw new InvalidStatus("commit() expected status ready.");

        synchronized (this) {
            status = commitPending;
            invokedCommit = true;
        }
    }

    public void commitOk() throws InvalidStatus, InvalidCommit {
        if (getStatus() != commitPending)
            throw new InvalidStatus("commitOk() expected status commitPending.");

        synchronized (tms1) {
            if (!tms1.validCommit(this))
                throw new InvalidCommit("cannot call commitOk() because there is no legal serial history of operations.");

            synchronized (this) {
                status = committed;
            }
        }
    }

    public void cancel() throws InvalidStatus, Cancel {
        if (getStatus() != ready)
            throw new InvalidStatus("cancel() expected status ready.");

        synchronized (this) {
            status = cancelPending;
        }

        throw new Cancel("cancel()");
    }

    public void abort() throws InvalidStatus, InvalidFail {
        if (!Set.of(beginPending, opPending, commitPending, cancelPending).contains(getStatus()))
            throw new InvalidStatus("abort() expected status beginPending, opPending, commitPending or cancelPending.");

        synchronized (tms1) {
            if (!tms1.validFail(this))
                throw new InvalidFail("cannot call abort() because there is a legal serial history of operations.");

            synchronized (this) {
                status = aborted;
            }
        }
    }

}

