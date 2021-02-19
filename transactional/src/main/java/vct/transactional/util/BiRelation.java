package vct.transactional.util;

import java.util.*;
import java.util.Map.Entry;

public class BiRelation<T, U> implements Iterable<Tuple<T, U>> {

    private final Map<T, Set<U>> left2Rights = new HashMap<>();
    private final Map<U, Set<T>> right2Lefts = new HashMap<>();

    public BiRelation() {
    }

    public synchronized final BiRelation<T, U> clone() {
        BiRelation<T, U> result = new BiRelation<>();
        for (Tuple<T, U> tup : this) {
            result.add(tup);
        }
        return result;
    }

    public synchronized long size() {
        long sum = 0;
        for (var entry : left2Rights.entrySet()) {
            sum = StrictMath.addExact(sum, (long) entry.getValue().size());
        }
        assert sum == right2Lefts.values().stream().mapToLong(set -> (long) set.size()).reduce(0L, StrictMath::addExact);
        return sum;
    }

    public synchronized boolean add(T left, U right) {
        boolean result1 = left2Rights.computeIfAbsent(left, x -> new HashSet<>()).add(right);
        boolean result2 = right2Lefts.computeIfAbsent(right, y -> new HashSet<>()).add(left);
        assert result1 == result2;
        return result1;
    }

    public synchronized boolean add(Tuple<T, U> pair) {
        assert pair != null;

        return add(pair.getFirst(), pair.getSecond());
    }

    public synchronized boolean contains(T left, U right) {
        Set<U> us = left2Rights.get(left);
        boolean result = us != null && us.contains(right);
        assert result == right2Lefts.getOrDefault(right, Collections.emptySet()).contains(left);
        return result;
    }

    public synchronized boolean contains(Tuple<T, U> pair) {
        return contains(pair.getFirst(), pair.getSecond());
    }

    public synchronized boolean remove(T left, U right) {
        Set<U> rights = left2Rights.get(left);
        Set<T> lefts = right2Lefts.get(right);
        boolean rightRemoved;
        boolean leftRemoved;

        if (rights != null) {
            rightRemoved = rights.remove(right);
            if (rights.isEmpty()) left2Rights.remove(left);
        } else {
            rightRemoved = false;
        }

        if (lefts != null) {
            leftRemoved = lefts.remove(left);
            if (lefts.isEmpty()) right2Lefts.remove(right);
        } else {
            leftRemoved = false;
        }

        assert rightRemoved == leftRemoved;
        return rightRemoved;
    }

    public synchronized boolean remove(Tuple<T, U> pair) {
        return remove(pair.getFirst(), pair.getSecond());
    }

    public synchronized void clear() {
        left2Rights.clear();
        right2Lefts.clear();
    }

    @Override
    public synchronized boolean equals(Object o) {
        if (o == this) return true;
        if (!(o instanceof BiRelation)) return false;

        BiRelation that = (BiRelation) o;
        return Objects.equals(this.left2Rights, that.left2Rights);
        //no need to check for equal right2Lefts because it contains the same information, but stored differently.
    }

    @Override
    public synchronized int hashCode() {
        return Objects.hash(this.left2Rights);
        //idem.
    }

    @Override
    public synchronized String toString() {
        StringJoiner stringJoiner = new StringJoiner(", ", "{", "}");
        for (Tuple<T, U> pair : this){
            stringJoiner.add(pair.getFirst() + "<~>" + pair.getSecond());
        }
        return stringJoiner.toString();
    }

