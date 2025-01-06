import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

public class Program {

    private static HashMap<Character, ArrayList<ArrayList<Integer>>> loadMap(String path) {
        HashMap<Character, ArrayList<ArrayList<Integer>>> map = new HashMap<>();

        try (BufferedReader reader = new BufferedReader(new FileReader(path))) {
            reader.lines().forEach(line -> {
                HashMap<Character, ArrayList<Integer>> mapOffsets = new HashMap<>();

                int offset = 0;
                for (char character : line.toCharArray()) {
                    ArrayList<Integer> offsets = mapOffsets.getOrDefault(character, new ArrayList<>());
                    offsets.add(offset++);
                    mapOffsets.put(character, offsets);
                }

                mapOffsets.forEach((character, offsets) -> {
                    ArrayList<ArrayList<Integer>> offsetList = map.getOrDefault(character, new ArrayList<>());
                    offsetList.add(offsets);
                    map.put(character, offsetList);
                });
            });
        } catch (IOException error) {
            return map;
        }

        return map;
    }

    public static void main(String args[]) {
        HashMap<Character, ArrayList<ArrayList<Integer>>> map = loadMap("./day/12/input.txt");
        
        map.forEach((character, offsetLists) -> {
            System.out.println(String.format("[letter: %c]", character));
            offsetLists.forEach(offsets -> {
                int min = offsets.getFirst();
                int max = offsets.getLast();

                for (int i = 0; i <= max; i++) {
                    if (i >= min)
                        System.out.print(character);
                    else
                        System.out.print('.');
                }

                System.out.println();
            });
        });
    }
}