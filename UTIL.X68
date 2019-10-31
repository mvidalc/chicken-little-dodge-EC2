; =============================================================================
; UTILITY MACROS
; =============================================================================

; -----------------------------------------------------------------------------
UTLSPEN     MACRO
; WRAPPER FOR SET PEN TRAP 15 TASK.
; INPUT    - \1 COLOR IN FORMAT $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.B  #80,D0
            MOVE.L  \1,D1
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
UTLSFIL     MACRO
; WRAPPER FOR SET FIL TRAP 15 TASK.
; INPUT    - \1 COLOR IN FORMAT $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.B  #81,D0
            MOVE.L  \1,D1
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
UTLLOCT     MACRO
; WRAPPER TO TEXT POSITIONNING FROM TRAP 15
; INPUT    - \1 X, \2 Y
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.W  #\1<<8|\2, D1
            MOVE.B  #11,D0
            TRAP    #15
            ENDM


; =============================================================================
; UTILITY SUBROUTINES
; =============================================================================

; -----------------------------------------------------------------------------
UTLINIT
; INITIALIZES UTILITY CODE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            CLR.B   (UTLRNDIX)
            RTS
; -----------------------------------------------------------------------------
UTLCHCOL
; CHECKS COLLISION
; INPUT    - D0.W X0 COORDINATE
;            D1.W Y0 COORDINATE
;            D2.W X1 COORDINATE
;            D3.W Y1 COORDINATE
;            D4.W WIDTH 0
;            D5.W WIDTH 1
;            D6.W HEIGHT 0
;            D7.W HEIGHT 1
; OUTPUT   - D0.B=FF - COLLISION, =0 - NO COLLISION
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.W D4-D7,-(A7)
            ADD.W   D0,D4
            CMP.W   D2,D4
            BLE     .NOCOL
            ADD.W   D2,D5
            CMP.W   D0,D5
            BLE     .NOCOL
            ADD.W   D1,D6
            CMP.W   D3,D6
            BLE     .NOCOL
            ADD.W   D3,D7
            CMP.W   D1,D7
            BLE     .NOCOL
            MOVE.B  #$FF,D0
            BRA     .END
.NOCOL      CLR.B   D0
.END        MOVEM.W (A7)+,D4-D7
            RTS

; -----------------------------------------------------------------------------
UTLCHCOLBAR
; CHECKS COLLISION BAR - PLAYER
; INPUT    - D0.W PLAYER POSITION X
;            D1.W PLAYER POSITION Y
;            D2.W BAR POSITION X
;            D3.W BAR POSITION Y
; OUTPUT   - D7.B=FF - COLLISION, =0 - NO COLLISION
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.W D4-D5,-(A7)
            MOVE.W  D0,D4
            SUB.W   #160,D4
            CMP.W   D4,D2
            BNE     .NOCOL
            MOVE.W  D3,D5
            ADD.W   #(BARHEIGH),D5
            CMP.W   D5,D1
            BGT     .NOCOL
            MOVE.B  #$FF,D6
            BRA     .END
.NOCOL      CLR.B   D6
.END        MOVEM.W (A7)+,D4-D5
            RTS
            
; -----------------------------------------------------------------------------
UTLCHCOLCOIN
; CHECKS COLLISION COIN - PLAYER
; INPUT    - D0.W PLAYER POSITION X
;            D1.W PLAYER POSITION Y
;            D2.W BAR POSITION X
;            D3.W BAR POSITION Y
; OUTPUT   - D7.B=FF - COLLISION, =0 - NO COLLISION
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.W D4-D5,-(A7)
            MOVE.W  D0,D4
            CMP.W   D4,D2
            BNE     .NOCOL
            MOVE.W  D3,D5
            ADD.W   #(BARHEIGH),D5
            CMP.W   D5,D1
            BGT     .NOCOL
            MOVE.B  #$FF,D6
            BRA     .END
.NOCOL      CLR.B   D6
.END        MOVEM.W (A7)+,D4-D5
            RTS       

; -----------------------------------------------------------------------------
UTLRAND
; PROVIDES A PSEUDO-RANDOM BYTE
; INPUT    - NONE
; OUTPUT   - D0.L RANDOM VALUE (ONLY BYTE)
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  A0,-(A7)
            LEA     .RANDVEC,A0
            CLR.L   D0
            MOVE.B  (UTLRNDIX),D0
            MOVE.B  (A0,D0.L),D0
            ADDQ.B  #1,(UTLRNDIX)
            MOVE.L  (A7)+,A0
            RTS
            
