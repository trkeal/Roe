DEFINT A-Z
SUB text (Dest as any ptr, yy as longint = -1, xx as longint = -1, subject as string = "", sp%, textfg% = 15, textbg% = 8, spacing% = -1 )
	
	dim as longint bindindex = 0
	
	IF sp% = -2 THEN
		bindingset -1, STRING$(0, 0), 0, 0
	END IF
	
	'''subject = bindtext$(subject, xx, yy, bindindex)
	
	scale$ = RIGHT$("00" + LTRIM$(STR$(text.scale%)), 2)

	IF sp% >= 1 AND sp% <= 15 AND text.colored% = 1 THEN
		ssp% = sp%
	ELSE
		ssp% = 15
	END IF

	'if ( keybind = 0 ) = 0 then
	'	subject = "{{" + mid$( subject, 1, 8 ) + "}}" + mid$( subject, 9 )
	'end if

	subject = bindtext$ ( subject, (col + 0), (row + 0 ), bindindex )
	
	placement% = 0
	
	placement% = LEN(subject) * spacing%
	
	'[!!!]'
	FOR ti% = LEN(subject) TO 1 step -1 
		ss% = ASC(MID$(subject, ti%, 1))
		
		textput Dest, (yy+0), (xx+0) + ti% - 1, ss%, scale$, textfg%, textbg%, placement%
		
		placement% -= spacing%
	NEXT ti%

END SUB

SUB textput (Dest as any ptr, yy, xx, ss%, scale$ = "08", textfg% = 15, textbg% = 0, placement% = 0 )
	
	draw string Dest, ((xx-1)*8-1+placement%,(yy-1)*8),chr$(ss%), textbg%
	draw string Dest, ((xx-1)*8+1+placement%,(yy-1)*8),chr$(ss%), textbg%
	draw string Dest, ((xx-1)*8+placement%,(yy-1)*8-1),chr$(ss%), textbg%
	draw string Dest, ((xx-1)*8+placement%,(yy-1)*8+1),chr$(ss%), textbg%
	
	draw string Dest, ((xx-1)*8+placement%,(yy-1)*8),chr$(ss%), textfg%

END SUB
