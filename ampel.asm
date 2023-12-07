ORG 0x00

MOV P1, #00000000b ; Initialisiere den Ampel-Port
MOV P2, #00000000b ; Initialisiere den Anzeige-Port

START:

  CALL PHASE1       ; Rufe Funktion PHASE1 auf: Phase 1: 0000000b
  CALL PHASE2       ; Rufe Funktion PHASE2 auf: Phase 2: 010101010b
  CALL PHASE3       ; Rufe Funktion PHASE3 auf: Phase 3: 0000000b
  CALL PHASE4       ; Rufe Funktion PHASE4 auf: Phase 4: 101010101b

  SJMP START        ; Springe zurück zum Anfang

PHASE1:
  MOV P1, #00000000b ; Setze Ampel-Port auf 0000000b
  MOV P2, #10011111b ; Setze Anzeige-Port auf eine 1
  ACALL DELAY        ; Rufe DELAY auf
  RET

PHASE2:
  MOV P1, #01010101b ; Setze Ampel-Port auf 010101010b
  MOV P2, #00100101b ; Setze Anzeige-Port auf eine 2
  ACALL DELAY        ; Rufe DELAY auf
  RET

PHASE3:
  MOV P1, #00000000b ; Setze Ampel-Port auf 0000000b
  MOV P2, #00001101b ; Setze Anzeige-Port auf eine 3
  ACALL DELAY        ; Rufe DELAY auf
  RET

PHASE4:
  MOV P1, #10101010b ; Setze Ampel-Port auf 101010101b
  MOV P2, #10011001b ; Setze Anzeige-Port auf eine 4
  ACALL DELAY        ; Rufe DELAY auf
  RET

DELAY:
  MOV R2, #10        ; Setze den "Zähler" (Wiederholungen) für die Verzögerung

DELAY_LOOP:
  NOP                ; Keine Operation (Verzögerung)
  NOP                ; Keine Operation (Verzögerung)
  NOP                ; Keine Operation (Verzögerung)
  DJNZ R2, DELAY_LOOP ; Dekrementiere R2 und springe zurück zum Schleifenanfang, wenn R2 nicht null ist
  RET

END
