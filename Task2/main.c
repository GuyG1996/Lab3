#include "util.h"

#define SYS_WRITE 4
#define STDOUT 1
#define SYS_OPEN 5
#define O_RDWR 2
#define SYS_SEEK 19
#define SEEK_SET 0
#define SHIRA_OFFSET 0x291

extern int system_call();

int main (int argc , char* argv[], char* envp[])
  {
    int i;
    for (i = 0; i < argc; i++) {
        int j = 0;
        while (argv[i][j] != '\0') {
            system_call(SYS_WRITE, STDOUT, argv[i] + j, 1);
            j++;
        }
        system_call(SYS_WRITE, STDOUT, "\n", 1);
    }
    return 0;
}
