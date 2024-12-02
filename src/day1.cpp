#include <algorithm>
#include <iostream>
#include <fstream>
#include <vector>
#include <map>

int main(int argc, char **argv) {    
    // part 1
    std::vector<int> ls, rs; // left side list and right side list

    // part 2
    std::map<int, int> counts; // table of values and how many times they appear

    bool leftSide = true; // switch to toggle which token gets added to which list
    int i, token, part1 = 0, part2 = 0;

    std::fstream file("input/day1.txt"); // open a handle to the input
    while (file >> token) {
        leftSide ? ls.push_back(token) : rs.push_back(token);
        leftSide = !leftSide; // toggle left/right on each value
    }
    file.close(); // don't need this anymore

    // sort the vectors in-place (problem says we need to compare them sorted)
    std::sort(ls.begin(), ls.end());
    std::sort(rs.begin(), rs.end());

    for (i = 0; i < ls.size(); i++) {
        // build a map of right side values and how many times each value appears
        // for part 2
        if (counts.count(rs[i]) == 0)
            counts[rs[i]] = 1;
        else
            counts[rs[i]]++;

        part1 += abs(ls[i] - rs[i]); 
    } // part 1 is done after this

    for (i = 0; i < ls.size(); i++) {
        if (counts.count(ls[i]))
            part2 += ls[i] * counts[ls[i]]; 
    } // part 2 is done after this

    std::cout << "part 1: " << part1 << std::endl;
    std::cout << "part 2: " << part2 << std::endl;

    return 0;
}