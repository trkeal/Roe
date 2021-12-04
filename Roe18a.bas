'''#define __encounter_debug__

'''#define __old_talk__

'''#define __old_map__

#lang "fblite"
option gosub


dim shared as integer filemode = 0
dim shared as string filename
filename = string$( 0, 0 )
dim shared as string buffer, subject, label, value
buffer = string$( 0, 0 )
subject = string$( 0, 0 )
label = string$( 0, 0 )
value = string$( 0, 0 )

#include once "crt/math.bi"
#include once "file.bi"
'#include once "windows.bi"
#include once "fbgfx.bi"
'
Const Pi = 4 * ATN(1)

dim shared as any ptr Dest

const crlf = chr$( 13 ) + chr$ ( 10 )
const quot = chr$( 34 )
const eq = "="
const colon = ":"
const comma = ","
const semi = ";"

#include once "gamedata\names.bas"

#include once "inc\sprites.bas"

#include once "inc\gui\render text.bas"

'#include once "inc\gfx\sprites 2x.bas"

#include once "inc\gfx\vector 2x.bas"

#include once "inc\gfx\string gfx.bas"

#include once "inc\gui\gui support.bas"

#include once "inc\hud\encounter hud.bas"
#include once "inc\hud\talk hud.bas"
#include once "do support\merchant header.bas"

	'==== Required Experience Points per Level Up
	
	redim shared as integer levelup( any )

	dim as integer levelindex = 0	
	redim shared as names_type levels_table( any )
	
	call load_names( "data\levels.dat", levels_table() )
		
	redim levelup( 0 to val( sync_names( "levels/count", levels_table() ) ) )
	
	for levelindex = lbound( levelup, 1 ) to ubound( levelup, 1 ) step 1
	
		levelup( levelindex ) = val( sync_names( "levels/" + ltrim$( str$( levelindex ) ), levels_table() ) )
		
	next levelindex
	
	'==== Short Code to Long Names table
	
	redim shared  as names_type longnames_table( any )
	call load_names( "data\longnames.dat", longnames_table() )

	'====
	
dim shared as integer textfg = 15
dim shared as integer textbg = 1

#include once "inc\mouse.bas"
#include once "inc\sprites.bas"
#include once "inc\screen scaler.bas"

#ifdef __qb_mouse__

 DECLARE SUB MouseDriver (ax AS INTEGER, bx AS INTEGER, cx AS INTEGER, dx AS INTEGER)
 DECLARE FUNCTION MouseInit% ()
 DECLARE SUB mouseshow ()
 DECLARE SUB mousestatus (lb AS INTEGER, rb AS INTEGER, Xmouse AS INTEGER, Ymouse AS INTEGER)

#endif


 DECLARE SUB cursorput ()
 DECLARE SUB cinput ()

 REM /*
 REM //
 REM //   ÍÍÍ
 REM //  ðúú/ð
 REM // ºúú/³úº
 REM // ºú/úÂÄº AquariusúGames
 REM // º/ÄÄÙúº
 REM //  ðúú³ð
 REM //   ÍÍÍ
 REM //
 REM // program: Puzzlum Roe
 REM // version: 2.092.018a
 REM // edition: FreeBASIC Win32 x86
 REM // created: 07-20-1997 06:52:00pm
 REM // copyright 1997, 2021 Tim Keal
 REM // website: http://puzzlum.net/
 REM //
 REM //*

do_startup:
 DEFINT A-Z
 DIM SHARED as integer AA, DD, ex, dy
 DIM SHARED as integer textrate
 DIM SHARED as single textdelay
 DIM SHARED c$
 DIM SHARED as integer tx, ty
 
 DIM SHARED as integer winct = 0
 DIM SHARED map$
 DIM SHARED lvup$

 DIM SHARED debugmode AS INTEGER, turncount AS LONG
 debugmode = 0
 turncount = 0

 REDIM SHARED e$(0 to 0, 0 to 4): REM'grid identity$
 REDIM SHARED g(0 to 0, 0 to 16) AS DOUBLE: REM'grid statistics

	REM'direction (n,e,s,w)
	
	dim shared as integer da (0 to 4, 1 to 2 )
	dim shared as string ds( 0 to 4 )
	
	filemode = freefile
	o=0
	if not open("data\rose.dat" for input as #filemode) then
		while not( eof( filemode ) )
			input #filemode, da( o, 1 ), da( o, 2 ), ds( o )
			o += 1
		wend
		close #filemode 
	else
		close #filemode 
	end if
	
	#ifdef __old_levels__
	dim shared as integer levelup( 0 to 99 )
	filemode = freefile
	o=0
	if not open("data\levels.dat" for input as #filemode) then
		while not( eof( filemode ) )
			input #filemode, subject
			if instr( 1, subject, "=" ) > 0 then
				levelup( val( left$( subject, instr( 1, subject, "=" ) - 1 ) ) ) = val( mid$( subject, instr( 1, subject, "=" ) + 1 ) )
			end if
			o += 1
		wend
		close #filemode 
	else
		close #filemode 
	end if
	#endif
	
	DIM SHARED t(24 * 24 + 8): REM'text image
 
	'ex = StartX 'INT(AA / 2): REM'map pointer x
	'dy = StartY 'INT(DD / 2): REM'map pointer y
	
	mdx = INT(40 / 2): REM'screen cursor x
	mdy = INT(25 / 2): REM'screen cursor y
	
	textrate = .01
	textdelay = 2.5: REM'''.8: REM'''.55
	winct = 4

	DIM SHARED win(-winct TO 2 * winct) AS INTEGER
	RANDOMIZE TIMER
	'[!!!]'RESTORE

	dim shared as string Special
	Special = string$( 4, "0" )
	
	REDIM SHARED e$(0 to 0, 0 to 4): REM'grid identity$
	REDIM SHARED g(0 to 0, 0 to 16) AS DOUBLE: REM'grid statistics


	filemode = FREEFILE
	filename = "data\win.dat"
	ttt=0
	if not( OPEN( filename FOR INPUT AS #filemode ) ) then
		while not( eof( filemode ) )
			input #filemode, subject
			if instr( 1, subject, "," ) > 0 then
				label = left$( subject, instr( 1, subject, "," ) - 1 )
				value = mid$( subject, instr( 1, subject, "," ) + 1 )
				win( 1 + ( ttt - 1) * 2 ) = val( label )
				win( 2 + ( ttt - 1) * 2 ) = val( value )
			end if
			ttt += 1
		wend
		close #filemode 
	else
		close #filemode 
	end if
	
	CLOSE #filemode
	
	#ifdef __old_map__
		map$ = "p292018a.vds"
	#else
		redim shared as names_type map_table( any )
		map$ = "p292018a"
	#endif
	
	dim as integer StartX = 1, StartY = 1
	dim as string MapMagic = string$( 0, 0 ), MapName = string$( 0, 0 )
	
	#ifdef __old_map__
	
		filemode = freefile
		if not( OPEN( "maps\" + map$ FOR INPUT AS filemode ) ) then
		INPUT #filemode, MapMagic, MapName, Special
		INPUT #filemode, AA, DD, StartX, StartY
		
	#else
	
		load_names("data\maps\"+map$+".dat", map_table())
		
		MapMagic = sync_names("MapMagic", map_table() )
		MapName = sync_names("MapName", map_table() )
		Special = sync_names("Special", map_table() )

		AA = val( sync_names("AA", map_table() ) )
		DD = val( sync_names("DD", map_table() ) )
		StartX = val(sync_names("StartX", map_table() ) )
		StartY = val(sync_names("StartY", map_table() ) )
		
	#endif
	
	REDIM e$(0 to AA * DD, 4): REM'grid identity$
	REDIM g(0 to AA * DD, 16): REM'grid statistics

	ex = StartX 'INT(AA / 2): REM'map pointer x
	dy = StartY 'INT(DD / 2): REM'map pointer y

 ctrl$ = "plyrimp_"
 IF INT(RND(1) * 2) + 1 = 2 THEN ctrl$ = ctrl$ + "dust"
 FOR ty = 1 TO DD

 	#ifdef __old_map__
		INPUT #filemode, r$
	#else
		'''r$ = sync_names("map/row/" + ltrim$( str$( ty ) ), map_table() )	
	#endif
 
	#ifdef __old_map__
		ty = val(r$)
	#endif
 
	#ifdef __old_map__
		LINE INPUT #filemode, bg$
		LINE INPUT #filemode, fg$
		LINE INPUT #filemode, sg$
	#else
		bg$ = sync_names("map/row/" + ltrim$( str$( ty ) )+"/bg", map_table() )	
		fg$ = sync_names("map/row/" + ltrim$( str$( ty ) )+"/fg", map_table() )	
		sg$ = sync_names("map/row/" + ltrim$( str$( ty ) )+"/sg", map_table() )	
	#endif

 FOR tx = 1 TO AA
  rbg$ = MID$(bg$, (tx - 1) * 5 + 1, 4)
  rfg$ = MID$(fg$, (tx - 1) * 5 + 1, 4)
  rsg$ = MID$(sg$, (tx - 1) * 5 + 1, 4)
  e$(tx + (ty - 1) * AA, 2) = "____" + rbg$
  e$(tx + (ty - 1) * AA, 3) = MKL$(0) + "____" + MKL$(0): REM'command$
  e$(tx + (ty - 1) * AA, 4) = "________": REM'graphicsaction$
  IF rfg$ = "____" THEN
   GOSUB do_prflblnk
   GOSUB do_prflset
  END IF
  IF rfg$ = "spdr" THEN
   GOSUB do_prflblnk
   prflidty$ = "Spider"
   prflactn$ = "movebiteweb_"
   prflgpic$ = "spdr"
   prflidtysng = 1
   prflhpsng = 10
   prflstrsng = 20
   prflspdsng = 1
   prflarmrsng = 1
   prflvalusng = 5
   prflpircsng = 1
   prfllvsng = 1
   prflhpmaxsng = 10
   prflstrmaxsng = 20
   prflessmaxsng = 380
   prflessspdsng = 3
   GOSUB do_prflset
  END IF
  IF rfg$ = "wall" THEN
   GOSUB do_prflblnk
   prflidty$ = "wall"
   prflgpic$ = "wall"
   prflidtysng = 2
   GOSUB do_prflset
  END IF
  IF rfg$ = "web_" THEN
   GOSUB do_prflblnk
   prflidty$ = "Web"
   prflactn$ = "spdr"
   prflgpic$ = "web_"
   prflidtysng = 3
   prflhpsng = 40
   prflstrsng = 50
   prflspdsng = 1
   prflvalusng = 1
   prfllvsng = 1
   prflhpmaxsng = 40
   prflstrmaxsng = 50
   prflessmaxsng = 380
   prflessspdsng = 2
   GOSUB do_prflset
  END IF
  IF rfg$ = "grml" THEN
   GOSUB do_prflblnk
   prflidty$ = "Gremlin"
   prflactn$ = "movebitepnch"
   IF RND(1) > .2 THEN
    prflactn$ = prflactn$ + "dggr"
   END IF
   prflgpic$ = "grml"
   prflidtysng = 4
   prflhpsng = 25
   prflstrsng = 90
   prflspdsng = 1
   prflarmrsng = 1
   prflvalusng = 5
   prflpircsng = 2
   prfllvsng = 1
   prflhpmaxsng = 25
   prflstrmaxsng = 90
   GOSUB do_prflset
  END IF
  IF rfg$ = "plyr" THEN
   GOSUB do_prflblnk
   prflidty$ = "Poindexter"
   prflactn$ = "wstf"
   prflgpic$ = "plyr"
   prflidtysng = 5
   prflhpsng = 30
   prflstrsng = 90
   prflesssng = 0
   prflspdsng = 3
   prflarmrsng = 2
   prflexpsng = 10
   prflvalusng = 15
   prflpircsng = 2
   prfllvsng = 1
   prflhpmaxsng = 30
   prflstrmaxsng = 90
   prflessmaxsng = 30
   prflessspdsng = .1
   prflevadsng = .07
   GOSUB do_prflset
  END IF
  IF rfg$ = "dtby" THEN
   GOSUB do_prflblnk
   prflidty$ = "Dust Bunny"
   prflactn$ = "movebitekickdtbydust"
   prflgpic$ = "dtby"
   prflidtysng = 6
   prflhpsng = 15
   prflstrsng = 20
   prflesssng = 5
   prflspdsng = 1.2
   prflvalusng = 2
   prfllvsng = 1
   prflhpmaxsng = 15
   prflstrmaxsng = 20
   prflessmaxsng = 280
   prflessspdsng = 1
   GOSUB do_prflset
  END IF
  IF rfg$ = "shkt" THEN
   GOSUB do_prflblnk
   prflidty$ = "Shiny Knight"
   prflactn$ = "movepnchdggr"
   prflgpic$ = "shkt"
   prflidtysng = 7
   prflhpsng = 45
   prflstrsng = 110
   prflspdsng = 1
   prflarmrsng = 4
   prflvalusng = 17
   prflpircsng = 3
   prfllvsng = 1
   prflhpmaxsng = 45
   prflstrmaxsng = 110
   prflessmaxsng = 12
   prflevadsng = .12
   GOSUB do_prflset
  END IF
  IF rfg$ = "emgd" THEN
   GOSUB do_prflblnk
   prflidty$ = "Emerald Guard"
   prflactn$ = "movepnchdggr"
   rr = RND(1)
   IF rr > .1 AND rr <= .4 THEN
    prflactn$ = prflactn$ + "dggr"
   END IF
   IF rr > .4 AND rr <= 1 THEN
    prflactn$ = prflactn$ + "pike"
   END IF
   prflgpic$ = "emgd"
   prflidtysng = 8
   prflhpsng = 40
   prflstrsng = 140
   prflspdsng = 2
   prflarmrsng = 5
   prflvalusng = 17
   prflpircsng = 3
   prfllvsng = 1
   prflhpmaxsng = 40
   prflstrmaxsng = 140
   prflevadsng = .2
   GOSUB do_prflset
  END IF
  IF rfg$ = "door" THEN
   GOSUB do_prflblnk
   prflidty$ = "Door"
   prflgpic$ = "door"
   IF INT(RND(1) * 2) = 1 THEN
    prflactn$ = "loc1"
   ELSE
    prflactn$ = "loc2"
   END IF
   prflidtysng = 9
   prflhpsng = 140
   prflstrsng = 140
   prflarmrsng = 5
   prflvalusng = 1
   prfllvsng = 1
   prflhpmaxsng = 140
   prflstrmaxsng = 140
   GOSUB do_prflset
  END IF
  IF rfg$ = "imp_" THEN
   GOSUB do_prflblnk
   prflidty$ = "Little Imp"
   prflactn$ = "movewingfire"
   IF INT(RND(1) * 2) + 1 = 2 THEN
    prflidty$ = "Merchant"
    prflactn$ = prflactn$ + "dggrgrplseed"
   END IF
   prflgpic$ = "imp_"
   prflidtysng = 10
   prflhpsng = 30
   prflstrsng = 30
   prflesssng = 30
   prflspdsng = 5
   prflarmrsng = 1
   prflvalusng = 24
   prflpircsng = 1
   prfllvsng = 1
   prflhpmaxsng = 30
   prflstrmaxsng = 30
   prflessmaxsng = 90
   prflessspdsng = 3
   prflevadsng = .3
   GOSUB do_prflset
  END IF
  IF rfg$ = "chst" THEN
   GOSUB do_prflblnk
   prflidty$ = "Treasure chest"
   IF INT(RND(1) * 2) = 1 THEN
    prflactn$ = "key1"
   ELSE
    prflactn$ = "key2"
   END IF
   prflgpic$ = "chst"
   prflidtysng = 11
   prflhpsng = 100
   prfllvsng = 1
   prflhpmaxsng = 100
   GOSUB do_prflset
  END IF
  IF rfg$ = "bldr" THEN
   GOSUB do_prflblnk
   prflidty$ = "Big boulder"
   prflactn$ = ""
   prflgpic$ = "bldr"
   prflidtysng = 12
   prflhpsng = 1000
   prflarmrsng = 10
   prfllvsng = 1
   prflhpmaxsng = 1000
   GOSUB do_prflset
  END IF
 NEXT tx
 NEXT ty
