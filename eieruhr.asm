;-------------------------------------------------
;Countdown / Zaehlt auf Null
;in Minuten und Sekunden
;
; mit 4x7-segment anzeige
;
; P2.0 =  1er Sekunden => P3=R2
; P2.1 = 10er Sekunden => P3=R3
; P2.2 =  1er Minuten  => P3=R4
; P2.3 = 10er Minuten  => P3=R5
;
; Hauptprogrammschleife
;
; Start = P1.0
; Stop  = P1.1
; Reset = P1.2
; -------------------------------------------------
cseg at 0h
ajmp init
cseg at 100h

; ------------------------------------------------
; Interrupt für TIMER0: Einsprung bei 0Bh
;-------------------------------------------------
ORG 0Bh
call timer
reti
;-------------------------------------------------------
;init: TIMER wird initialisiert
; für 40 ms benötigt man einen 16 bit Timer
; das dauert zu lange in der Simulation! 
; Daher hier eine kurze Variante!
; Es wird nur von C0h auf FFh hochgezählt und 
; dann der Timer wird auf C0h gesetzt
; (für Hardware müsste das ersetzt werden!)
;-------------------------------------------------------
ORG 20h
init:
mov IE, #10010010b
mov tmod, #00000010b
mov r7, #01h ; Minuten
mov r6, #10h ; Sekunden
mov tl0, #0c0h  ; Timer-Initionalsierung 
mov th0, #0c0h
mov P1,#00h
setb P0.0 ; Merker für RESET
;-----------------------------------------------------------------------
; die Voreingestellten Minuten und Sekunden erscheinen auf dem Display
;-----------------------------------------------------------------------
call zeigen
;---------------------------
anfang:
jnb p1.0, starttimer
jnb p1.1, stoptimer
nurRT:
jnb p1.2, RT
jnb tr0, da
ajmp anfang
da:
call display
jnb P0.0, nurRT
ajmp anfang
;------------------------------
; Hauptprogrammschleife
;
; Start = P1.0
; Stop  = P1.1
; Reset = P1.2
;------------------------------
starttimer:
setb tr0; start timer0
setb P1.0
ajmp anfang
; stop Timer
stoptimer:
clr tr0; stop timer
setb P1.1
ajmp anfang
; reset Timer
RT:
clr tr0; stop timer
setb P1.2
ljmp init
;---------------------------------------------
; timer
; Zählt 1 Sekunde: 25 mal 40 Millisekunden
; 24mal wird nur die Anzeige "refresht"
; beim 25mal wird die Zeit runter gezählt
;(hier: nur 2mal und nur wenige my Sekunden)
;---------------------------------------------
timer:
inc r1
cjne r1, #02h, nuranzeige
mov r1, #00h
call countdown
ret

nuranzeige:
call display
ret

countdown:
cjne r6, #0h, sekunden
cjne r7, #0h, minuten
hupe:
clr tr0; stop timer
clr P0.0
ret

minuten:
mov r6, #3bh
dec r7
call zeigen
ret
sekunden:
dec r6
call zeigen
ret
;-------------------------------------------------------
; Anzeigewerte: holt die Anzeigewerte aus der Datenbank
; - erst wird aus dem Hex_Wert ein Dezimalwert : BCD-Umrechnung
; dann wird der Wert mit @A+DPTR aus der Datenbank 
; in die Register geschrieben
; 1er Sekunden => P3=R2
; 10er Sekunden => P3=R3
; 1er Minuten  => P3=R4
; 10er Minuten  => P3=R5
;-------------------------------------------------------
zeigen:
mov DPTR, #table
mov a, R6
mov b, #0ah
div ab
mov R0, a
movc a,@a+dptr
mov r3, a
mov a, r0
xch a,b
movc a, @a+dptr
mov r2, a
;----------------
mov a, R7
mov b, #0ah
div ab
mov R0, a
movc a,@a+dptr
mov r5, a
mov a, r0
xch a,b
movc a, @a+dptr
mov r4, a
call display
ret
;-----------------------------------------------
;   DISPLAY: steuert die 4x7 Segmentanzeige
;-----------------------------------------------
display:
mov P3, R2
clr P2.0
setb P2.0

mov P3, R3
clr P2.1
setb P2.1

mov P3, R4
clr P2.2
setb P2.2

mov P3, R5
clr P2.3
setb P2.3

ret
;-------------------------------------------------
; TABLE: Datenbank der 7-Segment-Darstellung
;-------------------------------------------------
org 300h
table:
db 11000000b
db 11111001b, 10100100b, 10110000b
db 10011001b, 10010010b, 10000010b
db 11111000b, 10000000b, 10010000b

end
