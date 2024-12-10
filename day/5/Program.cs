Dictionary<string, List<string>> rules = [];

string[] sections = File.ReadAllText("./day/5/input.txt").Split(Environment.NewLine + Environment.NewLine);

int part1 = 0;

using (StringReader reader = new(sections[0])) {
    string line;
    while ((line = reader.ReadLine() ?? "") != "") {
        string[] pages = line.Split('|');
        if (rules.ContainsKey(pages[0])) {
            rules[pages[0]].Add(pages[1]);
        } else {
            rules[pages[0]] = [pages[1]];
        }
    }
}

using (StringReader reader = new(sections[1])) {
    string line;
    while ((line = reader.ReadLine() ?? "") != "") {
        string[] pages = line.Split(',');
        bool validLine = true;

        for (int i = pages.Length - 1; i >= 0; i--) {
            if (!validLine)
                break;
            
            if (rules.ContainsKey(pages[i])) {
                foreach (string notAllowed in rules[pages[i]]) {
                    if (pages[0..i].Contains(notAllowed))
                        validLine = false;
                }
            }
        }

        if (validLine) {
            part1 += Int32.Parse(pages[pages.Length / 2]);
        }
    }
}

Console.WriteLine($"part 1: {part1}");