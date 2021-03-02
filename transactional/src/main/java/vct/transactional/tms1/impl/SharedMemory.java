package vct.transactional.tms1.impl;

class SharedMemory {

    private final int[] values;

    SharedMemory(int size) {
        this.values = new int[size];
    }

    synchronized void set(int location, int value) {
        values[location] = value;
    }

    synchronized int get(int location) {
        return values[location];
    }

}
