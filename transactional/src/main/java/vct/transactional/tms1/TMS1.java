package vct.transactional.tms1;

import java.util.*;
import java.util.stream.*;

import vct.transactional.tms1.Transaction.Status;
import vct.transactional.util.*;

public class TMS1 {

    class I {
        final I I = new I();
        private I() {}
    }

    class R {
        final R R = new R();
        private R() {}
    }

    final BiRelation<Transaction, Transaction> extOrder = new BiRelation<>();
    private final Set<Transaction> allTransactions = new HashSet<>();

    public TMS1() {
    }

    public void addTransaction(Transaction transaction) {
        assert transaction.tms1 == this;
        this.allTransactions.add(transaction);
    }

    public void addTransactions(Iterable<Transaction> transactions) {
        for (Transaction transaction : transactions) {
            addTransaction(transaction);
        }
    }

    public void addTransactions(Transaction... transactions) {
        for (Transaction transaction : transactions) {
            addTransaction(transaction);
        }
    }

    //
    // operators not present in Java:
    //
    //

    static boolean implies(boolean lhs, boolean rhs) {
        return (!lhs) || rhs;
    }

    //technically available, but in java.util it mutates the first argument!
    static <A> Set<A> union(Set<A> lhs, Set<A> rhs) {
        Set<A> result = new HashSet<>();
        result.addAll(lhs);
        result.addAll(rhs);
        return result;
    }


    //
    // derived state variables:
    // side note: should Scala's immutable collections be used instead?
    //

    Set<Transaction> doneTransactions() {
        return allTransactions.stream().filter(t -> {
            switch (t.getStatus()) {
                case committed:
                case aborted:
                    return true;
                default:
                    return false;
            }
        }).collect(Collectors.toSet());
    }

    Set<Transaction> committedTransactions() {
        return allTransactions.stream()
                .filter(t -> t.getStatus() == Status.committed)
                .collect(Collectors.toSet());
    }

    Set<Transaction> commitPendingTransactions() {
        return allTransactions.stream()
                .filter(t -> t.getStatus() == Status.commitPending)
                .collect(Collectors.toSet());
    }

    Set<Transaction> invokedCommitTransactions() {
        return allTransactions.stream()
                .filter(Transaction::hasInvokedCommit)
                .collect(Collectors.toSet());
    }

    static <I, R> List<Tuple<I, R>> ops(List<Transaction> transactions) {
        return transactions.stream()
                .flatMap(t -> t.<I, R>getOps().stream())
                .collect(Collectors.toList());
    }

    boolean extConsPrefix(List<Transaction> serialization) {
        boolean res = true;
        for (Transaction t : allTransactions) {
            for (Transaction tPrime : allTransactions) {
                res &= serialization.contains(tPrime) && implies(extOrder.contains(t, tPrime), serialization.contains(t) == (t.getStatus() == Status.committed));
            }
        }
        return res;
    }

    //TODO I want this to be lazy... so I should return a Stream<Set<A>> instead (and adjust the implementation of course)
    private static <A> Set<Set<A>> power(Set<A> set) {
        if (set.isEmpty()) return Collections.emptySet();

        Set<A> subsetWithoutElement = new HashSet<>(set);
        Iterator<A> it = subsetWithoutElement.iterator();
        A element = it.next();
        it.remove();

        Set<Set<A>> powerSetSubsetWithoutElement = power(subsetWithoutElement);
        Set<Set<A>> powerSetSubsetWithElement = powerSetSubsetWithoutElement.stream()
                .map(s -> {var res = new HashSet<A>(s); res.add(element); return res;})
                .collect(Collectors.toSet());

        Set<Set<A>> result = new HashSet<>();
        result.addAll(powerSetSubsetWithoutElement);
        result.addAll(powerSetSubsetWithElement);
        return result;
    }

    private static Set<List<Transaction>> ser(Set<Transaction> transactions, BiRelation<Transaction, Transaction> extOrder) {
        return null; //TODO all serializatoins of the transactions, TODO continue here!!!
    }

    private static <I, R> boolean legal(List<Tuple<I, R>> operations) {
        return true; //TODO not really implementable as long as we don't model the shared memory yet.
    }

    boolean validCommit(Transaction t) {
        boolean res = false;

        for (Set<Transaction> subset : power(commitPendingTransactions())) {
            for (List<Transaction> serialization : ser(union(committedTransactions(), subset), extOrder)) {
                res |= subset.contains(t) && legal(ops(serialization));
            }
        }

        return res;
    }

    //TODO more derived state variables
}