#ifdef __old_map__
	close #filemode
 else
	close #filemode
 end if
#endif
GOTO do_starttitle

do_starttitle:
 screenres 640,480,8,8
 screenset 1,0
 textfg = 15
 textbg = 1
 'SCREEN 7, 0, 1, 0
 'WIDTH 40, 25
 'COLOR 15, 1
 'CLS
 colr = 15
 GOSUB do_title
 colr = 11
 texts$ = " program: Puzzlum Roe"
 GOSUB do_showtext
 texts$ = " version: 2.092.018a"
 GOSUB do_showtext
 texts$ = " edition: FreeBASIC Win32 x86"
 GOSUB do_showtext
 texts$ = " created: 07-20-1997 06:52:00pm"
 GOSUB do_showtext
 texts$ = " copyright 1997, 2021 Tim Keal"
 GOSUB do_showtext
 texts$ = " website: http://puzzlum.net/"
 GOSUB do_showtext
 PRINT
 colr = 9
 texts$ = " (H)elp"
 GOSUB do_showtext
 PRINT
 texts$ = " (C)ontinue"
 GOSUB do_showtext
 PRINT
 texts$ = " (R)estart"
 GOSUB do_showtext
 PRINT
 texts$ = " (Q)uit"
 GOSUB do_showtext
 PRINT
 texts$ = " (D)ebug"
 GOSUB do_showtext
 GOSUB do_commandwait
 IF c$ = "r" OR c$ = "R" OR (ym = 20 AND xm = 3 AND lb = -1) THEN
  GOSUB do_screenset
  END 'RUN
 END IF
 IF c$ = "d" OR c$ = "D" OR (ym = 24 AND xm = 3 AND lb = -1) THEN
  debugmode = (debugmode = 0)
  GOSUB do_screenset
  END 'RUN
 END IF
 IF c$ = CHR$(27) OR c$ = "q" OR c$ = "Q" OR (ym = 22 AND xm = 3 AND lb = -1) THEN
  GOSUB do_screenset
  END
 END IF
 IF c$ = "h" OR c$ = "H" OR (ym = 16 AND xm = 3 AND lb = -1) THEN
  OPEN "help\" + "roe92004.hlp" FOR INPUT AS 63
do_starthelp:
  LINE INPUT #63, r$
  IF r$ = "þ page start" THEN
   GOSUB do_title
   GOTO do_starthelp
  END IF
  IF r$ = "þ page end" THEN
   LOCATE 22, 1
   colr = 9
   texts$ = " (C)ontinue"
   GOSUB do_showtext
   PRINT
   texts$ = " (T)itle"
   GOSUB do_showtext
do_continuehelp:
   GOSUB do_commandwait
   IF c$ = "t" OR c$ = "T" OR (ym = 24 AND xm = 3 AND lb = -1) THEN
    CLOSE 63
    GOTO do_starttitle
   END IF
   IF NOT (c$ = STRING$(1, 32) OR c$ = "c" OR c$ = STRING$(1, 32) OR c$ = "C" OR (ym = 22 AND xm = 3 AND lb = -1)) THEN
    GOTO do_continuehelp
   END IF
   GOTO do_starthelp
  END IF
  IF r$ = "þ end" THEN
   CLOSE 63
   GOTO do_starttitle
  END IF
  IF LEFT$(r$, 7) = "þ COLOR" THEN
   colr = VAL(RIGHT$(r$, LEN(r$) - 7))
   GOTO do_starthelp
  END IF
  texts$ = r$
  IF r$ <> "" THEN
   GOSUB do_showtext
  ELSE
   PRINT
  END IF
  GOTO do_starthelp
 END IF
 IF c$ <> STRING$(1, 32) AND c$ <> "c" AND c$ <> "C" AND NOT (ym = 18 AND xm = 3 AND lb = -1) THEN
  GOTO do_starttitle
 END IF
 color 15,1 
 CLS
 screen_scaler 1, 7
 'screencopy 1, 0
 COLOR 15, 0
 cinput
GOTO do_command

do_main:
 FOR tx = 1 TO AA
 FOR ty = 1 TO DD
  a = 0
  d = 0
  IF g(tx + (ty - 1) * AA, 9) = 0 THEN
   g(tx + (ty - 1) * AA, 9) = 1
   MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
   GOSUB do_getaction
   IF action$ = "zzzz" AND dis > 0 THEN
    dis = dis - 1
    GOSUB do_putaction
   END IF
   SELECT CASE CVL(MID$(e$(tx + (ty - 1) * AA, 2), 1, 4))
   CASE CVL("wall")
   CASE CVL("spdr")
    GOSUB do_crtnspdr
   CASE CVL("web_")
    GOSUB do_crtnweb
   CASE CVL("dtby")
    GOSUB do_crtndtby
   CASE CVL("grml")
    GOSUB do_crtngrml
   CASE CVL("shkt")
    GOSUB do_crtnshkt
   CASE CVL("emgd")
    GOSUB do_crtnemgd
   CASE CVL("imp_")
    GOSUB do_crtnimp
   CASE CVL("fire")
    GOSUB do_crtnfire
   CASE CVL("plyr")
    GOSUB do_crtnplyr
   CASE CVL("ccts")
    GOSUB do_crtnccts
   CASE CVL("bldr")
    GOSUB do_crtnbldr
   CASE CVL("dust")
    GOSUB do_crtndust
   END SELECT
  END IF
 NEXT ty
 NEXT tx
 FOR tx = 1 TO AA
 FOR ty = 1 TO DD
  g(tx + (ty - 1) * AA, 9) = 0
 NEXT ty
 NEXT tx
GOTO do_command

do_command:
 tx = ex
 ty = dy
 textfg = 15
 textbg = 0
 renderfill 0, 0, 319, 199, textbg, 0
 'LINE (0, 0)-(319, 199), textbg, BF
 GOSUB do_portal
 screencopy 1, 2
GOSUB do_command2
GOTO do_command3

do_command2:
 screencopy 2, 1
 statx = 25
 framex1sng = statx
 framex2sng = 40
 framey1sng = 2
 framey2sng = 4
 framec1 = 6
 framec2 = 0
 GOSUB do_frameput
 SELECT CASE titled
 CASE 0
  text 3, statx + 4, "Puzzlum", 5
 CASE 1
  text 3, statx + 4, "(T)itle", 9
 END SELECT
 am$ = ctrl$
 GOSUB do_am
 IF am > 0 THEN
  statx = 25
  GOSUB do_status
 END IF
 screencopy 1, 3
RETURN

do_command3:
 cinput
 IF ym = 3 AND xm >= statx AND xm <= 39 AND titled = 0 THEN
  titled = 1
  GOSUB do_command2
 END IF
 IF NOT (ym = 3 AND xm >= statx AND xm <= 39) AND titled = 1 THEN
  titled = 0
  GOSUB do_command2
 END IF
 screencopy 3, 1
 cursorput
  screen_scaler 1, 7
