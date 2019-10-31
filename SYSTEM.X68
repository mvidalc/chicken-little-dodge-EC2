; =============================================================================
; SYSTEM MANAGEMENT (SYSTEM CODE)
; =============================================================================

; -----------------------------------------------------------------------------
SYSINIT
; INITIALIZES THE SYSTEM
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  (A7)+,A0                ; GET RETURN ADDRESS
            JSR     KBDINIT                 ; INIT KEYBOARD
            JSR     SCRINIT                 ; INIT SCREEN
            JSR     DMMINIT                 ; INIT DYNAMIC MEMORY
            ANDI.W  #$DFFF,SR               ; SWITCH TO USER
            MOVE.L  A0,-(A7)                ; PUT RETURN ADDRESS
            RTS

; =============================================================================
; SCREEN MANAGEMENT (SYSTEM CODE)
; =============================================================================

; -----------------------------------------------------------------------------
SCRINIT
; INITIALIZES THE SCREEN, SCREEN-RELATED INTERRUPT AND VARS.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - WHATEVER RESGISTER
; -----------------------------------------------------------------------------
            ; DISABLE INTS
            ANDI.W   #$F8FF,SR
            ORI.W    #(7<<8)&$700,SR
            ; INSTALL SCRUPD INTO TRAP SCRTRAP
            MOVE.L   #SCRUPD,($80+SCRTRAP*4)
            ; SET RESOLUTION 
            MOVE.B   #33,D0
            MOVE.L   #(SCRWIDTH<<16)|SCRHEIGH,D1
            TRAP     #15
            ; SET WINDOWED MODE  
            MOVE.L   #1,D1
            TRAP     #15
            ; CLEAR VISIBLE BUFFER
            MOVE.B   #11,D0
            CLR.L    D1
            MOVE.W   #$FF00,D1
            TRAP     #15
            ; ENABLE DOUBLE BUFFER      
            MOVE.L   #92,D0
            MOVE.L   #17,D1
            TRAP     #15
            ; CLEAR HIDDEN BUFFER
            MOVE.B   #11,D0
            CLR.L    D1
            MOVE.W   #$FF00,D1
            TRAP     #15
            ; INSTALL SCRISR FOR IRQ SCRIRQ
            MOVE.L   #SCRISR,($60+SCRIRQ*4)
            ; ENABLE AUTO-IRQ EVERY SCRTIM MS
            MOVE.B   #($1<<7+SCRIRQ),D2
            MOVE.L   #SCRTIM,D3
            MOVE.B   #6,D1
            MOVE.B   #32,D0
            TRAP     #15
            ; CLEAR SCRINTCT AND SCRCYCCT
            CLR.B    SCRINTCT
            CLR.B    SCRCYCCT
            ; ENABLE INTS
            ANDI.W   #$F8FF,SR
            ORI.W    #(0<<8)&$700,SR
            RTS

; -----------------------------------------------------------------------------
SCRISR
; SCREEN TIMER ISR. INCREASES THE INTERRUPT COUNTER AND UPDATES DOUBLE BUFFER.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ADDQ.B  #1,(SCRINTCT)           ; UPDATE INT FLAG/COUNTER
            ADDQ.B  #1,(SCRCYCCT)           ; UPDATE CYCLE COUNTER
            RTE

; -----------------------------------------------------------------------------
SCRUPD
; TRAP SERVICE ROUTINE IN CHARGE OF VISUALIZING CURRENT FRAME AND CLEARING
; BUFFER FOR THE NEXT ONE.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ; TO DO: UPDATE DOUBLE BUFFER AND CLEAR HIDDEN BUFFER
            MOVE.L  D0,-(A7)
            MOVE.B  #94,D0
            TRAP    #15
            MOVE.B  #11,D0                   ; CLEAR VISIBLE BUFFER
            CLR.L   D1
            MOVE.W  #$FF00,D1
            TRAP    #15
            MOVE.L  (A7)+,D0
            RTE

; =============================================================================
; KEYBOARD MANAGEMENT (SYSTEM CODE)
; =============================================================================

; -----------------------------------------------------------------------------
KBDINIT
; INITIALIZES THE SYSTEM VARIABLES KBDSYS AND KBDVAL
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            CLR.B   (KBDVAL)                ; INIT VARS
            CLR.B   (KBDEDGE)
            MOVE.L  #KBDREAD,($80+KBDTRAP*4) ; INSTALL
            RTS

; -----------------------------------------------------------------------------
KBDREAD
; TRAP SERVICE ROUTINE.
; UPDATES THE SYSTEM VARIABLES KBDEDGE AND KBDVAL ACCORDING TO THE BITFIELD
; DESCRIBED IN SYSCONST. KBDVAL HOLDS THE CURRENT VALUES AND KBDEFGE HOLDS
; RISING EDGES FROM PREVIOUS CALL TO THE CURRENT ONE.
; INPUT    - NONE
; OUTPUT   - (KBDVAL) AND (KBDEDGE)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D6/A0-A1,-(A7)
            MOVE.W  #7,D5
            MOVE.W  #31,D6
            MOVE.B  (SCRCYCCT),D4
            MOVE.B  (SCRINTCT),D3
            LEA.L   KBDVAL,A0
            LEA.L   KBDEDGE,A1
            MOVE.B  (A0),D2
            MOVE.L  #$00000000,(A0)         ; CLEAN KDBVAL
            CLR.L   D0
            
            MOVE.B  #19,D0
            MOVE.L  #(KBDPAUSE<<24+KBDFIRE3<<16+KBDFIRE2<<8+KBDFIRE1),D1 
            TRAP    #15