    @Override
    public Iterator<Tuple<T, U>> iterator() {
        return new Iterator<>() {
            Iterator<Entry<T, Set<U>>> it = new HashSet<>(left2Rights.entrySet()).iterator();
            Map.Entry<T, Iterator<U>> currentEntry = null;
            Tuple<T, U> lastReturned = null;

            @Override
            public boolean hasNext() {
                synchronized (BiRelation.this) {

                    if (currentEntry == null) {
                        while (it.hasNext()) {
                            Map.Entry<T, Set<U>> entry = it.next();
                            T t = entry.getKey();
                            Set<U> uSet = entry.getValue();
                            if (uSet != null) {
                                Iterator<U> uIterator = uSet.iterator();
                                if (uIterator.hasNext()) {
                                    currentEntry = Map.entry(t, uIterator);
                                    return true;
                                }
                            }
                        }
                    }

                    return false;
                }
            }

            @Override
            public Tuple<T, U> next() {
                synchronized (BiRelation.this) {
                    if (currentEntry != null && currentEntry.getValue().hasNext()) {
                        U u = currentEntry.getValue().next();
                        T t = currentEntry.getKey();
                        return lastReturned = new Tuple<>(t, u) {
                            @Override
                            public void setFirst(T first) {
                                BiRelation.this.remove(getFirst(), getSecond());
                                super.setFirst(first);
                                BiRelation.this.add(getFirst(), getSecond());
                            }

                            @Override
                            public void setSecond(U second) {
                                BiRelation.this.remove(getFirst(), getSecond());
                                super.setSecond(second);
                                BiRelation.this.add(getFirst(), getSecond());
                            }
                        };
                    }

                    if (!hasNext())
                        throw new NoSuchElementException("Empty iterator");

                    return next();
                }
            }

            @Override
            public void remove() {
                synchronized (BiRelation.this) {
                    if (lastReturned == null)
                        throw new IllegalStateException("Need to call next() first before calling remove()");

                    BiRelation.this.remove(lastReturned.getFirst(), lastReturned.getSecond());
                    lastReturned = null;
                }
            }
        };
    }


    public Set<Tuple<T, U>> values() {
        synchronized (BiRelation.this) {
            return new AbstractSet<Tuple<T, U>>() {
                @Override
                public Iterator<Tuple<T, U>> iterator() {
                    return BiRelation.this.iterator();
                }

                @Override
                public int size() {
                    return (int) BiRelation.this.size();
                }

                @Override
                public boolean add(Tuple<T, U> pair) {
                    return BiRelation.this.add(pair);
                }

                @SuppressWarnings({"rawtypes", "unchecked"})
                @Override
                public boolean remove(Object pair) {
                    if (!(pair instanceof Tuple)) return false;
                    return BiRelation.this.remove((Tuple) pair);
                }
            };
        }
    }


    public synchronized Set<U> rights(T left) {
        Set<U> us = left2Rights.computeIfAbsent(left, x -> new HashSet<>());

        return new AbstractSet<U>() {
            @Override
            public int size() {
                int res = us.size();
                assert res == right2Lefts.keySet().size();
                return res;
            }

            @Override
            public boolean isEmpty() {
                boolean res = us.isEmpty();
                assert res == right2Lefts.keySet().isEmpty();
                return res;
            }

            @Override
            public boolean contains(Object o) {
                boolean res = us.contains(o);
                assert res == right2Lefts.getOrDefault(o, Collections.emptySet()).contains(left);
                return res;
            }

            @Override
            public Iterator<U> iterator() {
                return new Iterator<>() {
                    Iterator<U> uit = us.iterator();
                    U last = null;

                    @Override
                    public boolean hasNext() {
                        return uit.hasNext();
                    }

                    @Override
                    public U next() {
                        return last = uit.next();
                    }

                    @Override
                    public void remove() {
                        uit.remove();
                        right2Lefts.remove(last);
                    }
                };
            }

            @Override
            public Object[] toArray() {
                return us.toArray();
            }

            @Override
            public <T> T[] toArray(T[] a) {
                return us.toArray(a);
            }

            @Override
            public boolean add(U u) {
                boolean res = us.add(u);
                boolean res2 = BiRelation.this.right2Lefts.computeIfAbsent(u, y -> new HashSet<>()).add(left);
                assert res == res2;
                return res;
            }

            @Override
            public boolean remove(Object u) {
                boolean res = us.remove(u);
                Set<T> lefts = BiRelation.this.right2Lefts.get(u);
                boolean res2 = lefts != null ? lefts.remove(left) : false;
                assert res == res2;
                return res;
            }

            @Override
            public boolean containsAll(Collection<?> c) {
                boolean res = us.containsAll(c);
                assert res == right2Lefts.keySet().containsAll(c);
                return res;
            }

            @Override
            public boolean addAll(Collection<? extends U> c) {
                boolean res = us.addAll(c);
                boolean res2 = false;
                for (U u : c) {
                    res2 |= right2Lefts.computeIfAbsent(u, y -> new HashSet<>()).add(left);
                }
                assert res == res2;
                return res;
            }

            @Override
            public boolean retainAll(Collection<?> c) {
                boolean res = us.retainAll(c);
                boolean res2 = right2Lefts.keySet().retainAll(c);
                assert res == res2;
                return res;
            }

            @Override
            public boolean removeAll(Collection<?> c) {
                boolean res = us.removeAll(c);
                boolean res2 = right2Lefts.keySet().removeAll(c);
                assert res == res2;
                return res;
            }

            @Override
            public void clear() {
                right2Lefts.keySet().removeAll(us);
                us.clear();
                //don't remove from the left2Rights map since our caller must be able to assume this Set is backed by the BiRelation!
            }
        };
    }