'screencopy 1, 0
 IF am > 0 THEN
  statx = 25
  GOSUB do_getaction
  IF ((c$ = "L") OR (ym = 6 AND xm = statx + 2 AND lb = -1)) THEN
   c$ = "L"
   GOSUB do_paylevelup
   GOTO do_command
  END IF
  IF (ym = 11 AND xm = statx + 1 AND lb = -1) AND d <> 0 THEN
   d = 0
   dis = 0
   GOSUB do_putaction
   GOSUB do_command2
  END IF
  IF (ym = 10 AND xm = statx + 1 AND lb = -1) AND d <> 1 THEN
   d = 1
   dis = 0
   GOSUB do_putaction
   GOSUB do_command2
  END IF
  IF (ym = 11 AND xm = statx + 2 AND lb = -1) AND d <> 2 THEN
   d = 2
   dis = 0
   GOSUB do_putaction
   GOSUB do_command2
  END IF
  IF (ym = 12 AND xm = statx + 1 AND lb = -1) AND d <> 3 THEN
   d = 3
   dis = 0
   GOSUB do_putaction
   GOSUB do_command2
  END IF
  IF (ym = 11 AND xm = statx AND lb = -1) AND d <> 4 THEN
   d = 4
   dis = 0
   GOSUB do_putaction
   GOSUB do_command2
  END IF
  IF lb = -1 AND NOT (action$ = "zzzz" AND dis > 0) THEN
   IF (xm) = statx THEN
    IF (((ym) - 12) / 1) >= 1 AND (((ym) - 12) / 1) <= LEN(e$(tx + (ty - 1) * AA, 1)) / 4 THEN
     AA$ = MID$(e$(tx + (ty - 1) * AA, 1), ((ym) - 13) * 4 + 1, 4)
     IF action$ <> AA$ THEN
      action$ = AA$
     ELSE
      action$ = "____"
     END IF
     c$ = "||"
    END IF
   END IF
  END IF
  GOSUB do_putaction
  stsng = TIMER
 END IF
 statx = 25
 IF c$ = "tint" OR c$ = "T" OR (ym = 3 AND xm = statx + 5 AND lb = -1) THEN
  GOTO do_starttitle
 END IF
 IF lb = -1 THEN
  IF ym > 2 AND ym < 24 THEN
   IF xm > 2 AND xm < 24 THEN
    tempy = INT((ym + 1 - 13) / 3 + dy)
    tempx = INT((xm + 1 - 13) / 3 + ex)
    dy = tempy
    ex = tempx
    c$ = "||"
   END IF
  END IF
 END IF
 SELECT CASE ex
 CASE IS < 1
  ex = 1
 CASE IS > AA
  ex = AA
 END SELECT
 SELECT CASE dy
 CASE IS < 1
  dy = 1
 CASE IS > DD
  dy = DD
 END SELECT
 IF rb = -1 THEN
  c$ = STRING$(1, 32)
  turncount = turncount + 1
 END IF
 IF INSTR(1, "L ||", RIGHT$(" " + c$, 1)) = 0 THEN
  GOTO do_command3
 END IF
 IF INSTR(1, "L||", RIGHT$(" " + c$, 1)) > 0 THEN
  GOTO do_command
 END IF
GOTO do_main

do_swapdata:
 FOR tint = 0 TO 1
  SWAP e$(tx + (ty - 1) * AA, tint), e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, tint)
 NEXT tint
 temp1$ = MID$(e$(tx + (ty - 1) * AA, 2), 1, 4)
 temp2$ = MID$(e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2), 1, 4)
 SWAP temp1$, temp2$
 MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) = temp1$
 MID$(e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2), 1, 4) = temp2$
 FOR tint = 3 TO 4
  SWAP e$(tx + (ty - 1) * AA, tint), e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, tint)
 NEXT tint
 FOR tint = 0 TO 16
  SWAP g(tx + (ty - 1) * AA, tint), g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, tint)
 NEXT tint
RETURN

do_attack:
 SELECT CASE CVL(MID$(e$(tx + (ty - 1) * AA, 3), 5, 4))
 CASE CVL("bite")
  GOSUB do_attkbite
 CASE CVL("pnch")
  GOSUB do_attkpnch
 CASE CVL("kick")
  GOSUB do_attkkick
 CASE CVL("vnom")
  GOSUB do_attkvnom
 CASE CVL("dggr")
  GOSUB do_attkdggr
 CASE CVL("pike")
  GOSUB do_attkpike
 CASE CVL("cure")
  GOSUB do_usecure
 CASE CVL("fire")
  GOSUB do_attkfire
 CASE ELSE
  MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
  MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "____"
 END SELECT
RETURN

do_battle:
 IF g(tx + (ty - 1) * AA, 2) >= struse AND g(tx + (ty - 1) * AA, 3) >= essuse THEN
  IF 1 = 1 THEN
   MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = attackpic$
   MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = attackname$
   g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) - struse
   g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) - essuse
   evadeattack = g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 15)
   evadeattack = evadeattack + RND(1) * (1 - evadeattack)
   attackblocked = attackdamage * (evadeattack) - g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 5)
   IF attackblocked < 0 THEN attackblocked = 0
   attackdamage = attackdamage * (1 - evadeattack) + attackblocked
   g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 1) = g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 1) - attackdamage
   GOSUB do_battleattack
   GOSUB do_victory
  END IF
 ELSE
   MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
   MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "____"
 END IF
RETURN

do_attkbite:
 attackpic$ = "bite"
 attackname$ = "bite"
 struse = 10
 essuse = 0
 attackdamage = 5
 strdamage = 2
 GOSUB do_battle
RETURN

do_attkpnch:
 attackpic$ = "pnch"
 attackname$ = "pnch"
 struse = 12
 essuse = 0
 attackdamage = 3
 strdamage = 2
 GOSUB do_battle
RETURN

do_attkwstf:
 attackpic$ = "wstf"
 attackname$ = "wstf"
 struse = 20
 essuse = 0
 attackdamage = 5
 strdamage = 4
 GOSUB do_battle
RETURN

do_attkkick:
 attackpic$ = "kick"
 attackname$ = "kick"
 struse = 14
 essuse = 0
 attackdamage = 4
 strdamage = 3
 GOSUB do_battle
RETURN

do_attkvnom:
 attackpic$ = "vnom"
 attackname$ = "vnom"
 struse = 0
 essuse = 15
 attackdamage = 7
 strdamage = 10
 GOSUB do_battle
RETURN

do_attkdggr:
 attackpic$ = "dggr"
 attackname$ = "dggr"
 struse = 18
 essuse = 0
 attackdamage = 8
 strdamage = 1
 GOSUB do_battle
RETURN

do_attkpike:
 attackpic$ = "pike"
 attackname$ = "pike"
 struse = 24
 essuse = 0
 attackdamage = 12
 strdamage = 8
 GOSUB do_battle
RETURN

do_attkburn:
 attackpic$ = "____"
 attackname$ = "burn"
 struse = 5
 essuse = 5
 attackdamage = 12
 strdamage = 15
 GOSUB do_battle
 IF MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) = "fire" THEN
  GOSUB do_gone
 END IF
RETURN

do_attkfire:
 attackpic$ = "____"
 attackname$ = "fire"
 struse = 5
 essuse = 20
 attackdamage = 15
 strdamage = 20
 GOSUB do_battle
RETURN

do_attkweb:
 attackpic$ = "____"
 attackname$ = "web_"
 struse = 22
 essuse = 0
 attackdamage = 0
 strdamage = 15
 GOSUB do_battle
RETURN

do_attktngl:
 attackpic$ = "____"
 attackname$ = "tngl"
 struse = 0
 essuse = 0
 attackdamage = 0
 strdamage = 10
 GOSUB do_battle
RETURN

do_attklash:
 attackpic$ = "____"
 attackname$ = "lash"
 struse = 0
 essuse = 0
 attackdamage = 5
 strdamage = 8
 GOSUB do_battle
RETURN

do_usecure:
 IF g(tx + (ty - 1) * AA, 3) >= 8 THEN
  IF 1 = 1 THEN
   MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "cure"
   MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "cure"
   AA$ = "cure"
   GOSUB do_attackung
   g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) - 8
   g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 1) = g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 1) + 12
   g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2) = g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2) + 15
   IF g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2) <= 0 THEN
    g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2) = 0
   END IF
   GOSUB do_victory
  END IF
 ELSE
  IF 1 = 1 THEN
   MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
   MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "____"
  END IF
 END IF
RETURN

do_useslep:
 IF g(tx + (ty - 1) * AA, 3) >= 8 THEN
  IF 1 = 1 THEN
   MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
   MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "slep"
   AA$ = "slep"
   GOSUB do_attackung
   g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) - 8
   MID$(e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 4), 1, 4) = "____"
   MID$(e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 4), 5, 4) = "zzzz"
   temptx = tx
   tempty = ty
   tx = tx + da(d, 1) * dis
   ty = ty + da(d, 2) * dis
   GOSUB do_tempget
   IF tempaction$ <> "zzzz" THEN
    tempaction$ = "zzzz"
    tempdis = 10 + INT(RND(1) * 6)
    GOSUB do_tempput
   END IF
   tx = temptx
   ty = tempty
   g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2) = g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2) - 15
   IF g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2) <= 0 THEN
    g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2) = 0
   END IF
   GOSUB do_victory
  END IF
 ELSE
  IF 1 = 1 THEN
   MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
   MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "____"
  END IF
 END IF
RETURN

do_victory:
 IF g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 1) <= 0 THEN
  expgain = g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 7)
  g(tx + (ty + -1) * AA, 6) = g(tx + (ty + -1) * AA, 6) + expgain
  strgain = g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2)
  g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) + strgain
  GOSUB do_defeated
  GOSUB do_windggr
  GOSUB do_winpike
  GOSUB do_wingrpl
  GOSUB do_winseed
  GOSUB do_winkey1
  GOSUB do_winkey2
  GOSUB do_delete
 END IF
RETURN

do_paylevelup:
 am$ = ctrl$
 GOSUB do_am
 IF am > 0 THEN
   renderfill 0, 0, 319, 199, textbg, 0
'LINE (0, 0)-(319, 199), textbg, BF
  GOSUB do_portal
  screencopy 1, 2
do_reshow1:
  screencopy 2, 1
  framex1sng = 15
  framex2sng = 40
  framey1sng = 4
  framey2sng = 24
  framec1 = 4
  framec2 = 12
  GOSUB do_frameput
  statx = 15
  GOSUB do_stts
  menu$ = ""
  menu$ = menu$ + "lvup" + MKL$(levelup(g(tx + (ty - 1) * AA, 10)))
  IF MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) = "plyr" THEN
   IF g(tx + (ty - 1) * AA, 10) >= 1 THEN
    haveit$ = "ispt"
    GOSUB do_haveit
    IF haveit = 0 THEN
     menu$ = menu$ + "ispt" + MKL$(0)
    END IF
   END IF
   IF g(tx + (ty - 1) * AA, 10) >= 1 THEN
    haveit$ = "move"
    GOSUB do_haveit
    IF haveit = 0 THEN
     menu$ = menu$ + "move" + MKL$(0)
    END IF
   END IF
   IF g(tx + (ty - 1) * AA, 10) >= 1 THEN
    haveit$ = "bite"
    GOSUB do_haveit
    IF haveit = 0 THEN
     menu$ = menu$ + "bite" + MKL$(2)
    END IF
   END IF
   IF g(tx + (ty - 1) * AA, 10) >= 1 THEN
    haveit$ = "pnch"
    GOSUB do_haveit
    IF haveit = 0 THEN
     menu$ = menu$ + "pnch" + MKL$(2)
    END IF
   END IF
   IF g(tx + (ty - 1) * AA, 10) >= 2 THEN
    haveit$ = "kick"
    GOSUB do_haveit
    IF haveit = 0 THEN
     menu$ = menu$ + "kick" + MKL$(10)
    END IF
   END IF
   IF g(tx + (ty - 1) * AA, 10) >= 3 THEN
    haveit$ = "cure"
    GOSUB do_haveit
    IF haveit = 0 THEN
     menu$ = menu$ + "cure" + MKL$(20)
    END IF
   END IF
   IF g(tx + (ty - 1) * AA, 10) >= 7 THEN
    haveit$ = "vnom"
    GOSUB do_haveit
    IF haveit = 0 THEN
     menu$ = menu$ + "vnom" + MKL$(30)
    END IF
   END IF
  END IF
  menu$ = menu$ + "cncl" + MKL$(0)
  menuze = LEN(menu$) / 8
  inmenu = 0
  FOR menuitem = 1 TO menuze
   menuitem$ = MID$(menu$, (menuitem - 1) * 8 + 1, 4)
   menucost = CVL(MID$(menu$, (menuitem - 1) * 8 + 5, 4))
   r$ = menuitem$
   GOSUB do_names
   IF menucost > 0 THEN
    text 10 + menuitem, 15, is_selected_hud( 0 ) + rr$ + " " + STRING$((40 - 15) - LEN(rr$) - 7, "-") + RIGHT$("----" + ltrim$(STR$(menucost)), LEN(ltrim$(STR$(menucost)))) + "$", 0
   END IF
   IF menucost = 0 THEN
    text 10 + menuitem, 15, is_selected_hud( 0 ) + rr$, 0
   END IF
  NEXT menuitem
