package vct.transactional.util;

import java.util.Objects;

public class Tuple<T, U> {

    private T first;
    private U second;

    public Tuple(T first, U second) {
        this.first = first;
        this.second = second;
    }

    public Tuple(Tuple<T, U> tuple) {
        this(tuple.getFirst(), tuple.getSecond());
    }

    public T getFirst() {
        return first;
    }

    public U getSecond() {
        return second;
    }

    public void setFirst(T first) {
        this.first = first;
    }

    public void setSecond(U second){
        this.second = second;
    }

    @Override
    public int hashCode() {
        return Objects.hash(getFirst(), getSecond());
    }

    @Override
    public boolean equals(Object o) {
        if (o == this) return true;
        if (!(o instanceof Tuple that)) return false;

        return Objects.equals(this.getFirst(), that.getFirst())
                && Objects.equals(this.getSecond(), that.getSecond());
    }

    @Override
    public String toString() {
        return "(" + getFirst() + "," + getSecond() + ")";
    }
}
