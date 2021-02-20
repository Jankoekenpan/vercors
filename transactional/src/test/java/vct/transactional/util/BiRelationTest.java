package vct.transactional.util;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.util.Set;

public class BiRelationTest {

    @Test
    public void testEmpty() {
        BiRelation<Integer, Integer> br1 = new BiRelation<>();
        BiRelation<Integer, Integer> br2 = new BiRelation<>();
        br1.add(0, 0);
        br1.clear();
        assertEquals(br2, br1);

        assertTrue(br1.isEmpty());
        assertEquals(0L, br1.size());
        assertFalse(br1.contains(0, 0));
        for (var tuple : br1) {
            fail("found tuple in iteration");
        }
        assertEquals(Set.of(), br1.values());
        assertEquals(Set.of(), br1.lefts(0));
        assertEquals(Set.of(), br1.rights(0));
    }

    @Test
    public void testSingle() {
        BiRelation<Integer, Integer> br = new BiRelation<>();
        br.add(0, 1);
        BiRelation<Integer, Integer> br2 = new BiRelation<>();
        br2.add(0, 1);
        assertEquals(br2, br);
        assertEquals(br2.hashCode(), br.hashCode());

        assertFalse(br.isEmpty());
        assertTrue(br.contains(0, 1));
        assertEquals(1L, br.size());
        for (var tuple : br) {
            assertEquals(new Tuple<>(0, 1), tuple);
        }
        assertEquals(Set.of(new Tuple<>(0, 1)), br.values());
        assertEquals(Set.of(1), br.rights(0));
        assertEquals(Set.of(0), br.lefts(1));
    }

    @Test
    public void testMultiple() {
        BiRelation<Integer, Integer> br = new BiRelation<>();
        BiRelation<Integer, Integer> br2 = new BiRelation<>();
        //populate
        for (int i = 1; i <= 3; ++i) {
            for (int j = 1; j <= 3; ++j) {
                br.add(i, j);
                br2.add(i, j);
            }
        }
        //assert
        assertEquals(br2, br);
        assertEquals(br2.hashCode(), br.hashCode());
        assertFalse(br.isEmpty());
        assertTrue(br.contains(1, 1));
        assertTrue(br.contains(1, 2));
        assertTrue(br.contains(1, 3));
        assertTrue(br.contains(2, 1));
        assertTrue(br.contains(2, 2));
        assertTrue(br.contains(2, 3));
        assertTrue(br.contains(3, 1));
        assertTrue(br.contains(3, 1));
        assertTrue(br.contains(3, 2));
        assertTrue(br.contains(3, 3));
        assertEquals(9, br.size());
        for (var tuple : br) {
            Integer first = tuple.getFirst();
            Integer second = tuple.getSecond();
            assertTrue(first == 1 || first == 2 || first == 3);
            assertTrue(second == 1 || second == 2 || second == 3);
        }
        assertEquals(
                Set.of(
                    new Tuple<>(1, 1), new Tuple<>(1, 2), new Tuple<>(1, 3),
                    new Tuple<>(2, 1), new Tuple<>(2, 2), new Tuple<>(2, 3),
                    new Tuple<>(3, 1), new Tuple<>(3, 2), new Tuple<>(3, 3)),
                br.values());
        assertEquals(Set.of(1, 2, 3), br.rights(1));
        assertEquals(Set.of(1, 2, 3), br.rights(2));
        assertEquals(Set.of(1, 2, 3), br.rights(3));
        assertEquals(Set.of(1, 2, 3), br.lefts(1));
        assertEquals(Set.of(1, 2, 3), br.lefts(2));
        assertEquals(Set.of(1, 2, 3), br.lefts(3));

        //remove a few elements
        for (int i = 1; i <= 3; ++i) {
            br.remove(i, i);
        }
        //assert
        assertNotEquals(br2, br);
        assertEquals(6L, br.size());
        assertFalse(br.contains(1, 1));
        assertFalse(br.contains(2, 2));
        assertFalse(br.contains(3, 3));
        assertTrue(br.contains(1, 2));
        assertTrue(br.contains(1, 3));
        assertTrue(br.contains(2, 1));
        assertTrue(br.contains(2, 3));
        assertTrue(br.contains(3, 1));
        assertTrue(br.contains(3, 2));
        assertEquals(
                Set.of(
                    new Tuple<>(1, 2), new Tuple<>(1, 3),
                    new Tuple<>(2, 1), new Tuple<>(2, 3),
                    new Tuple<>(3, 1), new Tuple<>(3, 2)),
                br.values());

    }

    @Test
    public void testBackedCollections() {
        BiRelation<Integer, Integer> br = new BiRelation<>();

        for (int i = 0; i < 10; ++i) {
            for (int j = 0; j < 10; ++j) {
                br.add(i, j);
            }
        }

        var values = br.values();
        values.remove(new Tuple<>(5, 5));
        assertFalse(br.contains(5, 5));
        values.add(new Tuple<>(100, 100));
        assertTrue(br.contains(100, 100));

        var iterator = br.iterator();
        assertTrue(iterator.hasNext());
        Tuple<Integer, Integer> pair = iterator.next();
        iterator.remove();
        assertFalse(br.contains(pair));

        var rightsFor4 = br.rights(4);
        rightsFor4.remove(3);
        assertFalse(br.contains(4, 3));
        rightsFor4.add(51);
        assertTrue(br.contains(4, 51));

        var leftsFor6 = br.lefts(6);
        leftsFor6.remove(7);
        assertFalse(br.contains(7, 6));
        leftsFor6.add(51);
        assertTrue(br.contains(51, 6));


    }
}