do_wwait0:
  GOSUB do_buttonwait
  menuselect$ = "____"
  menucost = 0
  IF lb = -1 THEN
   IF xm = 15 THEN
    IF ym >= 11 AND ym <= 10 + menuze THEN
     menuselect = ym - 10
     menuselect$ = MID$(menu$, (menuselect - 1) * 8 + 1, 4)
     menucost = CVL(MID$(menu$, (menuselect - 1) * 8 + 5, 4))
    END IF
   END IF
  END IF
  IF menuselect$ <> "lvup" AND menuselect$ <> "cncl" AND menuselect$ <> "____" THEN
   IF g(tx + (ty - 1) * AA, 6) >= menucost THEN
     c$ = "L"
    GOSUB do_abilitygain
   END IF
   GOTO do_reshow1
  END IF
  IF menuselect$ = "lvup" THEN
   IF g(tx + (ty - 1) * AA, 6) >= menucost THEN
    c$ = "L"
    GOSUB do_levelup
   END IF
   GOTO do_reshow1
  END IF
  IF menuselect$ = "cncl" THEN
   c$ = "L"
  ELSE
   GOTO do_wwait0
  END IF
  screencopy 2, 1
 END IF
RETURN

#include once "do support\do merchant.bas"

do_talk0001:
 am$ = ctrl$
 GOSUB do_am
 IF am > 0 THEN
  screencopy 1, 4
  screencopy 2, 1
   renderfill 0, 0, 319, 199, textbg, 0
'LINE (0, 0)-(319, 199), textbg, BF
  screencopy 1, 2
do_reshow3:
  GOSUB do_portal
  statx = 2
  GOSUB do_status
  viewx = 18
  menu$ = ""
  menu$ = menu$ + "bye_" + MKL$(0)
  menuze = LEN(menu$) / 8
  inmenu = 0

#ifdef __old_talk__
	text 5, viewx, "Poindexter:", 0
	text 6, viewx, "Hi. How are you. My", 0
	text 7, viewx, "name is Poindexter. I", 0
	text 8, viewx, "am the greatest thief", 0
	text 9, viewx, "in the entire world!!", 0
	
	graphicput 10, viewx + 6, "bsv\sprites\" + (MID$(e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2), 1, 4) + "____.24")

#else
	call talk_hud( "pndx" )
#endif

  FOR menuitem = 1 TO menuze
   menuitem$ = MID$(menu$, (menuitem - 1) * 8 + 1, 4)
   menucost = CVL(MID$(menu$, (menuitem - 1) * 8 + 5, 4))
   r$ = menuitem$
   GOSUB do_names
   IF menucost > 0 THEN
    text 12 + menuitem, viewx, is_selected_hud( 0 ) + rr$ + " =" + STR$(menucost), 0
   END IF
   IF menucost = 0 THEN
    text 12 + menuitem, viewx, is_selected_hud( 0 ) + rr$, 0
   END IF
  NEXT menuitem
do_wwait2:
  GOSUB do_buttonwait
  menuselect$ = "____"
  menucost = 0
  IF lb = -1 THEN
   IF xm = viewx THEN
    IF ym >= 13 AND ym <= 12 + menuze THEN
     menuselect = ym - 12
     menuselect$ = MID$(menu$, (menuselect - 1) * 8 + 1, 4)
     menucost = CVL(MID$(menu$, (menuselect - 1) * 8 + 5, 4))
    END IF
   END IF
  END IF
  IF menuselect$ <> "bye_" THEN
   GOTO do_wwait2
  END IF
  IF menuselect$ = "bye_" THEN
   c$ = "L"
  ELSE
   GOTO do_wwait1
  END IF
  screencopy 4, 1
 END IF
RETURN

do_abilitygain:
 e$(tx + (ty - 1) * AA, 1) = e$(tx + (ty - 1) * AA, 1) + menuselect$
 g(tx + (ty - 1) * AA, 6) = g(tx + (ty - 1) * AA, 6) - menucost
 am$ = ctrl$
 GOSUB do_am
 IF am > 0 THEN
   renderfill (25 - 1) * 8, 0, 319, 199, textbg, -1
LINE ((25 - 1) * 8, 0)-(319, 199), textbg, BF
  screencopy 1, 2
  GOSUB do_portal
  GOSUB do_avgframe
  text 5, 25, e$(tx + (ty - 1) * AA, 0), textrate
  text 7, 25, "gained", textrate
  r$ = menuselect$
  GOSUB do_names
  text 9, 25, rr$, textrate
  GOSUB do_okbutton
  screencopy 2, 1
 END IF
RETURN

do_levelup:
 IF MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) <> "____" THEN
  IF g(tx + (ty - 1) * AA, 6) >= levelup(g(tx + (ty - 1) * AA, 10)) THEN
   g(tx + (ty - 1) * AA, 6) = g(tx + (ty - 1) * AA, 6) - levelup(g(tx + (ty - 1) * AA, 10))
   r1 = INT(RND(1) * 5) + 1
   g(tx + (ty - 1) * AA, 11) = g(tx + (ty - 1) * AA, 11) + r1
   g(tx + (ty - 1) * AA, 1) = g(tx + (ty - 1) * AA, 1) + r1
   r2 = INT(RND(1) * 5) + 1
   g(tx + (ty - 1) * AA, 12) = g(tx + (ty - 1) * AA, 12) + r2
   g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) + r2
   r3 = INT(RND(1) * 5) + 1
   g(tx + (ty - 1) * AA, 13) = g(tx + (ty - 1) * AA, 13) + r3
   g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) + r3
   r4 = .2
   g(tx + (ty - 1) * AA, 4) = g(tx + (ty - 1) * AA, 4) + r4
   r5 = .05
   g(tx + (ty - 1) * AA, 14) = g(tx + (ty - 1) * AA, 14) + r5
   am$ = ctrl$
   GOSUB do_am
   IF am > 0 THEN
   renderfill (25 - 1) * 8, 0, 319, 199, textbg, -1
    'LINE ((25 - 1) * 8, 0)-(319, 199), textbg, BF
    screencopy 1, 2
    GOSUB do_portal
    GOSUB do_avgframe
    text 5, 25, e$(tx + (ty - 1) * AA, 0), textrate
    text 7, 25, "      level up", textrate
    text 9, 25, "HPmax +", textrate
    text 9, 35, RIGHT$(STRING$(5, " ") + STR$(r1), 5), textrate
    text 11, 25, "STRmax +", textrate
    text 11, 35, RIGHT$(STRING$(5, " ") + STR$(r2), 5), textrate
    text 13, 25, "ESSmax +", textrate
    text 13, 35, RIGHT$(STRING$(5, " ") + STR$(r3), 5), textrate
    text 15, 25, "STRspd up", textrate
    text 16, 25, "ESSspd up", textrate
   END IF
   IF g(tx + (ty - 1) * AA, 10) < 64 THEN
    g(tx + (ty - 1) * AA, 10) = g(tx + (ty - 1) * AA, 10) + 1
    am$ = ctrl$
    GOSUB do_am
    IF am > 0 THEN
     text 18, 25, "reached LV#", textrate
     text 18, 37, RIGHT$(STRING$(3, " ") + STR$(g(tx + (ty - 1) * AA, 10)), 3), textrate
     IF levelup(g(tx + (ty - 1) * AA, 10)) - g(tx + (ty - 1) * AA, 6) >= 0 THEN
      text 20, 25, "do_next:", textrate
      text 20, 34, RIGHT$(STRING$(5, " ") + STR$(levelup(g(tx + (ty - 1) * AA, 10)) - g(tx + (ty - 1) * AA, 6)), 5) + "$", textrate
     END IF
    END IF
   END IF
   am$ = ctrl$
   GOSUB do_am
   IF am > 0 THEN
    GOSUB do_okbutton
    screencopy 2, 1
   END IF
   IF g(tx + (ty - 1) * AA, 10) >= 2 AND MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) = "spdr" THEN
    getit$ = "vnom"
    haveit$ = "vnom"
    GOSUB do_haveit
    IF haveit = 0 THEN
     e$(tx + (ty - 1) * AA, 1) = e$(tx + (ty - 1) * AA, 1) + getit$
     GOSUB do_gain
    END IF
   END IF
  END IF
 END IF
RETURN

do_gain:
 am$ = ctrl$
 GOSUB do_am
 IF am > 0 THEN
     renderfill (25 - 1) * 8, 0, 319, 199, textbg, -1
'LINE ((25 - 1) * 8, 0)-(319, 199), textbg, BF
  screencopy 1, 2
  GOSUB do_portal
  GOSUB do_avgframe
  text 5, 25, e$(tx + (ty - 1) * AA, 0), textrate
  text 7, 25, "gained", textrate
  r$ = getit$
  GOSUB do_names
  text 9, 25, rr$, textrate
  GOSUB do_okbutton
  screencopy 2, 1
 END IF
RETURN

do_getit:
 IF getit$ <> "" THEN
  e$(tx + (ty - 1) * AA, 1) = e$(tx + (ty - 1) * AA, 1) + getit$
  am$ = ctrl$
  GOSUB do_am
  are$ = ctrl$
  GOSUB do_are
  IF am > 0 OR are > 0 THEN
      renderfill (25 - 1) * 8, 0, 319, 199, textbg, -1
'LINE ((25 - 1) * 8, 0)-(319, 199), textbg, BF
   screencopy 1, 2
   GOSUB do_portal
   GOSUB do_avgframe
   text 5, 25, e$(tx + (ty - 1) * AA, 0), textrate
   text 6, 25, "gained", textrate
   r$ = getit$
   GOSUB do_names
   text 7, 25, rr$, textrate
   text 8, 25, "from", textrate
   text 9, 25, e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 0) + "!", textrate
   GOSUB do_okbutton
   screencopy 2, 1
  END IF
 END IF
RETURN

do_attackung:
 am$ = ctrl$
 GOSUB do_am
 are$ = ctrl$
 GOSUB do_are
 IF am > 0 OR are > 0 THEN
     renderfill (25 - 1) * 8, 0, 319, 199, textbg, -1
'LINE ((25 - 1) * 8, 0)-(319, 199), textbg, BF
  screencopy 1, 2
  GOSUB do_portal
  GOSUB do_avgframe
  text 5, 25, e$(tx + (ty - 1) * AA, 0), textrate
  text 6, 25, "used", textrate
  r$ = AA$
  GOSUB do_names
  text 7, 25, rr$, textrate
  text 8, 25, "on", textrate
  text 9, 25, e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 0), textrate
  GOSUB do_okbutton
  screencopy 2, 1
 END IF
RETURN

do_battleattack:
 am$ = ctrl$
 GOSUB do_am
 are$ = ctrl$
 GOSUB do_are
 IF am > 0 OR are > 0 THEN
     renderfill (25 - 1) * 8, 0, 319, 199, textbg, -1
'LINE ((25 - 1) * 8, 0)-(319, 199), textbg, BF
  screencopy 1, 2
  GOSUB do_portal
  GOSUB do_avgframe
  text 5, 25, e$(tx + (ty - 1) * AA, 0), textrate
  text 6, 25, "used", textrate
  r$ = MID$(e$(tx + (ty - 1) * AA, 4), 5, 4)
  GOSUB do_names
  text 7, 25, rr$, textrate
  text 9, 25, e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 0), textrate
  text 10, 25, "HP  down " + ltrim$(STR$(attackdamage)), textrate
  text 11, 25, "STR down " + ltrim$(STR$(strdamage)), textrate
  GOSUB do_okbutton
  screencopy 2, 1
 END IF
RETURN

do_defeated:
 am$ = ctrl$
 GOSUB do_am
 are$ = ctrl$
 GOSUB do_are
 IF am > 0 OR are > 0 THEN
     renderfill (25 - 1) * 8, 0, 319, 199, textbg, -1
