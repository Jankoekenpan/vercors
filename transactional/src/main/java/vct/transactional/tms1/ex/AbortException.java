package vct.transactional.tms1.ex;

public class AbortException extends Exception {

    AbortException(String reason) {
        super(reason);
    }

}

