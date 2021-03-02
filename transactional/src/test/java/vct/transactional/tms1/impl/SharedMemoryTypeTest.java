package vct.transactional.tms1.impl;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;
import vct.transactional.tms1.*;
import static vct.transactional.tms1.impl.operation.Operation.*;
import vct.transactional.util.*;
import java.util.*;

public class SharedMemoryTypeTest {

    private final SharedMemoryType sharedMemoryType = new SharedMemoryType();


    @Test
    public void testEmptyHistory() {
        List<Tuple<InvOperation, RespOperation>> emptyHistory = List.of();

        assertTrue(sharedMemoryType.isLegal(emptyHistory));
    }

    @Test
    public void testWriteRead() {
        List<Tuple<InvOperation, RespOperation>> history = List.of(
                new Tuple<>(invWriteOp(0, 10), respWriteOp()),
                new Tuple<>(invReadOp(0), respReadOp(10))
        );

        assertTrue(sharedMemoryType.isLegal(history));
    }

    @Test
    public void testOverwrite() {
        List<Tuple<InvOperation, RespOperation>> history = List.of(
                new Tuple<>(invWriteOp(0, 5), respWriteOp()),
                new Tuple<>(invWriteOp(0, 10), respWriteOp()),
                new Tuple<>(invReadOp(0), respReadOp(10))
        );

        assertTrue(sharedMemoryType.isLegal(history));
    }

}