'LINE ((25 - 1) * 8, 0)-(319, 199), textbg, BF
  screencopy 1, 2
  GOSUB do_portal
  GOSUB do_avgframe
  text 5, 25, e$(tx + (ty - 1) * AA, 0), textrate
  text 6, 25, "defeated", textrate
  text 7, 25, e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 0), textrate
  text 8, 25, "EXP+", textrate
  text 9, 25, RIGHT$(STRING$(16, " ") + STR$(expgain), 15), textrate
  text 10, 25, "EXP:", textrate
  text 11, 25, RIGHT$(STRING$(16, " ") + STR$(g(tx + (ty - 1) * AA, 6)), 15), textrate
  text 12, 25, "STR+", textrate
  text 13, 25, RIGHT$(STRING$(16, " ") + STR$(strgain), 15), textrate
  text 14, 25, "STR:", textrate
  text 15, 25, RIGHT$(STRING$(16, " ") + STR$(g(tx + (ty - 1) * AA, 2)), 15), textrate
  GOSUB do_okbutton
  screencopy 2, 1
 END IF
RETURN

do_portal:
 textbg = 0
 framex1sng = ((-3) * 3 + 13 - 1)
 framex2sng = ((4) * 3 + 13 - 1)
 framey1sng = ((-3) * 3 + 13 - 1) - 1
 framey2sng = ((4) * 3 + 13 - 1)
 framec1 = 1
 framec2 = 9
 GOSUB do_frameput
 PSET (((3) * 3 + 13 - 1) * 8 + 16, ((7.5 * ty / DD - 3) * 3 + 13 - 2.5) * 8 - 8), 3
 LINE -(((3) * 3 + 13 - 1) * 8 + 18, ((7.5 * ty / DD - 3) * 3 + 13 - 2.5) * 8 - 8), 3
 PSET (((7.5 * tx / AA - 3) * 3 + 13 - 2.5) * 8 - 8, ((3) * 3 + 13 - 1) * 8 + 16), 3
 LINE -(((7.5 * tx / AA - 3) * 3 + 13 - 2.5) * 8 - 8, ((3) * 3 + 13 - 1) * 8 + 18), 3
 dx1 = tx - 3
 dy1 = ty - 3
 dx2 = tx + 3
 dy2 = ty + 3
 IF dx1 < 1 THEN
  dx1 = 1
 END IF
 IF dy1 < 1 THEN
  dy1 = 1
 END IF
 IF dx2 > AA THEN
  dx2 = AA
 END IF
 IF dy2 > DD THEN
  dy2 = DD
 END IF
 FOR ttx = dx1 TO dx2
 FOR tty = dy1 TO dy2
  graphicput ((tty - ty) * 3 + 13 - 1), ((ttx - tx) * 3 + 13 - 1), "bsv\sprites\" + (MID$(e$(ttx + (tty - 1) * AA, 2), 5, 4) + "____" + ".24")
  graphicput ((tty - ty) * 3 + 13 - 1), ((ttx - tx) * 3 + 13 - 1), "bsv\sprites\" + (MID$(e$(ttx + (tty - 1) * AA, 2), 1, 4) + MID$(e$(ttx + (tty - 1) * AA, 4), 1, 4) + ".24")
  temptx = tx
  tempty = ty
  tx = ttx
  ty = tty
  GOSUB do_tempget
  tx = temptx
  ty = tempty
  IF tempaction$ = "zzzz" THEN
   graphicput ((tty - ty) * 3 + 13 - 1), ((ttx - tx) * 3 + 13 - 1), "bsv\sprites\" + ("zzzz____.24")
  END IF
 NEXT tty
 NEXT ttx
 FOR ttx = dx1 TO dx2
 FOR tty = dy1 TO dy2
  temptx = tx
  tempty = ty
  tx = ttx
  ty = tty
  GOSUB do_tempget
  tx = temptx
  ty = tempty
  IF tempaction$ = "grpl" OR tempaction$ = "rapl" THEN
   IF tempdis > 0 THEN
     tempy1sng = (tty - ty) * 3 + 13 - 1
     tempx1sng = (ttx - tx) * 3 + 13 - 1
     tempy2sng = (tty - ty + da(tempd, 2) * tempdis) * 3 + 13 - 1
     tempx2sng = (ttx - tx + da(tempd, 1) * tempdis) * 3 + 13 - 1
     PSET ((tempx1sng - 1) * 8 + 12, (tempy1sng - 1) * 8 + 12), 6
     pset ((tempx2sng - 1) * 8 + 12, (tempy2sng - 1) * 8 + 12), 6
    FOR t! = 0 TO tempdis STEP tempdis / 8
     tempysng = (tty - ty + da(tempd, 2) * t!) * 3 + 13 - 1
     tempxsng = (ttx - tx + da(tempd, 1) * t!) * 3 + 13 - 1
     ttsng = t!
     IF tempdis <= 1 THEN
      ttsng = t!
     ELSE
      IF t! < tempdis - 1 THEN
       ttsng = -1
      ELSE
       ttsng = t! - tempdis + 1
      END IF
     END IF
     IF ttsng >= 0 THEN
      PSET ((tempxsng - 1) * 8 + 12, (tempysng - 1) * 8 + 12 - ttsng), 7
      PSET ((tempxsng - 1) * 8 + 12 + ttsng, (tempysng - 1) * 8 + 12), 7
      PSET ((tempxsng - 1) * 8 + 12, (tempysng - 1) * 8 + 12 + ttsng), 7
      PSET ((tempxsng - 1) * 8 + 12 - ttsng, (tempysng - 1) * 8 + 12), 7
     END IF
    NEXT t!
   END IF
  END IF
 NEXT tty
 NEXT ttx
RETURN

do_title:
 color 15,1
 CLS
 colr = 9
 texts$ = "   ÍÍÍ"
 GOSUB do_showtext
 texts$ = "  ðúú/ð"
 GOSUB do_showtext
 texts$ = " ºúú/³úº"
 GOSUB do_showtext
 texts$ = " ºú/úÂÄº AquariusúGames"
 GOSUB do_showtext
 texts$ = " º/ÄÄÙúº"
 GOSUB do_showtext
 texts$ = "  ðúú³ð"
 GOSUB do_showtext
 texts$ = "   ÍÍÍ"
 GOSUB do_showtext
 colr = 11
 text 2, 6, "/", colr
 text 3, 5, "/³", colr
 text 4, 4, "/", colr
 text 4, 6, "ÂÄ", colr
 text 4, 10, "AquariusúGames", colr
 text 5, 3, "/ÄÄÙ", colr
 text 6, 6, "³", colr
 LOCATE 9, 1

 graphicput 1, 2, "bsv\logos\" + "aquagame.56"

RETURN



do_status:
 GOSUB do_sttsfram
 GOSUB do_stts
 GOSUB do_sttsgpic
 GOSUB do_stttms
RETURN

do_sttsfram:
 framex1sng = statx
 framex2sng = 40
 framey1sng = 4
 framey2sng = 24
 framec1 = 4
 framec2 = 12
 GOSUB do_frameput
RETURN

do_stts:
 text 5, statx, e$(tx + (ty - 1) * AA, 0), 0
 text 6, statx, "LV", 0
 text 6, statx + 3, RIGHT$(STR$(100 + g(tx + (ty - 1) * AA, 10)), 2), 0
 text 6, statx + 9, (RIGHT$("     " + STR$(g(tx + (ty - 1) * AA, 6)), 5) + "$"), 0
 text 6, statx + 2, is_selected_hud( 0 ), 0
 text 7, statx, "HP", 0
 text 7, statx + 4, RIGHT$(STR$(10000 + INT(g(tx + (ty - 1) * AA, 1))), 4), 0
 text 7, statx + 9, "/", 0
 text 7, statx + 11, RIGHT$(STR$(10000 + INT(g(tx + (ty - 1) * AA, 11))), 4), 0
 text 8, statx, "STR", 0
 text 8, statx + 4, RIGHT$(STR$(10000 + INT(g(tx + (ty - 1) * AA, 2))), 4), 0
 text 8, statx + 9, "/", 0
 text 8, statx + 11, RIGHT$(STR$(10000 + INT(g(tx + (ty - 1) * AA, 12))), 4), 0
 text 9, statx, "ESS", 0
 text 9, statx + 4, RIGHT$(STR$(10000 + INT(g(tx + (ty - 1) * AA, 3))), 4), 0
 text 9, statx + 9, "/", 0
 text 9, statx + 11, RIGHT$(STR$(10000 + INT(g(tx + (ty - 1) * AA, 13))), 4), 0
RETURN

do_sttsgpic:
 GOSUB do_getaction
 SELECT CASE d
 CASE 0
  graphicput 10, statx, "bsv\sprites\" + "bttn"+ds(d)+".24"
 CASE 1
  graphicput 10, statx, "bsv\sprites\" + "bttn"+ds(d)+".24"
 CASE 2
  graphicput 10, statx, "bsv\sprites\" + "bttn"+ds(d)+".24"
 CASE 3
  graphicput 10, statx, "bsv\sprites\" + "bttn"+ds(d)+".24"
 CASE 4
  graphicput 10, statx, "bsv\sprites\" + "bttn"+ds(d)+".24"
 END SELECT
 graphicput 10, statx + 6, "bsv\sprites\" + (MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) + "____.24")
 graphicput 10, statx + 3, "bsv\sprites\" + (MID$(e$(tx + (ty - 1) * AA, 3), 5, 4) + "____.24")
RETURN

do_stttms:
 FOR tint = 1 TO LEN(e$(tx + (ty - 1) * AA, 1)) / 4
  r$ = MID$(e$(tx + (ty - 1) * AA, 1), (tint - 1) * 4 + 1, 4)
  GOSUB do_names
  IF action$ <> r$ THEN
   text 12 + (tint) * 1, statx, is_selected_hud( 0 ) + rr$, 0
  ELSE
   text 12 + (tint) * 1, statx, is_selected_hud( 1 ) + rr$, 0
  END IF
 NEXT tint
RETURN

do_names:

	if len(r$) = 0 then
		r$ = "____"
	end if
	
	rr$ = name_as_string( sync_names( "cards/" + r$ + "/longname", longnames_table() ) )
	
RETURN

do_move:
 MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "move"
 MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "move"
 IF g(tx + (ty - 1) * AA, 2) >= 1 AND MID$(e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2), 1, 4) = "____" THEN
  move = 1
  here$ = "watr"
  GOSUB do_here
  IF here > 0 THEN move = 0
  there$ = "watr"
  GOSUB do_there
  IF there > 0 THEN move = 0
  here$ = "hole"
  GOSUB do_here
  there$ = "holestps"
  GOSUB do_there
  IF here > 0 AND there <= 0 THEN move = 0
  IF move = 1 THEN
   IF tx = ex AND ty = dy THEN
    am$ = ctrl$
    GOSUB do_am
    IF am > 0 THEN
     ex = tx + da(d, 1) * dis
     dy = ty + da(d, 2) * dis
    END IF
   END IF
   g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) - 1
   GOSUB do_swapdata
  END IF
 END IF
RETURN

do_wingmove:
 MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "move"
 MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "move"
 IF g(tx + (ty - 1) * AA, 2) >= 3 AND MID$(e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2), 1, 4) = "____" THEN
  move = 1
  IF move = 1 THEN
   IF tx = ex AND ty = dy THEN
    am$ = ctrl$
    GOSUB do_am
    IF am > 0 THEN
     ex = tx + da(d, 1) * dis
     dy = ty + da(d, 2) * dis
    END IF
   END IF
   g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) - 3
   GOSUB do_swapdata
  END IF
 END IF
RETURN

do_firemove:
 IF g(tx + (ty - 1) * AA, 2) >= 1 THEN
  IF 1 = 1 THEN
   IF tx = ex AND ty = dy THEN
    am$ = ctrl$
    GOSUB do_am
    IF am > 0 THEN
     ex = tx + da(d, 1) * dis
     dy = ty + da(d, 2) * dis
    END IF
   END IF
   MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
   MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "move"
   g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) - 1
   GOSUB do_swapdata
  END IF
 ELSE
  GOSUB do_gone
 END IF
