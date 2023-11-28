CSEG    at 0
    org 0

START_BUTTON_PIN equ P2.0
TIMER_DELAY equ 1   ; Verzögerung in ms

    init:
        mov TMOD, #1
        mov TL0, #010h
        mov TH0, #0FCh
        setb TR0
        mov dptr, #ampel_tab

    haupt:
        jb START_BUTTON_PIN, start_pressed
        sjmp haupt

    start_pressed:
        call wait_for_1ms

        movc A, @A+dptr
        mov P1, A

        jb START_BUTTON_PIN, haupt
        sjmp haupt

    wait_for_1ms:
        setb TF0            
        wait_loop:
            jnb TF0, wait_loop 
        clr TF0             
        ret

    ampel_tab:
        db  01110011b
        db  00110101b
        db  11010110b
        db  10110100b
        db  01110011b
        db  01110101b
        db  01101110b
        db  01110100b
        db  00000000b

    end
