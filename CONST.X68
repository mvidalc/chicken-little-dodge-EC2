; =============================================================================
; SYSTEM CONSTANTS
; =============================================================================

; --- GAME STATES -------------------------------------------------------------

STANONE     EQU     -1                      ; PLACEHOLDER TO FORCE CHANGE
STAINTR     EQU     0                       ; INTRO/PRESS FIRE STATE
STAPLAY     EQU     1                       ; NORMAL GAME STATE
STAGOVR     EQU     2                       ; GAME OVER STATE

; --- AGENT TYPES -------------------------------------------------------------

BARTYPE     EQU     1

; --- PLAYER RELATED CONSTANTS ------------------------------------------------

PLRWIDTH    EQU     24                      ; PLAYER WIDTH (PIXELS)
PLRHEIGH    EQU     61                      ; PLAYER HEIGHT (PIXELS)

HAIRH       EQU     10                      ; PLAYER HAIR HEIGH
HAIRW       EQU     8                       ; PLAYER HAIR WIDTH
HAIRPCLR    EQU     $00000000               ; HAIR FIL COLOR
HAIRFCLR    EQU     $000000FF               ; HAIR PEN COLOR
HEADSIZE    EQU     24                      ; PLAYER HEAD DIAMETER
HEADPCLR    EQU     $00000000               ; PLAYER HEAD FIL COLOR
HEADFCLR    EQU     $00FFFFFF               ; PLAYER HEAD PEN COLOR
GLASDIAM    EQU     9                       ; PLAYER GLASSES DIAMETER
GLASPCLR    EQU     $005BDA5F               ; PLAYER GLASSES PEN COLOR

BDYHEIGH    EQU     10                      ; PLAYER BODY HEIGH
BDYWIDTH    EQU     24                      ; PLAYER BODY WIDHT
SHRTFCLR    EQU     $005BDA5F               ; PLAYER SHIRT FIL COLOR
SHRTPCLR    EQU     $00FFFFFF               ; PLAYER SHIRT PEN COLOR
PANTSH      EQU     8                       ; PLAYER PANTS HEIGH
PANTSW      EQU     PLRWIDTH/2              ; PLAYER PANTS WIDTH
PNTSPCLR    EQU     $00000000               ; PLAYER PANTS PEN COLOR
PNTSFCLR    EQU     $00336699               ; PLAYER PANTS FIL COLOR


PLRINIEN    EQU     30                      ; PLAYER INITIAL ENERGY (<SCRWIDTH)
PLRSPEED    EQU     20                      ; PLAYER SPEED (PIXELS PER INT)
PLRDMGCL    EQU     $000000FF               ; PLAYER DAMAGED COLOR
PLRTXTCL    EQU     $00FFFFFF               ; FONT COLOR
PLRTXTX     EQU     2                       ; SCORE X COORDINATE
PLRTXTY     EQU     1                       ; SCORE Y COORDINATE
PLRLIFEH    EQU     20                      ; HEIGHT OF LIFE BAR
PLRLIFEY    EQU     12                      ; LIFE BAR Y POS
PLRLIFEC    EQU     $000000FF               ; LIFE BAR COLOR
PLRUMDMG    EQU     %00000001               ; UPDATE DAMAGE MASK
PLRPMDMG    EQU     %00000010               ; PLOT DAMAGE MASK
PLRUBDMG    EQU     0                       ; UPDATE DAMAGE BIT
PLRPBDMG    EQU     1                       ; PLOT DAMAGE BIT
GRNDCLR     EQU     $00103258               ; GROUND COLOR
SKYCOLOR    EQU     $00C5B83E               ; SKY COLOR

; --- CLOUD RELATED CONSTANTS -------------------------------------------------

BARHEIGH    EQU     15                      ; CLOUD HEIGH
BARWIDTH    EQU     SCRWIDTH/2              ; CLOUD WIDTH
BARCL       EQU     $00FFFFFF               ; CLOUD COLOR
BARDMG      EQU     10                      ; BAR DAMAGE  TO PLAYER
BARSCORE    EQU     5                       ; BAR POINTS

; --- COIN RELATED CONSTANTS --------------------------------------------------

COINDIAM    EQU     20                      ; DIAMETER OF A COIN
CPENCL      EQU     $00000000               ; COIN ITEM PEN COLOR
CFILCL      EQU     $0033CCCC               ; COIN ITEM FIL COLOR

; --- INTRO STATE RELATED CONSTANTS -------------------------------------------

INTTITX     EQU     12                      ; TITLE X COORDINATE
INTTITY     EQU     3                       ; TITLE Y COORDINATE
INTTITC     EQU     $000000FF               ; TITLE COLOR
INTPRSX     EQU     31                      ; PRESS FIRE X COORDINATE
INTPRSY     EQU     28                      ; PRESS FIRE Y COORDINATE
INTPRSC     EQU     $00FFFFFF               ; PRESS FIRE COLOR
INTSCRX     EQU     43                      ; FINAL SCORE X COORDINATE
INTSCRY     EQU     30                      ; FINAL SCORE Y COORDINATE


; --- GAME OVER STATE RELATED CONSTANTS ---------------------------------------

GOVSTRX     EQU     25                      ; TITLE X COORDINATE
GOVSTRY     EQU     5                       ; TITLE Y COORDINATE
GOVSTRC     EQU     $00FFFFFF               ; TITLE COLOR

; --- MUSIC RELATED CONSTANTS -------------------------------------------------

MBKGREF     EQU     0                    ; REFERENCE NUMBER OF BACKGROUND SONG
MCOLREF     EQU     1                    ; REFERENCE NUMBER OF COLLISION SOUND
MCOINREF    EQU     2                    ; REFERENCE NUMBER OF COIN SOUND
MCMONREF    EQU     3                    ; REFERENCE NUMBER OF COME ON SOUND
MICANREF    EQU     4                    ; REFERENCE NUMBER OF I CAN SOUND
MOKREF      EQU     5                    ; REFERENCE NUMBER OF YOU OKAY SOUND
BKGPATH     DC.B    'BackgroundSong.wav',0
COLPATH     DC.B    'collisionSound.wav',0
COINPATH    DC.B    'coinSound.wav',0
CMONPATH    DC.B    'SoundComeOn.wav',0
ICANPATH    DC.B    'SoundICanDoThis.wav',0
OKPATH      DC.B    'SoundYouOkay.wav',0



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
