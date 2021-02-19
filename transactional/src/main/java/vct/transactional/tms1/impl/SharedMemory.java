package vct.transactional.tms1.impl;

public class SharedMemory {

    private final int[] values; //TODO AtomicInteger[] ?

    public SharedMemory(int size) {
        this.values = new int[size];
    }

    public void set(int location, int value) {
        values[location] = value;
    }

    public int get(int location) {
        return values[location];
    }

}
