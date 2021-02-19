package vct.transactional.tms1.ex;

public class InvalidFail extends AbortException {

    public InvalidFail(String message) {
        super(message);
    }
}
