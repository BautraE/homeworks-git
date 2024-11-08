#include "stdlib.h"
#include "stdio.h"
#include "md2.h"

int main(int argc, char *argv[])
{
    int  w1, h1, *matrix1, *p1;
    /*
    Nolasīs pirmos divus skaitļus no faila, sagaidot
    int tipa vērtības un saglabās iekš w un h mainīgos
    */
    scanf("%d", &h1);
    scanf("%d", &w1);
    /* 
    Buferu alokācija un cikls pa visiem matricas elementiem 
    Mainīgais matrix1 saturēs adresi blokam, kas ticis allocēts
    Sākumā pointeris būs uz šī bloka sākumu
    */
    matrix1 = (int*) malloc( w1 * h1 * sizeof(int));
    p1 = matrix1;

    for(int i=0; i<(w1*h1); i++)
    {
        scanf("%d", p1++);
    }
        
    // Ar 2. matricu dara to pašu, ko ar 1.    
    int  w2, h2, *matrix2, *p2;
    scanf("%d", &h2);
    scanf("%d", &w2);
    matrix2 = (int*) malloc( w2 * h2 * sizeof(int));
    p2 = matrix2;
    for(int i=0; i<(w2*h2); i++)
    {
        scanf("%d", p2++);
    }

    int *matrix3 = (int*) malloc( h1 * w2 * sizeof(int));
    int *p3 = matrix3;
    int ret = matmul(h1, w1, matrix1, h2, w2, matrix2, matrix3);
    // Kļūdas gadījums
    if(ret == 1) { 
        free(matrix1);
        free(matrix2);
        free(matrix3);
        exit(1);
    }
    // printf("Return value: %d\n", ret);
    // printf("Matrix3:\n");
    printf("%d %d\n", h1, w2);
    for(int kol=0; kol<h1; kol++) {
        printf("%d", *p3++);
        for(int row=1; row<w2; row++) {
            printf(" %d", *p3++);
        }
        printf("\n");
    }
    
    // Atbrīvo pieprasīto atmiņu:
    free(matrix1);
    free(matrix2);
    free(matrix3);
    return 0;
}

/*
    printf("Return value: %d\n", ret);
    p1 = matrix1;
    p2 = matrix2;
    printf("Matrix1:\n");
    for(int kol=0; kol<h1; kol++) {
        printf("%d", *p1++);
        for(int row=1; row<w1; row++) {
            printf(" %d", *p1++);
        }
        printf("\n");
    }
    printf("\n");
    printf("Matrix2:\n");
    for(int kol=0; kol<h2; kol++) {
        printf("%d", *p2++);
        for(int row=1; row<w2; row++) {
            printf(" %d", *p2++);
        }
        printf("\n");
    }
    printf("\n");
    printf("Matrix3:\n");
    for(int kol=0; kol<h1; kol++) {
        printf("%d", *p3++);
        for(int row=1; row<w2; row++) {
            printf(" %d", *p3++);
        }
        printf("\n");
    }
*/