RETURN

do_webmove:
 IF tx = ex AND ty = dy THEN
  am$ = ctrl$
  GOSUB do_am
  IF am > 0 THEN
   ex = tx + da(d, 1) * dis
   dy = ty + da(d, 2) * dis
  END IF
 END IF
 MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "move"
 MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "move"
 g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) - 1
 GOSUB do_swapdata
RETURN

do_castfire:
 IF g(tx + (ty - 1) * AA, 3) >= 20 THEN
  MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
  MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "fire"
  g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) - 20
  GOSUB do_prflblnk
  prflidty$ = "Flame"
  prflactn$ = "moveburn"
  prflgpic$ = "fire"
  prflcmnd$ = MKL$(d) + "move" + MKL$(0)
  prflhpsng = 120
  prflstrsng = 10
  prflesssng = 100
  prflspdsng = 1
  prflvalusng = 1
  prflchcksng = 1
  prfllvsng = 1
  prflhpmaxsng = 120
  prflstrmaxsng = 50
  prflessmaxsng = 100
  prflessspdsng = 5
  GOSUB do_prflmake
 END IF
RETURN

do_castdust:
 IF g(tx + (ty - 1) * AA, 3) >= 8 THEN
  MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
  MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "dust"
  g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) - 8
  GOSUB do_prflblnk
  prflidty$ = "Sleepy dust"
  prflactn$ = "move"
  prflgpic$ = "dust"
  prflcmnd$ = MKL$(d) + "move" + MKL$(0)
  prflhpsng = 120
  prflstrsng = 10
  prflesssng = 100
  prflspdsng = 1
  prflvalusng = 1
  prflchcksng = 1
  prfllvsng = 1
  prflhpmaxsng = 120
  prflstrmaxsng = 50
  prflessmaxsng = 100
  prflessspdsng = 5
  GOSUB do_prflmake
 END IF
RETURN
   
do_castweb:
 IF g(tx + (ty - 1) * AA, 3) >= 220 THEN
  g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) - 220
  GOSUB do_prflblnk
  prflidty$ = "Web"
  prflactn$ = "spdr"
  prflgpic$ = "web_"
  prflcmnd$ = MKL$(d) + "move" + MKL$(0)
  prflidtysng = 3
  prflhpsng = 40
  prflstrsng = 50
  prflspdsng = 1
  prflvalusng = 1
  prflchcksng = 1
  prfllvsng = 1
  prflhpmaxsng = 40
  prflstrmaxsng = 50
  prflessmaxsng = 380
  prflessspdsng = 2
  GOSUB do_prflmake
 END IF
RETURN
    
do_castspdr:
 IF g(tx + (ty - 1) * AA, 3) >= 320 THEN
  g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) - 320
  GOSUB do_prflblnk
  prflidty$ = "Spider"
  prflactn$ = "movebiteweb_"
  prflgpic$ = "spdr"
  prflcmnd$ = MKL$(0) + "move" + MKL$(0)
  prflidtysng = 1
  prflhpsng = 10
  prflstrsng = 20
  prflspdsng = 1
  prflarmrsng = 1
  prflvalusng = 5
  prflpircsng = 1
  prfllvsng = 1
  prflhpmaxsng = 10
  prflstrmaxsng = 20
  prflessmaxsng = 380
  prflessspdsng = 3
  GOSUB do_prflmake
 END IF
RETURN

do_castccts:
 GOSUB do_prflblnk
 prflidty$ = "Cactus"
 prflgpic$ = "ccts"
 prflidtysng = 13
 prflhpsng = 10
 prflstrsng = 20
 prflspdsng = 1
 prflarmrsng = 1
 prflvalusng = 5
 prflpircsng = 3
 prflchcksng = 1
 prfllvsng = 1
 prflhpmaxsng = 10
 prflstrmaxsng = 20
 prflessmaxsng = 380
 prflessspdsng = 3
 GOSUB do_prflmake
RETURN
     
do_castdtby:
 IF g(tx + (ty - 1) * AA, 3) >= 160 THEN
  g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) - 160
  GOSUB do_prflblnk
  prflidty$ = "Dust Bunny"
  prflactn$ = "bitekick"
  prflgpic$ = "dtby"
  prflcmnd$ = MKL$(0) + "move" + MKL$(0)
  prflidtysng = 6
  prflhpsng = 15
  prflstrsng = 20
  prflesssng = 5
  prflspdsng = 1.2
  prflvalusng = 2
  prflchcksng = 1
  prfllvsng = 1
  prflhpmaxsng = 15
  prflstrmaxsng = 20
  prflessmaxsng = 280
  prflessspdsng = 1
 GOSUB do_prflmake
 END IF
RETURN

do_gone:
 GOSUB do_prflblnk
 GOSUB do_prflset
RETURN

do_delete:
 GOSUB do_prflblnk
 GOSUB do_prflmake
RETURN

do_autolevelup:
 am$ = ctrl$
 GOSUB do_am
 IF am = 0 THEN
  GOSUB do_levelup
 END IF
RETURN

do_statgain:
 g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) + g(tx + (ty - 1) * AA, 4)
 g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) + g(tx + (ty - 1) * AA, 14)
RETURN

do_statmax:
 IF g(tx + (ty - 1) * AA, 1) > g(tx + (ty - 1) * AA, 11) THEN
  g(tx + (ty - 1) * AA, 1) = g(tx + (ty - 1) * AA, 11)
 END IF
 IF g(tx + (ty - 1) * AA, 2) > g(tx + (ty - 1) * AA, 12) THEN
  g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 12)
 END IF
 IF g(tx + (ty - 1) * AA, 3) > g(tx + (ty - 1) * AA, 13) THEN
  g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 13)
 END IF
RETURN

do_nextaction:
 am$ = ctrl$
 GOSUB do_am
 IF am = 0 THEN
  IF 1 = 1 THEN
   GOSUB do_newaction
   GOSUB do_putaction
  END IF
 ELSE
  GOSUB do_getaction
 END IF
RETURN

do_newaction:
 GOSUB do_getaction
 IF NOT (action$ = "zzzz" AND dis > 0) THEN
  d = INT(RND(1) * 4) + 1
  GOSUB do_randomaction
  dis = 0
 END IF
RETURN

do_randomaction:
 r = LEN(e$(tx + (ty - 1) * AA, 1)) / 4
 r = INT(RND(1) * (r + 1))
 IF r = 0 THEN
  action$ = "____"
 ELSE
  action$ = MID$(e$(tx + (ty - 1) * AA, 1), (r - 1) * 4 + 1, 4)
 END IF
RETURN

do_getaction:
 d = CVL(MID$(e$(tx + (ty - 1) * AA, 3), 1, 4))
 action$ = MID$(e$(tx + (ty - 1) * AA, 3), 5, 4)
 dis = CVL(MID$(e$(tx + (ty - 1) * AA, 3), 9, 4))
RETURN

do_putaction:
 MID$(e$(tx + (ty - 1) * AA, 3), 1, 4) = MKL$(d)
 MID$(e$(tx + (ty - 1) * AA, 3), 5, 4) = action$
 MID$(e$(tx + (ty - 1) * AA, 3), 9, 4) = MKL$(dis)
RETURN

do_tempget:
 tempd = CVL(MID$(e$(tx + (ty - 1) * AA, 3), 1, 4))
 tempaction$ = MID$(e$(tx + (ty - 1) * AA, 3), 5, 4)
 tempdis = CVL(MID$(e$(tx + (ty - 1) * AA, 3), 9, 4))
RETURN

do_tempput:
 MID$(e$(tx + (ty - 1) * AA, 3), 1, 4) = MKL$(tempd)
 MID$(e$(tx + (ty - 1) * AA, 3), 5, 4) = tempaction$
 MID$(e$(tx + (ty - 1) * AA, 3), 9, 4) = MKL$(tempdis)
RETURN

do_inbounds:
 IF tx + da(d, 1) * dis >= 1 AND tx + da(d, 1) * dis <= AA AND ty + da(d, 2) * dis >= 1 AND ty + da(d, 2) * dis <= DD THEN
  inbounds = 1
 ELSE
  inbounds = 0
 END IF
RETURN

#include once "do support\do possession.bas"

do_winexp:
 getit = g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 6)
 IF getit > 0 THEN
  getit$ = STR$(getit) + " EXP"
  getit$ = RIGHT$(getit$, LEN(getit$) - 1)
  g(tx + (ty - 1) * AA, 1) = g(tx + (ty - 1) * AA, 1) + getit
  GOSUB do_getit
  g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 6) = 0
 END IF
RETURN

do_windggr:
 winit$ = "dggr"
GOTO do_winit

do_winpike:
 winit$ = "pike"
GOTO do_winit

do_wingrpl:
 winit$ = "grpl"
GOTO do_winit

do_winseed:
 winit$ = "seed"
GOTO do_winit

do_winkey1:
 winit$ = "key1"
GOTO do_winit

do_winkey2:
 winit$ = "key2"
GOTO do_winit

do_winit:
 getit$ = winit$
 hasit$ = winit$
 GOSUB do_hasit
 IF hasit = 0 THEN RETURN
 haveit$ = winit$
 GOSUB do_haveit
 IF haveit > 0 THEN RETURN
 GOSUB do_getit
 hashadit$ = winit$
 GOSUB do_hashadit
RETURN

do_am:
 am = 0
 FOR tint = 1 TO LEN(am$) / 4
  IF MID$(am$, (tint - 1) * 4 + 1, 4) = MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) THEN
   am = am + 1
  END IF
 NEXT tint
RETURN

do_are:
 are = 0
 FOR tint = 1 TO LEN(are$) / 4
  IF MID$(are$, (tint - 1) * 4 + 1, 4) = MID$(e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2), 1, 4) THEN
   are = are + 1
  END IF
 NEXT tint
RETURN

do_here:
 here = 0
 FOR tint = 1 TO LEN(here$) / 4
  IF MID$(here$, (tint - 1) * 4 + 1, 4) = MID$(e$(tx + (ty - 1) * AA, 2), 5, 4) THEN
   here = here + 1
  END IF
 NEXT tint
RETURN

do_there:
 there = 0
 FOR tint = 1 TO LEN(there$) / 4
  IF MID$(there$, (tint - 1) * 4 + 1, 4) = MID$(e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2), 5, 4) THEN
   there = there + 1
  END IF
 NEXT tint
RETURN

do_blankcheck:
 are$ = blankcheck$
 GOSUB do_inbounds
 IF inbounds = 1 THEN
  GOSUB do_are
 ELSE
  are = -1
 END IF
 blankcheck = are
RETURN

do_okbutton:
 text 23, 25, is_selected_hud( 0 ) + "Ok", 0
do_wwait:
 GOSUB do_buttonwait
 IF ((c$ = "O" OR c$ = CHR$(13) OR c$ = "o") OR (ym = 23 AND xm = 25 AND lb = -1)) THEN
  c$ = "L"
 ELSE
  GOTO do_wwait
 END IF
RETURN

do_buttonwait:
 screencopy 1, 3
 cinput
 cursorput
  screen_scaler 1, 7
'screencopy 1, 0
 screencopy 3, 1
RETURN
  
do_commandwait:
 screencopy 1, 2
 c$ = "%%"
 lb = 0
 WHILE c$ = "%%" AND lb = 0
  cinput
  cursorput
   screen_scaler 1, 7
'screencopy 1, 0
  screencopy 2, 1
 WEND
RETURN

