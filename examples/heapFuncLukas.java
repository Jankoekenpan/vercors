final class Heap {
    int[] buffer;

    //@ requires 0 <= i;
    //@ ensures 0 <= \result;
    // ensures i != 0 ==> (i == childIndex(\result, true) || i == childIndex(\result, false));
    //@ ensures \result <= i;
    private static /*@ pure @*/ int parentIndex(int i) {
        if (i == 0) {
            return 0;
        } else {
            return (i - 1) / 2;
        }
    }

    //@ requires 0 <= i;
    private static /*@ pure @*/ boolean hasChild(int i, int length, boolean leftChild) {
        return childIndex(i, leftChild) < length;
    }

    //@ requires 0 <= i;
    //@ ensures i < \result;
    //@ ensures parentIndex(\result) == i;
    private static /*@ pure @*/ int childIndex(int i, boolean leftChild) {
        if (leftChild) {
            return i * 2 + 1;
        } else {
            return i * 2 + 2;
        }
    }

    //@ requires 0 < other;
    //@ ensures 0 < \result;
    //@ ensures \result == childIndex(parentIndex(other), false) || \result == childIndex(parentIndex(other), true);
    private static /*@ pure @*/ int getSiblingIndex(int other) {
        if (other%2 == 0) {
            return other-1;
        } else {
            return other+1;
        }
    }


    /*@
    requires xs != null;
    requires Perm(xs[*], read);
    private static inline bool isHeap(int[] xs) 
        = (\forall int i = 1 .. xs.length; {: xs[parentIndex(i)] :} >= xs[i]);

    requires xs != null;
    requires Perm(xs[*], read);
    private static inline bool isHeapSkip(int[] xs, int freshIndex) 
        = (\forall int i = 1 .. xs.length; i != freshIndex ==> {: xs[parentIndex(i)] :} >= xs[i])
          && (childIndex(freshIndex, true) < xs.length 
              ==> xs[parentIndex(freshIndex)] >= xs[childIndex(freshIndex, true)])
          && (childIndex(freshIndex, false) < xs.length 
              ==> xs[parentIndex(freshIndex)] >= xs[childIndex(freshIndex, false)]);
    @*/

    
    //@ context Perm(buffer, write) ** buffer != null ** Perm(buffer[*], write);
    //@ requires isHeap(buffer);
    //@ ensures isHeap(buffer);
    void insert(int x) {
        int[] newBuffer = new int[buffer.length + 1];
        int i;

        //@ loop_invariant Perm(newBuffer[*], write);
        //@ loop_invariant Perm(buffer, 1\4) ** buffer != null ** Perm(buffer[*], 1\4);
        //@ loop_invariant 0 <= i && i <= buffer.length;
        //@ loop_invariant newBuffer.length == buffer.length + 1;
        //@ loop_invariant isHeap(buffer);
        //@ loop_invariant (\forall int j = 0 .. i; newBuffer[j] == buffer[j]);
        //@ loop_invariant (\forall int j = 1 .. i; newBuffer[parentIndex(j)] >= newBuffer[j]);
        for (i = 0; i < buffer.length; i++) {
            newBuffer[i] = buffer[i];
        }

        newBuffer[buffer.length] = x;
        int newIndex = buffer.length;

        //@ assert isHeapSkip(newBuffer, newIndex);

        //@ loop_invariant Perm(newBuffer[*], write);
        //@ loop_invariant 0 <= newIndex && newIndex < newBuffer.length;
        //@ loop_invariant isHeapSkip(newBuffer, newIndex);
        while (!(newBuffer[parentIndex(newIndex)] >= newBuffer[newIndex])) {
            int insertedValue = newBuffer[newIndex];
            int oldValue = newBuffer[parentIndex(newIndex)];
            newBuffer[newIndex] = oldValue;
            newBuffer[parentIndex(newIndex)] = insertedValue;
            newIndex = parentIndex(newIndex);
        }

        //@ assert isHeap(newBuffer);

        buffer = newBuffer;
    }
}