.LOOP       BTST    D6,D1
            BEQ     .KEYNEXT
            BSET    D5,(A0)
.KEYNEXT    SUB.W   #8,D6
            CMP.W   #4,D5
            BNE     .NOCHANGE
            MOVE.B  #19,D0
            MOVE.L  #(KBDDOWN<<24+KBDRIGHT<<16+KBDUP<<8+KBDLEFT),D1
            TRAP    #15
.NOCHANGE   DBRA    D5,.LOOP
            
            NOT     D2
            AND.B   (A0),D2            
            MOVE.B  D2,(A1)
            MOVE.B  D3,(SCRINTCT)
            MOVE.B  D4,(SCRCYCCT)
            MOVEM.L (A7)+,D0-D6/A0-A1
            RTE

; =============================================================================
; DYNAMIC MEMORY MANAGEMENT (SYSTEM CODE)
; DYNAMIC MEMORY IS A SET OF DMMBNUM SLOTS OF DMMBSIZE BYTES EACH ONE.
; DMMBSIZE MUST BE POWER OF TWO. A SLOT HAS:
; - HEADER - 1 WORD. SPECIFIES THE OWNER (0 MEANS OWNED BY SYSTEM)
; - DATA   - DMMBSIZE - 2 BYTES. MAY CONTAIN VARS AND ANY KIND OF DATA RELATED
;            THE THE OWNER. IF OWNER==0, DATA IS MEANINGLESS.
; =============================================================================

; -----------------------------------------------------------------------------
DMMINIT
; INITIALIZES THE DYNAMIC MEMORY TO ALL OWNED BY SYSTEM.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            LEA     DMMDATA,A0
            MOVE.W  #DMMBNUM-1,D0
.LOOP       MOVE.W  #DMMSYSID,(A0)
            ADD.L   #DMMBSIZE,A0
            DBRA.W  D0,.LOOP
            MOVEM.L (A7)+,D0/A0
            RTS

; -----------------------------------------------------------------------------
DMMFIRST
; SEARCHES THE FIRST MEMORY SLOT NOT OWNED BY SYSTEM AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - NONE
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            LEA     DMMDATA,A0
DMMFRLOP    TST.W   (A0)+
            BNE     DMMFRFND
            ADD.L   #DMMBSIZE-2,A0
DMMFRCOM    CMP.L   #DMMDATA+DMMBSIZE*DMMBNUM-1,A0
            BLT     DMMFRLOP
            MOVE.L  #0,A0
DMMFRFND    RTS

; -----------------------------------------------------------------------------
DMMNEXT
; SEARCHES THE NEXT MEMORY SLOT NOT OWNED BY SYSTEM AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - A0   : POINTER WITHIN THE CURRENT SLOT
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  D0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; TAKE ADVANTAGE OF ALIGNMENT
            ADD.L   #DMMBSIZE,D0
            MOVE.L  D0,A0
            MOVE.L  (A7)+,D0
            BRA     DMMFRCOM

; -----------------------------------------------------------------------------
DMMFRSTO
; SEARCHES THE FIRST MEMORY SLOT WITH THE SPECIFIED ID AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - D0.W : ID TO SEARCH
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            LEA     DMMDATA,A0
DMMFLOOP    CMP.W   (A0)+,D0
            BEQ     DMMFFND
            ADD.L   #DMMBSIZE-2,A0
DMMFCOM     CMP.L   #DMMDATA+DMMBSIZE*DMMBNUM-1,A0
            BLT     DMMFLOOP
            MOVE.L  #0,A0
DMMFFND     RTS

; -----------------------------------------------------------------------------
DMMNEXTO
; SEARCHES THE NEXT MEMORY SLOT WITH THE SPECIFIED ID AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - D0.W : ID TO SEARCH
;            A0   : POINTER WITHIN THE CURRENT SLOT
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  D0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; TAKE ADVANTAGE OF ALIGNMENT
            ADD.L   #DMMBSIZE,D0
            MOVE.L  D0,A0
            MOVE.L  (A7)+,D0
            BRA     DMMFCOM

; -----------------------------------------------------------------------------
DMMALLOC
; SEARCHES THE FIRST FREE (SYS OWNED) SLOT, ASSIGNS TO THE SPECIFIED OWNER
; AND RETURNS A POINTER TO THE CORRESPONDING DATA (SLOT ADDRESS + 2)
; INPUT    - D0.W : ID TO ASSIGN
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FREE SPACE
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            CLR.W   D0
            JSR     DMMFRSTO
            MOVE.W  (A7)+,D0
            CMP.L   #0,A0
            BEQ     .END
            MOVE.W  D0,-2(A0)
.END        RTS

; -----------------------------------------------------------------------------
DMMFREE
; FREES THE SLOT TO WHICH THE PROVIDED POINTER BELONGS BY SETTING ITS OWNED TO
; SYSTEM (0)
; INPUT    - A0   : POINTER BELONGING TO THE SLOT TO FREE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; TAKE ADVANTAGE OF ALIGNMENT
            MOVE.L  D0,A0
            CLR.W   (A0)
            MOVEM.L (A7)+,D0/A0
            RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
