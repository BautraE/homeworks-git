    # Text segments
    .text
    # Izlīdzināt uz 4 baitu robežas
    .align 2
    # Norāda simbolus, kuri būs globāli un pieejami izmantošanai
    .global matmul

/*
Algoritma doma:
    Rēķināšana notiek ar otrādāku secību, līdz ar to katrs cikls
    tiek pārbaidīts uzreiz ar padotajām vērtībām pret 0, tās pēc
    vajadzības atjaunojot no steka.

    M3 vērtības tiks rakstītas no beigām uz sākumu, katru reizi
    adresi nobīdot par -4.

    Pati funkcija sastāv no 3 cikliem: 
    1) iet caur visām rindām m1
    2) iet cauri visām kolonnām m2
    3) iet cauri visām rindas vērtībām no m1 un kolonnas vērtībām
    no m2 un veic aprēķinus

    Nepieciešamās adreses M1 un M2 tiek iegūtas šādi:
    m1: new_add = original_add + ((remaining_rows*w1)-1)*4
    m2: new_add = original_add(((h2-1) * w2) + remaining_cols - 1)

    3. ciklā pēc katras iterācijas m1 tiek bīdīts par -4 un m2 par
    konkrētu soli, kas tiek sākumā aprēķināts: w2 * 4
 */

/*
Kam lietoti reģistri:
    R0:     h1
    R1:     w1
    R2:     m1 adrese
    R3:     h2
    R4:     w2
    R5:     m2 adrese
    R6:     m3 adrese
    R7:     Pagaidu starpvērtības aprēķiniem, m3 vērtības
    R8:     Vērtību no m1
    R9:     Vērtību no m2
    R10:    Adreses nobīde m2, staigājot pa kolonnu
 */

# Bloks, kas tiek izsaukts no C koda
# int matmul( int h1, int w1, int *m1, int h2, int w2, int *m2, int *m3 );
matmul:
    @ Ieliek stekā oriģinālās r4-r10 reģistru vērtības
    @ Tiek ieliktas arī r2 un r3 vērtības, kuras būs nepieciešamas aprēķiniem
    push    {r2}
    push    {r3}
    push    {r4}
    push    {r5}
    push    {r6}
    push    {r7}
    push    {r8}
    push    {r9}
    push    {r10}
    /*
    Steka nobīdes:
    R2      #32
    R3      #28
    R4(OG)  #24
    R5(OG)  #20
    R6(OG)  #16
    R7(OG)  #12
    R8(OG)  #8
    R9(OG)  #4
    R10(OG) #0
     */
    ldr     r4, [sp, #36] @ w2
    ldr     r5, [sp, #40] @ m2 adr
    ldr     r6, [sp, #44] @ m3 adr

    @ pārbauda, vai w1 sakrit ar h1
    cmp     r1, r3 
    bne     error
    
    @ Iegūst gala adresi m3:
    mul     r7, r0, r4
    sub     r7, #1
    lsl     r7, #2
    add     r6, r6, r7 @ gala adrese m3

    @ Adreses nobīde m2 aprēķiniem:
    lsl     r10, r4, #2 @ w2 * 4

    @ Aprēķinu sākums:
    b       loopRow

# Cikls ies cauri m1 rindām
loopRow:    
    cmp     r0, #0 @ atlikušās rindas m1 ar 0
    bgt     loopCols
    b       result

# Cikls ies cauri m2 kolonnām
loopCols:
    @ Ielādē sākotnējo m1 adresi
    ldr     r2, [sp, #32]
    @ m1 sakotneja adrese tiek pabidita:
    @ new add = original add + (((remaining rows)*w1)-1)*4
    mul     r7, r0, r1 @ atlikušās kolonnas * w1
    sub     r7, #1  @ atņem 1, jo 1. sākas ar #0 nevis #4
    lsl     r7, #2 @ *4
    add     r2, r2, r7 @ pieskaita pie oriģinālās m1 adreses

    @ Ielādē sākotnējo m2 adresi
    ldr     r5, [sp, #40]
    @ m2 sakotneja adrese tiek pabidita
    @ new add = original add(((h2-1) * w2) + remaining cols - 1)
    sub     r3, r3, #1 @ h2 - 1
    ldr     r7, [sp, #36] @ ielādē oriģinālo w2
    mul     r7, r3, r7 @ reizina h2-1 ar w2
    add     r7, r7, r4 @ pieskaita atlikušo kolonnu skaitu
    sub     r7, #1 @ atņem 1, jo 1. sākas ar #0 nevis #4
    lsl     r7, #2 @ *4
    add     r5, r5, r7 @ pieskaita pie oriģinālās m2 adreses
    
    @ Atjauno iepriekšējo r3
    add     r3, r3, #1

    @ reģistrs, kurā rēkinas atbildes
    mov     r7, #0 

    cmp     r4, #0 @ atlikušās kolonnas m2 ar 0
    bgt     loopCalc
    sub     r0, #1
    ldr     r4, [sp, #36]
    b       loopRow

# Cikls rēķinās vienu vērtību
loopCalc:
    cmp     r3, #0 @ w1 ar 0
    bgt     calc
    str     r7, [r6], #-4
    sub     r4, #1
    ldr     r3, [sp, #28] @ r3 OG vertiba
    b       loopCols

# Vērtības aprēķina bloks
calc:    
    ldr     r8, [r2], #-4 @ vertiba no matrix1
    ldr     r9, [r5], -r10 @ vertiba no matrix2
    mla     r7, r8, r9, r7 @ sareizina un pieskaita klāt elementa summai
    sub     r3, #1
    b       loopCalc

# Kļūdas bloks
error:
    mov     r0, #1
    b       result

# Rezultāta bloks
result:
    @ Atjauno oriģinālās vērtības lietotiem reģistriem
    pop     {r10}
    pop     {r9}
    pop     {r8}
    pop     {r7}
    pop     {r6}
    pop     {r5}
    pop     {r4}
    @ Steka nobīdīšana uz sākumu
    pop     {r1} @ par iepušoto r3
    pop     {r1} @ par iepušoto r2
    pop     {r2} @ par atlikušajiem 3 funkcijas argumentiem
    pop     {r2}
    pop     {r2}
    bx      lr
