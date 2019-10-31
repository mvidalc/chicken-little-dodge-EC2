; =============================================================================
; MUSIC MANAGEMENT
; =============================================================================

;------------------------------------------------------------------------------
PLAYMUSIC
; LOADS AND PLAYS A SONG IN LOOP
; INPUT    - PATH OF THE SONG TO LOAD AND PLAY - A1
; OUTPUT   - NONE
; MODIFIES - NONE
;------------------------------------------------------------------------------
    MOVEM.L D0-D2,-(A7)
    
    MOVE.W  #74,D0              ; LOADS THE SOUND INTO SOUND MEMORY
    MOVE.B  SONGREF,D1
    TRAP    #15
    
    MOVE.W  #77,D0              ; PLAYS THE SOUND IN LOOP
    MOVE.L  #1,D2
    TRAP    #15
    
    
    MOVEM.L (A7)+,D0-D2
    RTS
    
    
    
;------------------------------------------------------------------------------
PLAYSOUND
; LOADS AND PLAYS A SOUND ONLY ONE TIME
; INPUT    - PATH OF THE SONG TO LOAD AND PLAY - A1
; OUTPUT   - NONE
; MODIFIES - NONE
;------------------------------------------------------------------------------
    MOVEM.L D0-D2,-(A7)
    
    MOVE.W  #74,D0              ; LOADS THE SOUND INTO SOUND MEMORY
    MOVE.B  SONGREF,D1
    TRAP    #15
    
    MOVE.W  #73,D0              ; PLAYS THE SOUND ONE TIME
    TRAP    #15
    
    
    MOVEM.L (A7)+,D0-D2
    RTS
    


;------------------------------------------------------------------------------
STOPMUSIC
; STOPS ALL THE MUSIC 
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
;------------------------------------------------------------------------------
    MOVEM.L D0/D2,-(A7)
   
    MOVE.W  #77,D0
    MOVE.L  #3,D2
    TRAP    #15
    
    MOVEM.L (A7)+,D0/D2
    RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
