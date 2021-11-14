
SEVENSEG_ROW:       EQU 7
SEVENSEG_COL_G:     EQU 6
SEVENSEG_COL_R:     EQU 5

    ORG     0x0900
    LD      A, 0x00
    OUT     (SEVENSEG_COL_R), A
    OUT     (SEVENSEG_ROW), A
    OUT     (SEVENSEG_COL_G), A
    CALL    DELAY
LOOP:   
    LD      A, 0x01
    OUT     (SEVENSEG_COL_G), A
    LD      C, 8
    LD      A, 1
LOOP1:  
    OUT     (SEVENSEG_ROW), A
    CALL    DELAY
    RLC     A
    DEC     C
    JP      NZ, LOOP1

    LD      A, 0x00
    OUT     (SEVENSEG_COL_R), A
    LD      C, 8
    LD      A, 1
LOOP2:
    OUT     (SEVENSEG_COL_G), A
    CALL    DELAY
    RLC     A
    DEC     C
    JP      NZ, LOOP2

    LD      A, 0x00
    OUT     (SEVENSEG_COL_R), A
    LD      C, 8
    LD      A, 0x80
LOOP3:
    OUT     (SEVENSEG_ROW), A
    CALL    DELAY
    RRC     A
    DEC     C
    JP      NZ, LOOP3

    LD      A, 0x00
    OUT     (SEVENSEG_COL_R), A
    LD      C, 8
    LD      A, 0x80
LOOP4:
    OUT     (SEVENSEG_COL_G), A
    CALL    DELAY
    RRC     A
    DEC     C
    JP      NZ, LOOP4
    JP      LOOP

DELAY:
    LD      DE, 0x06FF
    LD      B, A
DELAYLOOP:
    DEC     DE
    LD      A,E
    OR      D
    JP      NZ, DELAYLOOP
    LD      A, B
    RET
    
