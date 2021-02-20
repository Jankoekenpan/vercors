package vct.transactional.tms1.impl;

public class SharedMemory {

    private final int[] values;

    public SharedMemory(int size) {
        this.values = new int[size];
    }

    public synchronized void set(int location, int value) {
        values[location] = value;
    }

    public synchronized int get(int location) {
        return values[location];
    }

}
