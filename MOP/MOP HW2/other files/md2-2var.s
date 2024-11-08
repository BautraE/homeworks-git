    # Text segments
    .text
    # Izlīdzināt uz 4 baitu robežas
    .align 2
    # Norāda simbolus, kuri būs globāli un pieejami izmantošanai
    .global matmul

# Bloks, kas tiek izsaukts no C koda
/*
Reģistru saturi:
    R0: h1
    R1: w1
    R2: matrix 1 atmiņas pointeris
    R3: h2
    R4: w2
    R5: matrix 2 atmiņas pointeris
    R6: matrix 3 atmiņas pointeris
    R7: reg, kur rekinas atbildi
    R8: vertiba no matrix1
    R9: vertiba no matrix2
    R10: adreses nobīde m2
    R11:
 */

/*
2 3
1 2 3
4 5 6

3 2
1 2
4 5
3 6

1*1+2*4+3*3 1*2+2*5+3*6
4*1+5*4+6*3 4*2+5*5+6*6

18 30
42 69

Ārējais cikls iet caur 1. matricas rindām ({1,2,3} un (4,5,6))

Iekš ārējā būs vēl viens cikls, kas iet cauri 2. matricas kolonnām ({1,4,3} un {2,5,6})

Iekš otrā cikla iterēs cauri visiem elementiem 1. matricas 1 rindā un 2. matricas 1 kolonnā
Veicot darbības un beigās ierakstot vērtību matricā m3
 */
matmul:
@...

matmulCode:
    pop {r6} @ m3 adr
    pop {r5} @ m2 adr
    pop {r4} @ w2
    pop {r3} @ h2

    cmp r1, r3
    bne error
    @ mov r10, r1 @ vnk satures cik gara ir rinda (w1) m1 un kol (h2) m2

    push {r2}
    push {r5}
    mov r0, r0 lsl #2
    mov r1, r1 lsl #2
    mov r3, r3 lsl #2 // sanak, ka šis tagad atbrīvojies
    mov r4, r4 lsl #2
    mla r6, r3, r3, r6 @ gala adrese m3 
    push    {r3}
    push    {r4}
     
    mul r10, r1, r4 @ adreses nobīde m2
    //@ rsb r10, r10, #0 @ m2 adreses nobīdes pārvēršana uz negatīvo
    @ #-4 adreses nobīde m1
    b loopRow

loopRow:
    @ push    {r4}
    @ push    {r3}
    cmp     r0, #0 @ h1 ar 0
    bgt     loopCols
    b       result
loopCols:
    mov     r7, #0 @ reg, kur rekinas atbildi
    mla     r2, r0, r1, r2 @ m1 sakotneja adrese tiek pabidita
    mla     r5, r3, r4, r5 @ m2 sakotneja adrese tiek pabidita
    cmp     r4, #0 @ w2 ar 0
    bgt     loopCalc
    sub     r0, #4
    pop     {r4}
    b       loopRow
loopCalc:
    cmp     r3, #0 @ w1 ar 0
    bgt     calc
    str     r7, [r6], #4 @#-4
    sub     r4, #4
    pop     {r3} // r3 OG vertiba
    b       loopCols
calc:
    ldr     r8, [r2], -r10 @ vertiba no matrix1
    ldr     r9, [r5], #-4 @ vertiba no matrix2
    mla     r7, r8, r9, r7 @ sareizina un pieliek klat elementa summai
    sub     r3, #4
    b       loopCalc
error:
    mov     r0, #0
    bx      lr
result:
    bx      lr

    
    @ Meginajums saprast, kad un ka likt tas atmiņas nobides.
    /*
    Izskatas, ka japamaina ieks loopCalc r1 ka loop condition uz r3, jo
    tad tas ietekmes atmiņas bidisanu atpakal ta ka vajag m2.
    Vienigi pirms veic to atminas nobidi, vajadzetu atiestatit sakuma sakotnejo
    adresi matricam

    Alternativi butu jadoma kkads veids ka tikai mainit tas pasas nobides, kas
    ļaus visu laiku nepopot un nepušot šo adrešu vērtības.
    */

    @ sanak, ka katru reizi r2 samazinasies par 4
    /*
    Šī samazināšana notiks līdz sasniedz pirmo elementu no m1
    rindas.Pēc kā to vajag atjaunot uz pēdējo vietu atkal.
    Šis brīdis tiek panākts pie loopCalc, kad r1 būs 0. Manl te
    preteja gadijuma nepieciesams resetot vērtības, balstoties
    uz attiecīgās rindas beigām. Manl ka to var izdarit ar:
    r0*(garums m1 rindai (kas varētu tikt vnk glabāta kādā citā reg.)) lsl 2
    */

    @ un tad r5 samazinasies par platums*4
    /*
    Principā te var izmantot to pašu vērtību, kas tiek glabāta
    iepriekš minētajā reģistrā. Sanāk, ka samazināšana notiks ar
    sub darbību, kur samazinās par platumu lsl 2.
    Sanāk, ka šis brīdis būs panākts pie loopCalc arī.
    Lai šim atjaunotu sākotnējo adresi nākamajam ciklam, nāksies
    to iestatīt uz: (tas velviens registrs) * w2(r4) lsl 2.
    */

    
    //Izdaritie komentari:
    ///////////////////////////////////////////////////////////////////////////////////////
    // 1.
    @ te vel bus komanda, lai ierakstitu jauno vērtību iekš m3
    @ sakuma bus jaraksta ieks adreses w1*h2 jeb w1^2 vai h2^2
    @ katru reizi pec ierakstisanas, adrese samazinasies par 4
    /* 
    Principa var jau uzreiz nemt registru, kas satur h2, jo tas
    nekam citam netiek izmantots. Tad uzreiz arī var tajā iegūt
    gala adreses nobīdi (vai nu ar, vai bez lsl uzreiz).
    Sanāk katru reizi pēc iterācijas atņemot 4 iznāk, ka viss
    saliksies kā vajag.
    */

    //////////////////////////////////////////////////////////////////////////////////////////
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
    
    push    {r2}
    push    {r5}
    push    {r3}
    push    {r4}
    

    mul     r7, r0, r0
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

    ldr     r5, [sp, #8]
    @ m2 sakotneja adrese tiek pabidita
    ldr r7, [sp, #0] @ ielādē oriģinālo w2 no steka
    
    @ sub r7, r7, #1
    
    mul r7, r3, r7 @ reizina h2 ar w2
    sub r7, r7, r3 @ no reizinājuma atņem vienu kolonnu?? (vajag rindu)

    @ ldr r9, [r5]
    @ ldr r5, [sp, #8]
    @ ldr r7, [r7]
    mov r0, r7
    @ mov r0, #34
    bx lr
    
    add r7, r7, r4
    @sub r7, #1 // Aizklaju jo speciali atstaju +1, kas pec tam tpt tiek atnemts
    lsl r7, #2
    add r5, r5, r7


    
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


    mla     r7, r8, r9, r7 @ sareizina un pieliek klat elementa summai
    sub     r3, #1

    b       loopCalc

error:
    mov     r0, #1
    bx      lr

result:
    mov r0, #0
    bx      lr


