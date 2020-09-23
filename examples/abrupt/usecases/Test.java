//:: cases TestAbrupt
//:: tools silicon
//:: verdict Pass

import java.io.*;
import java.util.InputMismatchException;

class C {
    ///////////////////////
    // Utility functions //
    ///////////////////////

    void doWork() throws RuntimeException;
    void readBuffer() throws IOException;
    void log(String s);
    void println(String s);

    ///////////////////
    // Plain catches //
    ///////////////////

    void logException() {
        try {
            doWork();
        } catch (RuntimeException e) {
            log(e.getMessage());
        }
    }

    void printStackTrace() {
        try {
            doWork();
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
    }

    void printStackTrace() {
        try {
            doWork();
        } catch (RuntimeException e) {
            println(e.getMessage());
        }
    }

    void ignoreException() {
        try {
            doWork();
        } catch (RuntimeException e) {
            // Ignore
        }
    }

    //////////////////////////
    // Exceptional handling //
    //////////////////////////

    //@ signals (RuntimeException e);
    void convertIntoUnchecked() {
        try {
            readBuffer();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    void convertIntoChecked() throws IOException {
        try {
            doWork();
        } catch (RuntimeException e) {
            throw new IOException(e);
        }
    }

    void useVariableDeclarations() {
        int total = 0;
        boolean caughtException = false;
        try {
            writeToDatabase();
        } catch (IOException e) {
            int x = 30;
            int y = 40;
            int z = x + y;
            //@ assert z == 70;
            caughtException = true;
            total = z;
        }
        //@ assert caughtException ==> total == 70;
    }

    /*
    int countBytesInFile(String path) {
        // TODO (Bob): Are the throws attributes imported as well?
        try {
            int total = 0;
            BufferedReader in = new BufferedReader(new FileReader(path));

            try {
                String str;
                while ((str = in.readLine()) != null) {
                    total += str.getLength();
                }
            } finally {
                in.close();
            }

            return total;
        } catch (FileNotFoundException e) {
            return 0;
        }
    }
    */

    // Adapted from:https://stackoverflow.com/questions/45519655/how-do-i-use-try-catch-statement-with-switch-case-but-loop-the-swich-case
    int getUserInput() throws InputMismatchException;

    void chatWithUser();
    void gameWithUser();
    void editWithUser();

    void scanUserInput() {
        int userChoice = 0;
        //@ loop_invariant 0 <= userChoice && userChoice <= 3;
        while (true) {
            try {
                userChoice = getUserInput();
                switch (userChoice) {
                    case 1:
                        chatWithUser();
                        break;
                    case 2:
                        gameWithUser();
                        break;
                    case 3:
                        editWithUser();
                        break;
                    default:
                        return;
                }
            } catch (InputMismatchException e) {
                assert userChoice == 0; // Hmmmm...
                continue;
            }
        }
        //@ assert 1 <= userChoice && userChoice <= 3;
    }

    /*
    for (Cat cat : cattery) {
        try {
             cat.removeFromCage();
             cat.healthCheck();
             if (cat.isPedigree()) {
                 continue;
             }
             cat.spey();
        } finally {
             cat.putBackInCage();
        }
    }
    */

    /*
    ll:{
        try {
            f = new FileInputStream(fname);
            i = f.read();
            if (i != ' ')
                break ll;
            i = f.read();
        } catch (IOException e) {
            System.out.println("Got an IO Exception!");
            break ll;
        } finally {
            f.close();           // Always executed
        }
        // Only reached if we don't break out of the try
        System.out.println("No breaks");
    }
    */

    // Only need maybe two examples of finally interacting return/continue
    // This kind of code actuallt exists: https://searchcode.com/file/109276830/#l-300
    // Titled: /server/src/main/org/jboss/ejb/plugins/EntitySynchronizationInterceptor.java
    // Another nice one: https://searchcode.com/file/59032296/#l-442
    // Titled: transport/src/main/java/io/netty/channel/nio/NioEventLoop.java
    // Just search for: finally switch
}
