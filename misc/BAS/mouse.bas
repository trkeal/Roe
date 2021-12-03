
Const LEFTBUTTON = 1 
Const MIDDLEBUTTON = 4 
Const RIGHTBUTTON = 2 
Const MouseShowSETTING = 1
Const MOUSEHIDESETTING = 0

const KEYBIND_ENABLED = 1

declare SUB loadmouse (filename$)
declare SUB cinput
declare function cursorcheck() as string
declare sub cursorshow()
declare SUB cursorput
declare SUB MouseDriver (ax%, bx%, cx%, dx%)
declare SUB MouseHide
declare FUNCTION MouseInit%
declare SUB MousePut
declare SUB MouseShow
declare SUB MouseStatus (lb%, rb%, Xmouse%, Ymouse%)

	DIM SHARED Mouse$
	DIM SHARED AMouse$
	DIM SHARED CMouse$

	DIM SHARED Xmouse%
	DIM SHARED Ymouse%

	DIM SHARED xm%
	DIM SHARED ym%

	DIM SHARED XXmouse%
	DIM SHARED YYmouse%

	DIM SHARED MS%

	DIM SHARED lb%
	DIM SHARED rb%

	DIM SHARED llb%
	DIM SHARED rrb%

	DIM SHARED lstart%
	DIM SHARED rstart%

MouseHide

DEFINT A-Z
SUB suspend (start!, delay)

		screencopy 1, 3
		cinput
		cursorput

		screen_scaler 1, 0
		screencopy 3, 1

END SUB

SUB loadmouse (filename$)
	exit sub
	
	filemode% = FREEFILE

	OPEN ".\DRIVERS\" + filename$ FOR BINARY AS #filemode%

	Mouse$ = STRING$(LOF(filemode%), 0)
	GET #filemode%, 1, Mouse$
	CLOSE #fileode%

	MS% = MouseInit%
	IF NOT MS% THEN
		REM''PRINT "Mouse not found"
		AMouse$ = "NO"
	END IF

	IF MS% THEN
		REM''PRINT "Mouse found and initialized"
		AMouse$ = "YES"
		REM''MouseShow
	END IF

END SUB

DEFINT A-Z
SUB cinput
XXmouse% = Xmouse%
YYmouse% = Ymouse%
l1b% = lb%
r1b% = rb%
c$ = INKEY$: IF len( c$ ) = 0 THEN c$ = "%%"

if c$ = "`" or c$ = "debug" then
	debugmode = ( debugmode = 0 ) = 0
end if

MouseStatus lb%, rb%, Xmouse%, Ymouse%
Xmouse% = Xmouse% * 319 / 639
Ymouse% = Ymouse% * 199 / 479
ym% = INT(Ymouse% / 8) + 1
xm% = INT(Xmouse% / 8) + 1
IF llb% <> lb% OR (llb% = 0 AND lb% = 0) THEN
		llb% = lb%: l1b% = lb%
		ELSE
		lb% = 0
END IF
IF rrb% <> rb% OR (rrb% = 0 AND rb% = 0) THEN
		rrb% = rb%: r1b% = rb%
		ELSE
		rb% = 0
END IF

END SUB

function cursorcheck() as string
	
	if c$ = chr$( 27 ) or c$ = sync_name( "quit", names_table() ) then
		cursorcheck = sync_name( "quit", names_table() )
		exit function
	end if
	
	dim as integer index = 0
	
	for index = lbound( clickli, 1 ) to ubound( clickli, 1 ) step 1
		if ( xm% >= clickli( index ).col ) and ( xm% <= clickli( index ).col + len( clickli( index ).label ) - 1 ) and ( ym% = clickli( index ).row ) and len( clickli( index ).label ) > 0 then
			cursorcheck = clickli( index ).label
			exit function
		end if
	next index
	
	cursorcheck = "%%"
	exit function
	
end function

sub cursorshow()
	
	dim as integer index = 0, col = 2, row = 1

	draw string ( ( col - 1 ) * 8, ( row - 1 ) * 8-1), str$( ubound( clickli, 1)), 3
	draw string ( ( col - 1 ) * 8+1, ( row - 1 ) * 8), str$(ubound( clickli, 1)), 3
	draw string ( ( col - 1 ) * 8, ( row - 1 ) * 8+1), str$(ubound( clickli, 1)), 3
	draw string ( ( col - 1 ) * 8-1, ( row - 1 ) * 8), str$(ubound( clickli, 1)), 3
	
	draw string ( ( col - 1 ) * 8, ( row -1 ) * 8), str$(ubound( clickli, 1)), 11

	
	for index = lbound( clickli, 1 ) to ubound( clickli, 1 ) step 1
		if len( clickli( index ).label ) > 0 then

			line( ( clickli( index ).col - 1 ) * 8 - 4, ( clickli( index ).row -1 ) * 8 - 4 )-( ( clickli( index ).col + len( clickli( index ).label ) - 1 ) * 8 + 4, ( clickli( index ).row - 1 ) * 8 + 4 ), 11, b

			draw string ( ( clickli( index ).col - 1 ) * 8, ( clickli( index ).row -1 ) * 8+1), clickli( index ).label, 3
			draw string ( ( clickli( index ).col - 1 ) * 8+1, ( clickli( index ).row -1 ) * 8), clickli( index ).label, 3
			draw string ( ( clickli( index ).col - 1 ) * 8, ( clickli( index ).row -1 ) * 8-1), clickli( index ).label, 3
			draw string ( ( clickli( index ).col - 1 ) * 8-1, ( clickli( index ).row -1 ) * 8), clickli( index ).label, 3

			draw string ( ( clickli( index ).col - 1 ) * 8, ( clickli( index ).row -1 ) * 8), clickli( index ).label, 11
			
			circle( ( clickli( index ).col - 1 ) * 8 - 4, ( clickli( index ).row -1 ) * 8 - 4 ), 14, 11
		end if
	next index
		
