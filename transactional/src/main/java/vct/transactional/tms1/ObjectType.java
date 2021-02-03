package vct.transactional.tms1;

import vct.transactional.util.*;
import java.util.*;

//TMS2 would refine/implement this using a shared memory
//where the legal predicate can inspect e.g. that reads only read values that were written before.
public interface ObjectType<I, R> {

    //checks whether a sequence of operations is a legal execution history.
    public boolean isLegal(List<Tuple<I, R>> operations);

}
