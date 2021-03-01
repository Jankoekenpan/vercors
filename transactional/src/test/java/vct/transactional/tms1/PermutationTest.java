package vct.transactional.tms1;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

import java.util.*;

public class PermutationTest {

    @Test
    public void testEmpty() {
        List<String> empty = List.of();
        List<List<String>> expected = List.of(List.of());
        assertEquals(expected, TMS1.permutations(empty));
    }

    @Test
    public void testFilled() {
        List<String> list = List.of("hello", "world", "foo", "bar");
        List<List<String>> expected = List.of(
                List.of("hello", "world", "foo", "bar"),
                List.of("hello", "world", "bar", "foo"),
                List.of("hello", "foo", "world", "bar"),
                List.of("hello", "foo", "bar", "world"),
                List.of("hello", "bar", "world", "foo"),
                List.of("hello", "bar", "foo", "world"),

                List.of("world", "hello", "foo", "bar"),
                List.of("world", "hello", "bar", "foo"),
                List.of("world", "foo", "hello", "bar"),
                List.of("world", "foo", "bar", "hello"),
                List.of("world", "bar", "hello", "foo"),
                List.of("world", "bar", "foo", "hello"),

                List.of("foo", "hello", "world", "bar"),
                List.of("foo", "hello", "bar", "world"),
                List.of("foo", "world", "hello", "bar"),
                List.of("foo", "world", "bar", "hello"),
                List.of("foo", "bar", "hello", "world"),
                List.of("foo", "bar", "world", "hello"),

                List.of("bar", "hello", "world", "foo"),
                List.of("bar", "hello", "foo", "world"),
                List.of("bar", "world", "hello", "foo"),
                List.of("bar", "world", "foo", "hello"),
                List.of("bar", "foo", "hello", "world"),
                List.of("bar", "foo", "world", "hello")
        );

        assertEquals(Set.copyOf(expected), Set.copyOf(TMS1.permutations(list)));
    }

}
