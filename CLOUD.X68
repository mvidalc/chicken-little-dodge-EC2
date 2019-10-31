; =============================================================================
; CLOUD MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
; +0 WORD X COORDINATE
; +2 WORD Y COORDINATE
; +4 WORD X SPEED
; +6 WORD Y SPEED
; =============================================================================

; -----------------------------------------------------------------------------
CLDINIT
; INITALIZES A CLOUD
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - ASSUMES SCRHEIGH IS GREATER THAN 255
; -----------------------------------------------------------------------------
            MOVEM.W  D0/D1,-(A7)
            JSR     UTLRNDPOS
            CMP.B   #0,D1
            BEQ     .ET0
            MOVE.W  #SCRWIDTH/2,(A0)        ; X POSITION (IF D1.B = 1)
.ET1        MOVE.W  #0,2(A0)                ; Y POSITION STARTS AT THE TOP 
            MOVE.W  #0,4(A0)                ; X SPEED = 0
            CMP.W   #15,(BARCTR)
            BLT     .NOUPDSPD
            ADD.W   #1,BARNSPD
            MOVE.B  #MCMONREF,(SONGREF)
            LEA     CMONPATH,A1
            JSR     PLAYSOUND
            CLR.W   BARCTR
.NOUPDSPD   MOVE.W  BARNSPD,6(A0)           ; Y SPEED IS CONSTANT
            MOVEM.W  (A7)+,D0/D1
            RTS
            
.ET0        MOVE.W  #0,(A0)                 ; X POSITION (IF D1.B = 0)
            BRA .ET1
; -----------------------------------------------------------------------------
CLDUPD
; UPDATES A CLOUD
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)                
            MOVE.W  6(A0),D0                ; UPDATE COORDINATES
            ADD.W   D0,2(A0)
            CMP.W   #(SCRHEIGH-25-(BARHEIGH)/2),2(A0)
            BGT     .KILL
            
.COLPLAY    MOVE.W  (PLRPOSX),D0
            MOVE.W  (PLRPOSY),D1
            MOVE.W  (A0),D2
            MOVE.W  2(A0),D3
            JSR     UTLCHCOLBAR
            TST.B   D6
            BEQ     .END            
            JSR     AGLKILL
            MOVE.B  #MCOLREF,(SONGREF)      ; PLAYS THE COLLISION SOUND
            LEA     COLPATH,A1
            JSR     PLAYSOUND
            MOVE.B  #MOKREF,(SONGREF)
            LEA     OKPATH,A1
            JSR     PLAYSOUND
            MOVE.B  #PLRUMDMG|PLRPMDMG,(PLRDMG)

.END        MOVE.W  (A7)+,D0
            RTS
.KILL       JSR     AGLKILL
            ADD.W   #BARSCORE,(PLRSCORE)
            ADD.W   #1,(BARCTR)
            BRA     .COLPLAY

; -----------------------------------------------------------------------------
CLDPLOT
; PLOTS A CLOUD
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            UTLSPEN #BARCL
            UTLSFIL #BARCL
            MOVEM.W D1-D4,-(A7)
            MOVE.W  (A0),D1
            MOVE.W  2(A0),D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #BARHEIGH,D4
            ADD.W   #BARWIDTH,D3
            MOVE.B  #88,D0
            TRAP    #15         

            MOVEM.W (A7)+,D1-D4
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
