    # Text segments
    .text
    # Izlīdzināt uz 4 baitu robežas
    .align 2
    # Norāda simbolus, kuri būs globāli un pieejami izmantošanai
    .global matmul

# Bloks, kas tiek izsaukts no C koda
# int matmul( int h1, int w1, int *m1, int h2, int w2, int *m2, int *m3 );
matmul:
    pop     {r4} @ w2
    pop     {r5} @ m2 adr
    pop     {r6} @ m3 adr
    
    cmp     r1, r3 @ vai w1 sakrit ar h1
    bne     error
    
    push {r2}
    push {r5}
    lsl r0, #2
    lsl r1, #2
    lsl r3, #2
    lsl r4, #2
    mla r6, r3, r3, r6 @ gala adrese m3 
    push    {r3}
    push    {r4}

    mov     r7, #0 @ reg, kur rekinas atbildi
    
    b       loopRow
    
    @mov r0, r1
    @ldr r0, [sp, #0]
    @bx lr

@ Cikls ies cauri m1 rindām
loopRow:
    cmp     r0, #0 @ h1 ar 0
    bgt     loopCols
    b       result

@ Cikls ies cauri m2 kolonnām
loopCols:
    mov     r7, #0 @ reg, kur rekinas atbildi
    ldr     r2, [sp, #12]
    ldr     r5, [sp, #8]
    mla     r2, r0, r1, r2 @ m1 sakotneja adrese tiek pabidita
    mla     r5, r3, r4, r5 @ m2 sakotneja adrese tiek pabidita
    cmp     r4, #0 @ w2 ar 0
    bgt     loopCalc
    sub     r0, #4
    ldr     r4, [sp, #0]
    b       loopRow

loopCalc:
    cmp     r3, #0 @ w1 ar 0
    bgt     calc
    str     r7, [r6], #-4
    mov     r7, #0 @ reg, kur rekinas atbildi
    sub     r4, #4
    ldr     r3, [sp, #4] @ r3 OG vertiba
    b       loopCols

calc:
    ldr     r2, [sp, #12]
    ldr     r5, [sp, #8]
    mul r3, r0, r1
    add r2, r2, #8
    @ mla     r2, r0, r1, r2 @ m1 sakotneja adrese tiek pabidita
    ldr     r8, [r2]@, -r10 @ vertiba no matrix1
    ldr     r9, [r5]@, #-4 @ vertiba no matrix2
    
    mov r0, r0
    @ mov r0, #34
    bx lr
    
    mla     r7, r8, r9, r7 @ sareizina un pieliek klat elementa summai
    sub     r3, #4
    b       loopCalc

error:
    mov     r0, #1
    bx      lr

result:
    mov r0, #0
    bx      lr
