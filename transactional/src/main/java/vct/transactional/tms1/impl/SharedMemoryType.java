package vct.transactional.tms1.impl;

import vct.transactional.tms1.InvOperation;
import vct.transactional.tms1.ObjectType;
import vct.transactional.tms1.RespOperation;
import vct.transactional.tms1.impl.operation.*;
import vct.transactional.util.Tuple;

import java.util.HashMap;
import java.util.List;

public class SharedMemoryType implements ObjectType {

    @Override
    public boolean isLegal(List<Tuple<InvOperation, RespOperation>> operations) {
        var memory = new HashMap<Integer, Integer>();

        // simulate operations
        for (var operation : operations) {
            InvOperation inv = operation.getFirst();
            RespOperation resp = operation.getSecond();

            if (inv instanceof InvReadOperation iro && resp instanceof RespReadOperation rro) {
                int addr = iro.address();
                int expectedValue = rro.value();
                Integer memoryValue = memory.get(addr);
                if (memoryValue == null) return false;                          //no value was written to that location yet
                if (memoryValue.intValue() != expectedValue) return false;      //different value was written to that location
            } else if (inv instanceof InvWriteOperation iwo && resp instanceof RespWriteOperation wro) {
                //RespWriteOperation hasn't got any members, so there is nothing to check in this case.
                //just continue!
            } else {
                return false;   //invalid combination of operations
            }
        }

        return true;
    }

}
