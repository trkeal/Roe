
Const LEFTBUTTON = 1 
Const MIDDLEBUTTON = 4 
Const RIGHTBUTTON = 2 
Const MouseShowSETTING = 1
Const MOUSEHIDESETTING = 0

const KEYBIND_ENABLED = 1

declare SUB loadmouse (filename$)
declare SUB MouseDriver (ax%, bx%, cx%, dx%)
declare SUB MouseHide
declare FUNCTION MouseInit%
declare SUB MousePut
declare SUB MouseShow
declare SUB MouseStatus (lb%, rb%, Xmouse%, Ymouse%)

DIM SHARED Mouse as string
DIM SHARED AMouse as string
DIM SHARED CMouse as string

DIM SHARED MS as integer

 DIM SHARED Xmouse as integer
 DIM SHARED Ymouse as integer
 DIM SHARED xm as integer
 DIM SHARED ym as integer
 DIM SHARED XXmouse as integer
 DIM SHARED YYmouse as integer
 DIM SHARED lb as integer
 DIM SHARED rb as integer
 DIM SHARED llb as integer
 DIM SHARED rrb as integer
 DIM SHARED lstart as integer
 DIM SHARED rstart as integer
 DIM SHARED jsx as integer
 DIM SHARED jsy as integer
 DIM SHARED jsa as integer
 DIM SHARED jsb as integer

 filemode = FREEFILE
 filename = "drivers\mouse.bin"
 OPEN filename FOR BINARY AS #filemode
 mouse$ = STRING$(LOF(filemode), 0)
 GET #filemode, 1, mouse$
 'mouse$ = SPACE$(57)
 CLOSE #filemode


 'FOR I% = 1 TO 57
  'READ a$
  'H$ = CHR$(VAL("&H" + a$))
  'MID$(mouse$, I%, 1) = H$
 'NEXT I%
 'DATA 55,89,E5,8B,5E,0C,8B,07,50,8B,5E,0A,8B,07,50,8B
 'DATA 5E,08,8B,0F,8B,5E,06,8B,17,5B,58,1E,07,CD,33,53
 'DATA 8B,5E,0C,89,07,58,8B,5E,0A,89,07,8B,5E,08,89,0F
 'DATA 8B,5E,06,89,17,5D,CA,08,00


MouseHide

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
