package vct.transactional.tms1.ex;

public class InvalidResp extends AbortException {

    public InvalidResp(String message) {
        super(message);
    }
}
