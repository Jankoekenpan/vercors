package vct.transactional.util;

import java.util.Comparator;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

public class AcyclicRelationComparator<T> implements Comparator<T> {

    private final BiRelation<T, T> relation;

    public AcyclicRelationComparator(BiRelation<T, T> relation) {
        this.relation = relation;
    }

    @Override
    public int compare(T first, T second) {
        if (Objects.equals(first, second)) {
            return 0;
        } else if (relation.contains(first, second)) {
            return -1;
        } else if (relation.contains(second, first)) {
            return 1;
        } else {
            Set<T> lefts = relation.lefts(first);
            while (!lefts.isEmpty()) {
                if (lefts.contains(second))
                    return 1;   //second was added way earlier than first. return 1 because first is larger than second.

                lefts = lefts.stream().flatMap(item -> relation.lefts(item).stream()).collect(Collectors.toSet());
                //this could loop infinitely if the relation contains cycles! hence this class is called AcyclicRelationComparator!
            }

            Set<T> rights = relation.rights(second);
            while (!rights.isEmpty()) {
                if (rights.contains(first))
                    return -1;  //first was added way later than second. return -1 because first is smaller than second.

                rights = rights.stream().flatMap(item -> relation.rights(item).stream()).collect(Collectors.toSet());
                //this could loop infinitely if the relation contains cycles! hence this class is called AcyclicRelationComparator!
            }

            //left and right are unrelated.
            return 0;
        }
    }

}
