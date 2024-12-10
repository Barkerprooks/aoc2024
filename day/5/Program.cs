bool IsValid(Dictionary<string, List<string>> rules, string[] pages) {
    for (int i = pages.Length - 1; i >= 0; i--) {
        if (rules.ContainsKey(pages[i])) {
            foreach (string notAllowed in rules[pages[i]]) {
                if (pages[0..i].Contains(notAllowed))
                    return false;
            }
        }
    }
    return true;
}

void RepairLine(Int64 i, Dictionary<string, List<string>> rules, string[] pages) {
    for (int j = 0; j < i; j++) {

        if (!rules.ContainsKey(pages[i]))
            return;

        if (rules[pages[i]].Contains(pages[j])) {
            string tmp = pages[i];
            pages[i] = pages[j];
            pages[j] = tmp;

            RepairLine(j, rules, pages);
        }
    }
}

string[] sections = File.ReadAllText("./day/5/input.txt").Split(Environment.NewLine + Environment.NewLine);
Dictionary<string, List<string>> rules = [];

int part1 = 0, part2 = 0;

using (StringReader reader = new(sections[0])) {
    string line;
    while ((line = reader.ReadLine() ?? "") != "") {
        string[] pages = line.Split('|');
        if (rules.ContainsKey(pages[0]))
            rules[pages[0]].Add(pages[1]);
        else
            rules[pages[0]] = [pages[1]];
    }
}

using (StringReader reader = new(sections[1])) {
    string line;
    while ((line = reader.ReadLine() ?? "") != "") {        
        string[] pages = line.Split(',');

        if (IsValid(rules, pages)) {
            part1 += Int32.Parse(pages[pages.Length / 2]);   
        } else {
            while (!IsValid(rules, pages)) {
                for (int i = pages.Length - 1; i >= 0; i--)
                    RepairLine(i, rules, pages);
            }
            part2 += Int32.Parse(pages[pages.Length / 2]);
        }
    }
}

Console.WriteLine($"part 1: {part1}");
Console.WriteLine($"part 2: {part2}");