    public synchronized Set<T> lefts(U right) {
        Set<T> ts = right2Lefts.computeIfAbsent(right, y -> new HashSet<>());

        return new AbstractSet<T>() {

            @Override
            public int size() {
                int res = ts.size();
                assert res == left2Rights.keySet().size();
                return res;
            }

            @Override
            public boolean isEmpty() {
                boolean res = ts.isEmpty();
                assert res == left2Rights.keySet().isEmpty();
                return res;
            }

            @Override
            public boolean contains(Object o) {
                boolean res = ts.contains(o);
                assert res == left2Rights.getOrDefault(o, Collections.emptySet()).contains(right);
                return res;
            }

            @Override
            public Iterator<T> iterator() {
                return new Iterator<>() {
                    Iterator<T> tit = ts.iterator();
                    T last = null;

                    @Override
                    public boolean hasNext() {
                        return tit.hasNext();
                    }

                    @Override
                    public T next() {
                        return last = tit.next();
                    }

                    @Override
                    public void remove() {
                        tit.remove();
                        left2Rights.remove(last);
                    }
                };
            }

            @Override
            public Object[] toArray() {
                return ts.toArray();
            }

            @Override
            public <T1> T1[] toArray(T1[] a) {
                return ts.toArray(a);
            }

            @Override
            public boolean add(T t) {
                boolean res = ts.add(t);
                boolean res2 = BiRelation.this.left2Rights.computeIfAbsent(t, x -> new HashSet<>()).add(right);
                assert res == res2;
                return res;
            }

            @Override
            public boolean remove(Object t) {
                boolean res = ts.remove(t);
                Set<U> rights = BiRelation.this.left2Rights.get(t);
                boolean res2 = rights != null ? rights.remove(right) : false;
                assert res == res2;
                return res;
            }

            @Override
            public boolean containsAll(Collection<?> c) {
                boolean res = ts.containsAll(c);
                assert res == left2Rights.keySet().containsAll(c);
                return res;
            }

            @Override
            public boolean addAll(Collection<? extends T> c) {
                boolean res = ts.addAll(c);
                boolean res2 = false;
                for (T t : c) {
                    res2 |= left2Rights.computeIfAbsent(t, x -> new HashSet<>()).add(right);
                }
                assert res == res2;
                return res;
            }

            @Override
            public boolean retainAll(Collection<?> c) {
                boolean res = ts.retainAll(c);
                boolean res2 = left2Rights.keySet().retainAll(c);
                assert res == res2;
                return res;
            }

            @Override
            public boolean removeAll(Collection<?> c) {
                boolean res = ts.removeAll(c);
                boolean res2 = right2Lefts.keySet().removeAll(c);
                assert res == res2;
                return res;
            }

            @Override
            public void clear() {
                left2Rights.keySet().removeAll(ts);
                ts.clear();
                //don't remove from the right2Lefts map since our caller must be able to assume this Set is backed by the BiRelation!
            }
        };
    }

}
