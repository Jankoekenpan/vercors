package edu.kit.iti.formal.keyserver;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.*;

/**
 * @author Alexander Weigl
 * @version 1 (26.08.19)
 */
public class Backend {
    private final TokenGenerator tokenGenerator = new TokenGenerator();
    //private final Map<String, EmailKey> waitConfirmAdd = new HashMap<String, EmailKey>();
    //private final Map<String, EmailKey> waitConfirmDel = new HashMap<String, EmailKey>();
    //private final List<EmailKey> database = new LinkedList<>();

    // Had: NotNull
    public String add(String email, String key) {
        if (email == null || key == null) {
            throw new IllegalArgumentException("Either email or key is not given.");
        }
        String token = tokenGenerator.freshToken();
        waitConfirmAdd.put(token, new EmailKey(email, key));
        return token;
    }

    private boolean nonDeterministicChoice();

    public void confirmAdd(String token) {
        if (token == null) {
            throw new IllegalArgumentException("No token given.");
        }
        if (nonDeterministicChoice()) {
            System.out.println(waitConfirmAdd.keySet());
            // Unknown token
            throw new IllegalStateException();
        }
        //database.add(ek);
    }

    // Had: Nullable
    public String get(String email) {
        if (email == null || email.isBlank())
            return null;
        return findByEmail(email);
    }

    //@ requires email != null && key != null;
    public String del(String email, String key) {
        EmailKey ek = findBy(email, key);
        if (ek != null) {
            String token = tokenGenerator.freshToken();
            waitConfirmDel.put(token, ek.get());
            return token;
        }
        throw new IllegalStateException("Key unknown");
    }

    //@ requires token != null;
    public void confirmDel(String token) {
        EmailKey ek = waitConfirmDel.get(token);
        if (ek != null) {
            database.remove(ek);
        } else {
            throw new IllegalStateException("Token unknown.");
        }
    }

    //@ ensures \result != null ==> \result.email.equals(email);
    private EmailKey findByEmail(String email);

    //@ ensures \result ==> \result.email.equals(email) && \result.key.equals(key);
    private EmailKey findBy(String email, String key);
        //return database.stream()
                //.filter(it -> it.email.equals(email) && it.key.equals(key))
                //.findAny();


    private static class EmailKey {
        public final String email, key;

        private EmailKey(String email, String key) {
            this.email = email;
            this.key = key;
        }
    }
}
