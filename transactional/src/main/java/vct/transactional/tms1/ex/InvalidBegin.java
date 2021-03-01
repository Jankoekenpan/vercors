package vct.transactional.tms1.ex;

public class InvalidBegin extends AbortException {

    public InvalidBegin(String message) {
        super(message);
    }

}