do_frameput:
 renderfill (framex1sng - 2) * 8 + 7, (framey1sng - 1) * 8 + 7, (framex2sng - 1) * 8, (framey2sng - 1) * 8, 8, 0

 LINE ((framex1sng - 2) * 8 + 7, (framey1sng - 1) * 8 + 7)-((framex2sng - 1) * 8, (framey2sng - 1) * 8), 0, BF
 LINE ((framex1sng - 2) * 8 + 7, (framey1sng - 1) * 8 + 5)-((framex2sng - 1) * 8, (framey2sng - 1) * 8 + 2), framec1, B
 LINE ((framex1sng - 2) * 8 + 5, (framey1sng - 1) * 8 + 7)-((framex2sng - 1) * 8 + 2, (framey2sng - 1) * 8), framec1, B
 LINE ((framex1sng - 2) * 8 + 6, (framey1sng - 1) * 8 + 6)-((framex2sng - 1) * 8 + 1, (framey2sng - 1) * 8 + 1), framec2, B
 PSET ((framex1sng - 2) * 8 + 6, (framey1sng - 1) * 8 + 6), framec1
 PSET ((framex2sng - 1) * 8 + 1, (framey2sng - 1) * 8 + 1), framec1
 PSET ((framex1sng - 2) * 8 + 6, (framey2sng - 1) * 8 + 1), framec1
 PSET ((framex2sng - 1) * 8 + 1, (framey1sng - 1) * 8 + 6), framec1
RETURN

do_avgframe:
 framex1sng = 25
 framex2sng = 40
 framey1sng = 4
 framey2sng = 24
 framec1 = 4
 framec2 = 12
 GOSUB do_frameput
RETURN

do_screenset:
 screencopy 2, 1
  screen_scaler 1, 7
'screencopy 1, 0
 SCREEN 7, 0, 0, 0
 COLOR 15, 1
RETURN

do_findcrsr:
 crsry = CSRLIN
 crsrx = POS(0)
RETURN

do_showtext:
 textfg = colr
 GOSUB do_findcrsr
 text crsry, crsrx, texts$, colr
 LOCATE crsry + 1, 1
RETURN

do_prflblnk:
 prflidty$ = ""
 prflactn$ = ""
 prflgpic$ = "____"
 prflcmnd$ = MKL$(0) + "____" + MKL$(0)
 prflgpicactn$ = "____" + "____"
 prflidtysng = 0
 prflhpsng = 0
 prflstrsng = 0
 prflesssng = 0
 prflspdsng = 0
 prflarmrsng = 0
 prflexpsng = 0
 prflvalusng = 0
 prflpircsng = 0
 prflchcksng = 0
 prfllvsng = 0
 prflhpmaxsng = 0
 prflstrmaxsng = 0
 prflessmaxsng = 0
 prflessspdsng = 0
 prflevadsng = 0
 prflblnksng = 0
RETURN

do_prflset:
 e$(tx + (ty - 1) * AA, 0) = prflidty$
 e$(tx + (ty - 1) * AA, 1) = prflactn$
 MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) = prflgpic$
 e$(tx + (ty - 1) * AA, 3) = prflcmnd$
 e$(tx + (ty - 1) * AA, 4) = prflgpicactn$
 g(tx + (ty - 1) * AA, 0) = prflidtysng
 g(tx + (ty - 1) * AA, 1) = prflhpsng
 g(tx + (ty - 1) * AA, 2) = prflstrsng
 g(tx + (ty - 1) * AA, 3) = prflesssng
 g(tx + (ty - 1) * AA, 4) = prflspdsng
 g(tx + (ty - 1) * AA, 5) = prflarmrsng
 g(tx + (ty - 1) * AA, 6) = prflexpsng
 g(tx + (ty - 1) * AA, 7) = prflvalusng
 g(tx + (ty - 1) * AA, 8) = prflpircsng
 g(tx + (ty - 1) * AA, 9) = prflchcksng
 g(tx + (ty - 1) * AA, 10) = prfllvsng
 g(tx + (ty - 1) * AA, 11) = prflhpmaxsng
 g(tx + (ty - 1) * AA, 12) = prflstrmaxsng
 g(tx + (ty - 1) * AA, 13) = prflessmaxsng
 g(tx + (ty - 1) * AA, 14) = prflessspdsng
 g(tx + (ty - 1) * AA, 15) = prflevadsng
 g(tx + (ty - 1) * AA, 16) = prflblnksng
RETURN

do_prflmake:
 e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 0) = prflidty$
 e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 1) = prflactn$
 MID$(e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2), 1, 4) = prflgpic$
 e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 3) = prflcmnd$
 e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 4) = prflgpicactn$
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 0) = prflidtysng
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 1) = prflhpsng
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2) = prflstrsng
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 3) = prflesssng
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 4) = prflspdsng
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 5) = prflarmrsng
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 6) = prflexpsng
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 7) = prflvalusng
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 8) = prflpircsng
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 9) = prflchcksng
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 10) = prfllvsng
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 11) = prflhpmaxsng
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 12) = prflstrmaxsng
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 13) = prflessmaxsng
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 14) = prflessspdsng
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 15) = prflevadsng
 g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 16) = prflblnksng
RETURN

do_actncure:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN RETURN
 IF blankcheck > 0 THEN RETURN
 blankcheck$ = "plyrspdrgrmldtbyemgdshktimp_"
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_usecure
  RETURN
 END IF
RETURN

do_actnbite:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN RETURN
 IF blankcheck > 0 THEN RETURN
 blankcheck$ = attackthem$
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_attkbite
  RETURN
 END IF
RETURN

do_actnpnch:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN RETURN
 IF blankcheck > 0 THEN RETURN
 blankcheck$ = attackthem$
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_attkpnch
  RETURN
 END IF
RETURN

do_actnkick:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN RETURN
 IF blankcheck > 0 THEN RETURN
 blankcheck$ = attackthem$
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_attkkick
  RETURN
 END IF
RETURN

do_actndggr:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN RETURN
 IF blankcheck > 0 THEN RETURN
 blankcheck$ = attackthem$
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_attkdggr
  RETURN
 END IF
RETURN

do_actnpike:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN RETURN
 IF blankcheck > 0 THEN RETURN
 blankcheck$ = attackthem$
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_attkpike
  RETURN
 END IF
RETURN

do_actnvnom:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN RETURN
 IF blankcheck > 0 THEN RETURN
 blankcheck$ = attackthem$
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_attkvnom
  RETURN
 END IF
RETURN

do_actnfire:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN RETURN
 IF blankcheck > 0 THEN
  GOSUB do_castfire
  RETURN
 END IF
 blankcheck$ = attackthem$
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_attkfire
  RETURN
 END IF
RETURN

do_actndust:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN RETURN
 IF blankcheck > 0 THEN
  GOSUB do_castdust
  RETURN
 END IF
 blankcheck$ = attackthem$
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_useslep
  RETURN
 END IF
RETURN

do_actnweb:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN RETURN
 IF blankcheck > 0 THEN
  GOSUB do_castweb
  RETURN
 END IF
 blankcheck$ = attackthem$
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_attkweb
  RETURN
 END IF
RETURN

do_actnspdr:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN RETURN
 IF blankcheck > 0 THEN
  GOSUB do_castspdr
  RETURN
 END IF
RETURN

do_actnccts:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN RETURN
 IF blankcheck > 0 THEN
  GOSUB do_castccts
  RETURN
 END IF
RETURN

do_actndtby:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN RETURN
 IF blankcheck > 0 THEN
  GOSUB do_castdtby
  RETURN
 END IF
RETURN

do_actnmove:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN
  RETURN
 END IF
 IF blankcheck > 0 THEN
  GOSUB do_move
  RETURN
 END IF
RETURN

do_actnwing:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN
  RETURN
 END IF
 IF blankcheck > 0 THEN
  GOSUB do_wingmove
  RETURN
 END IF
RETURN

do_actnwstf:
 dis = 1
 blankcheck$ = "bldr"
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  dis = 2
  blankcheck$ = "____"
  GOSUB do_blankcheck
  IF blankcheck > 0 THEN
   temptx = tx
   tempty = ty
   tx = tx + da(d, 1)
   ty = ty + da(d, 2)
   dis = 1
   GOSUB do_swapdata
   tx = temptx
   ty = tempty
   RETURN
  END IF
 END IF
 blankcheck$ = attackthem$
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_attkwstf
 END IF
RETURN

do_actnkey1:
 dis = 1
 blankcheck$ = "door"
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  hasit$ = "loc1"
  GOSUB do_hasit
  IF hasit > 0 THEN
   hashadit$ = "loc1"
   GOSUB do_hashadit
   havehadit$ = "key1"
   GOSUB do_havehadit
   GOSUB do_delete
  END IF
 END IF
RETURN

do_actnkey2:
 dis = 1
 blankcheck$ = "door"
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  hasit$ = "loc2"
  GOSUB do_hasit
  IF hasit > 0 THEN
   hashadit$ = "loc2"
   GOSUB do_hashadit
   havehadit$ = "key2"
   GOSUB do_havehadit
   GOSUB do_delete
  END IF
 END IF
RETURN

do_actnispt:
 dis = 1
 GOSUB do_putaction
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN
  RETURN
 END IF
 IF blankcheck > 0 THEN
  RETURN
 END IF
 IF e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 0) = "Merchant" THEN
  GOSUB do_merchant
  RETURN
 END IF
 IF e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 0) = "Poindexter" THEN
  GOSUB do_talk0001
  RETURN
 END IF
 blankcheck$ = "pwchchst"
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_winexp
  GOSUB do_windggr
  GOSUB do_winpike
  GOSUB do_wingrpl
  GOSUB do_winseed
  GOSUB do_winkey1
  GOSUB do_winkey2
  blankcheck$ = "pwch"
  IF blankcheck > 0 THEN
   GOSUB do_delete
  END IF
  RETURN
 END IF
RETURN
 
do_actnfiremove:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN
  GOSUB do_gone
  RETURN
 END IF
 IF blankcheck > 0 THEN
  GOSUB do_firemove
  RETURN
 END IF
 blankcheck$ = attackthem$
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_attkburn
  GOSUB do_gone
  RETURN
 END IF
 GOSUB do_gone
RETURN

do_actndustmove:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN
  GOSUB do_gone
  RETURN
 END IF
 IF blankcheck > 0 THEN
  GOSUB do_firemove
  RETURN
 END IF
 blankcheck$ = attackthem$
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_useslep
  GOSUB do_gone
  RETURN
 END IF
 GOSUB do_gone
RETURN

do_actnwebmove:
 dis = 1
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN RETURN
 IF blankcheck > 0 THEN
  GOSUB do_webmove
  RETURN
 END IF
 blankcheck$ = attackthem$
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_attktngl
  GOSUB do_gone
  RETURN
 END IF
RETURN

do_actngrpl:
 IF dis = 3 THEN
  action$ = "rapl"
  GOSUB do_putaction
  GOTO do_actnrapl
 END IF
 IF dis = 0 AND g(tx + (ty - 1) * AA, 2) < 10 THEN
  action$ = "____"
  GOSUB do_putaction
  RETURN
 END IF
 IF dis = 0 THEN
  g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) - 10
 END IF
 IF dis < 3 THEN
  dis = dis + 1
 END IF
 blankcheck$ = "____"
 MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "pnch"
 MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "grpl"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN
  dis = dis - 1
  RETURN
 END IF
 IF blankcheck > 0 THEN
  GOSUB do_putaction
  RETURN
 END IF
 blankcheck$ = attackthem$
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_putaction
  action$ = "rapl"
  MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "pnch"
  MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "grpl"
  GOSUB do_putaction
  GOSUB do_attklash
  RETURN
 END IF
 blankcheck$ = "bldrchst"
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  action$ = "rapl"
  MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "pnch"
  MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "grpl"
  GOSUB do_putaction
  RETURN
 END IF
RETURN

