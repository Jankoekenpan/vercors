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
 */
public class TMS1<I, R, O extends ObjectType<I, R>> {

    private final O objectType; //type-class pattern.

    final BiRelation<Transaction<I, R>, Transaction<I, R>> extOrder = new BiRelation<>();

    private final Set<Transaction<I, R>> allTransactions = new HashSet<>();

    public TMS1(O objectType /*type-class pattern*/) {
        this.objectType = objectType;
    }

    void addTransaction(Transaction<I, R> transaction) {
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
        List<A> result = new ArrayList<>();
        result.addAll(lhs);
        result.addAll(rhs);
        return result;
    }

    //idem
    static <A> List<A> append(List<A> list, A lastItem) {
        List<A> result = new ArrayList<>(list);
        result.addAll(list);
        result.add(lastItem);
        return result;
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

    private static <A> List<A> swap(int one, int two, List<A> list) {
        List<A> result = new ArrayList<>(list);
        A itemOne = list.get(one);
        A itemTwo = list.get(two);
        result.set(one, itemTwo);
        result.set(two, itemOne);
        return result;
    }

    //https://en.wikipedia.org/wiki/Heap%27s_algorithm#Details_of_the_algorithm
    private static <A> List<List<A>> permutations(Collection<A> coll) {
        List<A> list = coll instanceof List ? (List<A>) coll : List.copyOf(coll);

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

    //
    // derived state variables:
    // side note: should Scala's immutable collections be used instead?
    //

    Set<Transaction<I, R>> doneTransactions() {
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

    Set<Transaction<I, R>> committedTransactions() {
        return allTransactions.stream()
                .filter(t -> t.getStatus() == Status.committed)
                .collect(Collectors.toSet());
    }

    Set<Transaction<I, R>> commitPendingTransactions() {
        return allTransactions.stream()
                .filter(t -> t.getStatus() == Status.commitPending)
                .collect(Collectors.toSet());
    }

    Set<Transaction<I, R>> invokedCommitTransactions() {
        return allTransactions.stream()
                .filter(Transaction::hasInvokedCommit)
                .collect(Collectors.toSet());
    }

    static <I, R> List<Tuple<I, R>> ops(List<Transaction<I, R>> transactions) {
        return transactions.stream()
                .flatMap(t -> t.getOps().stream())
                .collect(Collectors.toList());
    }

    boolean extConsPrefix(Set<Transaction<I, R>> serialization) {
        boolean res = true;
        for (Transaction<I, R> t : allTransactions) {
            for (Transaction<I, R> tPrime : allTransactions) {
                res &= serialization.contains(tPrime) && implies(extOrder.contains(t, tPrime), serialization.contains(t) == (t.getStatus() == Status.committed));
            }
        }
        return res;
    }

    private static <I, R> Set<List<Transaction<I, R>>> ser(Set<Transaction<I, R>> transactions, BiRelation<Transaction<I, R>, Transaction<I, R>> extOrder) {
        Comparator<Transaction<I, R>> comparator = new Comparator<Transaction<I, R>>() {
            @Override
            public int compare(Transaction first, Transaction second) {
                if (Objects.equals(first, second)) return 0;

                Set<Transaction<I, R>> leftHandSide = Set.of(first);
                Set<Transaction<I, R>> rightHandSide;
                do {
                    rightHandSide = leftHandSide.stream()
                            .flatMap(lhs -> extOrder.rights(lhs).stream())
                            .collect(Collectors.toSet());
                } while (!rightHandSide.contains(second) || !(leftHandSide = rightHandSide).isEmpty());

                //if the second transaction is in the rhs set, then 'first' comes before 'second'!
                //we check the inverse condition (if the transaction is not in the right hand side set, then 'second' comes before 'first'!
                return rightHandSide.isEmpty() ? 1 : -1;
            }
        };

        //get permutations of transactions, then sort using the comparator. do not care about illegal histories here.
        List<List<Transaction<I, R>>> permutations = permutations(transactions);
        permutations.replaceAll(list -> {
            list.sort(comparator);
            return list;
        });


        return new HashSet<>(permutations);
    }

    private boolean legal(List<Tuple<I, R>> operations) {
        return objectType.isLegal(operations);
    }

    boolean validCommit(Transaction<I, R> t) {
        boolean res = false;

        for (Set<Transaction<I, R>> subset : power(commitPendingTransactions())) {
            for (List<Transaction<I, R>> serialization : ser(union(committedTransactions(), subset), extOrder)) {
                res |= subset.contains(t) && legal(ops(serialization));
            }
        }

        return res;
    }

    boolean validFail(Transaction<I, R> t) {
        boolean res = false;

        for (Set<Transaction<I, R>> subset : power(commitPendingTransactions())) {
            for (List<Transaction<I, R>> serialization : ser(union(committedTransactions(), subset), extOrder)) {
                res |= !subset.contains(t) && legal(ops(serialization));
            }
        }

        return res;
    }

    boolean validResp(Transaction<I, R> t, I i, R r) {
        boolean res = false;

        for (Set<Transaction<I, R>> subset : power(invokedCommitTransactions())) {
            for (List<Transaction<I, R>> serialization : ser(subset, extOrder)) {
                res |= extConsPrefix(union(subset, Set.of(t))) && legal(append(ops(append(serialization, t)), new Tuple<>(i, r)));
            }
        }

        return res;
    }

}
