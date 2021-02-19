package vct.transactional.tms1.impl.operation;

import vct.transactional.tms1.InvOperation;

public record InvReadOperation(int address) implements InvOperation {
}
