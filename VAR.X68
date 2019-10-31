; =============================================================================
; GAME VARS
; =============================================================================

; --- GAME STATE RELATED VARIABLES --------------------------------------------

STACUR      DS.W    1                       ; CURRENT GAME STATE
STANEXT     DS.W    1                       ; NEXT GAME STATE

; --- PLAYER RELATED VARIABLES ------------------------------------------------

PLRPOSX     DS.W    1                       ; PLAYER X POSITION (PIXELS)
PLRPOSY     DS.W    1                       ; PLAYER Y POSITION (PIXELS)
PLRENER     DS.W    1                       ; PLAYER ENERGY
PLRSCORE    DS.W    1                       ; PLAYER SCORE
PLRDMG      DS.B    1                       ; BIT0: UPD DAMAGE, BIT1 PLOT DMG
            DS.W    0
; --- BAR RELATED VARIABLES ---------------------------------------------------
            
BARNSPD     DC.W    9                       ; BAR REAL SPEED VARIABLE
BARCTR      DS.W    1                       ; IT COUNTS THE NUMBER OF BARS
            DS.W    0
           
; --- UTILITY VARIABLES -------------------------------------------------------

UTLRNDIX    DS.B    1                ; NEXT INDEX TO RANDOM NUMBER (UTLRAND)
UTLRNDIY    DS.W    1                ; NEXT INDEX TO RANDOM NUMBER (UTLRNDPOS)
            DS.W    0
            
; --- MUSIC VARIABLES ---------------------------------------------------------

SONGREF     DS.B    1               ; IT HAS THE NUMBER REFERENCE OF A SONG
            DS.W    0
            
; --- HARDWARE VARIABLES ------------------------------------------------------

SEGMADDR    DS.L    1            ; POINTERS TO THE ADDRESS OF HARDWARE SECTIONS
LEDADDR     DS.L    1
STCHADDR    DS.L    1
BUTADDR     DS.L    1

UPDINICY    DS.L    1                       ; CYCLES BEFORE UPDATE 
UPDFINCY    DS.L    1                       ; CYCLES AFTER UPDATE
PLOTINCY    DS.L    1                       ; CYCLES BEFORE PLOT 
PLOTFICY    DS.L    1                       ; CYCLES AFTER PLOT
            DS.W    0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
