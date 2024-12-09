#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>

int main() {
    char buffer[4096];
    int fd;
    
    fd = open("./day/7/input.txt", O_RDONLY);

    if (fd == -1) {
        printf("file not found\n");
        return 0;
    }

    read(fd, buffer, 4096);
    close(fd);

    printf("%s\n", buffer);

    return 0;
}