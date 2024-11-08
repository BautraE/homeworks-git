    # Text segments
    .text
    # Izlīdzināt uz 4 baitu robežas
    .align 2
    # Norāda simbolus, kuri būs globāli un pieejami izmantošanai
    .global matmul

# Bloks, kas tiek izsaukts no C koda
# int matmul( int h1, int w1, int *m1, int h2, int w2, int *m2, int *m3 );
matmul:
    push {r4-r10}

    /*
    R4  #24
    R5  #20
    R6  #16
    R7  #12
    R8  #8
    R9  #4
    R10 #0
     */

    bx lr
    ldr r4, [sp, #28]
    ldr r4, [sp, #32]
    pop     {r4} @ w2
    pop     {r5} @ m2 adr
    pop     {r6} @ m3 adr

    cmp     r1, r3 @ vai w1 sakrit ar h1
    bne     error
    
    push    {r2}
    push    {r5}
    push    {r3}
    push    {r4}
    

    mul     r7, r0, r4
    sub     r7, #1
    lsl     r7, #2
    add     r6, r6, r7 @ gala adrese m3

    lsl     r10, r4, #2 @ adreses nobīde m2

    b       loopRow

    @ mov     r7, #0 @ reg, kur rekinas atbildi
    

@ Cikls ies cauri m1 rindām
loopRow:
    @ ldr     r5, [sp, #8]
    @ @ m2 sakotneja adrese tiek pabidita
    @ mul r7, r3, r4
    @ @sub r7, #1 // Aizklaju jo speciali atstaju +1, kas pec tam tpt tiek atnemts
    @ lsl r7, #2
    @ add r5, r5, r7
    
    cmp     r0, #0 @ h1 ar 0
    bgt     loopCols
    b       result

@ Cikls ies cauri m2 kolonnām
loopCols:
    ldr     r2, [sp, #12]
    @ m1 sakotneja adrese tiek pabidita
    mul r7, r0, r1
    sub r7, #1
    lsl r7, #2
    add r2, r2, r7

    @ sub r4, #1

    ldr     r5, [sp, #8]
    @ m2 sakotneja adrese tiek pabidita
    @ ldr r7, [sp, #0] @ ielādē oriģinālo w2 no steka
    @ ldr r7, [sp, #4] @ r3 OG vertiba (h2)
    sub r3, r3, #1
    ldr r7, [sp, #0]
    mul r7, r3, r7 @ reizina h2-1 ar w2
    @ sub r7, r7, r3 @ no reizinājuma atņem vienu kolonnu?? (vajag rindu)
    add r7, r7, r4
    sub r7, #1
    @sub r7, #1 // Aizklaju jo speciali atstaju +1, kas pec tam tpt tiek atnemts
    lsl r7, #2
    add r5, r5, r7
    @ atgriez originalo r3
    ldr r3, [sp, #4]

    
    
    @ lsl r7, r4, #2
    @ sub r5, r5, r7
    @ reg, kur rekinas atbildi
    mov     r7, #0 

    cmp     r4, #0 @ w2 ar 0
    bgt     loopCalc
    sub     r0, #1
    ldr     r4, [sp, #0]
    b       loopRow

loopCalc:
    cmp     r3, #0 @ w1 ar 0
    bgt     calc

    @ str     r7, [r6]



    str     r7, [r6], #-4

    @ @ ldr r9, [r5]
    @ @ ldr r5, [sp, #8]
    @ @ ldr r7, [r5, #0]
    @ mov r0, r7
    @ @ mov r0, #34
    @ bx lr

    sub     r4, #1
    ldr     r3, [sp, #4] @ r3 OG vertiba
    b       loopCols

calc:
    @ mul r3, r0, r1
    @ sub r3, #1
    @ lsl r3, #2
    @ add r2, r2, r3
    @ mla     r2, r0, r1 lsl #2, r2 @ m1 sakotneja adrese tiek pabidita
    @ ldr r2, [sp, #12]

    
    ldr     r8, [r2], #-4 @ vertiba no matrix1
    ldr     r9, [r5], -r10 @ vertiba no matrix2
    @ ldr     r9, [r5]



    mla     r7, r8, r9, r7 @ sareizina un pieliek klat elementa summai
    sub     r3, #1

    b       loopCalc

error:
    mov     r0, #1
    bx      lr

result:
    mov r0, #0
    bx      lr


