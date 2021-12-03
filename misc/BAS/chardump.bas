
SUB chardump
	
	exit sub
	
	i% = 0
	seq$ = STRING$(0, 0)

	FOR row = 0 TO 15
		seq$ = STRING$(0, 0)
	
		FOR col = 0 TO 15
			seq$ = seq$ + CHR$(i%)
			text Dest, row + 1, 1, seq$, 15, textfg%, textbg%
			i% = i% + 1
	
		NEXT col
	NEXT row
	c$ = "%%"
	DO WHILE c$ = "%%"
		suspend 0, 0
	LOOP
END SUB

