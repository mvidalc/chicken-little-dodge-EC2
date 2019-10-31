; =============================================================================
; COIN MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
; +0 WORD X COORDINATE
; +2 WORD Y COORDINATE
; +4 WORD X SPEED
; +6 WORD Y SPEED
; =============================================================================

; -----------------------------------------------------------------------------
CINIT
; INITALIZES A COIN
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - ASSUMES SCRHEIGH IS GREATER THAN 255
; -----------------------------------------------------------------------------
            MOVEM.W  D0/D1,-(A7)
            JSR     UTLRNDPOS
            CMP.B   #0,D1
            BEQ     .ET0
            MOVE.W  #3*SCRWIDTH/4,(A0)      ; X POSITION (IF D1.B = 1)
.ET1        MOVE.W  #0,2(A0)                ; Y POSITION STARTS AT THE TOP 
            MOVE.W  #0,4(A0)                ; X SPEED = 0
            MOVE.W  #20,6(A0)               ; Y SPEED IS CONSTANT
            MOVEM.W  (A7)+,D0/D1
            RTS
            
.ET0        MOVE.W  #SCRWIDTH/4,(A0)        ; X POSITION (IF D1.B = 0)
            BRA .ET1
; -----------------------------------------------------------------------------
CUPD
; UPDATES A COIN
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)                
            MOVE.W  6(A0),D0                ; UPDATE COORDINATES
            ADD.W   D0,2(A0)
            CMP.W   #(SCRHEIGH-(COINDIAM)/2),2(A0) ; CHECK BOUNCE
            BGT     .KILL
            
.COLPLAY    MOVE.W  (PLRPOSX),D0
            MOVE.W  (PLRPOSY),D1
            MOVE.W  (A0),D2
            MOVE.W  2(A0),D3
            JSR     UTLCHCOLCOIN
            TST.B   D6
            BEQ     .END
            JSR     AGLKILL
            MOVE.B  #MCOINREF,(SONGREF)     ; PLAYS THE COIN'S SOUND
            LEA     COINPATH,A1
            JSR     PLAYSOUND
            MOVE.B  #MICANREF,(SONGREF)
            LEA     ICANPATH,A1
            JSR     PLAYSOUND
            ADD.W  #10,(PLRSCORE)

.END        MOVE.W  (A7)+,D0
            RTS
.KILL       JSR     AGLKILL
            BRA     .COLPLAY

; -----------------------------------------------------------------------------
CPLOT
; PLOTS A COIN
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            UTLSPEN #$00000000
            UTLSFIL #CFILCL
            MOVEM.W D1-D4,-(A7)
            MOVE.W  (A0),D1
            MOVE.W  2(A0),D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #COINDIAM,D4
            ADD.W   #COINDIAM,D3
            MOVE.B  #88,D0
            TRAP    #15
            MOVEM.W (A7)+,D1-D4
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
