package vct.transactional.tms1;

import java.util.*;
import java.util.stream.*;

import vct.transactional.tms1.Transaction.Status;
import vct.transactional.util.*;

/**
 * Models Transactional Memory Standard 1 as defined by Simon Doherty, Lindsay Groves, Victor Luchangco and Mark Moir
 * in "Towards formally specifying and verifying transactional memory", section 3.
 *
 * @see <a href=https://doi.org/10.1007/s00165-012-0225-8>Towards formally specifying and verifying transactional memory</a>
 *
 * @author Jan Boerman
 */
public class TMS1 {

    private final ObjectType objectType; //type-class pattern.

    private final BiRelation<Transaction, Transaction> extOrder = new BiRelation<>();
    private final Comparator<Transaction> relationComparator = new AcyclicRelationComparator<>(extOrder);

    private final Set<Transaction> allTransactions = new HashSet<>();

    public TMS1(ObjectType objectType /*type-class pattern*/) {
        this.objectType = objectType;
    }

    synchronized void addTransaction(Transaction transaction) {
        assert transaction.tms1 == this;
        this.allTransactions.add(transaction);
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

    //idem
    static <A> List<A> concat(List<A> lhs, List<A> rhs) {
        List<A> result = new ArrayList<>(lhs.size() + rhs.size());
        result.addAll(lhs);
        result.addAll(rhs);
        return result;
    }

    //idem
    static <A> List<A> append(List<A> list, A lastItem) {
        List<A> result = new ArrayList<>(list.size() + 1);
        result.addAll(list);
        result.add(lastItem);
        return result;
    }

    //TODO I want this to be lazy... so I should return a Stream<Set<A>> instead (and adjust the implementation of course)
    static <A> Set<Set<A>> power(Set<A> set) {
        if (set.isEmpty()) return Set.of(Set.of());

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

    private static <A> List<A> swap(int one, int two, List<A> list) {
        List<A> result = new ArrayList<>(list);
        A itemOne = list.get(one);
        A itemTwo = list.get(two);
        result.set(one, itemTwo);
        result.set(two, itemOne);
        return result;
    }

    //https://en.wikipedia.org/wiki/Heap%27s_algorithm#Details_of_the_algorithm
    static <A> List<List<A>> permutations(Collection<A> coll) {
        List<A> list = coll instanceof List ? (List<A>) coll : new ArrayList<>(coll);

        final int n = list.size();
        int[] c = new int[n];

        List<List<A>> result = new ArrayList<>();
        result.add(list);

        int i = 0;
        while (i < n) {
            if (c[i] < i) {
                if (i % 2 == 0) {
                    list = swap(0, i, list);
                } else {
                    list = swap(c[i], i, list);
                }
                result.add(list);
                c[i] += 1;
                i = 0;
            } else {
                c[i] = 0;
                i += 1;
            }
        }

        return result;
    }

    synchronized boolean addExtOrder(Transaction before, Transaction after) {
        return extOrder.add(before, after);
    }

    //
    // derived state variables:
    // side note: should Scala's immutable collections be used instead?
    //

    Set<Transaction> doneTransactions() {
        final Set<Transaction> set;
        synchronized (this) {
            set = this.allTransactions;
        }

        return set.stream().filter(t -> {
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
        final Set<Transaction> set;
        synchronized (this) {
            set = this.allTransactions;
        }

        return set.stream()
                .filter(t -> t.getStatus() == Status.committed)
                .collect(Collectors.toSet());
    }

    Set<Transaction> commitPendingTransactions() {
        final Set<Transaction> set;
        synchronized (this) {
            set = this.allTransactions;
        }

        return set.stream()
                .filter(t -> t.getStatus() == Status.commitPending)
                .collect(Collectors.toSet());
    }

    Set<Transaction> invokedCommitTransactions() {
        final Set<Transaction> set;
        synchronized (this) {
            set = this.allTransactions;
        }

        return set.stream()
                .filter(Transaction::hasInvokedCommit)
                .collect(Collectors.toSet());
    }

    static List<Tuple<InvOperation, RespOperation>> ops(List<Transaction> transactions) {
        List<Tuple<InvOperation, RespOperation>> result = new ArrayList<>();
        for (Transaction transaction : transactions) {
            result.addAll(transaction.getOps());
        }
        return result;
    }

    synchronized boolean extConsPrefix(Set<Transaction> serialization) {
        boolean res = true;
        for (Transaction t : allTransactions) {
            for (Transaction tPrime : allTransactions) {
                res &= serialization.contains(tPrime) && implies(extOrder.contains(t, tPrime), serialization.contains(t) == (t.getStatus() == Status.committed));
            }
        }
        return res;
    }

    //ideally this would be lazy.
    static <A> Set<List<A>> ser(Set<A> transactions, Comparator<A> comparator) {
        //get permutations of transactions, then sort using the comparator. do not care about illegal histories here.
        List<List<A>> permutations = permutations(transactions);

        Set<List<A>> result = new HashSet<>();
        outer:
        for (List<A> list : permutations) {
            for (int i = 0; i < list.size() - 1; i++) {
                for (int j = i+1; j < list.size(); j++) {
                    if (comparator.compare(list.get(i), list.get(j)) > 0) {
                        //first element is strictly larger than the second one!
                        continue outer;
                    }
                }
                //completely sorted!
            }

            result.add(list);
        }
        return result;
    }

    synchronized private boolean legal(List<Tuple<InvOperation, RespOperation>> operations) {
        return objectType.isLegal(operations);
    }

    synchronized boolean validCommit(Transaction t) {
        for (Set<Transaction> subset : power(commitPendingTransactions())) {
            for (List<Transaction> serialization : ser(union(committedTransactions(), subset), relationComparator)) {
                if (subset.contains(t) && legal(ops(serialization))) {
                    return true;
                }
            }
        }

        return false;
    }

    synchronized boolean validFail(Transaction t) {
        for (Set<Transaction> subset : power(commitPendingTransactions())) {
            for (List<Transaction> serialization : ser(union(committedTransactions(), subset), relationComparator)) {
                if (!subset.contains(t) && legal(ops(serialization))) {
                    return true;
                }
            }
        }

        return false;
    }

    synchronized boolean validResp(Transaction t, InvOperation i, RespOperation r) {
        for (Set<Transaction> subset : power(invokedCommitTransactions())) {
            for (List<Transaction> serialization : ser(subset, relationComparator)) {
                if (extConsPrefix(union(subset, Set.of(t))) && legal(append(ops(append(serialization, t)), new Tuple<>(i, r)))) {
                    return true;
                }
            }
        }

        return false;
    }

}
