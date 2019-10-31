; =============================================================================
; SPAWNER MANAGEMENT.
; =============================================================================

; -----------------------------------------------------------------------------
SPWUPD
; UPDATES THE SPAWNER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L  D0/A1-A3,-(A7)
            
            LEA     SKYCOLOR,A0             ; PLOTS THE BACKGROUND
            MOVE.W  2(A0),D1
            MOVE.B  #81,D0
            TRAP    #15
            CMP.W   #15,(BARCTR)
            UTLSFIL #SKYCOLOR               ; DRAWS THE SKY
            CLR.L   D1
            CLR.L   D2
            MOVE.W  #SCRWIDTH,D3
            MOVE.W  #SCRHEIGH,D4
            MOVE.B  #87,D0
            TRAP    #15
            UTLSPEN #GRNDCLR              ; DRAWS THE GROUND
            UTLSFIL #GRNDCLR
            CLR.L   D1
            MOVE.W  (PLRPOSY),D2
            ADD.W   #PLRHEIGH,D2
            MOVE.B  #87,D0
            TRAP    #15
            
            
            MOVE.B  (SCRCYCCT),D0
            AND     #$0F,D0                 ; EVERY 16 CYCLES
            BNE     .END                    ; CREATE A NEW ASTEROID
            
            JSR     UTLRAND
            CMP.B   #2,D0
            BNE     .BAR
            LEA     CINIT,A1
            LEA     CUPD,A2
            LEA     CPLOT,A3
            MOVE.W  #BARTYPE,D0
            JSR     AGLADD            
            
            JSR     UTLRNDPOS
.BAR        LEA     CLDINIT,A1
            LEA     CLDUPD,A2
            LEA     CLDPLOT,A3
            MOVE.W  #BARTYPE,D0
            JSR     AGLADD
.END        MOVEM.L (A7)+,D0/A1-A3
            RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