end sub


SUB cursorput
	
	bindingshow
	
		dim as string strokes = string( 0, 0 )
		
			dim as double ctime = timer
	
	ctime = ctime - fix(ctime)
	ctime = cos( 2 * Pi * ctime )
	
	cursorradius_w% = 15 + ctime * 4
	cursorradius_h% = 13 + ctime * 4
		
	ellipse 0, XMouse% - cursorradius_w%, YMouse% - cursorradius_h% * .8 , XMouse% + cursorradius_w%, Ymouse% + cursorradius_h% * .8, 11, 0, .3, 1

		cursorradius% = 5
	
	dim as integer x1 = 0, y1 = 0, x2 = 0, y2 = 0
	
	x1 = Xmouse% - cursorradius%
	y1 = Ymouse% - cursorradius%
	x2 = Xmouse% + cursorradius%
	y2 = Ymouse% + cursorradius%
	
	LINE ( x1, y1 )-( x2, y2 ), 9
	LINE ( x2, y1 )-( x1, y2 ), 9
		
		cursorshow
		c$ = cursorcheck
		
		IF c$ = CHR$( 27 ) THEN
			c$ = sync_name( "quit", names_table() )
		end if

		IF c$ = "`" THEN
			c$ = sync_name( "debug", names_table() )
		end if

		IF c$ = "h" THEN
			c$ = sync_name( "help", names_table() )
		end if
		
		IF c$ = "t" THEN
			c$ = sync_name( "title", names_table() )
		end if
		
		IF c$ = "c" THEN
			c$ = sync_name( "continue", names_table() )
		end if

		IF c$ = "r" THEN
			c$ = sync_name( "restart", names_table() )
		end if
		
		IF len( c$ ) = 0  THEN
			c$ = "%%"
		end if

		if c$ = sync_name( "debug", names_table() ) then
			debugmode = ( debugmode = 0 )		
		end if
	
		if c$ = sync_name( "quit", names_table() ) then
			quitoutro Dest
		end if
		
		'bindingshow
		'bindingcheck

		'IF debugmode THEN
			IF len( c$ ) > 0 AND c$ <> "%%" THEN
						
				text Dest, FIX(Ymouse%) / 8 + 1, FIX(Xmouse%) / 8 + 1, c$, 12, textfg%, textbg%
				
				LINE (Xmouse% - cursorradius% * 1.4, Ymouse% - cursorradius% * 1.4)-(Xmouse% + cursorradius%, Ymouse% + cursorradius% * 1.4), 12, B
		
			END IF
			
			text Dest, 25, 40 - len( ltrim$( str$( turncount ) ) ), ltrim$( str$( turncount ) ), 12, textfg%, textbg%
		
		'END IF
		
END SUB

DEFSNG A-Z
SUB MouseDriver (ax%, bx%, cx%, dx%)
		exit sub
		
		'DEF SEG = VARSEG(Mouse$)
		'Mouse% = SADD(Mouse$)
		'Absolute(ax%, bx%, cx%, dx%, Mouse%)
END SUB

SUB MouseHide

	SetMouse cx%, dx%, MOUSEHIDESETTING
	exit sub

	'ax% = 2
	'MouseDriver ax%, 0, 0, 0
END SUB

FUNCTION MouseInit%
	MouseInit% = 0
	exit function
	
	'ax% = 0
	'MouseDriver ax%, 0, 0, 0
	'MouseInit% = ax%
END FUNCTION

SUB MousePut
		ax% = 4
		cx% = x%
		dx% = y%
		SetMouse cx%, dx%, MouseShowSETTING
		exit sub
		
		'MouseDriver ax%, 0, cx%, dx%
END SUB

SUB MouseShow
		SetMouse cx%, dx%, MouseShowSETTING
		exit sub
		
		'ax% = 1
		'MouseDriver ax%, 0, 0, 0
END SUB
	
SUB MouseStatus (lb%, rb%, Xmouse%, Ymouse%)
	'ax% = 3
	'MouseDriver ax%, bx%, cx%, dx%

	Dim CurrentX As Integer 
	Dim CurrentY As Integer
	Dim MouseButtons As Integer
	Dim CanExit As Integer
	Dim As String A,B,C

	GetMouse CurrentX, CurrentY, , MouseButtons 

	cx%=CurrentX
	dx%=CurrentY
	bx% = MouseButtons

	lb% = ((bx% AND LEFTBUTTON) <> 0)
	rb% = ((bx% AND RIGHTBUTTON) <> 0)
	Xmouse% = cx%
	Ymouse% = dx%
	
exit sub

END SUB
