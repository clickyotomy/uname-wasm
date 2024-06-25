#include <stdio.h>
#include <sys/utsname.h>

int info(struct utsname *buf) {
    if (!buf)
        return 1;

    if (uname(buf))
        return 1;

    printf("uname: %s/%s\n", buf->sysname, buf->machine);
    return 0;
}

int main(int argc, char *argv[]) {
    struct utsname buff = {0};

    (void)argc;
    (void)argv;

    return info(&buff);
}
