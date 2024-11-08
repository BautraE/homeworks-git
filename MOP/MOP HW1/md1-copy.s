    # Text segments
    .text
    # Izlīdzināt uz 4 baitu robežas
    .align 2
    # Norāda simbolus, kuri būs globāli un pieejami izmantošanai
    .global asum

/* Apraksts:
   Lai iegūtu aritmētiskās progresijas summu, izmanto padoto vērtību
   r0 reģistrā un skaitot kopā rezultātu reģistrā r2. Skaitīšana notiek
   dilstošā formātā (no lielākā skaitļa līdz mazākajam). */

# Bloks, kas tiek izsaukts no C koda
asum:
    # Iestata r2 reģistra sākotnējo vērtību
    cmp     r0, #65535
    bgt     error
    mov     r2, #0
    cmp     r0, #0
    bgt     loop
    ble     error

# Condition bloks, kas pārbauda, vai ir vēl ko skaitīt klāt
cond:
    cmp     r0, #0
    bgt     loop
    beq     result

/* Cikla bloks, kur pie progresijas summas pieskaita
 nākamo vērtību un samazina iterāciju skaitu par 1 */
loop:
    add     r2, r0
    sub     r0, #1
    b       cond

# Rezultāta bloks, kas atgriež atbildi
result:
    mov     r0, r2
    bx      lr

# Kļūdu bloks, kas atgriež kļūdas kodu "0"
error:
    mov     r0, #0
    bx      lr