.RANDVEC    DC.B    5, 6, 7, 3, 4, 5, 4, 1 
            DC.B    6, 7, 2, 4, 0, 5, 5, 1 
            DC.B    7, 3, 2, 7, 4, 1, 0, 6 
            DC.B    7, 1, 3, 5, 1, 3, 5, 6 
            DC.B    3, 1, 0, 2, 5, 1, 6, 3 
            DC.B    6, 4, 1, 6, 7, 4, 4, 0 
            DC.B    0, 3, 2, 2, 6, 3, 7, 4 
            DC.B    5, 1, 1, 4, 7, 5, 3, 6 
            DC.B    5, 0, 3, 2, 6, 7, 7, 0 
            DC.B    1, 5, 0, 3, 3, 3, 6, 1 
            DC.B    4, 1, 2, 3, 4, 7, 2, 7 
            DC.B    7, 7, 0, 5, 5, 3, 2, 1 
            DC.B    1, 2, 3, 6, 4, 7, 7, 6 
            DC.B    2, 6, 0, 0, 7, 5, 1, 2 
            DC.B    6, 2, 2, 7, 0, 1, 2, 0 
            DC.B    4, 7, 4, 1, 6, 1, 7, 1 
            DC.B    2, 5, 2, 1, 3, 7, 7, 3 
            DC.B    6, 6, 1, 1, 4, 1, 2, 7 
            DC.B    0, 0, 6, 1, 4, 2, 2, 5 
            DC.B    7, 7, 2, 0, 3, 0, 7, 7 
            DC.B    4, 5, 1, 3, 6, 0, 7, 7 
            DC.B    1, 5, 6, 7, 4, 5, 7, 7 
            DC.B    5, 0, 2, 1, 3, 7, 7, 0 
            DC.B    1, 4, 7, 2, 2, 2, 4, 7 
            DC.B    0, 6, 4, 2, 4, 5, 6, 5 
            DC.B    0, 5, 2, 5, 7, 6, 2, 6 
            DC.B    4, 3, 6, 7, 7, 2, 4, 2 
            DC.B    1, 0, 1, 2, 2, 2, 3, 4 
            DC.B    0, 5, 1, 2, 5, 1, 5, 3 
            DC.B    5, 5, 2, 3, 1, 5, 0, 2 
            DC.B    4, 2, 0, 5, 2, 1, 3, 2 
            DC.B    7, 7, 7, 1, 3, 2, 5, 6
            
            
; -----------------------------------------------------------------------------
UTLRNDPOS
; PROVIDES A PSEUDO-RANDOM WORD THAT IT WILL BE THE POSITION OF A BAR
; INPUT    - NONE
; OUTPUT   - D1.W RANDOM VALUE
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  A0,-(A7)
            LEA     .RNDPOS,A0
            CLR.L   D1
            MOVE.B  (UTLRNDIY),D1
            MOVE.B  (A0,D1.L),D1
            ADDQ.B  #1,(UTLRNDIY)
            MOVE.L  (A7)+,A0
            RTS
            
            
.RNDPOS     DC.B    0, 0, 1, 0, 1, 1, 0, 1
            DC.B    1, 0, 1, 1, 0, 0, 1, 0
            DC.B    0, 1, 0, 1, 1, 1, 1, 0
            DC.B    0, 1, 0, 1, 1, 1, 0, 0
            DC.B    1, 1, 1, 1, 1, 1, 0, 0
            DC.B    0, 0, 1, 1, 1, 0, 1, 1
            DC.B    0, 0, 1, 1, 0, 1, 0, 1
            DC.B    0, 0, 0, 0, 1, 1, 0, 1
            DC.B    1, 0, 0, 1, 0, 1, 1, 1
            DC.B    0, 1, 1, 0, 0, 1, 0, 0
            DC.B    1, 1, 1, 0, 1, 1, 1, 0
            DC.B    1, 0, 0, 1, 0, 0, 1, 1
            DC.B    0, 0, 0, 0, 0, 0, 1, 0
            DC.B    0, 0, 1, 1, 1, 1, 1, 0
            DC.B    0, 0, 0, 0, 1, 1, 0, 1
            DC.B    0, 0, 1, 0, 1, 1, 1, 0
            DC.B    0, 1, 0, 1, 1, 1, 0, 1
            DC.B    1, 0, 0, 0, 0, 1, 1, 0
            DC.B    1, 1, 1, 1, 0, 1, 1, 0
            DC.B    0, 1, 0, 0, 1, 0, 1, 1
            DC.B    1, 0, 0, 1, 1, 1, 1, 1
            DC.B    1, 1, 0, 0, 1, 0, 1, 1
            DC.B    1, 0, 1, 0, 1, 0, 0, 0
            DC.B    0, 0, 1, 1, 0, 0, 0, 0
            DC.B    1, 1, 1, 1, 1, 0, 0, 1
            DC.B    1, 0, 1, 1, 0, 0, 1, 0
            DC.B    1, 0, 0, 1, 0, 0, 1, 1
            DC.B    0, 0, 0, 0, 1, 1, 0, 1
            DC.B    0, 1, 0, 1, 1, 0, 0, 0
            DC.B    1, 0, 0, 1, 0, 1, 0, 0
            DC.B    1, 0, 1, 0, 1, 0, 0, 1
            DC.B    1, 1, 0, 1, 1, 1, 0, 1


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
