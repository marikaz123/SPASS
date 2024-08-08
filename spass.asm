;----------------------------------------------------------------------------
; *** SPASS ver. 1.4 ***  MOD2401 *** (c)1995 'marikaz'
;----------------------------------------------------------------------------

_TEXT SEGMENT WORD PUBLIC 'CODE'
      ASSUME cs:_TEXT

MINPWLENGTH = 10        ;min. ilocs znakow hasla
MAXPWLENGTH = 32        ;max. ilocs znakow hasla

JUMPS

ORG 100h
start:
            mov di,OFFSET fData
            mov cx,MAXPWLENGTH SHL 1  ;oba bufory
            mov al,0
            rep stosb
            jmp begin

fName       DB 'SPASS.DAT',0
epTxt       DB 'PASSWORD: $'
fErrTxt     DB 'F.ERROR$'
cPos        DW ?

clrLine     PROC
            mov ah,2
            mov dx,cPos
            int 10h
            mov ax,920h      ;spacje
            mov bx,7
            mov cx,80
            int 10h
            ret
clrLine     ENDP

begin:
            mov ah,3
            xor bx,bx
            int 10h
            mov cPos,dx

            mov ah,4eh          ;poszukaj 'spass.dat'
            lea dx,fName
            mov cx,11b
            int 21h
            jc getPasswdA

            mov ax,3d00h
            lea dx,fName
            int 21h
            jc fError

            mov bx,ax
            mov ah,3fh
            lea dx,fData
            mov cx,-1
            int 21h
            jc fError
            cmp ax,MAXPWLENGTH
            jne wrongPWD  ;ktos majstrowal przy pliku?

            mov ah,3eh
            int 21h
            jc fError

            lea dx,epTxt
            mov ah,9
            int 21h

            mov cx,MAXPWLENGTH
            lea di,passw
getPass:
            mov ax,0c07h
            int 21h
            cmp al,0dh
            je next
            stosb
            loop getPass

            mov ah,7     ;po <MAXPWLENGTH> znakach czeka
            int 21h
            cmp al,0dh   ;ale tylko na pojedynczy enter
            je next
   wf13h_1:              ;dalsze wpisywanie znakow
            mov ah,7     ;jest jednoznaczne ze zlym haslem
            int 21h      ;bo haslo moze miec max. <MAXPWLENGTH> zn.
            cmp al,0dh   ;..ale cierpliwie czekamy na enter
            jne wf13h_1  ;              ''
            jmp wrongPWD ;by oficjalnie stwierdzic ze to zle haslo
next:
            call clrLine
            mov dx,WORD PTR [di-2] ;ostatnie 2 znaki hasla nie byly
                                   ;nigdzie zapisywane, ale biora czynny
                                   ;udzial w dekodowaniu zakodowanych znkow.
            mov WORD PTR [di-2],0  ;W kodowaniu i dekodowaniu uczestniczy
                                   ;CALY bufor dlatego trzeba przywrocic
                                   ;wartosci 'startowe'.
            sub dh,30
            lea di,passw
            lea si,fData
            mov cx,MAXPWLENGTH
decrypt:
            lodsb
             xor al,dl  ;.
             add al,cl  ; .
             rol al,cl  ;   . instrukcje dekodujace
             not al     ; .
             sub al,dh  ;.
            cmp BYTE PTR [di],al ; . do pierwszej niezgodnosci
            jne wrongPWD         ;.
            inc di
            loop decrypt
            jmp exit     ;haslo prawidlowe

;---------- USTAW HASLO ADMINISTRATORA -----------------------------
getPasswdA:
            mov ah,9
            lea dx,epTxt
            int 21h
            lea di,passw
            mov cx,MAXPWLENGTH
getPassA:
            mov ah,0
            int 16h
            cmp al,0dh     ;enter - koniec hasla
            je endPass
            cmp al,20h
            jb getPassA    ;bez znakow sterujacych (ale ze spacja)
            cmp al,7eh
            ja getPassA    ;bez znakow rozszerzonych i DEL

            mov dl,al
            mov ah,6       ;pokaz znaki
            int 21h
            stosb
            loop getPassA
   wf13h_2:
            mov ah,0    ;po <MAXPWLENGTH> znakach czeka
            int 16h
            cmp al,0dh  ;na enter od 'admina'
            jne wf13h_2
endPass:
            mov ax,MAXPWLENGTH   ;haslo >= 10 znakow
            sub ax,cx
            cmp ax,MINPWLENGTH
            jb getPassA

            call clrLine
            mov dx,WORD PTR [di-2]   ;ostatnie 2 znaki wezma udzial
                                     ;w kodowaniu pozostalych znakow,
                                     ;ale nie beda zapisane i szyfrowane
            mov WORD PTR [di-2],0    ;trzeba przywrocic pierwotna
                                     ;zawartosc bufora bo CALY jest kodowany
            sub dh,30
            lea si,passw
            lea di,fData
            mov cx,MAXPWLENGTH
encrypt:
            lodsb
             add al,dh   ;.
             not al      ; .
             ror al,cl   ;  . instrukcje kodujace
             sub al,cl   ; .
             xor al,dl   ;.
            stosb
            loop encrypt

            mov ah,3ch
            lea dx,fName
            mov cx,0     ;atrybut
            int 21h
            jc  fError
            mov bx,ax

            mov ah,40h
            lea dx,fData
            mov cx,MAXPWLENGTH
            int 21h
            jc fError

            mov ah,3eh
            int 21h
            jc fError

            mov ax,4301h  ;ustaw atrybut dla 'spass.dat'
            mov cx,11b    ;hidden, read-only
            lea dx,fName
            int 21h
exit:
            mov ah,4ch
            int 21h
fError:
            mov ah,9
            lea dx,fErrTxt
            int 21h
            jmp exit

wrongPWD:
            call clrLine

;---------- OBSLUGA BLEDNEGO HASLA ------------------------

            mov al,0adh   ;wylacz klawiature
            out 64h,al
            jmp $

;----------------------------------------------------------

fData       DB MAXPWLENGTH DUP (?)
passw       DB MAXPWLENGTH DUP (?)

_TEXT       ENDS
            END start
