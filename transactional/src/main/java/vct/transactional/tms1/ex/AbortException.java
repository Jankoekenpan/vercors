package vct.transactional.tms1.ex;

public class AbortException extends Exception {

    public AbortException(String reason) {
        super(reason);
    }

}

