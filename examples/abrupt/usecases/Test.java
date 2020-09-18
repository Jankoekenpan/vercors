//:: cases TestAbrupt
//:: tools silicon
//:: verdict Pass

import java.io.IOException;
import java.io.*;

class C {
    void doWork() throws Exception;

    void writeToDatabase() throws IOException;

    void log(String s);

    void ignoreException() {
        try {
            doWork();
        } catch (Exception e) {
            // Ignore
        }
    }

    void logException() {
        try {
            doWork();
        } catch (Exception e) {
            // TODO (Bob): Add getMessage()
            log(e.getMessage());
        }
    }

    void printStackTrace() {
        try {
            doWork();
        } catch (Exception e) {
            // TODO (Bob): Add printStackTrace()
            e.printStackTrace();
        }
    }

    // Contract is still needed:
    //@ signals (RuntimeException e) true;
    void throwUncheckedException() {
        try {
            doWork();
        } catch (Exception e) {
            // TODO (Bob): Add constructor with causes from std library
            throw new RuntimeException(e);
        }
    }

    /*
    void printException() {
        try {
            doWork();
        } catch (Exception e) {
            // TODO (Bob): Need some string support for this
            System.out.println("Abcde");
        }
    }
    */

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
    void throwCheckedException() throws Exception {
        try {
            writeToDatabase();
        } catch (IOException e) {
            // TODO (Bob): Need a constructor here
            throw new Exception(e);
        }
    }
    */

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

    /*
    // From:https://stackoverflow.com/questions/45519655/how-do-i-use-try-catch-statement-with-switch-case-but-loop-the-swich-case
    void scanUserInput() {
        Scanner userinput = new Scanner(System.in);
        int startup;
        while (true) {
            try {
                System.out.println("Press \"1\" to chat" + " & " + "\"2\" to play games" + " & \"3\" to edit the conversations");
                System.out.println("Typing other numbers will end the Chatbot");
                startup = userinput.nextInt();
                switch (startup) {
                    case 1:
                        ConversationBot chat = new ConversationBot();
                        chat.ChattingBot();
                        break;
                    case 2:
                        GameBot game = new GameBot();
                        game.GamingBot();
                        break;
                    case 3:
                        EditBot edit = new EditBot();
                        edit.EditingBot();
                        break;
                    default:
                        System.exit(0);
                }
            } catch (InputMismatchException e) {
                System.out.println("Invalid User Input. Please enter a value from 0 to 4.");
                continue;
            }
        }
        //@ assert 1 <= startup && start <= 3;
    }
    // TODO (Bob): Simplify this example? Can probably do without the dependency on Scanner
    */

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
