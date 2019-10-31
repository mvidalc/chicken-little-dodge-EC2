; =============================================================================
; PLAYER MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
PLRINIT
; INITIALIZES THE PLAYER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.B  #MBKGREF,(SONGREF)
            LEA     BKGPATH,A1
            JSR     PLAYMUSIC
            
            MOVE.W  #(SCRWIDTH)/4,(PLRPOSX)
            MOVE.W  #SCRHEIGH-PLRHEIGH-20,(PLRPOSY)
            MOVE.W  #PLRINIEN,(PLRENER)
            CLR.W   (PLRSCORE)
            CLR.W   (PLRDMG)
            RTS

; -----------------------------------------------------------------------------
PLRUPD
; UPDATES THE PLAYER MOTION
; INPUT    - NONE (ACCESSES KBDVAL AND KBDEDGE)
; OUTPUT   - NONE (MODIFIES PLAYER DATA)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BCLR.B  #PLRUBDMG,(PLRDMG)
            BEQ     .NODMG
            SUB.W   #BARDMG,(PLRENER)
            BGT     .NODMG
            MOVE.W  #STAGOVR,(STANEXT)      ; IF LIFE IS 0, GAME OVER
.NODMG      MOVE.W  D1,-(A7)
            MOVE.B  (KBDVAL),D1             ; PERFORM MOTION
            ROR.B   #1,D1
            BCC     .CHKRT
            MOVE.W   #SCRWIDTH/4,(PLRPOSX)  ; THE PLAYER HAS ONLY 2 POSITIONS
            TST.W   (PLRPOSX)
            BGE     .CHKRT
            CLR.W   (PLRPOSX)
.CHKRT      ROR.B   #2,D1
            BCC     .MDONE
            MOVE.W   #3*(SCRWIDTH)/4,(PLRPOSX)
            CMP.W   #SCRWIDTH-PLRWIDTH,(PLRPOSX)
            BLE     .MDONE
            MOVE.W  #SCRWIDTH-PLRWIDTH,(PLRPOSX)
.MDONE      BTST.B  #KBDBITF1,(KBDEDGE)
            MOVE.W  (A7)+,D1
            RTS

; -----------------------------------------------------------------------------
PLRPLOT
; PLOTS THE PLAYER ITS LIFE AND THE SCORE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D6,-(A7) 
*            MOVE.L  #SHIRTCLR,D1           ; DECIDE COLOR
            BCLR.B  #PLRPBDMG,(PLRDMG)
            BEQ     .NODMG
            MOVE.L  #PLRDMGCL,D1

.NODMG      MOVE.B  #80,D0
            TRAP    #15
            ADDQ.B  #1,D0
            TRAP    #15
                                            ; PLOT THE PLAYER
            UTLSPEN #HAIRPCLR               
            UTLSFIL #HAIRFCLR
            MOVE.W  (PLRPOSX),D1            ; PLOT THE HAIR
            MOVE.W  (PLRPOSY),D2
            
            ADD.W   #(HEADSIZE/3),D1
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #HAIRW,D3
            ADD.W   #HAIRH,D4
            MOVE.B  #87,D0
            TRAP    #15 
            
            UTLSPEN #HEADPCLR               
            UTLSFIL #HEADFCLR
            MOVE.W  (PLRPOSX),D1            ; PLOT THE HEAD
            MOVE.W  (PLRPOSY),D2
            ADD.W   #HAIRH-5,D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #HEADSIZE,D3
            ADD.W   #HEADSIZE,D4
            MOVE.B  #88,D0
            TRAP    #15  
            
            UTLSPEN #GLASPCLR
            MOVE.W  (PLRPOSX),D1            ; PLOT THE GLASSES AND EYES
            MOVE.W  (PLRPOSY),D2 
            ADD.W   #HEADSIZE/5,D1          ; (LEFT)
            ADD.W   #HEADSIZE/2,D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #GLASDIAM,D3
            ADD.W   #GLASDIAM,D4
            MOVE.B  #91,D0
            TRAP    #15
            
            MOVE.W  D2,D6
            MOVE.W  D1,D5                   ; LEFT(EYE)
            UTLSPEN #$00000000
            MOVE.W  D5,D1
            ADD.W   #5,D1
            ADD.W   #5,D2
            MOVE.B  #82,D0
            TRAP    #15 
            
            UTLSPEN #GLASPCLR
            MOVE.W  D5,D1
            MOVE.W  D6,D2
            ADD.W   #HEADSIZE/3,D1          ; (RIGHT)
            MOVE.W  D1,D3
            ADD.W   #GLASDIAM,D3
            MOVE.B  #91,D0
            TRAP    #15
            
            MOVE.W  D1,D5                   ; RIGHT(EYE)
            UTLSPEN #$00000000
            MOVE.W  D5,D1
            ADD.W   #5,D1
            ADD.W   #5,D2
            MOVE.B  #82,D0
            TRAP    #15
            
            UTLSPEN #SHRTPCLR               
            UTLSFIL #SHRTFCLR
            MOVE.W  (PLRPOSX),D1            ; PLOT THE BODY (CIRCLE)
            MOVE.W  (PLRPOSY),D2
            ADD.W   #HAIRH-5,D2
            ADD.W   #HEADSIZE,D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #HEADSIZE,D3
            ADD.W   #HEADSIZE,D4
            MOVE.B  #88,D0
            TRAP    #15 
            
            MOVE.W  (PLRPOSX),D1
            ADD.W   #(HEADSIZE/2),D2        ; PLOT THE BODY (RECTANGLE)
            ADD.W   #BDYHEIGH,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            UTLSPEN #PNTSPCLR              
            UTLSFIL #PNTSFCLR
            MOVE.W  (PLRPOSX),D1            ; PLOT THE PANTS (LEFT)
            ADD.W   #BDYWIDTH,D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #PANTSW,D3
            ADD.W   #PANTSH,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            MOVE.W  D3,D1                   ; PLOT THE PANTS (RIGHT)
            ADD.W   #PANTSW,D3
            MOVE.B  #87,D0
            TRAP    #15
            UTLSPEN #PLRTXTCL               ; PLOT THE SCORE TEXT
            UTLSFIL #SKYCOLOR
            UTLLOCT PLRTXTX,PLRTXTY
            LEA     .SCORESTR,A1
            CLR.L   D1
            MOVE.W  (PLRSCORE),D1
            MOVE.B  #17,D0
            TRAP    #15

            UTLSPEN #$00FFFFFF              ; PLOT LIFE
            UTLSFIL #PLRLIFEC
            MOVE.W  #(SCRWIDTH-PLRINIEN)/2,D1
            MOVE.W  #PLRLIFEY,D2
            MOVE.W  (PLRENER),D3
            ADD.W   D1,D3
            MOVE.W  #PLRLIFEY+PLRLIFEH,D4
            MOVE.B  #87,D0
            TRAP    #15
            MOVE.W  #(SCRWIDTH+PLRINIEN)/2,D3
            MOVE.B  #90,D0
            TRAP    #15

            MOVEM.L (A7)+,D0-D6
            RTS
.SCORESTR   DC.B    'SCORE: ',0




*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
