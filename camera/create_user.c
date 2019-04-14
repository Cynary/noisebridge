#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>

//------------------------------------------------------------------------------
// Runs `strtol`, converting the string in `nptr` to an integer, and setting the
// value of `output` to that integer.
//
// Main difference between this function and strtol is that this function
// returns 0 if no error occurs, and the entire string in `nptr` is converted,
// otherwise it returns the errno in error cases, or EINVAL if the entire string
// in `nptr` was not converted.  Empty strings will return EINVAL.
//
// In error cases, the value of `output` is undefined.
//
// Assumes `nptr` is a well formed string (ending in '\0').
//
int
safe_strtol(
    const char* nptr,
    int base,
    long int* output)
{
    size_t nptrLen = strlen(nptr);
    if(nptrLen == 0)
    {
        return EINVAL;
    }

    char* end;
    errno = 0;
    *output = strtol(nptr, &end, base);

    return errno ?: (end == (nptr+nptrLen) ? 0 : EINVAL);
}

int
main(
    int argc,
    char** argv)
{
    long int uid;

    if(argc != 3 ||
       (safe_strtol(argv[1], 10 /*base*/, &uid) != 0))
    {
        printf("Usage: %s UID_NUM USER_NAME\n", argv[0]);
        return EINVAL;
    }

    int ret = setuid(0);

    if(ret != 0)
    {
        int error = errno;
        printf(
            "setuid(0) failed with error %d (%s)\n",
            error,
            strerror(error));

        return error;
    }

    const char* userName = argv[2];
    if(execlp("useradd", "useradd", "-m", "-u", argv[1], userName, NULL))
    {
        int error = errno;
        printf(
            "Failed to exec with error %d (%s)",
            error,
            strerror(error));

        return error;
    }

    return 0;
}
