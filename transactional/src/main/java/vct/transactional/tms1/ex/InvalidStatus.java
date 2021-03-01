package vct.transactional.tms1.ex;

public class InvalidStatus extends Exception {
    //this is not an AbortException, because this exception is not used to go to the state: aborted.

    public InvalidStatus(String reason) {
        super(reason);
    }
}
