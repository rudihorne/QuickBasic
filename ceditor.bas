' name: Console editor
' description: 80 column text editor
' for: QuickBasic
' by: Rudi Horne
' web: http://rudih.info

DIM line$(1200) ' buffer array

fposy = 1' file position
lenfile = 2' length of file

' reset screen
CLS
posy = 1
posx = 1

filen$ = COMMAND$
filen$ = LTRIM$(filen$)
filen$ = RTRIM$(filen$)
IF filen$ <> "" THEN GOTO skipload:

top:
CLS
FOR m = 1 TO 24
  PRINT line$((fposy - posy - 1) + m)
NEXT
IF posy >= 24 THEN PRINT line$(fposy)
ftop:
LOCATE posy, posx
PRINT "Ü"

' get input
user$ = ""
WHILE user$ = ""
 user$ = INKEY$
WEND

' delete
IF user$ = CHR$(0) + CHR$(83) THEN
      LeftL$ = LEFT$(line$(fposy), posx - 1)
      RightL$ = MID$(line$(fposy), posx + 1, leng)
	line$(fposy) = LeftL$ + RightL$
	GOTO top:
END IF

' page up
IF user$ = CHR$(0) + CHR$(73) THEN
	IF fposy >= 25 THEN
	   fposy = fposy - 24
	   posy = 1
	ELSE
	  posy = 1
	  fposy = 1
	END IF
	GOTO top:
END IF

' page down
IF user$ = CHR$(0) + CHR$(81) THEN
	fposy = fposy + 24
	IF fposy >= lenfile OR fposy >= 1100 THEN fposy = lenfile
	GOTO top:
END IF


' enter / down
IF user$ = CHR$(13) OR user$ = CHR$(0) + "P" THEN
	IF fposy = lenfile AND user$ = CHR$(0) + "P" THEN GOTO top:
	oldposx = posx
	posx = 1
	posy = posy + 1
	fposy = fposy + 1
	IF fposy > lenfile THEN lenfile = fposy
	IF lenfile > 1100 THEN
		PRINT "file too long"
		SLEEP
		END
	END IF
	IF posy > 23 THEN
		posy = 23
	       IF fposy >= lenfile THEN lenfile = fposy
	       GOTO top:
	END IF
	IF user$ = CHR$(13) THEN
		IF posy = 25 THEN GOTO top:
	   lenfile = lenfile + 1
	   FOR m = 1 TO lenfile - fposy
	     line$(lenfile - m) = line$(lenfile - m - 1)
	   NEXT
      IF posx < 2 THEN
	line$(fposy) = ""
'        line$(fposy - 1) = ""
      END IF
      leng = LEN(line$(fposy - 1))
	   IF posx < leng THEN
		line$(fposy) = MID$(line$(fposy - 1), oldposx, leng)
		line$(fposy - 1) = MID$(line$(fposy - 1), 1, oldposx - 1)
	   END IF
	 IF fposy >= lenfile THEN lenfile = fposy
	END IF
	GOTO top:
END IF
' f2(save)
IF user$ = CHR$(0) + "<" THEN
	CLS
	INPUT "Enter filename to save as (or enter to cancel): ", filen$
	IF filen$ = "" THEN GOTO top:
	OPEN filen$ FOR OUTPUT AS #1
	FOR m = 1 TO lenfile
		PRINT #1, line$(m)
	NEXT m
	CLOSE #1
	GOTO top:
END IF
' f3(load)
IF user$ = CHR$(0) + "=" THEN
	CLS
	INPUT "Enter filename to load (or enter to cancel): ", filen$
	IF filen$ = "" THEN GOTO top:
skipload:
	FOR m = 1 TO 1200
		line$(m) = ""
	NEXT
	OPEN filen$ FOR INPUT AS #1
	lenfile = 1
	WHILE NOT EOF(1)
	 LINE INPUT #1, line$(lenfile)
	 IF LEN(line$(lenfile)) > 80 THEN
		PRINT "line too long"
		SLEEP
		END
	 END IF
	 lenfile = lenfile + 1
	 IF lenfile > 1100 THEN
		PRINT "file too long"
		SLEEP
		END
	 END IF
	WEND
	CLOSE #1
	fposy = 1
	posy = 1
   posx = 1
	GOTO top:
END IF
' f1(help)
IF user$ = CHR$(0) + ";" THEN
	CLS
	PRINT " Console editor help. "
	PRINT " <F1> - help"
	PRINT " <F2> - save as"
	PRINT " <F3> - load"
	PRINT " <Esc> - exit"
	PRINT " Column:"; posx; " Line:"; fposy; " Length:"; lenfile
	PRINT " Press any key..."
	SLEEP
	GOTO top:
END IF
' Esc(exit)
IF user$ = CHR$(27) THEN
	CLS
	PRINT "Do you want to exit (y/n)?";
	x$ = ""
	WHILE x$ = ""
	x$ = INKEY$
	WEND
	IF x$ = "Y" OR x$ = "y" THEN END
	GOTO top:
END IF
' backspace / left
IF user$ = CHR$(8) OR user$ = CHR$(0) + "K" THEN
	IF posx = 1 AND posy = 1 THEN
		line$(fposy) = ""
		GOTO top:
	END IF
	IF posx > 1 THEN
	posx = posx - 1
	IF user$ = CHR$(0) + "K" THEN GOTO top:
	PRINT " "
      LeftL$ = LEFT$(line$(fposy), posx - 1)
      RightL$ = MID$(line$(fposy), posx + 1, leng)
	line$(fposy) = LeftL$ + RightL$
	END IF
	IF posx = 1 THEN
		IF user$ = CHR$(0) + "K" THEN GOTO top:
		lenfile = lenfile - 1
		IF fposy > 1 THEN fposy = fposy - 1
		IF posy > 1 THEN posy = posy - 1
		IF fposy = lenfile THEN lenfile = lenfile + 1
		line$(lenfile + 1) = ""
		FOR m = 1 TO lenfile - fposy
			line$(fposy + m) = line$(fposy + m + 1)
		NEXT
		CLS
		IF fposy > 1 THEN
			FOR m = 1 TO 24
			  PRINT line$((fposy - posy) + m)
		   NEXT
		END IF
	END IF
	GOTO top:
END IF
' up
IF user$ = CHR$(0) + "H" AND posy < 2 THEN
	IF fposy < 2 THEN GOTO top:
   fposy = fposy - 1
	posx = 1
	GOTO top:
END IF
IF user$ = CHR$(0) + "H" AND posy > 1 THEN
	fposy = fposy - 1
	posy = posy - 1
	posx = 1
	GOTO top:
END IF
' right
IF user$ = CHR$(0) + "M" THEN
	IF posx > 78 THEN GOTO top:
	leng = LEN(line$(fposy))
	IF posx > leng THEN GOTO top:
	posx = posx + 1
   GOTO top:
END IF
' home
IF user$ = CHR$(0) + "G" THEN
	posx = 1
	GOTO top:
END IF
' end
IF user$ = CHR$(0) + "O" THEN
	posx = LEN(line$(fposy)) + 1
	GOTO top:
END IF

IF lenfile > 1100 THEN
	PRINT "file too long"
	SLEEP
	END
END IF
leng = LEN(line$(fposy))
IF leng > 78 GOTO top:
LeftL$ = LEFT$(line$(fposy), posx - 1)
RightL$ = MID$(line$(fposy), posx, leng)
line$(fposy) = LeftL$ + user$ + RightL$
LOCATE posy, 1
PRINT line$(fposy)
IF posx < 80 THEN posx = posx + 1
GOTO ftop:

