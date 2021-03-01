package vct.transactional.tms1;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.*;

import java.util.Set;

public class PowerTest {

    @Test
    public void testEmpty() {
        Set<String> emptySet = Set.of();
        Set<Set<String>> actual = TMS1.power(emptySet);
        assertEquals(Set.of(emptySet), actual);
    }

    @Test
    public void testElements() {
        Set<String> set = Set.of("foo", "bar", "hello", "world");

        Set<Set<String>> expected = Set.of(
                Set.of("foo", "bar", "hello", "world"),
                Set.of("foo", "bar", "hello"),
                Set.of("foo", "bar", "world"),
                Set.of("foo", "hello", "world"),
                Set.of("foo", "bar"),
                Set.of("foo", "hello"),
                Set.of("foo", "world"),
                Set.of("foo"),
                Set.of("bar", "hello", "world"),
                Set.of("bar", "hello"),
                Set.of("bar", "world"),
                Set.of("bar"),
                Set.of("hello", "world"),
                Set.of("hello"),
                Set.of("world"),
                Set.of()
        );
        Set<Set<String>> acutal = TMS1.power(set);
    }
}
