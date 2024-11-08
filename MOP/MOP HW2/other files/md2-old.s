/*
Reģistru saturi:
    R0: h1
    R1: w1
    R2: matrix 1 atmiņas pointeris
    R3: h2
    R4: w2
    R5: matrix 2 atmiņas pointeris
    R6: matrix 3 atmiņas pointeris
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
    cmp r1, r3
    @ bne error
    @ mov r10, r1 @ vnk satures cik gara ir rinda (w1) m1 un kol (h2) m2

    push {r2}
    push {r5}
    mov r0, r0 lsl #2
    mov r1, r1 lsl #2
    mov r3, r3 lsl #2
    mov r4, r4 lsl #2
    mul r3, r3 @ gala adrese m3 
    push {r1} @iepušo w1/h2 og vertibu uz steku
     
    mul r10, r1, r4 @ adreses nobīde m2
    //@ rsb r10, r10, #0 @ m2 adreses nobīdes pārvēršana uz negatīvo
    @ #-4 adreses nobīde m1
    mla r2, r0, r1, r2 @ m1 sakotneja adrese tiek pabidita
    mla r5, r3, r4, r5 @ m2 sakotneja adrese tiek pabidita
loopRow:
    cmp r0, #0 @ h1 ar 0
    bge loopCols
loopCols:
    cmp r4, #0 @ w2 ar 0
    mov r7, #0 @ reg, kur rekinas atbildi
    bge loopCalc
loopCalc:
    cmp r1, #0 @ w1 ar 0
    bge calc
calc:
    ldr r8, [r2], -r10 @ vertiba no matrix1
    ldr r9, [r5], #-4 @ vertiba no matrix2
    mla r7, r8, r9, r7
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
    
    
error:
    mov r0, #1
    bx lr
















    pop     {r6}    @ matrix3
    pop     {r5}    @ matrix2
    pop     {r4}    @ w2
    @ mov     r7, r0
    @ mov     r0, #0
    @ mla     r0 
    @ bx      lr

darbiba:
    mov r10, #0 @ skaititajs pirmas matricas rindai
    push {r10}
    mov r11, #0 @ skaititajs otras matricas kolonai
    mov r9, #0
    ldr r7, [r2]
    ldr r8, [r5]
    mla r9, r7, r8, r9
    ldr r7, [r2 #4 * (pasreizejais kartas numurs)]
    ldr r8, [r5 (4*elementu skaits rindā) * (pasreizejais kartas numurs)]

loop1row:
    pop {r10}
    cmp r0, r10
    bge loop1col

loop1col:
    @ add r10, r10, #4
    push {r10}
    
    ldr r7, [r2]
    ldr r8, [r5]

/*
Plāns, kā darbosies funkcija šajā failā:
    * Sākumā tiks veikta pārbaude uz to, vai padotās matricas
      ir derīgas.
    * Ja nav kaut kādas kļūdas, tad sāks reizināt. 
    Tiks ņemta vērtība no 1. matricas 1. elementa un reizinās to ar otrās matricas
    pirmo elementu. Tālāk pāries uz 1. matricas 1. rindas otro

 */

 matmul:
    PUSH {R4-R11, LR}          // Save registers and return address

    // Check if w1 == h2; if not, return 0 (error)
    CMP R1, R3
    BNE error                   // Branch to error if w1 != h2

    MOV R7, R0                  // Outer loop counter (row index in m1)
loop_rows:
    CMP R7, R0                  // Compare row index with h1
    BGE end                     // End loop if row index >= h1

    MOV R8, R4                  // Inner loop counter (column index in m2)
loop_cols:
    CMP R8, R4                  // Compare column index with w2
    BGE next_row                // Move to next row if column index >= w2

    MOV R9, #0                  // Dot product accumulator for m3 element
    MOV R10, R1                 // Element counter (dot product index)
dot_product:
    CMP R10, R1                 // Compare index with w1
    BGE store_result            // Store result if index >= w1

    // Load element from m1
    LDR R4, [R2, R7, LSL #2]    // Load m1 element (scaled by row)
    LDR R5, [R3, R8, LSL #2]    // Load m2 element (scaled by column)

    MLA R9, R4, R5, R9          // Multiply m1 * m2 and accumulate in R9

    ADD R10, #1                 // Increment dot product index
    B dot_product               // Repeat dot product calculation

store_result:
    STR R9, [R6, R7, LSL #2]    // Store dot product result in m3
    ADD R8, #1                  // Move to the next column
    B loop_cols                 // Repeat column loop

next_row:
    ADD R7, #1                  // Move to the next row
    B loop_rows                 // Repeat row loop

end:
    MOV R0, #1                  // Set return value to 1 (success)
    POP {R4-R11, PC}            // Restore registers and return

error:
    MOV R0, #0                  // Set return value to 0 (error)
    POP {R4-R11, PC}            // Restore registers and return