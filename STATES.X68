; =============================================================================
; GAME STATE MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INITALIZES THE STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #STANONE,(STACUR)
            MOVE.W  #STAINTR,(STANEXT)
            JSR     SHOWHWIN
            RTS

; -----------------------------------------------------------------------------
STAUPD
; PERFORMS STATE UPDATE AND INIT IF NECESSARY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/D1/A0,-(A7)
            
            JSR     GETCYCLES               ; HARDWARE
            MOVE.L  D1,UPDINICY             ; HARDWARE
            
            CLR.L   D0
            MOVE.W  (STANEXT),D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD

            MOVE.W  D0,(STACUR)             ; IF STATE CHANGED, DO INIT
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
.DOUPD      CLR.L   D0                      ; IN ANY CASE, DO UPDATE
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            
            JSR     GETCYCLES               ; HARDWARE
            MOVE.L  D1,UPDFINCY             ; HARDWARE
            JSR     COUNTCYCLES             ; HARDWARE
            
            MOVEM.L (A7)+,D0/D1/A0
            RTS
.INITBL     DC.L    STAINTRI,STAPLAYI,STAEMPTY
.UPDTBL     DC.L    STAINTRU,STAPLAYU,STAGOVRU

; -----------------------------------------------------------------------------
STAPLOT
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/D1/A0,-(A7)
            
            JSR     GETCYCLES               ; HARDWARE
            MOVE.L  D1,PLOTINCY             ; HARDWARE
            
            CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0
            JSR     (A0)
            
            JSR     GETCYCLES               ; HARDWARE
            MOVE.L  D1,PLOTFICY             ; HARDWARE
            JSR     COUNTCYCLES             ; HARDWARE
            
            MOVEM.L (A7)+,D0/D1/A0
            RTS
.PLTTBL     DC.L    STAINTRP,STAPLAYP,STAGOVRP

; -----------------------------------------------------------------------------
STAEMPTY
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A PLACEHOLDER. NOTHING TO DO.
; -----------------------------------------------------------------------------
            RTS

; -----------------------------------------------------------------------------
STAPLAYI    EQU     PLRINIT
; PLAY STATE INITIALIZATION.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A WRAPPER FOR PLRINIT
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
STAPLAYU
; PLAY STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     PLRUPD
            JSR     SPWUPD
            BRA     AGLUPD

; -----------------------------------------------------------------------------
STAPLAYP
; PLAY STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     AGLPLOT
            BRA     PLRPLOT

; -----------------------------------------------------------------------------
STAINTRI    EQU     DMMINIT
; INTRO STATE INIT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A WRAPPER FOR DMMINIT TO RELEASE ALL MEMORY
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
STAINTRU
; INTRO STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            MOVE.W  #STAPLAY,(STANEXT)
.END        RTS

; -----------------------------------------------------------------------------
STAINTRP
; INTRO STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L A1/D0-D3,-(A7)
            UTLSPEN #INTTITC
            UTLSFIL #$00000000
            MOVE.B  #11,D3      ; NUMBER OF LINES
            LEA  .TITSTR,A1
            CLR.W   D2
            
            UTLLOCT INTTITX,INTTITY
.LOOP         
            MOVE.B  #11,D0
            TRAP    #15
    
            MOVE.B  #14,D0
            TRAP    #15
            ADD.W   #60,A1       ; ADD NUMBER OF CHARACTERS OF EVERY LINE
            ADD.W   #1,D1
            
            DBRA    D3,.LOOP 

            UTLLOCT INTPRSX,INTPRSY
            UTLSPEN #INTPRSC
            UTLSFIL #$00000000
            LEA     .PRSSTR,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEM.L (A7)+,A1/D0-D3
            RTS

.TITSTR     DC.B    '   ___ _     _      _                  __ _ _   _   _      ',0
            DC.B    '  / __| |__ (_) ___| | _____ _ __     / /(_| |_| |_| | ___ ',0
            DC.B    ' / /  | `_ \| |/ __| |/ / _ | `_ \   / / | | __| __| |/ _ \',0
            DC.B    '/ /___| | | | | (__|   |  __| | | | / /__| | |_| |_| |  __/',0
            DC.B    '\____/|_| |_|_|\___|_|\_\___|_| |_| \____|_|\__|\__|_|\___|',0
            DC.B    '                                                           ',0
            DC.B    '                 ___          _                            ',0
            DC.B    '                /   \___   __| | __ _  ___                 ',0
            DC.B    '               / /\ / _ \ / _` |/ _` |/ _ \                ',0
            DC.B    '              / /_/| (_) | (_| | (_| |  __/                ',0
            DC.B    '             /___,´ \___/ \__,_|\__, |\___|                ',0
            DC.B    '                                |___/                      ',0
            DS.W    0
            
.PRSSTR     DC.B    'PUSH SPACE TO START',0
            DS.W    0

; -----------------------------------------------------------------------------
STAGOVRU
; GAME OVER STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            MOVE.B  #30,D0      ; CLEAR THE CYCLE COUNTER
            TRAP    #15         ; THEREBY IT'S IMPOSSIBLE EXCEED
                                ; 32 BITS IN THE CYCLE COUNTER
            MOVE.W  #STAINTR,(STANEXT)
.END        RTS

; -----------------------------------------------------------------------------
STAGOVRP
; GAME OVER STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L A1/D0-D4,-(A7)
            UTLSPEN #GOVSTRC
            UTLSFIL #$00000000

            MOVE.B  #10,D3      ; NUMBER OF LINES
            LEA  .GOVSTR,A1
            CLR.W   D2
            UTLLOCT GOVSTRX,GOVSTRY   
.LOOP       ADD.W   #1,D1
            MOVE.B  #11,D0
            TRAP    #15
    
            MOVE.B  #14,D0
            TRAP    #15
            ADD.W   #28,A1       ; ADD NUMBER OF CHARACTERS OF EVERY LINE
            
            DBRA    D3,.LOOP    
            
            UTLLOCT INTPRSY,INTPRSY
            UTLSPEN #INTPRSC
            UTLSFIL #$00000000
            LEA     .LOST,A1
            MOVE.B  #14,D0
            TRAP    #15

            MOVE.W  #9,BARNSPD
            JSR     STOPMUSIC
            
            UTLLOCT INTPRSY,INTSCRY
            LEA     .SCORE,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            UTLLOCT INTSCRX,INTSCRY
            CLR.L   D1
            MOVE.W  (PLRSCORE),D1
            MOVE.B  #3,D0
            TRAP    #15
            
            MOVEM.L (A7)+,A1/D0-D4
            RTS

.GOVSTR         DC.B   '   ___                     ',0
                DC.B   '  / _ \__ _ _ __ ___   ___ ',0
                DC.B   ' / /_\/ _` | `_ ` _ \ / _ \',0
                DC.B   '/ /_\| (_| | | | | | |  __/',0
                DC.B   '\____/\__,_|_| |_| |_|\___|',0
                DC.B   '                           ',0
                DC.B   '      ___                  ',0
                DC.B   '     /_____   _____ _ __   ',0
                DC.B   '    //  /\ \ / / _ | `__|  ',0
                DC.B   '   / \_// \ V |  __| |     ',0
                DC.B   '   \___/   \_/ \___|_|     ',0
                DS.W    0
.LOST       DC.B    'THE SKY HAS FALLEN DOWN!',0
.SCORE      DC.B    'YOUR SCORE IS: ',0
            DS.W    0












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
