package vct.transactional.tms1.ex;

public class InvalidCommit extends AbortException {

    public InvalidCommit(String message) {
        super(message);
    }
}
