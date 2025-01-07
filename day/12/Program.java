import java.nio.file.Files;
import java.nio.file.Paths;
import java.io.IOException;

public class Program {
    public static void main(String args[]) {
        try {
            String content = Files.readString(Paths.get("./day/12/input.txt"));
            System.out.println(content);
        } catch (IOException error) {
            System.out.println("nice");
        }
    }
}