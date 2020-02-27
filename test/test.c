#include <confort.h>
#include <stdio.h>
#include <stdlib.h>

#define test(x) test0(__FILE__,__LINE__,x,#x)
int test0(char *file, unsigned int line, int expr, char *descr);

int main() {
    confort cfg;
    char buf[1024];
    char defvalue[] = "bu bu buuu";
    int ret;

    ret = mincf_read(&cfg,"nonexistent.cfg");
    test( ret != MINCF_OK );
    test( ret & MINCF_ERROR );
    test( ret & MINCF_FILE_NOT_FOUND );
    mincf_free(&cfg);

    if (test(mincf_read(&cfg,"test.cfg") == MINCF_OK)) {
        ret = mincf_exists(&cfg,"thiskeydoesnotexist");
        test( ret != MINCF_OK );
        test( (ret & MINCF_ERROR) == 0 );
        test( (ret & MINCF_NOT_FOUND) != 0 );

        ret = mincf_exists(&cfg,"key6");
        printf("%s %04x\n","MINCF_OK",MINCF_OK);
        printf("%s %04x\n","MINCF_ERROR",MINCF_ERROR);
        printf("%s %04x\n","MINCF_NOT_FOUND",MINCF_NOT_FOUND);
        test( ret == MINCF_OK );
        test( (ret & MINCF_ERROR) == 0 );
        test( (ret & MINCF_NOT_FOUND) == 0 );

        if (test(mincf_get(&cfg,"key1",buf,sizeof(buf),NULL) == MINCF_OK)) {
            test(!strcmp(buf,"value1"));
        }
        test(mincf_get(&cfg,"test_overwrite_1",buf,sizeof(buf),NULL) == MINCF_OK);
        if (test(mincf_get(&cfg,"test_overwrite_2",buf,sizeof(buf),defvalue) == MINCF_OK)) {
            test(!strcmp(buf,"A very short comment."));
            printf("buffer content: '%s'\n",buf);
        }
        mincf_free(&cfg);
    }

    return 0;
}

int test0(char *file, unsigned int line, int expr, char *descr) {
    printf("%s has %s the test (line %d): %s\n",
        file, expr ? "PASSED" : "FAILED",
        line, descr);
    return expr;
}