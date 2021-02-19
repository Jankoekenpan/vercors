package vct.transactional.tms1.ex;

public class InvalidStatus extends AbortException {

    public InvalidStatus(String reason) {
        super(reason);
    }
}
