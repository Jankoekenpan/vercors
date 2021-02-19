package vct.transactional.tms1.impl.operation;

import vct.transactional.tms1.InvOperation;

public record InvWriteOperation(int address, int value) implements InvOperation {
}
