package vct.transactional.tms1.ex;

public class InvalidFail extends Exception {
    //this is not an AbortException, because this exception is not used to go to the state: aborted.

    public InvalidFail(String message) {
        super(message);
    }
}
