
#include once "bas\legacy text.bas"

declare SUB bindingbubble (index as longint, bindradius%, bindfg%, bindbg%)
declare SUB bindingcheck
declare SUB bindingset (index as longint = -1 , label as string = "", col as longint = -1 , row as longint = -1)
declare SUB bindingshow
declare FUNCTION bindtext$ (label as string = "", col as longint = -1, row as longint = -1, bindindex as longint = -1)

SUB bindingbubble (index as longint, bindradius%, bindfg%, bindbg%)

	dim as string CMlongname = ""

dim as longint x = 0, y = 0

	x = (clickli(index).col - 1) * 8 + 4
	y = (clickli(index).row - 1) * 8 + 4

	CIRCLE (x - 1, y), bindradius%, bindfg%
	text Dest, (clickli(index).row), (clickli(index).col), clickli(index).label, bindfg%, textfg%, textbg%

	IF debugmode THEN
		text Dest, (index + 0), 1, LTRIM$(STR$(index + 0)) + ":" + clickli(index).label, 12, textfg%, textbg%
		text Dest, clicks% + 1, 1, LTRIM$(STR$(clickhover)) + ":" + CMouse$, 12, textfg%, textbg%
		text Dest, (index + 0), 9, LTRIM$(STR$(clickli(index).col)), 12, textfg%, textbg%
		text Dest, (index + 0), 12, LTRIM$(STR$(clickli(index).row)), 12, textfg%, textbg%
		text Dest, clicks% + 1, 9, LTRIM$(STR$(xm%)), 12, textfg%, textbg%
		text Dest, clicks% + 1, 12, LTRIM$(STR$(ym%)), 12, textfg%, textbg%
	END IF

	renderframe Dest, 25,22,40,24,10,2

	IF clickhover = index THEN
		
		CMouse$ = clickli(index).label
		CIRCLE (x - 1, y), bindradius% + 2, 15
		text Dest, (clickli(index).row), (clickli(index).col), CMouse$, 12, textfg%, textbg%
				
		text Dest, 27, 22, sync_name( clickli(index).label, names_table() ), 12, 10, 2, - 2

	END IF

END SUB

SUB bindingcheck

	clickbutton1% = -1
	clickbutton2% = -1
	clickhover = -1

	CMouse$ = "%%"

	index = 1
	DO WHILE index <= clicks%
	
		IF len( clickli(index).label ) > 0 THEN
			IF ( xm% >= clickli( index ).col ) and ( xm% <= clickli( index ).col + len( clickli( index ).label) - 1 ) AND ( ym% = clickli( index ).row ) THEN
				clickhover = index
				'[!]'CMouse$ = sync_name( clickli( clickhover ).label, names_table())
				CMouse$ = clickli( clickhover ).label

				IF lb% THEN
	
					IF len( clickli(index).label ) > 0 THEN
						C$ = CMouse$
					END IF
					
					clickbutton1% = index
				END IF
				IF rb% THEN
						
					C$ = string$( 1, 32 )	
					clickbutton2% = index
					
				END IF
				
				EXIT SUB
				
			END IF
		END IF
		
		IF index = clicks% THEN
			EXIT DO
		END IF
	
		index = index + 1

	LOOP

END SUB

SUB bindingset (index as longint = -1 , label as string = "", col as longint = -1 , row as longint = -1)
	
	dim as integer i = 0
	
	SELECT CASE index
	CASE -1
	
		clicks% = 0
	
		FOR i = LBOUND( clickli ) TO UBOUND( clickli ) STEP 1
			clickli( i ).col = -1
			clickli( i ).row = -1
			clickli( i ).label = STRING$( 0, 0 )
		NEXT i
		
		exit sub
		
	CASE ELSE
		
		if len( label ) = 0 then
			exit sub
		end if
		
		SELECT CASE clicks%
		CASE IS < UBOUND( clickli, 1 )
		
			clicks% += 1
		
			clickli( clicks% ).col = col
			clickli( clicks% ).row = row
			
			clickli( clicks% ).label = label
			
		END SELECT

	END SELECT

END SUB

SUB bindingshow

	charradius% = 4
	bindradius% = 7

	bindradius2% = bindradius% + (TIMER * 4) MOD 4

	bindfg% = 11
	bindbg% = 0

	dim as longint index = 1

	DO WHILE index <= clicks%
	
		IF isinbounds( ( clickli(index).col ), ( clickli(index).row ), 1, 1, 40, 25 ) THEN
			IF clickhover = index THEN

				renderframe Dest, 23, 30, 25, 40, 10, 2, 8, -1
				text Dest, 23,30, sync_name( clickli( index ).label, names_table() ), 0, 10, 2
				
				bindingbubble index, bindradius2%, bindfg%, bindbg%
	
			ELSE
				bindingbubble index, bindradius%, bindfg%, bindbg%
			END IF
		END IF

		SELECT CASE index
		CASE IS >= clicks%
			EXIT DO
		CASE ELSE
			index = index + 1
		END SELECT

	LOOP

END SUB

FUNCTION bindtext$ (label as string = "", col as longint = -1, row as longint = -1, bindindex as longint = -1)
	
	dim as string bindname = string$( 0, 0 )
	
	bindtext$ = label
	ssbuffer$ = label

	bopen$ = "{{"
	bclose$ = "}}"

	button1% = INSTR(1, ssbuffer$, bopen$)
	
	SELECT CASE button1%
	CASE IS > 0
	
		button2% = INSTR(button1% + LEN(bopen$), ssbuffer$, bclose$)

		SELECT CASE button2%
		CASE IS > button1%
	
			souter1$ = LEFT$(ssbuffer$, button1% - 1)
			souter2$ = MID$(ssbuffer$, button2% + LEN(bclose$))
		
			sinner0$ = ssbuffer$
			sinner0$ = MID$(sinner0$, button1% + LEN(bopen$))
			sinner0$ = MID$(sinner0$, 1, button2% - button1% - LEN(bopen$))
	
			bindingset UBOUND(clickli, 1), sinner0$, col + button1% - 1, row
			
			bindname = sync_name( sinner0$, names_table())
			if len( bindname ) = 0 then
				bindname = sinner0$
			else

				clicks% += 1

				redim preserve clickli( 0 to clicks% )

				clickli(clicks%).label = bindname

				clickli(clicks%).col = col

				clickli(clicks%).row = row

			end if 
			
			ssbuffer$ = souter1$ + ucword( bindname ) + souter2$
		
			label = ssbuffer$

		CASE ELSE
			EXIT FUNCTION
		END SELECT
	CASE ELSE
		EXIT FUNCTION
	END SELECT

	bindtext$ = label

END FUNCTION
