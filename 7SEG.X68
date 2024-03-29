; =============================================================================
; HARDWARE WINDOW MANAGEMENT
; =============================================================================            

;------------------------------------------------------------------------------
COUNTCYCLES
; COUNTS NUMBER OF CYCLES AND SHOW IT ON THE HARDWARE WINDOW
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A0-A1,-(A7)
            LEA     SEGMADDR,A0             ; GET MAPPING ADDRESSES
            JSR     GTHWADDR
            MOVE.L  (SEGMADDR), A0          ; PLACE 7-SEGMENT ADDR INTO A0
            MOVE.L  (STCHADDR), A1          ; PLACE SWITCH BUTTONS ADDR INTO A1
            
            MOVE.L  (UPDINICY),D2
            MOVE.L  (UPDFINCY),D0
            SUB.L   D2,D0
            
            MOVE.W  (A1),D1
            BTST    #8,D1
            BNE     .NOCHG
            MOVE.L  (PLOTINCY),D2
            MOVE.L  (PLOTFICY),D0
            SUB.L   D2,D0
.NOCHG      JSR     NWRTSEGM
            MOVEM.L (A7)+,D0-D2/A0-A1        
            RTS

;------------------------------------------------------------------------------
GETCYCLES
; Get the number of Cycles at this moment.
; INPUT    - NONE
; OUTPUT   - D1.L - Number of cycles.
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L D0,-(A7)
            MOVE.B  #31,D0
            TRAP    #15
            MOVE.L (A7)+,D0
            RTS

; -----------------------------------------------------------------------------
NWRTSEGM
; Displays a 32 bit number as a hex string in the 7-segment display.
; Input    - D0.L: Number to display
;            A0  : Display set mapping address
; Output   - None
; Modifies - Nothing
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2,-(A7)
            MOVE.L  D0,D1                   ; COPY VALUE TO DISPLAY
            MOVE.W  #7,D2                   ; PREPARE DBRA
            AND.W   #$000F,D0               ; BEGIN WITH DISPLAY NUMBER 0
.LOOP       AND.W   #$0F0F,D0               ; MASK FOR VALUE AND DISPLAY NUMBER
            JSR     WRTSEGM                 ; DISPLAY THE DATA
            ADD.W   #$0100,D0               ; ADD ONE TO THE DISPLAY NUMBER
            LSR.L   #4,D1                   ; PREPARE THE NEXT NIBBLE
            MOVE.B  D1,D0                   ; TRANSFER IT TO D0
            DBRA.W  D2,.LOOP                ; LOOP FOR ALL NIBBLES
            MOVEM.L (A7)+,D0-D2
            RTS


; -----------------------------------------------------------------------------
SHOWHWIN
; Shows the hardware window
; Input    - None
; Output   - None
; Modifies - Nothing
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            MOVE.B  #32, D0
            CLR.B   D1
            TRAP    #15
            MOVEM.L (A7)+,D0-D1
            RTS

; -----------------------------------------------------------------------------
WRTSEGM
; Displays a number between $0 and $F in the specified 7-segment display
; Input    - D0.W: MSB: Display number, LSB value ($0-$F) to show. A display
;                  number of 0 means the rightmost display whilst a value of
;                  7 means the leftmost.
;            A0  : Display set mapping address
; Output   - None
; Modifies - Nothing
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A1,-(A7)
            MOVE.W  D0,D1
            AND.L   #$FF,D0
            NOT.W   D1
            LSR.W   #7,D1
            AND.L   #$0E,D1
            LEA     .DATA,A1
            MOVE.B  (A1,D0),(A0,D1)
            MOVEM.L (A7)+,D0-D1/A1
            RTS
.DATA       DC.B    $3F,$06,$5B,$4F,$66,$6D,$7D,$07,$7F,$6F,$77,$7C,$39,$5E,$79
            DC.B    $71

; -----------------------------------------------------------------------------
GTHWADDR
; Puts the addresses where the 7-segment display, the LED array, the switches
; and the toggle buttons are mapped in the RAM addresses beginning at A0 in
; the specified order.
; Input    - A0: Address to begin storing mapped hardware addresses.
; Output   - Addresses stored in RAM.
; Modifies - Nothing
; -----------------------------------------------------------------------------
            MOVEM.L A0-A1/D0-D2,-(A7)
            LEA     .DATA,A1
            MOVE.W  #3,D2
            MOVE.B  #32,D0
.LOOP       MOVE.B  (A1)+,D1
            TRAP    #15
            MOVE.L  D1,(A0)+
            DBRA.W  D2,.LOOP
            MOVEM.L (A7)+,A0-A1/D0-D2
            RTS

            ; TRAP #15 FUNCTION 32 PARAMETERS
.DATA       DC.B    1,2,3,7
            DS.W    0






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
