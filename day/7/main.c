#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <stdio.h>
#include <math.h>

int is_possible(const unsigned long long answer, char *values) {
    unsigned long result, buffer[80];
    int i, j, eqmask = 0, length = 0;
    char *value, *text = values;

    while ((value = strsep(&text, " ")))
        buffer[length++] = atol(value);

    for (i = 0; i < pow(2, length); i++) {
        result = i & 1; // 1 = multiply so start with 1 (product summation)

        for (j = 0; j < length; j++) {
            if ((i >> j) & 1 == 1)
                result *= buffer[j];
            else
                result += buffer[j];
        }

        if (result == answer)
            return 1;
    }

    return 0;
}

unsigned long long process_line(char *line) {
    char *values, *text = line;
    unsigned long long answer;

    answer = atoll(strsep(&text, ":"));
    values = strsep(&text, ":") + 1; // remove space at the front

    return is_possible(answer, values) ? answer : 0;
}

int main() {
    char buffer[4096 * 8], *text, *line;
    unsigned long long part1 = 0;
    int fd;
    
    fd = open("./day/7/input.txt", O_RDONLY);

    if (fd == -1) {
        printf("file not found\n");
        return 0;
    }

    read(fd, buffer, 4096 * 8);
    close(fd);

    text = strdup(buffer);
    while ((line = strsep(&text, "\n")) != NULL)
        part1 += process_line(line);        

    printf("part 1: %llu\n", part1);

    return 0;
}