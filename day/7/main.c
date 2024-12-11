#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <stdio.h>

int main() {
    char buffer[4096];
    int fd;
    
    fd = open("./day/7/test.txt", O_RDONLY);

    if (fd == -1) {
        printf("file not found\n");
        return 0;
    }

    read(fd, buffer, 4096);
    close(fd);

    char *token;
    char *string = strdup(buffer);

    while ((token = strsep(&string, "\n")) != NULL) {
        printf("%s\n\n", token);
    }

    return 0;
}