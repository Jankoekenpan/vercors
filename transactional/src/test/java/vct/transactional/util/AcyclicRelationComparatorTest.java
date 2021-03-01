package vct.transactional.util;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.*;

import java.util.Comparator;

public class AcyclicRelationComparatorTest {

    private final BiRelation<String, String> relation = new BiRelation<>(); {
        relation.add("00", "10");
        relation.add("00", "11");
        relation.add("11", "20");
    }
    private final Comparator<String> comparator = new AcyclicRelationComparator<>(relation);

    @Test
    public void testEqual() {
        assertEquals(0, comparator.compare("10", "10"));
    }

    @Test
    public void testSmaller() {
        assertTrue(comparator.compare("00", "10") < 0);
    }

    @Test
    public void testLarger() {
        assertTrue(comparator.compare("20", "11") > 0);
    }

    @Test
    public void testIndirect() {
        assertTrue(comparator.compare("20", "00") > 0);
    }

    @Test
    public void testUnrelated() {
        assertEquals(0, comparator.compare("10", "11"));
    }

}
