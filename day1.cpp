#include <algorithm>
#include <iostream>
#include <fstream>
#include <vector>

int main(int argc, char **argv) {

    std::fstream file("input/day1.txt");
    std::vector<int> ds, ls, rs;
    bool leftSide = true;
    int token, n = 0, sum = 0;

    while (file >> token) {
        leftSide ? ls.push_back(token) : rs.push_back(token);
        leftSide = !leftSide;
        n++;
    }

    file.close();

    std::sort(ls.begin(), ls.end());
    std::sort(rs.begin(), rs.end());

    for (int i = 0; i < n / 2; i++)
        sum += abs(ls[i] - rs[i]);

    std::cout << "part 1: " << sum << std::endl;

    return 0;
}