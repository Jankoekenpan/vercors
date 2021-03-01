package vct.transactional.tms1;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.*;
import vct.transactional.util.*;
import java.util.*;

public class SerializationsTest {

    private final BiRelation<String, String> relation = new BiRelation<>(); {
        relation.add("00", "10");
        relation.add("00", "11");
        relation.add("11", "20");
    }
    private final Comparator<String> comparator = new AcyclicRelationComparator<>(relation);

    @Test
    public void testEmptySerializations() {
        assertEquals(Set.of(List.of()), TMS1.ser(Set.of(), comparator));
    }

    @Test
    public void testElementsSerializations() {
        Set<String> elements = Set.of("00", "10", "11", "20");
        Set<List<String>> expected = Set.of(
                List.of("00", "10", "11", "20"),
                List.of("00", "11", "10", "20"),
                List.of("00", "11", "20", "10")
        );
        assertEquals(expected, TMS1.ser(elements, comparator));
    }
}
