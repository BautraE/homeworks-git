#include "stdio.h"
#include "stdlib.h"
#include "md1.h"

// int main(int argc, char *argv[])
// {
//     unsigned int val = atoi(argv[1]);
//     int ret = asum(val);
//     printf("Val = %d        Ret = %d \n", val, ret);
//     // printf(val);
//     val = 1;
//     do {
//         ret = asum(val);
//         printf("Val = %d        Ret = %d \n", val, ret);
//         val = val + 1;
//     } while (ret > 0);
//     return 0;
// }
// 2147450880
// 4294901760
// 4294967295 ir lielakais skaitlis, ko var ierakstit aritmetiskaja progresija
// qemu-arm -L /usr/arm-linux-gnueabi ./md1
// 65535 max vertiba, ko var padot funkcijai, lai ta negativu neatgriez

// Variants, kur pārbauda, vai nav palaists kods bez argumenta
    // int ret;
    // int val;
    // if(argc < 2) val = 0;
    // else val = atoi(argv[1]);
    // ret = asum(val);
    // // printf("Val = %d        Ret = %d \n", val, ret);
    // printf("%d\n", ret);
    // return 0;

// Variants, kur iet cauri visiem padotiem argumentiem
    // int ret;
    // int val;
    // if(argc < 2) {
    //     val = 0;
    //     ret = asum(val);
    //     // printf("Val = %d        Ret = %d \n", val, ret);
    //     printf("%d\n", ret);
    // }
    // else {
    //     int i = 1;
    //     do {
    //         val = atoi(argv[i]);
    //         ret = asum(val);
    //         // printf("Val = %d        Ret = %d \n", val, ret);
    //         printf("%d\n", ret);
    //         i++;
    //     } while(i < argc);
    // }
    // return 0;

int main(int argc, char *argv[])
{
    int ret;
    long int val;
    char *endptr;

    if(argc < 2) val = 0;
    else {
        val = strtol(argv[1], &endptr, 10);
        if (*endptr != '\0') val = 0;
    }
    ret = asum(val);
    printf("%d\n", ret);
    return 0;
}