do_actnrapl:
 MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "pnch"
 MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "grpl"
 IF dis = 1 THEN
  action$ = "____"
  dis = 0
  GOSUB do_putaction
  MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
  MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "____"
  RETURN
 END IF
 blankcheck$ = "____"
 GOSUB do_blankcheck
 IF blankcheck = -1 THEN
  IF dis > 1 THEN
   dis = dis - 1
   GOSUB do_putaction
  END IF
  RETURN
 END IF
 IF blankcheck > 0 THEN
  IF dis > 1 THEN
   dis = dis - 1
   GOSUB do_putaction
  END IF
 END IF
 blankcheck$ = attackthem$
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  GOSUB do_attklash
  dis = dis - 1
  GOSUB do_putaction
  RETURN
 END IF
 blankcheck$ = "bldrchst"
 GOSUB do_blankcheck
 IF blankcheck > 0 THEN
  dis = 1
  blankcheck$ = "____"
  GOSUB do_blankcheck
  IF blankcheck = 0 THEN
   dis = dis - 1
   GOSUB do_putaction
   RETURN
  END IF
  IF blankcheck > 0 THEN
   IF tx = ex AND ty = dy THEN
    am$ = ctrl$
    GOSUB do_am
    IF am > 0 THEN
     ex = tx + da(d, 1) * dis
     dy = ty + da(d, 2) * dis
    END IF
   END IF
   GOSUB do_swapdata
   temptx = tx
   tempty = ty
   tx = tx + da(d, 1)
   ty = ty + da(d, 2)
   GOSUB do_getaction
   dis = dis - 1
   GOSUB do_putaction
   tx = temptx
   ty = tempty
   RETURN
  END IF
 END IF
RETURN

do_crtnimp:
 GOSUB do_statgain
 GOSUB do_statmax
 GOSUB do_nextaction
 attackthem$ = "plyrgrmlspdrdtbyweb_emgdshkt"
 SELECT CASE CVL(action$)
 CASE CVL("move")
  GOSUB do_actnmove
 CASE CVL("fire")
  GOSUB do_actnfire
 CASE CVL("ispt")
  GOSUB do_actnispt
 CASE CVL("wing")
  GOSUB do_actnwing
 END SELECT
 GOSUB do_autolevelup
RETURN

do_crtnfire:
 GOSUB do_statgain
 GOSUB do_statmax
 GOSUB do_getaction
 attackthem$ = "plyrgrmlspdrdtbyweb_shktemgd"
 SELECT CASE CVL(action$)
 CASE CVL("move")
  GOSUB do_actnfiremove
 END SELECT
RETURN

do_crtndust:
 GOSUB do_statgain
 GOSUB do_statmax
 GOSUB do_getaction
 attackthem$ = "plyrgrmlspdrshktemgdimp_"
 SELECT CASE CVL(action$)
 CASE CVL("move")
  GOSUB do_actndustmove
 END SELECT
RETURN

do_crtnshkt:
 GOSUB do_statgain
 GOSUB do_statmax
 GOSUB do_nextaction
 attackthem$ = "plyrgrmlspdrdtbyweb_imp_"
 SELECT CASE CVL(action$)
 CASE CVL("move")
  GOSUB do_actnmove
 CASE CVL("fire")
  GOSUB do_actnfire
 CASE CVL("bite")
  GOSUB do_actnbite
 CASE CVL("pnch")
  GOSUB do_actnpnch
 CASE CVL("kick")
  GOSUB do_actnkick
 CASE CVL("dggr")
  GOSUB do_actndggr
 CASE CVL("pike")
  GOSUB do_actnpike
 END SELECT
 GOSUB do_autolevelup
RETURN

do_crtnemgd:
 GOSUB do_statgain
 GOSUB do_statmax
 GOSUB do_nextaction
 attackthem$ = "plyrgrmlspdrdtbyweb_imp_"
 SELECT CASE CVL(action$)
 CASE CVL("move")
  GOSUB do_actnmove
 CASE CVL("fire")
  GOSUB do_actnfire
 CASE CVL("bite")
  GOSUB do_actnbite
 CASE CVL("pnch")
  GOSUB do_actnpnch
 CASE CVL("kick")
  GOSUB do_actnkick
 CASE CVL("dggr")
  GOSUB do_actndggr
 CASE CVL("pike")
  GOSUB do_actnpike
 END SELECT
 GOSUB do_autolevelup
RETURN

do_crtnspdr:
 GOSUB do_statgain
 GOSUB do_statmax
 GOSUB do_nextaction
 attackthem$ = "plyrdtbyspdrimp_emgdshktgrml"
 SELECT CASE CVL(action$)
 CASE CVL("move")
  GOSUB do_actnmove
 CASE CVL("web_")
  GOSUB do_actnweb
 CASE CVL("bite")
  GOSUB do_actnbite
 CASE CVL("vnom")
  GOSUB do_actnkick
 END SELECT
 GOSUB do_autolevelup
RETURN

do_crtnweb:
 GOSUB do_statgain
 GOSUB do_statmax
 GOSUB do_getaction
 IF action$ <> "move" THEN
  GOSUB do_nextaction
 END IF
 attackthem$ = "plyrgrmldtbyweb_shktemgdimp_"
 SELECT CASE CVL(action$)
 CASE CVL("move")
  GOSUB do_actnwebmove
 CASE CVL("spdr")
  GOSUB do_actnspdr
 END SELECT
 GOSUB do_autolevelup
RETURN
  
do_crtndtby:
 GOSUB do_statgain
 GOSUB do_statmax
 GOSUB do_nextaction
 attackthem$ = "plyrgrmlspdrimp_emgdshkt"
 SELECT CASE CVL(action$)
 CASE CVL("move")
  GOSUB do_actnmove
 CASE CVL("fire")
  GOSUB do_actnfire
 CASE CVL("dtby")
  GOSUB do_actndtby
 CASE CVL("bite")
  GOSUB do_actnbite
 CASE CVL("kick")
  GOSUB do_actnkick
 CASE CVL("dust")
  GOSUB do_actndust
 END SELECT
 GOSUB do_autolevelup
RETURN

do_crtngrml:
 GOSUB do_statgain
 GOSUB do_statmax
 GOSUB do_nextaction
 attackthem$ = "plyrdtbyspdrimp_emgdshktweb_"
 SELECT CASE CVL(action$)
 CASE CVL("move")
  GOSUB do_actnmove
 CASE CVL("fire")
  GOSUB do_actnfire
 CASE CVL("bite")
  GOSUB do_actnbite
 CASE CVL("pnch")
  GOSUB do_actnpnch
 CASE CVL("kick")
  GOSUB do_actnkick
 CASE CVL("dggr")
  GOSUB do_actndggr
 CASE CVL("pike")
  GOSUB do_actnpike
 END SELECT
 GOSUB do_autolevelup
RETURN

do_crtnplyr:
 GOSUB do_statgain
 GOSUB do_statmax
 GOSUB do_nextaction
 attackthem$ = "plyrdtbyspdrimp_emgdshktweb_grmlccts"
 SELECT CASE CVL(action$)
 CASE CVL("move")
  GOSUB do_actnmove
 CASE CVL("fire")
  GOSUB do_actnfire
 CASE CVL("bite")
  GOSUB do_actnbite
 CASE CVL("pnch")
  GOSUB do_actnpnch
 CASE CVL("kick")
  GOSUB do_actnkick
 CASE CVL("dggr")
  GOSUB do_actndggr
 CASE CVL("pike")
  GOSUB do_actnpike
 CASE CVL("spdr")
  GOSUB do_actnspdr
 CASE CVL("web_")
  GOSUB do_actnweb
 CASE CVL("vnom")
  GOSUB do_actnvnom
 CASE CVL("cure")
  GOSUB do_actncure
 CASE CVL("ispt")
  GOSUB do_actnispt
 CASE CVL("grpl")
  GOSUB do_actngrpl
 CASE CVL("rapl")
  GOSUB do_actnrapl
 CASE CVL("seed")
  GOSUB do_actnccts
 CASE CVL("wstf")
  GOSUB do_actnwstf
 CASE CVL("wing")
  GOSUB do_actnwing
 CASE CVL("key1")
  GOSUB do_actnkey1
 CASE CVL("key2")
  GOSUB do_actnkey2
 END SELECT
 GOSUB do_autolevelup
RETURN

do_crtnccts:
 GOSUB do_statgain
 GOSUB do_statmax
 GOSUB do_nextaction
 attackthem$ = ""
 IF MID$(e$(tx + (ty - 1) * AA, 2), 5, 4) = "watr" THEN
  MID$(e$(tx + (ty - 1) * AA, 2), 5, 4) = "hole"
 END IF
 SELECT CASE CVL(action$)
 CASE CVL("seed")
  GOSUB do_actnccts
 END SELECT
 GOSUB do_autolevelup
RETURN

do_crtnbldr:
 GOSUB do_statgain
 GOSUB do_statmax
 GOSUB do_nextaction
 attackthem$ = ""
 IF MID$(e$(tx + (ty - 1) * AA, 2), 5, 4) = "hole" THEN
  MID$(e$(tx + (ty - 1) * AA, 2), 5, 4) = "dirt"
  GOSUB do_gone
  RETURN
 END IF

 IF MID$(e$(tx + (ty - 1) * AA, 2), 5, 4) = "watr" THEN
  MID$(e$(tx + (ty - 1) * AA, 2), 5, 4) = "wstp"
  GOSUB do_gone
  RETURN
 END IF
 'SELECT CASE CVL(action$)
 'END SELECT
 GOSUB do_autolevelup
RETURN

SUB cinput
XXmouse = Xmouse
YYmouse = Ymouse
l1b = lb
r1b = rb
c$ = INKEY$

IF len(c$) = 0 THEN
	c$ = "%%"
end if

mousestatus lb, rb, Xmouse, Ymouse

Xmouse = Xmouse * 320 / 640
Ymouse = Ymouse * 200 / 480

ym = INT(Ymouse / 8) + 1
xm = INT(Xmouse / 8) + 1
IF llb <> lb OR (llb = 0 AND lb = 0) THEN
  llb = lb: l1b = lb
  ELSE
  lb = 0
END IF
IF rrb <> rb OR (rrb = 0 AND rb = 0) THEN
  rrb = rb: r1b = rb
  ELSE
  rb = 0
END IF

END SUB

SUB cursorput
  LINE (Xmouse - 2, Ymouse - 2)-(Xmouse + 2, Ymouse + 2), 9
  LINE (Xmouse + 2, Ymouse - 2)-(Xmouse - 2, Ymouse + 2), 9
	
	select case lcase$(c$)
	case chr$(27)
		c$="quit"
	case "q"
		c$="quit"
	case "quit"
		c$="quit"
	end select
  
  IF lcase$(c$) = "quit" THEN
        DIM outro AS STRING
        outro = "Goodnight Sweet Prince.."
        SCREEN 7, 0, 0, 0
        COLOR 13, 5
        CLS
        LOCATE 25 / 2, 40 / 2 - LEN(outro) / 2
        PRINT outro;
        WHILE LEN(inkey) = 0
        WEND
        END
  END IF
  text 24, 40 - LEN(LTRIM$(STR$(turncount))), LTRIM$(STR$(turncount)), 15
END SUB


SUB splash (filename AS STRING)

 DIM subject AS STRING, label AS STRING, value AS STRING
 DIM filemode AS INTEGER

 filemode = FREEFILE

 IF LEN(filename) = 0 THEN
  EXIT SUB
 END IF

 OPEN filename FOR INPUT AS #filemode

 WHILE NOT (EOF(filemode))
 
  LINE INPUT #filemode, subject
 
  IF LEFT$(subject, 2) = is_selected_hud( 1 ) + STRING$(1, 32) THEN
   subject = MID$(subject, 3)
  
   IF INSTR(1, subject, STRING$(1, 32)) > 0 THEN
    label = LEFT$(subject, INSTR(1, subject, STRING$(1, 32)) - 1)
    value = MID$(subject, INSTR(1, subject, STRING$(1, 32)) + 1)
   ELSE
    label = subject
    value = STRING$(0, 0)
   END IF
  
   SELECT CASE label
   CASE "COLOR"
    textfg = VAL(value)
   CASE "BGCOLOR"
    textbg = VAL(value)
   CASE "page"
    SELECT CASE value
    CASE "new"
    CASE "end"
    END SELECT
   CASE "end"
    EXIT SUB
   END SELECT
  ELSE
   COLOR textfg
   PRINT subject
  END IF

 WEND

 CLOSE #filemode

END SUB

DEFINT A-Z
SUB suspend (startsng, delay)
  screencopy 1, 3
  cinput
  cursorput
   screen_scaler 1, 7
'screencopy 1, 0
  screencopy 3, 1
END SUB
