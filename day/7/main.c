#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <stdio.h>
#include <math.h>

int is_possible_with_concat(const double answer, char *values) {
    char concat[80], *value, *text = values;
    double result, buffer[80];
    int i, j, k, op, length = 0;

    while ((value = strsep(&text, " ")))
        buffer[length++] = strtod(value, NULL);

    for (i = 0; i < pow(2, length); i++) {
        for (j = 0; j < pow(2, length); j++) {
            result = ((i & 1 == 1) ? (j & 1 == 1) : 0) ? 1.0 : 0.0; 
            // 1 = multiply so start with 1 (product summation)
            // if we're starting with concat instead
            // change back to 0
            for (k = 0; k < length; k++) {

                switch (((i >> k) & 1) + ((j >> k) & 1)) {
                    case 2:
                        sprintf(concat, "%0.0f%0.0f", result, buffer[k]);
                        result = strtod(concat, NULL);
                        break;
                    case 1:
                        result *= buffer[k];
                        break;
                    case 0:
                        result += buffer[k];
                        break;
                }

                if (result > answer)
                    break; // cut out early if no matches
            }

            if (result == answer)
                    return 1;
        }
    }

    return 0;
}

int is_possible(const double answer, char *values) {
    char *value, *text = values;
    double result, buffer[80];
    int i, j, length = 0;

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

double process_line_part1(char *line) {
    char *values, *text = line;
    double answer;

    answer = strtod(strsep(&text, ":"), NULL);
    values = strsep(&text, ":") + 1; // remove space at the front

    return is_possible(answer, values) ? answer : 0;
}

double process_line_part2(char *line) {
    char *values, *text = line;
    double answer;

    answer = strtod(strsep(&text, ":"), NULL);
    values = strsep(&text, ":") + 1; // remove space at the front

    return is_possible_with_concat(answer, values) ? answer : 0;
}

int main() {
    double part1, part2;

    char buffer[4096 * 8], *text, *line;
    int fd;
    
    fd = open("./day/7/input.txt", O_RDONLY);

    if (fd == -1) {
        printf("file not found\n");
        return 0;
    }

    read(fd, buffer, 4096 * 8);
    close(fd);

    text = strdup(buffer);
    part1 = 0.0;

    while ((line = strsep(&text, "\n")) != NULL)
        part1 += process_line_part1(line);

    text = strdup(buffer); // run it again
    part2 = 0.0;

    // this one takes forever but I want to move on to the next challenge
    // it works tho :s

    // smashing rocks together typa shit
    while ((line = strsep(&text, "\n")) != NULL)
        part2 += process_line_part2(line);    

    printf("part 1: %0.0f\n", part1);
    printf("part 2: %0.0f\n", part2);

    return 0;
}