
#lang "fblite"
option gosub

'dim shared as string config_table( Any, Any )
dim as integer filemode = freefile
dim as string buffer = string$( 0, 0 )

#include once "crt/math.bi"
#include once "file.bi"
'#include once "windows.bi"
#include once "fbgfx.bi"
'
dim shared as any ptr Dest

const crlf = chr$( 13 ) + chr$ ( 10 )
const quot = chr$( 34 )

Const LEFTBUTTON = 1 
Const MIDDLEBUTTON = 4 
Const RIGHTBUTTON = 2 
Const MouseShowSETTING = 1
Const MOUSEHIDESETTING = 0

const KEYBIND_ENABLED = 1

declare SUB MouseDriver (ax%, bx%, cx%, dx%)
declare SUB MouseHide
declare FUNCTION MouseInit%
declare SUB MousePut
declare SUB MouseShow
declare SUB MouseStatus (lb%, rb%, Xmouse%, Ymouse%)

MouseHide

dim shared as longint viewx = 0

declare function ucword( subject as string ) as string

declare function cursorcheck() as string	

declare sub cursorshow()

declare sub quitoutro( Dest as any ptr )

declare function image_scaler( source as any ptr, dest_w as integer = 24, dest_h as integer = 24 ) as any ptr

declare sub region_scaler( img( Any ) as any ptr )

declare sub ellipse( Dest as any ptr = 0, x1 as integer = 32, y1 as integer = 32, x2 as integer = 128, y2 as integer = 128, fg as integer = 12, bitflip as integer = 0, lo as single = 0, hi as single = 1 )

declare function ellipsecheck( x1 as integer = 32, y1 as integer = 32, x2 as integer = 128, y2 as integer = 128, px as single = 0, py as single = 0, bitflip as integer = 0, lo as single = 0, hi as single = 1 )

declare function ord_series( subject as string = "" ) as integer

declare function sync_name( lookup as string = "", table( Any, Any) as string ) as string

declare sub load_names( filename as string = "", table( Any, Any) as string )

dim shared as string names_table( Any, Any ), level_table( Any, Any ), config_table( Any, Any ), text_table( Any, Any )

load_names "RES\CONFIG\NAMES.DAT", names_table()

dim shared as string menu, iname
menu = string$(0,0)
iname = string$(0,0)

dim shared as single icost = 0.0

Dim Shared As Any Ptr videopage
videopage = imagecreate( 320, 200, 0, 8)

dim shared sync_dat as string
sync_dat = string$( 0, 0 )

dim shared names_dat as string
names_dat = string$( 0, 0 )

declare sub inventory_click ( menu as string = "", byref o as integer = -1 )

declare sub menu_value( menu as string = "cncl", o as integer = 0, byref item as string = "", byref cost as single = 0.0 )

declare sub sync_gfx( filename as string, lookup as string = "" )

declare sub load_binding_options( lookup1 as string = "" )

declare function just_cardname( filename as string ) as string

declare function load_sprite( img As Any Ptr, filename as string = "" ) as string

declare sub putplane (img As Any Ptr, y as integer, w as integer, bb as integer, byref buffer as string )

declare sub sprite_put( dest As Any Ptr, x as integer, y as integer, filename as string = "", op as string = "xor" )


declare function As_Binary( value as string ) as integer

declare sub inventory ( y as integer, x as integer, menu as string )

declare sub statput( staty as integer = 0, statx as integer = 0, stat as string = "HP", cur as integer = 0, max as integer = 0, fg% = 15, bg% = 0 )

declare sub screen_scaler( srcpage as integer = 1, destpage as integer = 7 )

declare sub pset_placeholder_op( x as integer,y as integer, px as integer, op as string = "xor" )

declare sub placeholder( xx as integer = 0, yy as integer = 0, filename as string = "" )

#ifdef __FB_GFX__

declare function loadfile$( ss$ = "" )

#endif

DECLARE SUB fntempget ()
DECLARE SUB fntempput ()

DECLARE SUB chardump ()

DECLARE FUNCTION isinbounds (x as longint, y as longint, x1 as longint, y1 as longint, x2 as longint, y2 as longint) as longint

'====

DECLARE SUB bindingset (index as longint = -1 , value as string = "", col as longint = -1 , row as longint = -1)

DECLARE SUB bindingbubble (index as longint, bindradius%, bindfg%, bindbg%)

DECLARE SUB bindingcheck ()

DECLARE SUB bindingshow ()

DECLARE FUNCTION bindtext$ (label as string = "", col as longint = -1, row as longint = -1, bindindex as longint = -1)

'====

DECLARE SUB renderframe ( Dest as any ptr, framex1!, framey1!, framex2!, framey2!, framec1% = 12, framec2% = 4, bg1% = 0, bg2% = 8)
DECLARE SUB renderportal ()
DECLARE SUB loadtextmode (filename$)
DECLARE SUB loadmouse (filename$)
DECLARE SUB loadlvupdata (lvupfile$)
DECLARE sub resconfig (filename$, config_table( Any, Any ) as string )
DECLARE SUB cardload (cardidty$)

DECLARE SUB splash (filename$, colstart%, rowstart%, lineskip%, fg%, bg%)
DECLARE SUB cinput ()
DECLARE SUB text (Dest as any ptr, yy as longint = -1, xx as longint = -1, subject as string = "", sp%, textfg% = 15, textbg% = 8, spacing% = -1 )
declare SUB textput (Dest as any ptr, yy, xx, ss%, scale$ = "08", textfg% = 15, textbg% = 0, placement% = 0 )

DECLARE SUB cursorput ()
DECLARE SUB splashchat (filename$, colstart%, rowstart%, lineskip%, fg%, bg%)
DECLARE SUB graphicput ( yy1%, xx1%, ss1$, special as integer = 1 )

DECLARE SUB logoput (yy1%, xx1%, ss1$)
DECLARE FUNCTION carddeckmath% (cardidty$, value$, op$)
DECLARE FUNCTION cardvarget% (tag$, value$)
DECLARE FUNCTION cardstatmath% (cardidty$, value$, op$)
DECLARE FUNCTION diceroll% ()
DECLARE FUNCTION cardvarset% (tag$, value$)

DECLARE SUB suspend (start!, delay%)

'if open( "res\config\config.cfg" for binary as filemode) then
'	windowtitle "Roe 2.92.034c"
'	close filemode
'else
'	close filemode
'	load_names "res\config\config.cfg", config_table()
'	if len( sync_name( "title", config_table() ) ) > 0 then
'		windowtitle sync_name( "title", config_table() )
'	else
'		windowtitle "Roe 2.92.034c"
'	end if	
'end if

dim shared textfg% = 15
dim shared textbg% = 0

DIM SHARED lv(0 TO 99)

dim shared as long turncount = 0

dim shared as string sync_data
sync_data = string$( 0, 0 )

DIM SHARED clickbutton1 as longint
DIM SHARED clickbutton2 as longint
DIM SHARED clickhover as longint

type clicktype
	label as string
	col as longint
	row as longint
end type

dim shared clicks as integer
REDIM SHARED as clicktype clickli( Any )

declare sub cute_text( Dest as any ptr, subject as string = "", byref x as integer = -1, byref y as integer = -1, fg as integer = 15, bg as integer = 0, wipe_clicks as integer = 0, spacing = -2 )

declare sub cute_clicks( Dest as any ptr, x as integer = -1, y as integer = -1, fg as integer = 15, bg as integer = 3)

declare sub cute_splash( Dest as any ptr, buffer as string = "" )

DIM SHARED debugmode as longint

cute_text Dest, "{{Hello}} {{world!}}", 16, 16, 11, 3, -1, -2
suspend timer, 0

cute_clicks Dest, 1, 1, 11, 3
suspend timer, 0


DIM SHARED prflidty$
DIM SHARED prflactn$
DIM SHARED prflgpic$

DIM SHARED prflidty!

DIM SHARED prflhp!
DIM SHARED prflhpmax!
DIM SHARED prflhpspd!

DIM SHARED prflstr!
DIM SHARED prflstrmax!
DIM SHARED prflspd!

DIM SHARED prfless!
DIM SHARED prflessmax!
DIM SHARED prflessspd!

DIM SHARED prfllv!
DIM SHARED prflvalu!

DIM SHARED prflarmr!
DIM SHARED prflpirc!

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
	REM // program: Puzzlum Roe 2
	REM // version: 2.092.026
	REM // edition: QuickBASIC 7.1 PDS
	REM // created: 07-20-1997 06:52:00pm
	REM // copyright 1997, 2021 Tim Keal
	REM // http://puzzlum.net/
	REM //
	REM //*

startup:

	RANDOMIZE TIMER
	RESTORE

	DEFINT A-Z

	DIM SHARED AA
	DIM SHARED DD

	DIM SHARED ex
	DIM SHARED dy

	DIM SHARED text.sprites%
	DIM SHARED text.colored%
	DIM SHARED text.font$
	DIM SHARED text.scale%

	DIM SHARED textrate
	DIM SHARED textdelay
	DIM SHARED c$

	DIM SHARED tx
	DIM SHARED ty

	'DIM SHARED sync_name( "bind_open", config_table() )
	'DIM SHARED sync_name( "bind_close", config_table() )

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

	DIM SHARED wini%

	'DIM SHARED sync_name( "file_map", config_table() )
	'DIM SHARED sync_name( "file_lvup", config_table() )
	'DIM SHARED sync_name( "file_help", config_table() )

	'DIM SHARED sync_name( "file_splash", config_table() )
	'DIM SHARED sync_name( "file_options", config_table() )
	'DIM SHARED sync_name( "file_mainmenu", config_table() )

	'DIM SHARED sync_name( "file_mouse", config_table() )
	'DIM SHARED sync_name( "file_win", config_table() )
	'DIM SHARED sync_name( "file_text", config_table() )

	DIM SHARED resourcefile$
	
	REDIM SHARED G(Any,Any) AS DOUBLE: REM'grid statistics

	REM sync_name( "file_map", config_table() ) = "p2092019.vds"
	REM sync_name( "file_help", config_table() ) = "roe92004.hlp"
	REM sync_name( "file_lvup", config_table() ) = "roe_lvup.dat"
	REM sync_name( "file_mouse", config_table() ) = "MOUSE.BIN"
	REM sync_name( "file_win", config_table() ) = "win.dat"
	REM sync_name( "file_text", config_table() ) = "textmode.dat"

	resourcefile$ = "RESOURCE.CFG"

	load_names( "RES\CONFIG\" + resourcefile$, config_table())
	
	resconfig (resourcefile$, config_table())
		
	load_names( "RES\CONFIG\" + sync_name("mode_text", config_table() ), text_table())

	load_names( "RES\CONFIG\" + sync_name("file_lvup", config_table() ), level_table())

	mapmode = FREEFILE
	OPEN ".\RES\MAPS\" + sync_name( "file_map", config_table() ) FOR INPUT AS #mapmode
	INPUT #mapmode, mapid$
	INPUT #mapmode, AA
	INPUT #mapmode, DD
	DIM SHARED e$(AA * DD, 4): REM'grid identity$
	REDIM SHARED G(AA * DD, 16) AS DOUBLE: REM'grid statistics
	DIM SHARED da(4, 2): REM'direction (n,e,s,w)
	DIM SHARED ta(64 * 64 + 5): REM'text image
	'DIM SHARED lv(64): REM'level up
	da(0, 1) = 0: da(0, 2) = 0: REM'
	da(1, 1) = 0: da(1, 2) = -1: REM'north
	da(2, 1) = 1: da(2, 2) = 0: REM'east
	da(3, 1) = 0: da(3, 2) = 1: REM'south
	da(4, 1) = -1: da(4, 2) = 0: REM'west
	ex = INT(AA / 2): REM'map pointer x
	dy = INT(DD / 2): REM'map pointer y
	mdx = INT(40 / 2): REM'screen cursor x
	mdy = INT(25 / 2): REM'screen cursor y
	textrate = .01
	textdelay = 2.5: REM'''.8: REM'''.55

	wini% = 4
	REDIM SHARED win(-wini% TO 2 * wini%)

	ctrl$ = "plyrimp_"
	IF INT(RND(1) * 2) + 1 = 2 THEN ctrl$ = ctrl$ + "dust"
	FOR ty = 1 TO DD
	INPUT #mapmode, r$
	LINE INPUT #mapmode, bg$
	LINE INPUT #mapmode, fg$
	LINE INPUT #mapmode, sg$
	FOR tx = 1 TO AA
		rbg$ = MID$(bg$, (tx - 1) * 5 + 1, 4)
		rfg$ = MID$(fg$, (tx - 1) * 5 + 1, 4)
		rsg$ = MID$(fg$, (tx - 1) * 5 + 1, 4)
		e$(tx + (ty - 1) * AA, 2) = "____" + rbg$
		e$(tx + (ty - 1) * AA, 3) = MKL$(0) + "____" + MKL$(0): REM'docommand$
		e$(tx + (ty - 1) * AA, 4) = "________": REM'graphicsaction$
	
		IF 0 THEN
		GOSUB prflblnk
		cardload rfg$
		GOSUB prflset
		END IF

		SELECT CASE rfg$
		CASE "____"
			GOSUB prflblnk
			GOSUB prflset
		CASE "spdr"
			GOSUB prflblnk
			prflidty$ = "Spider"
			prflactn$ = "movebiteweb_"
			prflgpic$ = "spdr"
			prflidty! = 1
			prflhp! = 10
			prflstr! = 20
			prflspd! = 1
			prflarmr! = 1
			prflvalu! = 5
			prflpirc! = 1
			prfllv! = 1
			prflhpmax! = 10
			prflstrmax! = 20
			prflessmax! = 380
			prflessspd! = 3
			GOSUB prflset

		CASE "wall"
			GOSUB prflblnk
			prflidty$ = "wall"
			prflgpic$ = "wall"
			prflidty! = 2
			GOSUB prflset
		CASE "web_"
			GOSUB prflblnk
			prflidty$ = "Web"
			prflactn$ = "spdr"
			prflgpic$ = "web_"
			prflidty! = 3
			prflhp! = 40
			prflstr! = 50
			prflspd! = 1
			prflvalu! = 1
			prfllv! = 1
			prflhpmax! = 40
			prflstrmax! = 50
			prflessmax! = 380
			prflessspd! = 2
			GOSUB prflset

		CASE "grml"
			GOSUB prflblnk
			prflidty$ = "Gremlin"
			prflactn$ = "movebitepnch"
			IF RND(1) > .2 THEN
				prflactn$ = prflactn$ + "dggr"
			END IF
			prflgpic$ = "grml"
			prflidty! = 4
			prflhp! = 25
			prflstr! = 90
			prflspd! = 1
			prflarmr! = 1
			prflvalu! = 5
			prflpirc! = 2
			prfllv! = 1
			prflhpmax! = 25
			prflstrmax! = 90
			GOSUB prflset
		CASE "plyr"
			GOSUB prflblnk
			prflidty$ = "Poindexter"
			prflactn$ = "wstf"
			prflgpic$ = "plyr"
			prflidty! = 5
			prflhp! = 30
			prflstr! = 90
			prfless! = 0
			prflspd! = 3
			prflarmr! = 2
			prflexp! = 10
			prflvalu! = 15
			prflpirc! = 2
			prfllv! = 1
			prflhpmax! = 30
			prflstrmax! = 90
			prflessmax! = 30
			prflessspd! = .1
			prflevad! = .07
			GOSUB prflset
		CASE "dtby"
			GOSUB prflblnk
			prflidty$ = "Dust Bunny"
			prflactn$ = "movebitekickdtbydust"
			prflgpic$ = "dtby"
			prflidty! = 6
			prflhp! = 15
			prflstr! = 20
			prfless! = 5
			prflspd! = 1.2
			prflvalu! = 2
			prfllv! = 1
			prflhpmax! = 15
			prflstrmax! = 20
			prflessmax! = 280
			prflessspd! = 1
			GOSUB prflset
		CASE "shkt"
			GOSUB prflblnk
			prflidty$ = "Shiny Knight"
			prflactn$ = "movepnchdggr"
			prflgpic$ = "shkt"
			prflidty! = 7
			prflhp! = 45
			prflstr! = 110
			prflspd! = 1
			prflarmr! = 4
			prflvalu! = 17
			prflpirc! = 3
			prfllv! = 1
			prflhpmax! = 45
			prflstrmax! = 110
			prflessmax! = 12
			prflevad! = .12
			GOSUB prflset
		CASE "emgd"
			GOSUB prflblnk
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
			prflidty! = 8
			prflhp! = 40
			prflstr! = 140
			prflspd! = 2
			prflarmr! = 5
			prflvalu! = 17
			prflpirc! = 3
			prfllv! = 1
			prflhpmax! = 40
			prflstrmax! = 140
			prflevad! = .2
			GOSUB prflset
		CASE "door"
			GOSUB prflblnk
			prflidty$ = "Door"
			prflgpic$ = "door"
			IF INT(RND(1) * 2) = 1 THEN
				prflactn$ = "loc1"
			ELSE
				prflactn$ = "loc2"
			END IF
			prflidty! = 9
			prflhp! = 140
			prflstr! = 140
			prflarmr! = 5
			prflvalu! = 1
			prfllv! = 1
			prflhpmax! = 140
			prflstrmax! = 140
			GOSUB prflset
		CASE "imp_"
			GOSUB prflblnk
			prflidty$ = "Little Imp"
			prflactn$ = "movewingfire"
			IF INT(RND(1) * 2) + 1 = 2 THEN
				prflidty$ = "Merchant"
				prflactn$ = prflactn$ + "dggrgrplseed"
			END IF
			prflgpic$ = "imp_"
			prflidty! = 10
			prflhp! = 30
			prflstr! = 30
			prfless! = 30
			prflspd! = 5
			prflarmr! = 1
			prflvalu! = 24
			prflpirc! = 1
			prfllv! = 1
			prflhpmax! = 30
			prflstrmax! = 30
			prflessmax! = 90
			prflessspd! = 3
			prflevad! = .3
			GOSUB prflset
		CASE "chst"
			GOSUB prflblnk
			prflidty$ = "Treasure chest"
			IF INT(RND(1) * 2) = 1 THEN
				prflactn$ = "key1"
			ELSE
				prflactn$ = "key2"
			END IF
			prflgpic$ = "chst"
			prflidty! = 11
			prflhp! = 100
			prfllv! = 1
			prflhpmax! = 100
			GOSUB prflset
		CASE "bldr"
			GOSUB prflblnk
			prflidty$ = "Big boulder"
			prflactn$ = ""
			prflgpic$ = "bldr"
			prflidty! = 12
			prflhp! = 1000
			prflarmr! = 10
			prfllv! = 1
			prflhpmax! = 1000
			GOSUB prflset
		END SELECT
	NEXT tx
	NEXT ty
	CLOSE #mapmode
GOTO starttitle

starttitle:
	screenres 640,480,8,8
	screenset 1,0

	COLOR 15, 1
	CLS

	COLOR 15, 1
	CLS

	colr% = 15
	GOSUB title
	colr% = 11

	bindingset -1, STRING$(0, 0), 0, 0
		
	cute_splash Dest, _
	"@ res\splash\" + sync_name( "file_splash", config_table() ) + crlf + _
	"@ res\splash\" + sync_name( "file_mainmenu", config_table() )
	', 2, 16, 2, 9, 1

	GOSUB commandwait

	IF c$ = sync_name( "restart", names_table()) OR (ym% = 22 AND xm% = 3 AND lb% = -1) THEN
		'GOSUB doscreenset
		quitoutro Dest	'RUN
	END IF
	IF c$ =  sync_name( "quit", names_table()) OR (ym% = 24 AND xm% = 3 AND lb% = -1) THEN
		'GOSUB doscreenset
		quitoutro Dest
	END IF
	IF c$ =  sync_name( "help", names_table()) OR (ym% = 18 AND xm% = 3 AND lb% = -1) THEN

		cute_splash Dest, "@ RES\HELP\" + sync_name( "file_help", config_table() ) + crlf + "@ res\splash\" + sync_name( "file_options", config_table() )
starthelp:
		
	bindingset -1, STRING$(0, 0), 0, 0

	cute_splash Dest, "@ res\splash\" + sync_name( "file_options", config_table() )

continuehelp:
		GOSUB commandwait
		IF c$ =  sync_name( "title", names_table()) OR (ym% = 24 AND xm% = 3 AND lb% = -1) THEN
			GOTO starttitle
		END IF
		IF NOT (c$ =  sync_name( "continue", names_table()) OR (ym% = 22 AND xm% = 3 AND lb% = -1)) THEN
			GOTO continuehelp
		END IF

		GOTO starthelp

	END IF
	IF c$ <> "continue" AND NOT (ym% = 20 AND xm% = 3 AND lb% = -1) THEN
		GOTO starttitle
	END IF
	CLS
	screen_scaler 1, 0
	COLOR 15, 0
	cinput
GOTO docommand

main:
	FOR tx = 1 TO AA
	FOR ty = 1 TO DD
		a = 0
		di% = 0
		IF G(tx + (ty - 1) * AA, 9) = 0 THEN
			G(tx + (ty - 1) * AA, 9) = 1
			MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
			GOSUB getaction
			IF action$ = "zzzz" AND dis > 0 THEN
				dis = dis - 1
				GOSUB putaction
			END IF
			SELECT CASE CVL(MID$(e$(tx + (ty - 1) * AA, 2), 1, 4))
			CASE CVL("wall")
			CASE CVL("spdr")
				GOSUB crtnspdr
			CASE CVL("web_")
				GOSUB crtnweb
			CASE CVL("dtby")
				GOSUB crtndtby
			CASE CVL("grml")
				GOSUB crtngrml
			CASE CVL("shkt")
				GOSUB crtnshkt
			CASE CVL("emgd")
				GOSUB crtnemgd
			CASE CVL("imp_")
				GOSUB crtnimp
			CASE CVL("fire")
				GOSUB crtnfire
			CASE CVL("plyr")
				GOSUB crtnplyr
			CASE CVL("ccts")
				GOSUB crtnccts
			CASE CVL("bldr")
				GOSUB crtnbldr
			CASE CVL("dust")
				GOSUB crtndust
			END SELECT
		END IF
	NEXT ty
	NEXT tx
	FOR tx = 1 TO AA
	FOR ty = 1 TO DD
		G(tx + (ty - 1) * AA, 9) = 0
	NEXT ty
	NEXT tx
GOTO docommand

docommand:
	tx = ex
	ty = dy
	LINE (0, 0)-(319, 199), 0, BF
	GOSUB portal
	screencopy 1, 2
GOSUB command2
GOTO command3

command2:
	screencopy 2, 1
	statx = 25
	framex1! = statx
	framex2! = 40
	framey1! = 2
	framey2! = 4
	framec1% = 6
	framec2% = 0
	GOSUB frameput

	bindingset -1, STRING$(0, 0), 0, 0
	SELECT CASE titled%
	CASE 0
		splash "gamename.dat", (statx + 0) + 4, 3, 1, 5, 0
		REM text Dest, 3, (statx + 0) + 4, "Puzzlum", 5
	CASE 1
		splash "pause.dat", (statx + 0) + 4, 3, 1, 9, 0
		REM text Dest, 3, (statx + 0) + 4, "(ti%)itle", 9
	END SELECT
	am$ = ctrl$
	GOSUB am
	IF am > 0 THEN
		statx = 25
		GOSUB status
	END IF
	screencopy 1, 3
RETURN

command3:
	cinput
	IF ym% = 3 AND xm% >= statx AND xm% <= 39 AND titled% = 0 THEN
		titled% = 1
		GOSUB command2
	END IF
	IF NOT (ym% = 3 AND xm% >= statx AND xm% <= 39) AND titled% = 1 THEN
		titled% = 0
		GOSUB command2
	END IF
	screencopy 3, 1
	cursorput
	screen_scaler 1, 0
	IF am > 0 THEN
		statx = 25
		GOSUB getaction
		IF ((c$ = sync_name( "level up", names_table())) OR (ym% = 6 AND xm% = statx + 2 AND lb% = -1)) THEN
			c$ = sync_name( "level up", names_table())
			GOSUB paylevelup
			GOTO docommand
		END IF
		IF (ym% = 11 AND xm% = statx + 1 AND lb% = -1) AND di% <> 0 THEN
			di% = 0
			dis = 0
			GOSUB putaction
			GOSUB command2
		END IF
		IF (ym% = 10 AND xm% = statx + 1 AND lb% = -1) AND di% <> 1 THEN
			di% = 1
			dis = 0
			GOSUB putaction
			GOSUB command2
		END IF
		IF (ym% = 11 AND xm% = statx + 2 AND lb% = -1) AND di% <> 2 THEN
			di% = 2
			dis = 0
			GOSUB putaction
			GOSUB command2
		END IF
		IF (ym% = 12 AND xm% = statx + 1 AND lb% = -1) AND di% <> 3 THEN
			di% = 3
			dis = 0
			GOSUB putaction
			GOSUB command2
		END IF
		IF (ym% = 11 AND xm% = statx AND lb% = -1) AND di% <> 4 THEN
			di% = 4
			dis = 0
			GOSUB putaction
			GOSUB command2
		END IF
		IF lb% = -1 AND NOT (action$ = "zzzz" AND dis > 0) THEN
			IF (xm%) = statx THEN
				IF (((ym%) - 12) / 1) >= 1 AND (((ym%) - 12) / 1) <= LEN(e$(tx + (ty - 1) * AA, 1)) / 4 THEN
					AA$ = MID$(e$(tx + (ty - 1) * AA, 1), ((ym%) - 13) * 4 + 1, 4)
					IF action$ <> AA$ THEN
						action$ = AA$
					ELSE
						action$ = "____"
					END IF
					c$ = "||"
				END IF
			END IF
		END IF
		GOSUB putaction
		st! = TIMER
	END IF
	statx = 25
	IF c$ = sync_name( "title", names_table()) OR (ym% = 3 AND xm% = statx + 5 AND lb% = -1) THEN
		GOTO starttitle
	END IF
	IF lb% = -1 THEN
		IF ym% > 2 AND ym% < 24 THEN
			IF xm% > 2 AND xm% < 24 THEN
				tempy = INT((ym% + 1 - 13) / 3 + dy)
				tempx = INT((xm% + 1 - 13) / 3 + ex)
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
	IF rb% = -1 THEN
		c$ = " "
		turncount += 1
	END IF
	IF INSTR(1, "L ||", RIGHT$(" " + c$, 1)) = 0 THEN

		GOTO command3
	END IF
	IF INSTR(1, "L||", RIGHT$(" " + c$, 1)) > 0 THEN
		GOTO docommand
	END IF
GOTO main

swapdata:
	FOR ti% = 0 TO 1
		SWAP e$(tx + (ty - 1) * AA, ti%), e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, ti%)
	NEXT ti%
	temp1$ = MID$(e$(tx + (ty - 1) * AA, 2), 1, 4)
	temp2$ = MID$(e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2), 1, 4)
	SWAP temp1$, temp2$
	MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) = temp1$
	MID$(e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2), 1, 4) = temp2$
	FOR ti% = 3 TO 4
		SWAP e$(tx + (ty - 1) * AA, ti%), e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, ti%)
	NEXT ti%
	FOR ti% = 0 TO 16
		SWAP G(tx + (ty - 1) * AA, ti%), G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, ti%)
	NEXT ti%
RETURN

attack:
	SELECT CASE CVL(MID$(e$(tx + (ty - 1) * AA, 3), 5, 4))
	CASE CVL("bite")
		GOSUB attkbite
	CASE CVL("pnch")
		GOSUB attkpnch
	CASE CVL("kick")
		GOSUB attkkick
	CASE CVL("vnom")
		GOSUB attkvnom
	CASE CVL("dggr")
		GOSUB attkdggr
	CASE CVL("pike")
		GOSUB attkpike
	CASE CVL("cure")
		GOSUB usecure
	CASE CVL("fire")
		GOSUB attkfire
	CASE ELSE
		MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
		MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "____"
	END SELECT
RETURN

battle:
	IF G(tx + (ty - 1) * AA, 2) >= struse AND G(tx + (ty - 1) * AA, 3) >= essuse THEN
		IF 1 = 1 THEN
			MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = attackpic$
			MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = attackname$
			G(tx + (ty - 1) * AA, 2) = G(tx + (ty - 1) * AA, 2) - struse
			G(tx + (ty - 1) * AA, 3) = G(tx + (ty - 1) * AA, 3) - essuse
			evadeattack = G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 15)
			evadeattack = evadeattack + RND(1) * (1 - evadeattack)
			attackblocked = attackdamage * (evadeattack) - G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 5)
			IF attackblocked < 0 THEN attackblocked = 0
			attackdamage = attackdamage * (1 - evadeattack) + attackblocked
			G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 1) = G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 1) - attackdamage
			GOSUB battleattack
			GOSUB victory
		END IF
	ELSE
			MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
			MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "____"
	END IF
RETURN

attkbite:
	attackpic$ = "bite"
	attackname$ = "bite"
	struse = 10
	essuse = 0
	attackdamage = 5
	strdamage = 2
	GOSUB battle
RETURN

attkpnch:
	attackpic$ = "pnch"
	attackname$ = "pnch"
	struse = 12
	essuse = 0
	attackdamage = 3
	strdamage = 2
	GOSUB battle
RETURN

attkwstf:
	attackpic$ = "wstf"
	attackname$ = "wstf"
	struse = 20
	essuse = 0
	attackdamage = 5
	strdamage = 4
	GOSUB battle
RETURN

attkkick:
	attackpic$ = "kick"
	attackname$ = "kick"
	struse = 14
	essuse = 0
	attackdamage = 4
	strdamage = 3
	GOSUB battle
RETURN

attkvnom:
	attackpic$ = "vnom"
	attackname$ = "vnom"
	struse = 0
	essuse = 15
	attackdamage = 7
	strdamage = 10
	GOSUB battle
RETURN

attkdggr:
	attackpic$ = "dggr"
	attackname$ = "dggr"
	struse = 18
	essuse = 0
	attackdamage = 8
	strdamage = 1
	GOSUB battle
RETURN

attkpike:
	attackpic$ = "pike"
	attackname$ = "pike"
	struse = 24
	essuse = 0
	attackdamage = 12
	strdamage = 8
	GOSUB battle
RETURN

attkburn:
	attackpic$ = "____"
	attackname$ = "burn"
	struse = 5
	essuse = 5
	attackdamage = 12
	strdamage = 15
	GOSUB battle
	IF MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) = "fire" THEN
		GOSUB gone
	END IF
RETURN

attkfire:
	attackpic$ = "____"
	attackname$ = "fire"
	struse = 5
	essuse = 20
	attackdamage = 15
	strdamage = 20
	GOSUB battle
RETURN

attkweb:
	attackpic$ = "____"
	attackname$ = "web_"
	struse = 22
	essuse = 0
	attackdamage = 0
	strdamage = 15
	GOSUB battle
RETURN

attktngl:
	attackpic$ = "____"
	attackname$ = "tngl"
	struse = 0
	essuse = 0
	attackdamage = 0
	strdamage = 10
	GOSUB battle
RETURN

attklash:
	attackpic$ = "____"
	attackname$ = "lash"
	struse = 0
	essuse = 0
	attackdamage = 5
	strdamage = 8
	GOSUB battle
RETURN

usecure:
	IF G(tx + (ty - 1) * AA, 3) >= 8 THEN
		IF 1 = 1 THEN
			MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "cure"
			MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "cure"
			AA$ = "cure"
			GOSUB attackusing
			G(tx + (ty - 1) * AA, 3) = G(tx + (ty - 1) * AA, 3) - 8
			G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 1) = G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 1) + 12
			G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2) = G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2) + 15
			IF G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2) <= 0 THEN
				G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2) = 0
			END IF
			GOSUB victory
		END IF
	ELSE
		IF 1 = 1 THEN
			MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
			MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "____"
		END IF
	END IF
RETURN

useslep:
	IF G(tx + (ty - 1) * AA, 3) >= 8 THEN
		IF 1 = 1 THEN
			MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
			MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "slep"
			AA$ = "slep"
			GOSUB attackusing
			G(tx + (ty - 1) * AA, 3) = G(tx + (ty - 1) * AA, 3) - 8
			MID$(e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 4), 1, 4) = "____"
			MID$(e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 4), 5, 4) = "zzzz"
			temptx = tx
			tempty = ty
			tx = tx + da(di%, 1) * dis
			ty = ty + da(di%, 2) * dis
			GOSUB tempget
			IF tempaction$ <> "zzzz" THEN
				tempaction$ = "zzzz"
				tempdis = 10 + INT(RND(1) * 6)
				GOSUB tempput
			END IF
			tx = temptx
			ty = tempty
			G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2) = G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2) - 15
			IF G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2) <= 0 THEN
				G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2) = 0
			END IF
			GOSUB victory
		END IF
	ELSE
		IF 1 = 1 THEN
			MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
			MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "____"
		END IF
	END IF
RETURN

victory:
	IF G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 1) <= 0 THEN
		expgain = G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 7)
		G(tx + (ty + -1) * AA, 6) = G(tx + (ty + -1) * AA, 6) + expgain
		strgain = G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2)
		G(tx + (ty - 1) * AA, 2) = G(tx + (ty - 1) * AA, 2) + strgain
		GOSUB defeated
		GOSUB windggr
		GOSUB winpike
		GOSUB wingrpl
		GOSUB winseed
		GOSUB winkey1
		GOSUB winkey2
		GOSUB deleter
	END IF
RETURN

paylevelup:
	am$ = ctrl$
	GOSUB am
	IF am > 0 THEN
		LINE (0, 0)-(319, 199), 0, BF
		GOSUB portal
		screencopy 1, 2
reshow1:
		screencopy 2, 1
		framex1! = 15
		framex2! = 40
		framey1! = 4
		framey2! = 24
		framec1% = 4
		framec2% = 12
		GOSUB frameput
		statx = 15
		GOSUB stts
		menu$ = ""
		menu$ = menu$ + "lvup" + MKL$(lv(G(tx + (ty - 1) * AA, 10)))
		IF MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) = "plyr" THEN
			IF G(tx + (ty - 1) * AA, 10) >= 1 THEN
				haveit$ = "ispt"
				GOSUB haveit
				IF haveit = 0 THEN
					menu$ = menu$ + "ispt" + MKL$(0)
				END IF
			END IF
			IF G(tx + (ty - 1) * AA, 10) >= 1 THEN
				haveit$ = "move"
				GOSUB haveit
				IF haveit = 0 THEN
					menu$ = menu$ + "move" + MKL$(0)
				END IF
			END IF
			IF G(tx + (ty - 1) * AA, 10) >= 1 THEN
				haveit$ = "bite"
				GOSUB haveit
				IF haveit = 0 THEN
					menu$ = menu$ + "bite" + MKL$(2)
				END IF
			END IF
			IF G(tx + (ty - 1) * AA, 10) >= 1 THEN
				haveit$ = "pnch"
				GOSUB haveit
				IF haveit = 0 THEN
					menu$ = menu$ + "pnch" + MKL$(2)
				END IF
			END IF
			IF G(tx + (ty - 1) * AA, 10) >= 2 THEN
				haveit$ = "kick"
				GOSUB haveit
				IF haveit = 0 THEN
					menu$ = menu$ + "kick" + MKL$(10)
				END IF
			END IF
			IF G(tx + (ty - 1) * AA, 10) >= 3 THEN
				haveit$ = "cure"
				GOSUB haveit
				IF haveit = 0 THEN
					menu$ = menu$ + "cure" + MKL$(20)
				END IF
			END IF
			IF G(tx + (ty - 1) * AA, 10) >= 7 THEN
				haveit$ = "vnom"
				GOSUB haveit
				IF haveit = 0 THEN
					menu$ = menu$ + "vnom" + MKL$(30)
				END IF
			END IF
		END IF
		menu$ = menu$ + "cncl" + MKL$(0)
		menusize = LEN(menu$) / 8
		inmenu = 0
		
		inventory 10, 15, menu$
		
		if 0 then
		
			FOR menuindex = 1 TO menusize
			menuitem$ = MID$(menu$, (menuindex - 1) * 8 + 1, 4)
			menucost = CVL(MID$(menu$, (menuindex - 1) * 8 + 5, 4))
			r$ = menuitem$
			GOSUB names
			IF menucost > 0 THEN
				text Dest, 10 + menuindex, 15, "{{" + menuitem$ + "}}" + rr$ + " " + STRING$((40 - 15) - LEN(rr$) - 7, "-") + RIGHT$("----" + LTRIM$(STR$(menucost)) + "$", 5), 0, textfg%, textbg%
			END IF
			IF menucost = 0 THEN
				text Dest, 10 + menuindex, 15, "{{" + menuitem$ + "}}" + rr$, 0, textfg%, textbg%
			END IF
		NEXT menuindex
		
		end if 
		
wwait0:
	GOSUB buttonwait
	menuselect$ = "____"
	menucost = 0
	
	menuselect = -1
	
	IF lb% = -1 THEN
		
		inventory_click menu, menuselect
		menu_value menu, menuselect, iname, icost

		menuselect$ = iname
		menucost = icost
		
	end if

		IF menuselect$ <> "lvup" AND menuselect$ <> "cncl" AND menuselect$ <> "____" THEN
			IF G(tx + (ty - 1) * AA, 6) >= menucost THEN
					c$ = sync_name( "level up", names_table())
				GOSUB abilitygain
			END IF
			GOTO reshow1
		END IF
		IF menuselect$ = "lvup" THEN
			IF G(tx + (ty - 1) * AA, 6) >= menucost THEN
				c$ = sync_name( "level up", names_table())
				GOSUB levelup
			END IF
			GOTO reshow1
		END IF
		IF menuselect$ = "cncl" THEN
			c$ = sync_name( "level up", names_table())
		ELSE
			GOTO wwait0
		END IF
		screencopy 2, 1
	END IF
RETURN

merchant:
	am$ = ctrl$
	GOSUB am
	IF am > 0 THEN
		LINE (0, 0)-(319, 199), 0, BF
		GOSUB portal
		statx = 2
		GOSUB status
		viewx = 18
		menu$ = ""
		hasit$ = "dggr"
		GOSUB hasit
		IF hasit > 0 THEN
			menu$ = menu$ + "dggr" + MKL$(5)
		END IF
		hasit$ = "pike"
		GOSUB hasit
		IF hasit > 0 THEN
			menu$ = menu$ + "pike" + MKL$(20)
		END IF
		hasit$ = "grpl"
		GOSUB hasit
		IF hasit > 0 THEN
			menu$ = menu$ + "grpl" + MKL$(15)
		END IF
		hasit$ = "seed"
		GOSUB hasit
		IF hasit > 0 THEN
			menu$ = menu$ + "seed" + MKL$(15)
		END IF
		hasit$ = "wstf"
		GOSUB hasit
		IF hasit > 0 THEN
			menu$ = menu$ + "wstf" + MKL$(10)
		END IF
		menu$ = menu$ + "cncl" + MKL$(0)
		menusize = LEN(menu$) / 8
		inmenu = 0

		bindingset -1, STRING$(0, 0), 0, 0
		splashchat "merc", (viewx + 0), 5, 1, 15, 1
		IF 0 THEN
			text Dest, 5, (viewx + 0), "Merchant", 0, textfg%, textbg%
			text Dest, 7, (viewx + 0), "Wha'du like?", 0, textfg%, textbg%
		END IF
		graphicput 10, (viewx + 0) + 6, (MID$(e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2), 1, 4) + "____.24")
		FOR menuindex = 1 TO menusize
			menuitem$ = MID$(menu$, (menuindex - 1) * 8 + 1, 4)
			menucost = CVL(MID$(menu$, (menuindex - 1) * 8 + 5, 4))
			r$ = menuitem$
			GOSUB names
			IF menucost > 0 THEN
				text Dest, 12 + menuindex, (viewx + 0), "ú" + rr$ + " " + STRING$((40 - viewx) - LEN(rr$) - 7, "-") + RIGHT$("----" + LTRIM$(STR$(menucost)) + "$", 5), 0, textfg%, textbg%
			END IF
			IF menucost = 0 THEN
				text Dest, 12 + menuindex, (viewx + 0), "ú" + rr$, 0, textfg%, textbg%
			END IF
		NEXT menuindex
wwait1:
		GOSUB buttonwait
		menuselect$ = "____"
		menucost = 0
		IF lb% = -1 THEN
			IF xm% = viewx THEN
				IF ym% >= 13 AND ym% <= 12 + menusize THEN
					menuselect = ym% - 12
					menuselect$ = MID$(menu$, (menuselect - 1) * 8 + 1, 4)
					menucost = CVL(MID$(menu$, (menuselect - 1) * 8 + 5, 4))
				END IF
			END IF
		END IF
		IF menuselect$ <> "lvup" AND menuselect$ <> "cncl" AND menuselect$ <> "____" THEN
			IF G(tx + (ty - 1) * AA, 6) >= menucost THEN
					c$ = "level up"
				GOSUB abilitygain
				hashadit$ = menuselect$
				GOSUB hashadit
				G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 6) = G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 6) + menucost
				GOTO merchant
			END IF
			GOTO merchant
		END IF
		IF menuselect$ = "lvup" THEN
			IF G(tx + (ty - 1) * AA, 6) >= menucost THEN
				c$ = "level up"
				GOSUB levelup
				GOTO merchant
			END IF
			GOTO merchant
		END IF
		IF menuselect$ = "cncl" THEN
			c$ = "level up"
		ELSE
			GOTO wwait1
		END IF
	END IF
RETURN

talk0001:
	am$ = ctrl$
	GOSUB am
	IF am > 0 THEN
		screencopy 1, 4
		screencopy 2, 1
		LINE (0, 0)-(319, 199), 0, BF
		screencopy 1, 2
reshow3:
		GOSUB portal
		statx = 2
		GOSUB status
		viewx = 18
		menu$ = ""
		menu$ = menu$ + "bye_" + MKL$(0)
		menusize = LEN(menu$) / 8
		inmenu = 0
	
		bindingset -1, STRING$(0, 0), 0, 0
		splashchat "pndx", (viewx + 0), 5, 1, 15, 1
		IF 0 THEN
			text Dest, 5, (viewx + 0), "Poindexter:", 0, textfg%, textbg%
			text Dest, 6, (viewx + 0), "Hi. How are you. My", 0, textfg%, textbg%
			text Dest, 7, (viewx + 0), "name is Poindexter. I", 0, textfg%, textbg%
			text Dest, 8, (viewx + 0), "am the greatest thief", 0, textfg%, textbg%
			text Dest, 9, (viewx + 0), "in the entire world!!!", 0, textfg%, textbg%
		END IF
		graphicput 10, (viewx + 0) + 6, (MID$(e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2), 1, 4) + "____.24")
		
		inventory 10, 15, menu$

		if 0 then
		
		FOR menuindex = 1 TO menusize
			menuitem$ = MID$(menu$, (menuindex - 1) * 8 + 1, 4)
			menucost = CVL(MID$(menu$, (menuindex - 1) * 8 + 5, 4))
			r$ = menuitem$
			GOSUB names
			IF menucost > 0 THEN
				text Dest, 12 + menuindex, (viewx + 0), "ú" + rr$ + " =" + STR$(menucost), 0, textfg%, textbg%
			END IF
			IF menucost = 0 THEN
				text Dest, 12 + menuindex, (viewx + 0), "ú" + rr$, 0, textfg%, textbg%
			END IF
		NEXT menuindex
	
	end if

wwait2:
		GOSUB buttonwait
		menuselect$ = "____"
		menucost = 0
		IF lb% = -1 THEN
			IF xm% = viewx THEN
				IF ym% >= 13 AND ym% <= 12 + menusize THEN
					menuselect = ym% - 12
					menuselect$ = MID$(menu$, (menuselect - 1) * 8 + 1, 4)
					menucost = CVL(MID$(menu$, (menuselect - 1) * 8 + 5, 4))
				END IF
			END IF
		END IF
		IF menuselect$ <> "bye_" THEN
			GOTO wwait2
		END IF
		IF menuselect$ = "bye_" THEN
			c$ = "level up"
		ELSE
			GOTO wwait1
		END IF
		screencopy 4, 1
	END IF
RETURN

abilitygain:
	e$(tx + (ty - 1) * AA, 1) = e$(tx + (ty - 1) * AA, 1) + menuselect$
	G(tx + (ty - 1) * AA, 6) = G(tx + (ty - 1) * AA, 6) - menucost
	am$ = ctrl$
	GOSUB am
	IF am > 0 THEN
		LINE ((25 - 1) * 8, 0)-(319, 199), 0, BF
		screencopy 1, 2
		GOSUB portal
		GOSUB avgframe
		text Dest, 5, 25, e$(tx + (ty - 1) * AA, 0), textrate, textfg%, textbg%
		text Dest, 7, 25, "gained", textrate, textfg%, textbg%
		r$ = menuselect$
		GOSUB names
		text Dest, 9, 25, rr$, textrate, textfg%, textbg%
		GOSUB okbutton
		screencopy 2, 1
	END IF
RETURN

levelup:
	IF MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) <> "____" THEN
		IF G(tx + (ty - 1) * AA, 6) >= lv(G(tx + (ty - 1) * AA, 10)) THEN
			G(tx + (ty - 1) * AA, 6) = G(tx + (ty - 1) * AA, 6) - lv(G(tx + (ty - 1) * AA, 10))
			r1 = INT(RND(1) * 5) + 1
			G(tx + (ty - 1) * AA, 11) = G(tx + (ty - 1) * AA, 11) + r1
			G(tx + (ty - 1) * AA, 1) = G(tx + (ty - 1) * AA, 1) + r1
			r2 = INT(RND(1) * 5) + 1
			G(tx + (ty - 1) * AA, 12) = G(tx + (ty - 1) * AA, 12) + r2
			G(tx + (ty - 1) * AA, 2) = G(tx + (ty - 1) * AA, 2) + r2
			r3 = INT(RND(1) * 5) + 1
			G(tx + (ty - 1) * AA, 13) = G(tx + (ty - 1) * AA, 13) + r3
			G(tx + (ty - 1) * AA, 3) = G(tx + (ty - 1) * AA, 3) + r3
			r4 = .2
			G(tx + (ty - 1) * AA, 4) = G(tx + (ty - 1) * AA, 4) + r4
			r5 = .05
			G(tx + (ty - 1) * AA, 14) = G(tx + (ty - 1) * AA, 14) + r5
			am$ = ctrl$
			GOSUB am
			IF am > 0 THEN
				LINE ((25 - 1) * 8, 0)-(319, 199), 0, BF
				screencopy 1, 2
				GOSUB portal
				GOSUB avgframe
				text Dest, 5, 25, e$(tx + (ty - 1) * AA, 0), textrate, textfg%, textbg%
				text Dest, 7, 25, "      level up!", textrate, textfg%, textbg%
				text Dest, 9, 25, "HPmax +", textrate, textfg%, textbg%
				text Dest, 9, 35, RIGHT$(STRING$(5, " ") + STR$(r1), 5), textrate, textfg%, textbg%
				text Dest, 11, 25, "STRmax +", textrate, textfg%, textbg%
				text Dest, 11, 35, RIGHT$(STRING$(5, " ") + STR$(r2), 5), textrate, textfg%, textbg%
				text Dest, 13, 25, "ESSmax +", textrate, textfg%, textbg%
				text Dest, 13, 35, RIGHT$(STRING$(5, " ") + STR$(r3), 5), textrate, textfg%, textbg%
				text Dest, 15, 25, "STRspd up!", textrate, textfg%, textbg%
				text Dest, 16, 25, "ESSspd up!", textrate, textfg%, textbg%
			END IF
			IF G(tx + (ty - 1) * AA, 10) < 64 THEN
				G(tx + (ty - 1) * AA, 10) = G(tx + (ty - 1) * AA, 10) + 1
				am$ = ctrl$
				GOSUB am
				IF am > 0 THEN
					text Dest, 18, 25, "reached LV#", textrate, textfg%, textbg%
					text Dest, 18, 37, RIGHT$(STRING$(3, " ") + STR$(G(tx + (ty - 1) * AA, 10)), 3), textrate, textfg%, textbg%
					IF lv(G(tx + (ty - 1) * AA, 10)) - G(tx + (ty - 1) * AA, 6) >= 0 THEN
						text Dest, 20, 25, "next:", textrate, textfg%, textbg%
						text Dest, 20, 34, RIGHT$(STRING$(5, " ") + STR$(lv(G(tx + (ty - 1) * AA, 10)) - G(tx + (ty - 1) * AA, 6)), 5) + "$", textrate, textfg%, textbg%
					END IF
				END IF
			END IF
			am$ = ctrl$
			GOSUB am
			IF am > 0 THEN
				GOSUB okbutton
				screencopy 2, 1
			END IF
			IF G(tx + (ty - 1) * AA, 10) >= 2 AND MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) = "spdr" THEN
				getit$ = "vnom"
				haveit$ = "vnom"
				GOSUB haveit
				IF haveit = 0 THEN
					e$(tx + (ty - 1) * AA, 1) = e$(tx + (ty - 1) * AA, 1) + getit$
					GOSUB gain
				END IF
			END IF
		END IF
	END IF
RETURN

gain:
	am$ = ctrl$
	GOSUB am
	IF am > 0 THEN
		LINE ((25 - 1) * 8, 0)-(319, 199), 0, BF
		screencopy 1, 2
		GOSUB portal
		GOSUB avgframe
		text Dest, 5, 25, e$(tx + (ty - 1) * AA, 0), textrate, textfg%, textbg%
		text Dest, 7, 25, "gained", textrate, textfg%, textbg%
		r$ = getit$
		GOSUB names
		text Dest, 9, 25, rr$, textrate, textfg%, textbg%
		GOSUB okbutton
		screencopy 2, 1
	END IF
RETURN

getit:
	IF getit$ <> "" THEN
		e$(tx + (ty - 1) * AA, 1) = e$(tx + (ty - 1) * AA, 1) + getit$
		am$ = ctrl$
		GOSUB am
		are$ = ctrl$
		GOSUB are
		IF am > 0 OR are > 0 THEN
			LINE ((25 - 1) * 8, 0)-(319, 199), 0, BF
			screencopy 1, 2
			GOSUB portal
			GOSUB avgframe
			text Dest, 5, 25, e$(tx + (ty - 1) * AA, 0), textrate, textfg%, textbg%
			text Dest, 6, 25, "gained", textrate, textfg%, textbg%
			r$ = getit$
			GOSUB names
			text Dest, 7, 25, rr$, textrate, textfg%, textbg%
			text Dest, 8, 25, "from", textrate, textfg%, textbg%
			text Dest, 9, 25, e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 0) + "!", textrate, textfg%, textbg%
			GOSUB okbutton
			screencopy 2, 1
		END IF
	END IF
RETURN

attackusing:
	am$ = ctrl$
	GOSUB am
	are$ = ctrl$
	GOSUB are
	IF am > 0 OR are > 0 THEN
		LINE ((25 - 1) * 8, 0)-(319, 199), 0, BF
		screencopy 1, 2
		GOSUB portal
		GOSUB avgframe
		text Dest, 5, 25, e$(tx + (ty - 1) * AA, 0), textrate, textfg%, textbg%
		text Dest, 6, 25, "used", textrate, textfg%, textbg%
		r$ = AA$
		GOSUB names
		text Dest, 7, 25, rr$, textrate, textfg%, textbg%
		text Dest, 8, 25, "on", textrate, textfg%, textbg%
		text Dest, 9, 25, e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 0), textrate, textfg%, textbg%
		GOSUB okbutton
		screencopy 2, 1
	END IF
RETURN

battleattack:
	am$ = ctrl$
	GOSUB am
	are$ = ctrl$
	GOSUB are
	IF am > 0 OR are > 0 THEN
		LINE ((25 - 1) * 8, 0)-(319, 199), 0, BF
		screencopy 1, 2
		GOSUB portal
		GOSUB avgframe
		text Dest, 5, 25, e$(tx + (ty - 1) * AA, 0), textrate, textfg%, textbg%
		text Dest, 6, 25, "used", textrate, textfg%, textbg%
		r$ = MID$(e$(tx + (ty - 1) * AA, 4), 5, 4)
		GOSUB names
		text Dest, 7, 25, rr$, textrate, textfg%, textbg%
		text Dest, 9, 25, e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 0), textrate, textfg%, textbg%
		text Dest, 10, 25, "HP  down" + STR$(attackdamage), textrate, textfg%, textbg%
		text Dest, 11, 25, "STR down" + STR$(strdamage), textrate, textfg%, textbg%
		GOSUB okbutton
		screencopy 2, 1
	END IF
RETURN

defeated:
	am$ = ctrl$
	GOSUB am
	are$ = ctrl$
	GOSUB are
	IF am > 0 OR are > 0 THEN
		LINE ((25 - 1) * 8, 0)-(319, 199), 0, BF
		screencopy 1, 2
		GOSUB portal
		GOSUB avgframe
		text Dest, 5, 25, e$(tx + (ty - 1) * AA, 0), textrate, textfg%, textbg%
		text Dest, 6, 25, "defeated", textrate, textfg%, textbg%
		text Dest, 7, 25, e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 0), textrate, textfg%, textbg%
		text Dest, 8, 25, "EXP+", textrate, textfg%, textbg%
		text Dest, 9, 25, RIGHT$(STRING$(16, " ") + STR$(expgain), 15), textrate, textfg%, textbg%
		text Dest, 10, 25, "EXP:", textrate, textfg%, textbg%
		text Dest, 11, 25, RIGHT$(STRING$(16, " ") + STR$(G(tx + (ty - 1) * AA, 6)), 15), textrate, textfg%, textbg%
		text Dest, 12, 25, "STR+", textrate, textfg%, textbg%
		text Dest, 13, 25, RIGHT$(STRING$(16, " ") + STR$(strgain), 15), textrate, textfg%, textbg%
		text Dest, 14, 25, "STR:", textrate, textfg%, textbg%
		text Dest, 15, 25, RIGHT$(STRING$(16, " ") + STR$(G(tx + (ty - 1) * AA, 2)), 15), textrate, textfg%, textbg%
		GOSUB okbutton
		screencopy 2, 1
	END IF
RETURN

portal:

renderportal

IF 0 THEN
	framex1! = ((-3) * 3 + 13 - 1)
	framex2! = ((4) * 3 + 13 - 1)
	framey1! = ((-3) * 3 + 13 - 1) - 1
	framey2! = ((4) * 3 + 13 - 1)
	framec1% = 1
	framec2% = 9
	GOSUB frameput
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
		graphicput ((tty - ty) * 3 + 13 - 1), ((ttx - tx) * 3 + 13 - 1), (MID$(e$(ttx + (tty - 1) * AA, 2), 5, 4) + "____" + ".24")
		graphicput ((tty - ty) * 3 + 13 - 1), ((ttx - tx) * 3 + 13 - 1), (MID$(e$(ttx + (tty - 1) * AA, 2), 1, 4) + MID$(e$(ttx + (tty - 1) * AA, 4), 1, 4) + ".24")
		temptx = tx
		tempty = ty
		tx = ttx
		ty = tty
		GOSUB tempget
		tx = temptx
		ty = tempty
		IF tempaction$ = "zzzz" THEN
			graphicput ((tty - ty) * 3 + 13 - 1), ((ttx - tx) * 3 + 13 - 1), ("zzzz____.24")
		END IF
	NEXT tty
	NEXT ttx
	FOR ttx = dx1 TO dx2
	FOR tty = dy1 TO dy2
		temptx = tx
		tempty = ty
		tx = ttx
		ty = tty
		GOSUB tempget
		tx = temptx
		ty = tempty
		IF tempaction$ = "grpl" OR tempaction$ = "rapl" THEN
			IF tempdis > 0 THEN
					tempy1! = (tty - ty) * 3 + 13 - 1
					tempx1! = (ttx - tx) * 3 + 13 - 1
					tempy2! = (tty - ty + da(tempd, 2) * tempdis) * 3 + 13 - 1
					tempx2! = (ttx - tx + da(tempd, 1) * tempdis) * 3 + 13 - 1
					PSET ((tempx1! - 1) * 8 + 12, (tempy1! - 1) * 8 + 12), 6
					LINE -((tempx2! - 1) * 8 + 12, (tempy2! - 1) * 8 + 12), 6
				FOR ts! = 0 TO tempdis STEP tempdis / 8
					tempy! = (tty - ty + da(tempd, 2) * ts!) * 3 + 13 - 1
					tempx! = (ttx - tx + da(tempd, 1) * ts!) * 3 + 13 - 1
					tt! = ts!
					IF tempdis <= 1 THEN
						tt! = ts!
					ELSE
						IF ts! < tempdis - 1 THEN
							tt! = -1
						ELSE
							tt! = ts! - tempdis + 1
						END IF
					END IF
					IF tt! >= 0 THEN
						PSET ((tempx! - 1) * 8 + 12, (tempy! - 1) * 8 + 12 - tt!), 7
						PSET ((tempx! - 1) * 8 + 12 + tt!, (tempy! - 1) * 8 + 12), 7
						PSET ((tempx! - 1) * 8 + 12, (tempy! - 1) * 8 + 12 + tt!), 7
						PSET ((tempx! - 1) * 8 + 12 - tt!, (tempy! - 1) * 8 + 12), 7
					END IF
				NEXT ts!
			END IF
		END IF
	NEXT tty
	NEXT ttx
END IF
RETURN


title:
	CLS
	colr% = 9
	texts$ = "   ÍÍÍ"
	GOSUB showtext
	texts$ = "  ðúú/ð"
	GOSUB showtext
	texts$ = " ºúú/³úº"
	GOSUB showtext
	texts$ = " ºú/úÂÄº"' AquariusúGames"
	GOSUB showtext
	texts$ = " º/ÄÄÙúº"
	GOSUB showtext
	texts$ = "  ðúú³ð"
	GOSUB showtext
	texts$ = "   ÍÍÍ"
	GOSUB showtext
	colr% = 11
	text Dest, 2, 6, "/", colr%, textfg%, textbg%
	text Dest, 3, 5, "/³", colr%, textfg%, textbg%
	text Dest, 4, 4, "/", colr%, textfg%, textbg%
	text Dest, 4, 6, "ÂÄ", colr%, textfg%, textbg%
	text Dest, 4, 10, "AquariusúGames", colr%, textfg%, textbg%
	text Dest, 5, 3, "/ÄÄÙ", colr%, textfg%, textbg%
	text Dest, 6, 6, "³", colr%, textfg%, textbg%

	logoput 1, 2, "AQUAGAME.56"

	LOCATE 9, 1
RETURN

status:
	GOSUB sttsfram
	GOSUB stts
	GOSUB sttsgpic
	GOSUB sttsitms
RETURN

sttsfram:
	framex1! = statx
	framex2! = 40
	framey1! = 4
	framey2! = 24
	framec1% = 4
	framec2% = 12
	GOSUB frameput
RETURN

stts:

	text Dest, 5, (statx + 0), e$(tx + (ty - 1) * AA, 0), 0, textfg%, textbg%
	'text Dest, 6, (statx + 0), "{{Lvup}}", 0, textfg%, textbg%

	statput 6, (statx + 0), "{{Lvup}}", INT(G(tx + (ty - 1) * AA, 1)), INT(G(tx + (ty - 1) * AA, 10))
	
	'text Dest, 6, (statx + 0) + 3, LTRIM$(STR$(100 + G(tx + (ty - 1) * AA, 10))), 0, textfg%, textbg%
	
	'text Dest, 6, (statx + 0) + 9, (RIGHT$("     " + STR$(G(tx + (ty - 1) * AA, 6)), 5) + "$"), 0, textfg%, textbg%
	'text Dest, 6, (statx + 0) + 2, "ú", 0, textfg%, textbg%
	
	statput 7, (statx + 0), "HP", INT(G(tx + (ty - 1) * AA, 1)), INT(G(tx + (ty - 1) * AA, 11)), 15, 0

	statput 8, (statx + 0), "STR", INT(G(tx + (ty - 1) * AA, 2)), INT(G(tx + (ty - 1) * AA, 12)), 15, 0

	statput 9, (statx + 0), "ESS", INT(G(tx + (ty - 1) * AA, 3)), INT(G(tx + (ty - 1) * AA, 13)), 15, 0

	RETURN

sttsgpic:
	GOSUB getaction
	SELECT CASE di%
	CASE 0
		graphicput 10, (statx + 0), "bttnself.24"
	CASE 1
		graphicput 10, (statx + 0), "bttnnrth.24"
	CASE 2
		graphicput 10, (statx + 0), "bttneast.24"
	CASE 3
		graphicput 10, (statx + 0), "bttnsuth.24"
	CASE 4
		graphicput 10, (statx + 0), "bttnwest.24"
	END SELECT
	graphicput 10, (statx + 0) + 6, (MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) + "____.24")
	graphicput 10, (statx + 0) + 3, (MID$(e$(tx + (ty - 1) * AA, 3), 5, 4) + "____.24")
RETURN

sttsitms:
	FOR ti% = 1 TO LEN(e$(tx + (ty - 1) * AA, 1)) / 4
		r$ = MID$(e$(tx + (ty - 1) * AA, 1), (ti% - 1) * 4 + 1, 4)
		GOSUB names
		IF action$ <> r$ THEN
			text Dest, 12 + (ti%) * 1, (statx + 0), "ú" + rr$, 0, textfg%, textbg%
		ELSE
			text Dest, 12 + (ti%) * 1, (statx + 0), "þ" + rr$, 0, textfg%, textbg%
		END IF
	NEXT ti%
RETURN

names:
	IF len( r$ ) = 0 THEN
		r$ = string$( 4, "_" )
	END IF
	
	rr$ = sync_name( r$, names_table() )

	if 0 then
	
	SELECT CASE CVL(r$)
	CASE CVL("____")
		rr$ = ""
	CASE CVL("lvup")
		rr$ = "level up"
	CASE CVL("cncl")
		rr$ = "cancel"
	CASE CVL("cure")
		rr$ = "cure"
	CASE CVL("ok__")
		rr$ = "ok"
	CASE CVL("yes_")
		rr$ = "yes"
	CASE CVL("no__")
		rr$ = "no"
	CASE CVL("bye_")
		rr$ = "bye"
	CASE CVL("bttn")
	rr$ = "button"
	CASE CVL("self")
	rr$ = "self"
	CASE CVL("nrth")
		rr$ = "north"
	CASE CVL("east")
		rr$ = "east"
	CASE CVL("suth")
		rr$ = "south"
	CASE CVL("west")
		rr$ = "west"
	CASE CVL("vnom")
		rr$ = "venom"
	CASE CVL("fire")
		rr$ = "fire"
	CASE CVL("cure")
		rr$ = "cure"
	CASE CVL("move")
		rr$ = "move"
	CASE CVL("bite")
		rr$ = "bite"
	CASE CVL("pnch")
		rr$ = "punch"
	CASE CVL("kick")
		rr$ = "kick"
	CASE CVL("dggr")
		rr$ = "dagger"
	CASE CVL("pike")
		rr$ = "pike"
	CASE CVL("wall")
		rr$ = "wall"
	CASE CVL("dtby")
		rr$ = "dust bunny"
	CASE CVL("spdr")
		rr$ = "spider"
	CASE CVL("plyr")
		rr$ = "player"
	CASE CVL("emgd")
		rr$ = "emerald guard"
	CASE CVL("shkt")
		rr$ = "shiny knight"
	CASE CVL("grml")
		rr$ = "gremlin"
	CASE CVL("web_")
		rr$ = "web"
	CASE CVL("door")
		rr$ = "door"
	CASE CVL("key_")
		rr$ = "key"
	CASE CVL("wstf")
		rr$ = "wooden staff"
	CASE CVL("bldr")
		rr$ = "boulder"
	CASE CVL("mgnt")
		rr$ = "magnet"
	CASE CVL("leap")
		rr$ = "leap"
	CASE CVL("lrft")
		rr$ = "life raft"
	CASE CVL("watr")
		rr$ = "water"
	CASE CVL("hole")
		rr$ = "hole"
	CASE CVL("padl")
		rr$ = "paddle"
	CASE CVL("irft")
		rr$ = "insta-raft"
	CASE CVL("axe_")
		rr$ = "axe"
	CASE CVL("chst")
		rr$ = "chest"
	CASE CVL("talk")
		rr$ = "talk"
	CASE CVL("burn")
		rr$ = "burn"
	CASE CVL("tngl")
		rr$ = "tangle"
	CASE CVL("grpl")
		rr$ = "grapple"
	CASE CVL("rapl")
		rr$ = "rapple"
	CASE CVL("ispt")
		rr$ = "inspect"
	CASE CVL("key1")
		rr$ = "iron key"
	CASE CVL("key2")
		rr$ = "rusty key"
	CASE CVL("loc1")
		rr$ = "iron lock"
	CASE CVL("loc2")
		rr$ = "red lock"
	CASE CVL("slep")
		rr$ = "sleep spell"
	CASE ELSE
		rr$ = r$
	END SELECT
	end if
	
RETURN

move:
	MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "move"
	MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "move"
	IF G(tx + (ty - 1) * AA, 2) >= 1 AND MID$(e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2), 1, 4) = "____" THEN
		move = 1
		here$ = "watr"
		GOSUB here
		IF here > 0 THEN move = 0
		there$ = "watr"
		GOSUB there
		IF there > 0 THEN move = 0
		here$ = "hole"
		GOSUB here
		there$ = "holestps"
		GOSUB there
		IF here > 0 AND there <= 0 THEN move = 0
		IF move = 1 THEN
			IF tx = ex AND ty = dy THEN
				am$ = ctrl$
				GOSUB am
				IF am > 0 THEN
					ex = tx + da(di%, 1) * dis
					dy = ty + da(di%, 2) * dis
				END IF
			END IF
			G(tx + (ty - 1) * AA, 2) = G(tx + (ty - 1) * AA, 2) - 1
			GOSUB swapdata
		END IF
	END IF
RETURN

wingmove:
	MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "move"
	MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "move"
	IF G(tx + (ty - 1) * AA, 2) >= 3 AND MID$(e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2), 1, 4) = "____" THEN
		move = 1
		IF move = 1 THEN
			IF tx = ex AND ty = dy THEN
				am$ = ctrl$
				GOSUB am
				IF am > 0 THEN
					ex = tx + da(di%, 1) * dis
					dy = ty + da(di%, 2) * dis
				END IF
			END IF
			G(tx + (ty - 1) * AA, 2) = G(tx + (ty - 1) * AA, 2) - 3
			GOSUB swapdata
		END IF
	END IF
RETURN

firemove:
	IF G(tx + (ty - 1) * AA, 2) >= 1 THEN
		IF 1 = 1 THEN
			IF tx = ex AND ty = dy THEN
				am$ = ctrl$
				GOSUB am
				IF am > 0 THEN
					ex = tx + da(di%, 1) * dis
					dy = ty + da(di%, 2) * dis
				END IF
			END IF
			MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
			MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "move"
			G(tx + (ty - 1) * AA, 2) = G(tx + (ty - 1) * AA, 2) - 1
			GOSUB swapdata
		END IF
	ELSE
		GOSUB gone
	END IF
RETURN

webmove:
	IF tx = ex AND ty = dy THEN
		am$ = ctrl$
		GOSUB am
		IF am > 0 THEN
			ex = tx + da(di%, 1) * dis
			dy = ty + da(di%, 2) * dis
		END IF
	END IF
	MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "move"
	MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "move"
	G(tx + (ty - 1) * AA, 2) = G(tx + (ty - 1) * AA, 2) - 1
	GOSUB swapdata
RETURN

castfire:
	IF G(tx + (ty - 1) * AA, 3) >= 20 THEN
		MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
		MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "fire"
		G(tx + (ty - 1) * AA, 3) = G(tx + (ty - 1) * AA, 3) - 20
		GOSUB prflblnk
		prflidty$ = "Flame"
		prflactn$ = "moveburn"
		prflgpic$ = "fire"
		prflcmnd$ = MKL$(di%) + "move" + MKL$(0)
		prflhp! = 120
		prflstr! = 10
		prfless! = 100
		prflspd! = 1
		prflvalu! = 1
		prflchck! = 1
		prfllv! = 1
		prflhpmax! = 120
		prflstrmax! = 50
		prflessmax! = 100
		prflessspd! = 5
		GOSUB prflmake
	END IF
RETURN

castdust:
	IF G(tx + (ty - 1) * AA, 3) >= 8 THEN
		MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
		MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "dust"
		G(tx + (ty - 1) * AA, 3) = G(tx + (ty - 1) * AA, 3) - 8
		GOSUB prflblnk
		prflidty$ = "Sleepy dust"
		prflactn$ = "move"
		prflgpic$ = "dust"
		prflcmnd$ = MKL$(di%) + "move" + MKL$(0)
		prflhp! = 120
		prflstr! = 10
		prfless! = 100
		prflspd! = 1
		prflvalu! = 1
		prflchck! = 1
		prfllv! = 1
		prflhpmax! = 120
		prflstrmax! = 50
		prflessmax! = 100
		prflessspd! = 5
		GOSUB prflmake
	END IF
RETURN
			
castweb:
	IF G(tx + (ty - 1) * AA, 3) >= 220 THEN
		G(tx + (ty - 1) * AA, 3) = G(tx + (ty - 1) * AA, 3) - 220
		GOSUB prflblnk
		prflidty$ = "Web"
		prflactn$ = "spdr"
		prflgpic$ = "web_"
		prflcmnd$ = MKL$(di%) + "move" + MKL$(0)
		prflidty! = 3
		prflhp! = 40
		prflstr! = 50
		prflspd! = 1
		prflvalu! = 1
		prflchck! = 1
		prfllv! = 1
		prflhpmax! = 40
		prflstrmax! = 50
		prflessmax! = 380
		prflessspd! = 2
		GOSUB prflmake
	END IF
RETURN
				
castspdr:
	IF G(tx + (ty - 1) * AA, 3) >= 320 THEN
		G(tx + (ty - 1) * AA, 3) = G(tx + (ty - 1) * AA, 3) - 320
		GOSUB prflblnk
		prflidty$ = "Spider"
		prflactn$ = "movebiteweb_"
		prflgpic$ = "spdr"
		prflcmnd$ = MKL$(0) + "move" + MKL$(0)
		prflidty! = 1
		prflhp! = 10
		prflstr! = 20
		prflspd! = 1
		prflarmr! = 1
		prflvalu! = 5
		prflpirc! = 1
		prfllv! = 1
		prflhpmax! = 10
		prflstrmax! = 20
		prflessmax! = 380
		prflessspd! = 3
		GOSUB prflmake
	END IF
RETURN

castccts:
	GOSUB prflblnk
	prflidty$ = "Cactus"
	prflgpic$ = "ccts"
	prflidty! = 13
	prflhp! = 10
	prflstr! = 20
	prflspd! = 1
	prflarmr! = 1
	prflvalu! = 5
	prflpirc! = 3
	prflchck! = 1
	prfllv! = 1
	prflhpmax! = 10
	prflstrmax! = 20
	prflessmax! = 380
	prflessspd! = 3
	GOSUB prflmake
RETURN
					
castdtby:
	IF G(tx + (ty - 1) * AA, 3) >= 160 THEN
		G(tx + (ty - 1) * AA, 3) = G(tx + (ty - 1) * AA, 3) - 160
		GOSUB prflblnk
		prflidty$ = "Dust Bunny"
		prflactn$ = "bitekick"
		prflgpic$ = "dtby"
		prflcmnd$ = MKL$(0) + "move" + MKL$(0)
		prflidty! = 6
		prflhp! = 15
		prflstr! = 20
		prfless! = 5
		prflspd! = 1.2
		prflvalu! = 2
		prflchck! = 1
		prfllv! = 1
		prflhpmax! = 15
		prflstrmax! = 20
		prflessmax! = 280
		prflessspd! = 1
	GOSUB prflmake
	END IF
RETURN

gone:
	GOSUB prflblnk
	GOSUB prflset
RETURN

deleter:
	GOSUB prflblnk
	GOSUB prflmake
RETURN

autolevelup:
	am$ = ctrl$
	GOSUB am
	IF am = 0 THEN
		GOSUB levelup
	END IF
RETURN

statgain:
	G(tx + (ty - 1) * AA, 2) = G(tx + (ty - 1) * AA, 2) + G(tx + (ty - 1) * AA, 4)
	G(tx + (ty - 1) * AA, 3) = G(tx + (ty - 1) * AA, 3) + G(tx + (ty - 1) * AA, 14)
RETURN

statmax:
	IF G(tx + (ty - 1) * AA, 1) > G(tx + (ty - 1) * AA, 11) THEN
		G(tx + (ty - 1) * AA, 1) = G(tx + (ty - 1) * AA, 11)
	END IF
	IF G(tx + (ty - 1) * AA, 2) > G(tx + (ty - 1) * AA, 12) THEN
		G(tx + (ty - 1) * AA, 2) = G(tx + (ty - 1) * AA, 12)
	END IF
	IF G(tx + (ty - 1) * AA, 3) > G(tx + (ty - 1) * AA, 13) THEN
		G(tx + (ty - 1) * AA, 3) = G(tx + (ty - 1) * AA, 13)
	END IF
RETURN

nextaction:
	am$ = ctrl$
	GOSUB am
	IF am = 0 THEN
		IF 1 = 1 THEN
			GOSUB newaction
			GOSUB putaction
		END IF
	ELSE
		GOSUB getaction
	END IF
RETURN

newaction:
	GOSUB getaction
	IF NOT (action$ = "zzzz" AND dis > 0) THEN
		di% = INT(RND(1) * 4) + 1
		GOSUB randomaction
		dis = 0
	END IF
RETURN

randomaction:
	r = LEN(e$(tx + (ty - 1) * AA, 1)) / 4
	r = INT(RND(1) * (r + 1))
	IF r = 0 THEN
		action$ = "____"
	ELSE
		action$ = MID$(e$(tx + (ty - 1) * AA, 1), (r - 1) * 4 + 1, 4)
	END IF
RETURN

getaction:
	di% = CVL(MID$(e$(tx + (ty - 1) * AA, 3), 1, 4))
	action$ = MID$(e$(tx + (ty - 1) * AA, 3), 5, 4)
	dis = CVL(MID$(e$(tx + (ty - 1) * AA, 3), 9, 4))
RETURN

putaction:
	MID$(e$(tx + (ty - 1) * AA, 3), 1, 4) = MKL$(di%)
	MID$(e$(tx + (ty - 1) * AA, 3), 5, 4) = action$
	MID$(e$(tx + (ty - 1) * AA, 3), 9, 4) = MKL$(dis)
RETURN


tempget:
	fntempget
	IF 0 THEN
		tempd = CVL(MID$(e$(tx + (ty - 1) * AA, 3), 1, 4))
		tempaction$ = MID$(e$(tx + (ty - 1) * AA, 3), 5, 4)
		tempdis = CVL(MID$(e$(tx + (ty - 1) * AA, 3), 9, 4))
	END IF
RETURN

tempput:
	fntempput
	IF 0 THEN
		MID$(e$(tx + (ty - 1) * AA, 3), 1, 4) = MKL$(tempd)
		MID$(e$(tx + (ty - 1) * AA, 3), 5, 4) = tempaction$
		MID$(e$(tx + (ty - 1) * AA, 3), 9, 4) = MKL$(tempdis)
	END IF
RETURN

inbounds:
	IF tx + da(di%, 1) * dis >= 1 AND tx + da(di%, 1) * dis <= AA AND ty + da(di%, 2) * dis >= 1 AND ty + da(di%, 2) * dis <= DD THEN
		inbounds = 1
	ELSE
		inbounds = 0
	END IF
RETURN

haveit:
	haveit = 0
	ts$ = e$(tx + (ty - 1) * AA, 1)
	ti% = LEN(ts$) / 4
	FOR tt = 1 TO ti%
		tt$ = MID$(ts$, (tt - 1) * 4 + 1, 4)
		IF tt$ = haveit$ THEN
			haveit = haveit + 1
		END IF
	NEXT tt
RETURN

hasit:
	hasit = 0
	ts$ = e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 1)
	ti% = LEN(ts$) / 4
	FOR tt = 1 TO ti%
		tt$ = MID$(ts$, (tt - 1) * 4 + 1, 4)
		IF tt$ = hasit$ THEN
			hasit = hasit + 1
		END IF
	NEXT tt
RETURN

havehadit:
	ts$ = e$(tx + (ty - 1) * AA, 1)
	ti% = LEN(ts$) / 4
	FOR tt = 1 TO ti%
		tt$ = MID$(ts$, (tt - 1) * 4 + 1, 4)
		IF tt$ = havehadit$ THEN
			ts$ = LEFT$(ts$, (tt - 1) * 4) + RIGHT$(ts$, ti% * 4 + 1 - tt * 4 - 1)
			tt = ti%
		END IF
	NEXT tt
	e$(tx + (ty - 1) * AA, 1) = ts$
RETURN

hashadit:
	ts$ = e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 1)
	ti% = LEN(ts$) / 4
	FOR tt = 1 TO ti%
		tt$ = MID$(ts$, (tt - 1) * 4 + 1, 4)
		IF tt$ = hashadit$ THEN
			ts$ = LEFT$(ts$, (tt - 1) * 4) + RIGHT$(ts$, ti% * 4 + 1 - tt * 4 - 1)
			tt = ti%
		END IF
	NEXT tt
	e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 1) = ts$
RETURN

havegotit:
	ts$ = e$(tx + (ty - 1) * AA, 1)
	e$(tx + (ty - 1) * AA, 1) = ts$ + havegotit$
RETURN

hasgotit:
	ts$ = e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 1)
	e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 1) = ts$ + hasgotit$
RETURN

winexp:
	getit = G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 6)
	IF getit > 0 THEN
		getit$ = STR$(getit) + " EXP"
		getit$ = RIGHT$(getit$, LEN(getit$) - 1)
		G(tx + (ty - 1) * AA, 1) = G(tx + (ty - 1) * AA, 1) + getit
		GOSUB getit
		G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 6) = 0
	END IF
RETURN

windggr:
	winit$ = "dggr"
GOTO winit

winpike:
	winit$ = "pike"
GOTO winit

wingrpl:
	winit$ = "grpl"
GOTO winit

winseed:
	winit$ = "seed"
GOTO winit

winkey1:
	winit$ = "key1"
GOTO winit

winkey2:
	winit$ = "key2"
GOTO winit

winit:
	getit$ = winit$
	hasit$ = winit$
	GOSUB hasit
	IF hasit = 0 THEN RETURN
	haveit$ = winit$
	GOSUB haveit
	IF haveit > 0 THEN RETURN
	GOSUB getit
	hashadit$ = winit$
	GOSUB hashadit
RETURN

am:
	am = 0
	FOR ti% = 1 TO LEN(am$) / 4
		IF MID$(am$, (ti% - 1) * 4 + 1, 4) = MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) THEN
			am = am + 1
		END IF
	NEXT ti%
RETURN

are:
	are = 0
	FOR ti% = 1 TO LEN(are$) / 4
		IF MID$(are$, (ti% - 1) * 4 + 1, 4) = MID$(e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2), 1, 4) THEN
			are = are + 1
		END IF
	NEXT ti%
RETURN

here:
	here = 0
	FOR ti% = 1 TO LEN(here$) / 4
		IF MID$(here$, (ti% - 1) * 4 + 1, 4) = MID$(e$(tx + (ty - 1) * AA, 2), 5, 4) THEN
			here = here + 1
		END IF
	NEXT ti%
RETURN

there:
	there = 0
	FOR ti% = 1 TO LEN(there$) / 4
		IF MID$(there$, (ti% - 1) * 4 + 1, 4) = MID$(e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2), 5, 4) THEN
			there = there + 1
		END IF
	NEXT ti%
RETURN

blankcheck:
	are$ = blankcheck$
	GOSUB inbounds
	IF inbounds = 1 THEN
		GOSUB are
	ELSE
		are = -1
	END IF
	blankcheck = are
RETURN

okbutton:
	text Dest, 23, 25, "{{Ok}}", 0, textfg%, textbg%
wwait:
	GOSUB buttonwait
	IF (( c$ = "ok" OR c$ = CHR$(13) ) OR (ym% = 23 AND xm% = 25 AND lb% = -1)) THEN
		c$ = "level up"
	ELSE
		GOTO wwait
	END IF
RETURN

buttonwait:
	suspend timer, 0
	'screencopy 1, 3
	'cinput
	'cursorput
	'screen_scaler 1, 0
	'screencopy 3, 1
RETURN
		
commandwait:
	screencopy 1, 2
	c$ = "%%"
	lb% = 0
	WHILE c$ = "%%" AND lb% = 0
		cinput
		cursorput
		screen_scaler 1, 0
		screencopy 2, 1
	WEND
RETURN


frameput:

renderframe Dest, framex1!, framey1!, framex2!, framey2!, framec1%, framec2%

RETURN

avgframe:
	framex1! = 25
	framex2! = 40
	framey1! = 4
	framey2! = 24
	framec1% = 4
	framec2% = 12
	GOSUB frameput
RETURN

doscreenset:
	screencopy 2, 1
	screen_scaler 1, 0
	screenres 320,200,8,8
	'SCREEN 7, 0, 0, 0
	COLOR 15, 1
RETURN

findcrsr:
	crsry% = CSRLIN
	crsrx% = POS(0)
RETURN

showtext:
	GOSUB findcrsr
	text Dest, (crsry + 0), (crsrx + 0),  texts$, colr%, textfg%, textbg%
	LOCATE crsry% + 1, 1
RETURN

prflblnk:
	prflidty$ = ""
	prflactn$ = ""
	prflgpic$ = "____"
	prflcmnd$ = MKL$(0) + "____" + MKL$(0)
	prflgpicactn$ = "____" + "____"
	prflidty! = 0
	prflhp! = 0
	prflstr! = 0
	prfless! = 0
	prflspd! = 0
	prflarmr! = 0
	prflexp! = 0
	prflvalu! = 0
	prflpirc! = 0
	prflchck! = 0
	prfllv! = 0
	prflhpmax! = 0
	prflstrmax! = 0
	prflessmax! = 0
	prflessspd! = 0
	prflevad! = 0
	prflblnk! = 0
RETURN

prflset:
	e$(tx + (ty - 1) * AA, 0) = prflidty$
	e$(tx + (ty - 1) * AA, 1) = prflactn$
	MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) = prflgpic$
	e$(tx + (ty - 1) * AA, 3) = prflcmnd$
	e$(tx + (ty - 1) * AA, 4) = prflgpicactn$
	G(tx + (ty - 1) * AA, 0) = prflidty!
	G(tx + (ty - 1) * AA, 1) = prflhp!
	G(tx + (ty - 1) * AA, 2) = prflstr!
	G(tx + (ty - 1) * AA, 3) = prfless!
	G(tx + (ty - 1) * AA, 4) = prflspd!
	G(tx + (ty - 1) * AA, 5) = prflarmr!
	G(tx + (ty - 1) * AA, 6) = prflexp!
	G(tx + (ty - 1) * AA, 7) = prflvalu!
	G(tx + (ty - 1) * AA, 8) = prflpirc!
	G(tx + (ty - 1) * AA, 9) = prflchck!
	G(tx + (ty - 1) * AA, 10) = prfllv!
	G(tx + (ty - 1) * AA, 11) = prflhpmax!
	G(tx + (ty - 1) * AA, 12) = prflstrmax!
	G(tx + (ty - 1) * AA, 13) = prflessmax!
	G(tx + (ty - 1) * AA, 14) = prflessspd!
	G(tx + (ty - 1) * AA, 15) = prflevad!
	G(tx + (ty - 1) * AA, 16) = prflblnk!
RETURN

prflmake:
	e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 0) = prflidty$
	e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 1) = prflactn$
	MID$(e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2), 1, 4) = prflgpic$
	e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 3) = prflcmnd$
	e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 4) = prflgpicactn$
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 0) = prflidty!
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 1) = prflhp!
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 2) = prflstr!
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 3) = prfless!
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 4) = prflspd!
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 5) = prflarmr!
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 6) = prflexp!
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 7) = prflvalu!
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 8) = prflpirc!
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 9) = prflchck!
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 10) = prfllv!
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 11) = prflhpmax!
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 12) = prflstrmax!
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 13) = prflessmax!
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 14) = prflessspd!
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 15) = prflevad!
	G(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 16) = prflblnk!
RETURN

actncure:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN RETURN
	IF blankcheck > 0 THEN RETURN
	blankcheck$ = "plyrspdrgrmldtbyemgdshktimp_"
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB usecure
		RETURN
	END IF
RETURN

actnbite:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN RETURN
	IF blankcheck > 0 THEN RETURN
	blankcheck$ = attackthem$
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB attkbite
		RETURN
	END IF
RETURN

actnpnch:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN RETURN
	IF blankcheck > 0 THEN RETURN
	blankcheck$ = attackthem$
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB attkpnch
		RETURN
	END IF
RETURN

actnkick:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN RETURN
	IF blankcheck > 0 THEN RETURN
	blankcheck$ = attackthem$
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB attkkick
		RETURN
	END IF
RETURN

actndggr:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN RETURN
	IF blankcheck > 0 THEN RETURN
	blankcheck$ = attackthem$
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB attkdggr
		RETURN
	END IF
RETURN

actnpike:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN RETURN
	IF blankcheck > 0 THEN RETURN
	blankcheck$ = attackthem$
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB attkpike
		RETURN
	END IF
RETURN

actnvnom:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN RETURN
	IF blankcheck > 0 THEN RETURN
	blankcheck$ = attackthem$
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB attkvnom
		RETURN
	END IF
RETURN

actnfire:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN RETURN
	IF blankcheck > 0 THEN
		GOSUB castfire
		RETURN
	END IF
	blankcheck$ = attackthem$
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB attkfire
		RETURN
	END IF
RETURN

actndust:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN RETURN
	IF blankcheck > 0 THEN
		GOSUB castdust
		RETURN
	END IF
	blankcheck$ = attackthem$
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB useslep
		RETURN
	END IF
RETURN

actnweb:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN RETURN
	IF blankcheck > 0 THEN
		GOSUB castweb
		RETURN
	END IF
	blankcheck$ = attackthem$
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB attkweb
		RETURN
	END IF
RETURN

actnspdr:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN RETURN
	IF blankcheck > 0 THEN
		GOSUB castspdr
		RETURN
	END IF
RETURN

actnccts:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN RETURN
	IF blankcheck > 0 THEN
		GOSUB castccts
		RETURN
	END IF
RETURN

actndtby:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN RETURN
	IF blankcheck > 0 THEN
		GOSUB castdtby
		RETURN
	END IF
RETURN

actnmove:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN
		RETURN
	END IF
	IF blankcheck > 0 THEN
		GOSUB move
		RETURN
	END IF
RETURN

actnwing:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN
		RETURN
	END IF
	IF blankcheck > 0 THEN
		GOSUB wingmove
		RETURN
	END IF
RETURN

actnwstf:
	dis = 1
	blankcheck$ = "bldr"
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		dis = 2
		blankcheck$ = "____"
		GOSUB blankcheck
		IF blankcheck > 0 THEN
			temptx = tx
			tempty = ty
			tx = tx + da(di%, 1)
			ty = ty + da(di%, 2)
			dis = 1
			GOSUB swapdata
			tx = temptx
			ty = tempty
			RETURN
		END IF
	END IF
	blankcheck$ = attackthem$
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB attkwstf
	END IF
RETURN

actnkey1:
	dis = 1
	blankcheck$ = "door"
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		hasit$ = "loc1"
		GOSUB hasit
		IF hasit > 0 THEN
			hashadit$ = "loc1"
			GOSUB hashadit
			havehadit$ = "key1"
			GOSUB havehadit
			GOSUB deleter
		END IF
	END IF
RETURN

actnkey2:
	dis = 1
	blankcheck$ = "door"
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		hasit$ = "loc2"
		GOSUB hasit
		IF hasit > 0 THEN
			hashadit$ = "loc2"
			GOSUB hashadit
			havehadit$ = "key2"
			GOSUB havehadit
			GOSUB deleter
		END IF
	END IF
RETURN

actnispt:
	dis = 1
	GOSUB putaction
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN
		RETURN
	END IF
	IF blankcheck > 0 THEN
		RETURN
	END IF
	IF e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 0) = "Merchant" THEN
		GOSUB merchant
		RETURN
	END IF
	IF e$(tx + da(di%, 1) * dis + (ty + da(di%, 2) * dis - 1) * AA, 0) = "Poindexter" THEN
		GOSUB talk0001
		RETURN
	END IF
	blankcheck$ = "pwchchst"
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB winexp
		GOSUB windggr
		GOSUB winpike
		GOSUB wingrpl
		GOSUB winseed
		GOSUB winkey1
		GOSUB winkey2
		blankcheck$ = "pwch"
		IF blankcheck > 0 THEN
			GOSUB deleter
		END IF
		RETURN
	END IF
RETURN
	
actnfiremove:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN
		GOSUB gone
		RETURN
	END IF
	IF blankcheck > 0 THEN
		GOSUB firemove
		RETURN
	END IF
	blankcheck$ = attackthem$
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB attkburn
		GOSUB gone
		RETURN
	END IF
	GOSUB gone
RETURN

actndustmove:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN
		GOSUB gone
		RETURN
	END IF
	IF blankcheck > 0 THEN
		GOSUB firemove
		RETURN
	END IF
	blankcheck$ = attackthem$
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB useslep
		GOSUB gone
		RETURN
	END IF
	GOSUB gone
RETURN

actnwebmove:
	dis = 1
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN RETURN
	IF blankcheck > 0 THEN
		GOSUB webmove
		RETURN
	END IF
	blankcheck$ = attackthem$
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB attktngl
		GOSUB gone
		RETURN
	END IF
RETURN

actngrpl:
	IF dis = 3 THEN
		action$ = "rapl"
		GOSUB putaction
		GOTO actnrapl
	END IF
	IF dis = 0 AND G(tx + (ty - 1) * AA, 2) < 10 THEN
		action$ = "____"
		GOSUB putaction
		RETURN
	END IF
	IF dis = 0 THEN
		G(tx + (ty - 1) * AA, 2) = G(tx + (ty - 1) * AA, 2) - 10
	END IF
	IF dis < 3 THEN
		dis = dis + 1
	END IF
	blankcheck$ = "____"
	MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "pnch"
	MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "grpl"
	GOSUB blankcheck
	IF blankcheck = -1 THEN
		dis = dis - 1
		RETURN
	END IF
	IF blankcheck > 0 THEN
		GOSUB putaction
		RETURN
	END IF
	blankcheck$ = attackthem$
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB putaction
		action$ = "rapl"
		MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "pnch"
		MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "grpl"
		GOSUB putaction
		GOSUB attklash
		RETURN
	END IF
	blankcheck$ = "bldrchst"
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		action$ = "rapl"
		MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "pnch"
		MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "grpl"
		GOSUB putaction
		RETURN
	END IF
RETURN

actnrapl:
	MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "pnch"
	MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "grpl"
	IF dis = 1 THEN
		action$ = "____"
		dis = 0
		GOSUB putaction
		MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
		MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "____"
		RETURN
	END IF
	blankcheck$ = "____"
	GOSUB blankcheck
	IF blankcheck = -1 THEN
		IF dis > 1 THEN
			dis = dis - 1
			GOSUB putaction
		END IF
		RETURN
	END IF
	IF blankcheck > 0 THEN
		IF dis > 1 THEN
			dis = dis - 1
			GOSUB putaction
		END IF
	END IF
	blankcheck$ = attackthem$
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		GOSUB attklash
		dis = dis - 1
		GOSUB putaction
		RETURN
	END IF
	blankcheck$ = "bldrchst"
	GOSUB blankcheck
	IF blankcheck > 0 THEN
		dis = 1
		blankcheck$ = "____"
		GOSUB blankcheck
		IF blankcheck = 0 THEN
			dis = dis - 1
			GOSUB putaction
			RETURN
		END IF
		IF blankcheck > 0 THEN
			IF tx = ex AND ty = dy THEN
				am$ = ctrl$
				GOSUB am
				IF am > 0 THEN
					ex = tx + da(di%, 1) * dis
					dy = ty + da(di%, 2) * dis
				END IF
			END IF
			GOSUB swapdata
			temptx = tx
			tempty = ty
			tx = tx + da(di%, 1)
			ty = ty + da(di%, 2)
			GOSUB getaction
			dis = dis - 1
			GOSUB putaction
			tx = temptx
			ty = tempty
			RETURN
		END IF
	END IF
RETURN

crtnimp:
	GOSUB statgain
	GOSUB statmax
	GOSUB nextaction
	attackthem$ = "plyrgrmlspdrdtbyweb_emgdshkt"
	SELECT CASE CVL(action$)
	CASE CVL("move")
		GOSUB actnmove
	CASE CVL("fire")
		GOSUB actnfire
	CASE CVL("ispt")
		GOSUB actnispt
	CASE CVL("wing")
		GOSUB actnwing
	END SELECT
	GOSUB autolevelup
RETURN

crtnfire:
	GOSUB statgain
	GOSUB statmax
	GOSUB getaction
	attackthem$ = "plyrgrmlspdrdtbyweb_shktemgd"
	SELECT CASE CVL(action$)
	CASE CVL("move")
		GOSUB actnfiremove
	END SELECT
RETURN

crtndust:
	GOSUB statgain
	GOSUB statmax
	GOSUB getaction
	attackthem$ = "plyrgrmlspdrshktemgdimp_"
	SELECT CASE CVL(action$)
	CASE CVL("move")
		GOSUB actndustmove
	END SELECT
RETURN

crtnshkt:
	GOSUB statgain
	GOSUB statmax
	GOSUB nextaction
	attackthem$ = "plyrgrmlspdrdtbyweb_imp_"
	SELECT CASE CVL(action$)
	CASE CVL("move")
		GOSUB actnmove
	CASE CVL("fire")
		GOSUB actnfire
	CASE CVL("bite")
		GOSUB actnbite
	CASE CVL("pnch")
		GOSUB actnpnch
	CASE CVL("kick")
		GOSUB actnkick
	CASE CVL("dggr")
		GOSUB actndggr
	CASE CVL("pike")
		GOSUB actnpike
	END SELECT
	GOSUB autolevelup
RETURN

crtnemgd:
	GOSUB statgain
	GOSUB statmax
	GOSUB nextaction
	attackthem$ = "plyrgrmlspdrdtbyweb_imp_"
	SELECT CASE CVL(action$)
	CASE CVL("move")
		GOSUB actnmove
	CASE CVL("fire")
		GOSUB actnfire
	CASE CVL("bite")
		GOSUB actnbite
	CASE CVL("pnch")
		GOSUB actnpnch
	CASE CVL("kick")
		GOSUB actnkick
	CASE CVL("dggr")
		GOSUB actndggr
	CASE CVL("pike")
		GOSUB actnpike
	END SELECT
	GOSUB autolevelup
RETURN

crtnspdr:
	GOSUB statgain
	GOSUB statmax
	GOSUB nextaction
	attackthem$ = "plyrdtbyspdrimp_emgdshktgrml"
	SELECT CASE CVL(action$)
	CASE CVL("move")
		GOSUB actnmove
	CASE CVL("web_")
		GOSUB actnweb
	CASE CVL("bite")
		GOSUB actnbite
	CASE CVL("vnom")
		GOSUB actnkick
	END SELECT
	GOSUB autolevelup
RETURN

crtnweb:
	GOSUB statgain
	GOSUB statmax
	GOSUB getaction
	IF action$ <> "move" THEN
		GOSUB nextaction
	END IF
	attackthem$ = "plyrgrmldtbyweb_shktemgdimp_"
	SELECT CASE CVL(action$)
	CASE CVL("move")
		GOSUB actnwebmove
	CASE CVL("spdr")
		GOSUB actnspdr
	END SELECT
	GOSUB autolevelup
RETURN
		
crtndtby:
	GOSUB statgain
	GOSUB statmax
	GOSUB nextaction
	attackthem$ = "plyrgrmlspdrimp_emgdshkt"
	SELECT CASE CVL(action$)
	CASE CVL("move")
		GOSUB actnmove
	CASE CVL("fire")
		GOSUB actnfire
	CASE CVL("dtby")
		GOSUB actndtby
	CASE CVL("bite")
		GOSUB actnbite
	CASE CVL("kick")
		GOSUB actnkick
	CASE CVL("dust")
		GOSUB actndust
	END SELECT
	GOSUB autolevelup
RETURN

crtngrml:
	GOSUB statgain
	GOSUB statmax
	GOSUB nextaction
	attackthem$ = "plyrdtbyspdrimp_emgdshktweb_"
	SELECT CASE CVL(action$)
	CASE CVL("move")
		GOSUB actnmove
	CASE CVL("fire")
		GOSUB actnfire
	CASE CVL("bite")
		GOSUB actnbite
	CASE CVL("pnch")
		GOSUB actnpnch
	CASE CVL("kick")
		GOSUB actnkick
	CASE CVL("dggr")
		GOSUB actndggr
	CASE CVL("pike")
		GOSUB actnpike
	END SELECT
	GOSUB autolevelup
RETURN

crtnplyr:
	GOSUB statgain
	GOSUB statmax
	GOSUB nextaction
	attackthem$ = "plyrdtbyspdrimp_emgdshktweb_grmlccts"
	SELECT CASE CVL(action$)
	CASE CVL("move")
		GOSUB actnmove
	CASE CVL("fire")
		GOSUB actnfire
	CASE CVL("bite")
		GOSUB actnbite
	CASE CVL("pnch")
		GOSUB actnpnch
	CASE CVL("kick")
		GOSUB actnkick
	CASE CVL("dggr")
		GOSUB actndggr
	CASE CVL("pike")
		GOSUB actnpike
	CASE CVL("spdr")
		GOSUB actnspdr
	CASE CVL("web_")
		GOSUB actnweb
	CASE CVL("vnom")
		GOSUB actnvnom
	CASE CVL("cure")
		GOSUB actncure
	CASE CVL("ispt")
		GOSUB actnispt
	CASE CVL("grpl")
		GOSUB actngrpl
	CASE CVL("rapl")
		GOSUB actnrapl
	CASE CVL("seed")
		GOSUB actnccts
	CASE CVL("wstf")
		GOSUB actnwstf
	CASE CVL("wing")
		GOSUB actnwing
	CASE CVL("key1")
		GOSUB actnkey1
	CASE CVL("key2")
		GOSUB actnkey2
	END SELECT
	GOSUB autolevelup
RETURN

crtnccts:
	GOSUB statgain
	GOSUB statmax
	GOSUB nextaction
	attackthem$ = ""
	IF MID$(e$(tx + (ty - 1) * AA, 2), 5, 4) = "watr" THEN
		MID$(e$(tx + (ty - 1) * AA, 2), 5, 4) = "hole"
	END IF
	SELECT CASE CVL(action$)
	CASE CVL("seed")
		GOSUB actnccts
	END SELECT
	GOSUB autolevelup
RETURN

crtnbldr:
	GOSUB statgain
	GOSUB statmax
	GOSUB nextaction
	attackthem$ = ""
	IF MID$(e$(tx + (ty - 1) * AA, 2), 5, 4) = "hole" THEN
		MID$(e$(tx + (ty - 1) * AA, 2), 5, 4) = "dirt"
		GOSUB gone
		RETURN
	END IF
	'SELECT CASE CVL(action$)
	'END SELECT
	GOSUB autolevelup
RETURN

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

DEFINT A-Z
FUNCTION carddeckmath% (cardidty$, value$, op$)
	
	success% = 1
	
	REM cardvarget cardidty$, oldvalue$
	REM cardvarput cardidty$, oldvalue$ + oldvalue$
	
	SELECT CASE LEN(oldvalue$)
	CASE 0 TO 14 * 4
		SELECT CASE op$
		CASE "+"
			SELECT CASE FIX(LEN(oldvalue$) / 4)
			CASE IS < 15
				success% = cardvarset%(cardidty$, oldvalue$ + oldvalue$)
			CASE ELSE
				success% = 0
			END SELECT
		CASE "-"
			o% = 1
			DO WHILE FIX(o% / 4) <= FIX(LEN(oldvalue$) / 4)
				SELECT CASE MID$(oldvalue$, o%, 4)
				CASE value$
					SELECT CASE o% + 4
					CASE IS <= LEN(oldvalue$)
						temp$ = MID$(oldvalue$, o% + 4)
					CASE ELSE
						temp$ = STRING$(0, 0)
					END SELECT
				
					oldvalue$ = LEFT$(oldvalue$, o% - 1) + temp$
					EXIT DO
				END SELECT
				o% = o% + 4
			LOOP
		END SELECT
	CASE IS > 15
		success% = 0
	CASE ELSE
		success% = 0
	END SELECT
	
	carddeckmath% = success%
END FUNCTION

DEFSNG A-Z
SUB cardload (cardidty$)

	card$ = STRING$(0, 0)

	filemode% = FREEFILE

	OPEN ".\res\cards\" + cardidty$ + ".dat" FOR INPUT AS filemode%

	REM GOSUB prflblnk

	dice% = 0
	roll% = 0

	DO WHILE NOT (EOF(filemode%))
		LINE INPUT #filemode%, rr$
		
		SELECT CASE LEFT$(rr$, 1)
		CASE "?"
			
			SELECT CASE INSTR(1, rr$, ":")
			CASE 6
				
	SELECT CASE MID$(rr$, 2, 4)
				CASE "?roll:"
					success% = cardvarset%("prflroll!", LTRIM$(STR$(diceroll%)))
	CASE "?dice:"
					
		SELECT CASE MID$(rr$, INSTR(1, rr$, ":") + 5, 4)
		CASE " to "
			success% = cardvarget%("prflroll!", value$)
			dice% = VAL(value$)
						
			SELECT CASE dice%
			CASE IS >= VAL(MID$(rr$, INSTR(1, rr$, " to ") - 4, 4))
							
				SELECT CASE dice%
				CASE IS <= VAL(MID$(rr$, INSTR(1, rr$, " to ") + 4, 4))
					
		op$ = MID$(rr$, INSTR(1, rr$, " to ") + 9, 1)
		o% = 10
		DO WHILE o% + 3 < LEN(rr$)
			success% = carddeckmath%(cardidty$, MID$(rr$, o%, 4), op$)
			o% = o% + 4
		LOOP
				END SELECT
				
			END SELECT
			
		END SELECT
					
	END SELECT
	
			END SELECT
			
		END SELECT
		
REM
REM        varmode$ = "set"
REM
REM        SELECT CASE varmode$
REM        CASE "get"
REM         success% = cardvarget%(tag$, value$)
REM        CASE "set"
REM         success% = cardvarset%(tag$, value$)
REM        CASE ELSE
REM         success% = 0
REM        END SELECT
REM
REM    GOSUB prflset
REM   SELECT

LOOP

CLOSE #filemode%
END SUB

DEFINT A-Z
FUNCTION cardstatmath% (cardidty$, value$, op$)
	success% = cardvarget%(cardidty$, oldvalue$)
	old% = VAL(oldvalue$)
	
	success% = 1
	
	SELECT CASE op$
	CASE "+"
		success% = cardvarset%(cardidty$, LTRIM$(STR$(old% + VAL(value$))))
	CASE "-"
		success% = cardvarset%(cardidty$, LTRIM$(STR$(old% - VAL(value$))))
	CASE "*"
		success% = cardvarset%(cardidty$, LTRIM$(STR$(old% * VAL(value$))))
	CASE "/"
		IF VAL(value$) <> 0 THEN
			success% = cardvarset%(cardidty$, LTRIM$(STR$(old% / VAL(value$))))
		ELSE
			success% = 0
		END IF
	CASE ELSE
		success% = 0
	END SELECT
	cardstatmath% = success%
END FUNCTION

DEFSNG A-Z
FUNCTION cardvarget% (tag$, value$)
	
	success% = 1
	
	SELECT CASE RIGHT$(tag$, 1)
	CASE "$"
		
		SELECT CASE MID$(tag$, 5)
		CASE "idty"
			prflidty$ = value$
		CASE "actn"
			prflactn$ = value$
		CASE "gpic"
			prflgpic$ = value$
		CASE ELSE
			success% = 0
		END SELECT
	
	CASE "!"
		SELECT CASE MID$(tag$, 5)
		CASE "idty"
			value$ = LTRIM$(STR$(prflidty!))
		CASE "hp"
			value$ = LTRIM$(STR$(prflhp!))
		CASE "str"
			value$ = LTRIM$(STR$(prflstr!))
		CASE "ess"
			value$ = LTRIM$(STR$(prfless!))
		CASE "spd"
			value$ = LTRIM$(STR$(prflspd!))
		CASE "armr"
			value$ = LTRIM$(STR$(prflarmr!))
		CASE "exp"
			value$ = LTRIM$(STR$(prflexp!))
		CASE "valu"
			value$ = LTRIM$(STR$(prflvalu!))
		CASE "pirc"
			value$ = LTRIM$(STR$(prflpirc!))
		CASE "lv"
			value$ = LTRIM$(STR$(prfllv!))
		CASE "hpmax"
			value$ = LTRIM$(STR$(prflhpmax!))
		CASE "strmax"
			value$ = LTRIM$(STR$(prflstrmax!))
		CASE "essmax"
			value$ = LTRIM$(STR$(prflessmax!))
		CASE "essspd"
			value$ = LTRIM$(STR$(prflessspd!))
		CASE "evad"
			value$ = LTRIM$(STR$(prflevad!))
		CASE ELSE
			success% = 0
		END SELECT
	CASE ELSE
			success% = 0
	END SELECT
	
	cardvarget% = success%

END FUNCTION

FUNCTION cardvarset% (tag$, value$)
	
	success% = 1
	
	SELECT CASE RIGHT$(tag$, 1)
	CASE "$"
		
		SELECT CASE MID$(tag$, 5)
		CASE "idty"
			prflidty$ = value$
		CASE "actn"
			prflactn$ = value$
		CASE "gpic"
			prflgpic$ = value$
		CASE ELSE
			success% = 0
		END SELECT
	
	CASE "!"
		SELECT CASE MID$(tag$, 5)
		CASE "idty"
			prflidty! = VAL(value$)
		CASE "hp"
			prflhp! = VAL(value$)
		CASE "str"
			prflstr! = VAL(value$)
		CASE "ess"
			prfless! = VAL(value$)
		CASE "spd"
			prflspd! = VAL(value$)
		CASE "armr"
			prflarmr! = VAL(value$)
		CASE "exp"
			prflexp! = VAL(value$)
		CASE "valu"
			prflvalu! = VAL(value$)
		CASE "pirc"
			prflpirc! = VAL(value$)
		CASE "lv"
			prfllv! = VAL(value$)
		CASE "hpmax"
			prflhpmax! = VAL(value$)
		CASE "strmax"
			prflstrmax! = VAL(value$)
		CASE "essmax"
			prflessmax! = VAL(value$)
		CASE "essspd"
			prflessspd! = VAL(value$)
		CASE "evad"
			prflevad! = VAL(value$)
		CASE ELSE
			success% = 0
		END SELECT
	CASE ELSE
		success% = 0
	END SELECT
	cardvarset% = success%
END FUNCTION

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
FUNCTION diceroll%
	diceroll% = FIX(RND(1) * 10000)
END FUNCTION

DEFINT A-Z
SUB graphicput ( yy1%, xx1%, ss1$, special as integer = 1 )
	
	dim as integer special_text = 1
	
	dim as string path = "res\sprites\"
	dim as string erasure_mask = "", shade_mask = ""
	dim as string justss = "", scaless = ""
	dim as integer scale = 0

	scaless = ss1$
	do while instr( 1, scaless, "." ) > 0
		scaless = mid$( scaless, instr( 1, scaless, "." ) + 1 )
	loop
	
	'scaless = left$( scaless, len( scaless ) - 1 )
	
	scale = val( scaless )
	
	justss = just_cardname( ss1$ )
				
	justss += string$( 8 - len( justss ), "_" )

	if justss = string$( 8, "_" ) then
		exit sub
	end if
	
	erasure_mask = justss + "." + scaless + "y"
	shade_mask = justss + "." + scaless + "x"
	
	sprite_put 0, xx1%, yy1%, path + erasure_mask, "and"
	sprite_put 0, xx1%, yy1%, path + shade_mask$, "or"

	'if special and special_text then
	'
	'	if left$( justss, 4 ) <> string$( 4, "_" ) then
	'		text Dest, yy1%+1, xx1%, left$( justss, 4 ), 0, 15, 0, -2
	'	end if
	'	
	'	if mid$( justss, 5, 4 ) <> string$( 4, "_" ) then
	'		text Dest, yy1%+2, xx1%, mid$( justss, 5, 4 ), 0, 15, 0, -2
	'	end if
	'end if
	
	'if debugmode then
	'	text Dest, 20, 1, path + erasure_mask, 0, 14, 6, -1
	'	text Dest, 21, 1, path + shade_mask, 0, 14, 6, -1
	'end if
	
END SUB

DEFSNG A-Z
FUNCTION isinbounds (x as longint, y as longint, x1 as longint, y1 as longint, x2 as longint, y2 as longint) as longint
	isinbounds = (x >= x1 AND y >= y1 AND x <= x2 AND y <= y2)
END FUNCTION

SUB itemmenu (list$, caption$, colstart%, rowstart%, maxw%, maxh%, fg%, bg%)

		dim as longint row2 = 0, col2 = 0
	colend% = colstart% + maxw% - 1
	rowend% = rowstart% + maxh% - 1

	LINE (colstart% * 8 - 8, rowstart% * 8 - 8)-(colend% * 8 - 8, rowend% * 8 - 8), bg%, BF

	FOR o% = 1 TO LEN(list$) / 4 STEP 1
	
		col = o% MOD maxw%
		row = FIX(o% / maxw%)
		cardid$ = MID$(list$, o% * 4 - 3, 4)
		graphicput row + rowstart%, col + colstart%, cardid$
		
	NEXT o%

	LINE (colstart% * 8 - 8 - 1, rowstart% * 8 - 8 + 1)-(colend% * 8 - 8 + 1, rowend% * 8 - 8 - 1), fg% XOR 8, B
	LINE (colstart% * 8 - 8 + 1, rowstart% * 8 - 8 - 1)-(colend% * 8 - 8 - 1, rowend% * 8 - 8 + 1), fg% XOR 8, B

	LINE (colstart% * 8 - 8, rowstart% * 8 - 8)-(colstart% * 8 - 8, rowend% * 8 - 8), fg%
	LINE (colstart% * 8 - 8, rowstart% * 8 - 8)-(colstart% * 8 - 8, rowend% * 8 - 8), fg%
	LINE (colend% * 8 - 8, rowstart% * 8 - 8)-(colend% * 8 - 8, rowend% * 8 - 8), fg%
	LINE (colend% * 8 - 8, rowstart% * 8 - 8)-(colend% * 8 - 8, rowend% * 8 - 8), fg%

	IF LEN(cardid$) > 0 THEN
		text Dest, (row2+0), (colstart%+0), cardid$, fg%, textfg%, textbg%
	END IF

END SUB

DEFINT A-Z
SUB loadlvupdata (lvupfile$)

	load_names( "RES\CONFIG\" + sync_name( "file_lvup", config_table() ), level_table())

	for ti% = lbound( level_table, 1 ) to ubound( level_table, 1 ) step 1
	lv(ti%) = val( sync_name( ltrim$( str$( ti% ) ), level_table() ) )
	next ti%

	exit sub
	
	filemode% = FREEFILE
	OPEN ".\RES\STATS\" + lvupfile$ FOR INPUT AS #filemode%

	ti% = 0
	DO WHILE NOT (EOF(filemode%))
		INPUT #filemode%, lv(ti%)
		IF ti% >= 64 THEN EXIT DO
		ti% = ti% + 1
	LOOP

	CLOSE #filemode%

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

DEFSNG A-Z
SUB loadtextmode (filename$)
	
	text.sprites% = 1
	text.colored% = 1
	text.font$ = "lttr"
	text.scale% = VAL("08")

	filemode% = FREEFILE
	OPEN ".\RES\config\" + filename$ FOR INPUT AS #filemode%

	DO WHILE NOT (EOF(filemode%))
	
		LINE INPUT #filemode%, rr$
		label$ = LCASE$(LEFT$(rr$, INSTR(1, rr$, "=") - 1))
		value$ = MID$(rr$, INSTR(1, rr$, "=") + 1)
	
		SELECT CASE LCASE$(label$)
		CASE "sprites"
			text.sprites% = VAL(value$)
	
		CASE "colored"
			text.colored% = VAL(value$)

		CASE "font"
			text.font$ = value$
	
		CASE "scale"
			text.scale% = VAL(value$)
	
		END SELECT
	
	LOOP
	CLOSE #filemode%

END SUB

DEFINT A-Z
SUB loadwin ()
	filemode% = FREEFILE
	OPEN ".\RES\config\" + sync_name( "file_win", config_table() ) FOR INPUT AS #filemode%

	IF NOT (EOF(filemode%)) THEN
		INPUT #filemode%, range%
		REDIM win(-range% TO 2 * range%)
	END IF

	ttt% = 0
	DO WHILE NOT (EOF(filemode%)) AND ttt% <= range%
	
		LINE INPUT #filemode%, rr$

		win(1 + (ttt% - 1) * 2) = VAL(LEFT$(rr$, INSTR(1, rr$, ",") - 1))
		win(2 + (ttt% - 1) * 2) = VAL(MID$(rr$, INSTR(1, rr$, ",") + 1))
	
		IF ttt% = range% THEN
			EXIT DO
		END IF

		ttt% = ttt% + 1

	LOOP

	CLOSE #filemode%

END SUB

SUB logoput (yy1%, xx1%, ss1$)
	SELECT CASE LEN(ss1$)
	CASE 11
		
		dim ta(0 to 56 * 56 + 5) as integer

		'dim as fb.image ptr timg

		ss2$ = ss1$ + "y"  
		'timg = loadbsv( "RES\LOGOS\" + ss2$,4)
		'PUT ((xx1% - 1) * 8, (yy1% - 1) * 8), timg, AND
		'imagedestroy timg
		
		ss3$ = ss1$ + "x"
		'timg = loadbsv( "RES\LOGOS\" + ss3$,4)
		'PUT ((xx1% - 1) * 8, (yy1% - 1) * 8), timg, OR
		'imagedestroy timg
		
	CASE ELSE
		LOCATE yy1% + 1, xx1% + 1: PRINT ".";
	END SELECT
REM''END IF

END SUB

DEFSNG A-Z
SUB MouseDriver (ax%, bx%, cx%, dx%)
		exit sub
		
		'DEF SEG = VARSEG(Mouse$)
		'Mouse% = SADD(Mouse$)
		'CALL Absolute(ax%, bx%, cx%, dx%, Mouse%)
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

DEFINT A-Z
SUB renderframe ( Dest as any ptr, framex1!, framey1!, framex2!, framey2!, framec1% = 12, framec2% = 4, bg1% = 0, bg2% = 8)
	
	dim as ulongint framex3 = 0, framey3 = 0
	dim as ulongint o = 0, px = 0
	
	dim as ulongint fx1 = ( fix( framex1! ) - 2 ) * 8 + 7
	dim as ulongint fy1 = ( fix( framey1! ) - 1 ) * 8 + 7
	
	dim as ulongint fx2 = ( fix( framex2! ) - 1 ) * 8
	dim as ulongint fy2 = ( fix( framey2! ) - 1 ) * 8
	
	dim as ulongint fxs = ( fx2 - fx1 ), fys = ( fy2 - fy1 )

	dim as ulongint fx3 = 0, fy3 = 0
	
	for o = 0 to fxs * fys - 1 step 1
		
		fx3 = o mod fxs
		fy3 = fix( o / fxs )
		
		if ( fx3 and 1 ) xor ( fy3 and 1 ) then
			if bg1% >= 0 then
				pset Dest, ( fx3 + fx1, fy3 + fy1 ), bg1%
			end if
		else
			if bg2% >= 0 then
				pset Dest, ( fx3 + fx1, fy3 + fy1 ), bg2%
			end if
		end if
		
	next o
	
	'LINE ((framex1! - 2) * 8 + 7, (framey1! - 1) * 8 + 7)-((framex2! - 1) * 8, (framey2! - 1) * 8), 0, BF
	
	LINE Dest, ((framex1! - 2) * 8 + 7, (framey1! - 1) * 8 + 5)-((framex2! - 1) * 8, (framey2! - 1) * 8 + 2), framec1%, B
	LINE Dest, ((framex1! - 2) * 8 + 5, (framey1! - 1) * 8 + 7)-((framex2! - 1) * 8 + 2, (framey2! - 1) * 8), framec1%, B
	LINE Dest, ((framex1! - 2) * 8 + 6, (framey1! - 1) * 8 + 6)-((framex2! - 1) * 8 + 1, (framey2! - 1) * 8 + 1), framec2%, B
	
	PSET Dest, ((framex1! - 2) * 8 + 6, (framey1! - 1) * 8 + 6), framec1%
	PSET Dest, ((framex2! - 1) * 8 + 1, (framey2! - 1) * 8 + 1), framec1%
	PSET Dest, ((framex1! - 2) * 8 + 6, (framey2! - 1) * 8 + 1), framec1%
	PSET Dest, ((framex2! - 1) * 8 + 1, (framey1! - 1) * 8 + 6), framec1%
	
END SUB

SUB renderportal

	framex1! = ((-3) * 3 + 13 - 1)
	framex2! = ((4) * 3 + 13 - 1)
	framey1! = ((-3) * 3 + 13 - 1) - 1
	framey2! = ((4) * 3 + 13 - 1)
	framec1% = 1
	framec2% = 9

	renderframe Dest, framex1!, framey1!, framex2!, framey2!, framec1%, framec2%

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
		graphicput ((tty - ty) * 3 + 13 - 1), ((ttx - tx) * 3 + 13 - 1), (MID$(e$(ttx + (tty - 1) * AA, 2), 5, 4) + "____" + ".24")
		graphicput ((tty - ty) * 3 + 13 - 1), ((ttx - tx) * 3 + 13 - 1), (MID$(e$(ttx + (tty - 1) * AA, 2), 1, 4) + MID$(e$(ttx + (tty - 1) * AA, 4), 1, 4) + ".24")
		temptx = tx
		tempty = ty
		tx = ttx
		ty = tty
	
		fntempget
	
		tx = temptx
		ty = tempty
		IF tempaction$ = "zzzz" THEN
			graphicput ((tty - ty) * 3 + 13 - 1), ((ttx - tx) * 3 + 13 - 1), ("zzzz____.24")
		END IF
	NEXT tty
	NEXT ttx
	FOR ttx = dx1 TO dx2
	FOR tty = dy1 TO dy2
		temptx = tx
		tempty = ty
		tx = ttx
		ty = tty
		fntempget
		tx = temptx
		ty = tempty
		IF tempaction$ = "grpl" OR tempaction$ = "rapl" THEN
			IF tempdis > 0 THEN
					tempy1! = (tty - ty) * 3 + 13 - 1
					tempx1! = (ttx - tx) * 3 + 13 - 1
					tempy2! = (tty - ty + da(tempd, 2) * tempdis) * 3 + 13 - 1
					tempx2! = (ttx - tx + da(tempd, 1) * tempdis) * 3 + 13 - 1
					PSET ((tempx1! - 1) * 8 + 12, (tempy1! - 1) * 8 + 12), 6
					LINE -((tempx2! - 1) * 8 + 12, (tempy2! - 1) * 8 + 12), 6
				FOR ts! = 0 TO tempdis STEP tempdis / 8
					tempy! = (tty - ty + da(tempd, 2) * ts!) * 3 + 13 - 1
					tempx! = (ttx - tx + da(tempd, 1) * ts!) * 3 + 13 - 1
					tt! = ts!
					IF tempdis <= 1 THEN
						tt! = ts!
					ELSE
						IF ts! < tempdis - 1 THEN
							tt! = -1
						ELSE
							tt! = ts! - tempdis + 1
						END IF
					END IF
					IF tt! >= 0 THEN
						PSET ((tempx! - 1) * 8 + 12, (tempy! - 1) * 8 + 12 - tt!), 7
						PSET ((tempx! - 1) * 8 + 12 + tt!, (tempy! - 1) * 8 + 12), 7
						PSET ((tempx! - 1) * 8 + 12, (tempy! - 1) * 8 + 12 + tt!), 7
						PSET ((tempx! - 1) * 8 + 12 - tt!, (tempy! - 1) * 8 + 12), 7
					END IF
				NEXT ts!
			END IF
		END IF
	NEXT tty
	NEXT ttx

END SUB

SUB resconfig (filename$, config_table( Any, Any ) as string )

	load_names( "res\config\" + filenames$, config_table() )
	windowtitle sync_name( "window_title", config_table() )
	debugmode = ( val( sync_name( "file_text", config_table() ) ) = 0 ) = 0

END SUB

DEFSNG A-Z
SUB splash (filename$, colstart%, rowstart%, lineskip%, fg%, bg%)
	row = rowstart%
	col = colstart%
	filemode% = FREEFILE
	OPEN ".\res\splash\" + filename$ FOR INPUT AS #filemode%
		DO WHILE NOT (EOF(filemode%))
			LINE INPUT #filemode%, rr$
			LOCATE row, col
			text Dest, (row + 0), (col + 0),  rr$, fg%, textfg%, textbg%
			row = row + lineskip%
			IF row > 25 THEN
				row = rowstart%
				suspend TIMER, .2
			END IF
		LOOP
	CLOSE #filemode%
END SUB

SUB splashchat (filename$, colstart%, rowstart%, lineskip%, fg%, bg%)

	row = rowstart%
	col = colstart%
	filemode% = FREEFILE
	OPEN ".\res\talk\" + filename$ FOR INPUT AS #filemode%
	
	speaker$ = ""
	
	IF NOT (EOF(filemode%)) THEN
			LINE INPUT #filemode%, rr$
			IF LEFT$(rr$, 1) = "@" AND RIGHT$(rr$, 1) = ":" THEN
				speaker$ = MID$(rr$, 2, LEN(rr$) - 2)
			END IF
	END IF
	
	IF LEN(speaker$) > 0 THEN
		text Dest, (row + 0), (col + 0),  speaker$, 15, textfg%, textbg%
		row = row + lineskip%
		IF row > 25 THEN
			row = rowstart%
			suspend TIMER, .2
		END IF
	END IF
	
	DO WHILE NOT (EOF(filemode%))
		LINE INPUT #filemode%, rr$
		
		LOCATE row, col
		text Dest, (row + 0), (col + 0),  rr$, fg%, textfg%, textbg%
		
		row = row + lineskip%
		IF row > 25 THEN
			row = rowstart%
			suspend TIMER, .2
		END IF
	
	LOOP
	
	CLOSE #filemode%
END SUB

DEFINT A-Z
SUB suspend (start!, delay)

		screencopy 1, 3
		cinput
		cursorput

		screen_scaler 1, 0
		screencopy 3, 1

END SUB

SUB fntempget()

	tempd = CVL(MID$(e$(tx + (ty - 1) * AA, 3), 1, 4))
	tempaction$ = MID$(e$(tx + (ty - 1) * AA, 3), 5, 4)
	tempdis = CVL(MID$(e$(tx + (ty - 1) * AA, 3), 9, 4))

END SUB

DEFSNG A-Z
SUB fntempput()

	MID$(e$(tx + (ty - 1) * AA, 3), 1, 4) = MKL$(tempd)
	MID$(e$(tx + (ty - 1) * AA, 3), 5, 4) = tempaction$
	MID$(e$(tx + (ty - 1) * AA, 3), 9, 4) = MKL$(tempdis)

END SUB

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

function loadfile$( ss$ )
	
	filemode% = freefile
	
	open ss$ for binary as #filemode%
	
	r$ = string( lof( filemode% ), 0 )
	
	get #filemode, 1, r$
	
	close #filemode%
	
	loadfile$ = r$
	
end function

sub placeholder( xx as integer = 0, yy as integer = 0, filename as string = "" )
	
	dim as integer xx0 = 0, yy0 = 0, x2 = 0, y2 = 0
	dim as string filename2 = ""
	
	xx0 = ( xx - 1 ) * 8
	yy0 = ( yy - 1 ) * 8

	filename2 = just_cardname( filename )
	
	line ( xx0, yy0 )-( xx0 + 23, yy0 + 23 ), 12, b
	
	text Dest, yy + 1, (xx+0), "{{" + left$( filename2, 4 ) + "}}", 0, 15, 0, -2
	text Dest, yy + 2, (xx+0), mid$( filename2, 5, 4 ), 0, 15, 0, -2
	
end sub

sub pset_placeholder_op( x as integer,y as integer, px as integer, op as string)
		
	select case fix(rnd(1)*100)
	case 0 to 19
		px = 0
	case 20 to 60
		px = 8
	case 61 to 95
		select case fix(rnd(1)*10)
		case 0 to 6
			px = 7
		case 7 to 9
			px = 8
		end select
	case 96 to 99
		px = 7
	end select	
	
	select case op
	case "pset"
		pset ( x, y ), px
	case "and"
		pset ( x, y ), px and point( x, y )
	case "or"
		pset ( x, y ), px or point( x, y )
	case "xor"
		pset ( x, y ), px xor point( x, y )
	case else
	end select

end sub

sub screen_scaler( srcpage as integer = 1, destpage as integer = 7 )
	
	redim as integer src( 0 to 319, 0 to 199)
	redim as integer dest( 0 to 639, 0 to 479)
		
	screenset srcpage, 0

	for y = 0 to ubound( src, 2 ) step 1
	for x = 0 to ubound( src, 1 ) step 1
		
		src( x, y ) = point( x, y )
		
	next x
	next y
	
	for y = 0 to ubound( dest, 2 ) step 1
	for x = 0 to ubound( dest, 1 ) step 1
		
		x2 = ( x * ubound( src, 1 ) ) / ubound( dest, 1 )
		y2 = ( y * ubound( src, 2 ) ) / ubound( dest, 2 )
		
		dest( x, y ) = src( x2, y2 )
		
	next x
	next y
	
	screenset destpage, 0
	
	for y = 0 to ubound( dest, 2 ) step 1
	for x = 0 to ubound( dest, 1 ) step 1
		
		pset ( x, y ), dest( x, y )
		
	next x
	next y
	
	screenset srcpage, 0
	screencopy destpage, srcpage
	screencopy srcpage, 0
	
end sub

function As_Binary( value as string ) as integer

	dim as integer o = 0, ret = 0

	for o = len(value) to 1 step -1
		ret = ( ret shl 8 ) or asc( mid$( value, o, 1 ) )
	next o
		
	As_Binary = ret

end function

sub statput( staty as integer = 0, statx as integer = 0, stat as string = "HP", cur as integer = 0, max as integer = 0, fg% = 15, bg% = 0 )

	text Dest, ( staty + 0 ), (statx + 0),  stat, 0, textfg%, textbg%

	dim as string s2 = string$(0,0)

	text Dest, ( staty + 0 ), (statx + 0),  stat, 0, textfg%, textbg%

	s2 = ltrim$(str$(cur))
	s2 = string( len( s2 ) - 4, 32 ) + s2

	text Dest, ( staty + 0 ), (statx + 0) + 4, s2, 0, textfg%, textbg%
	text Dest, ( staty + 0 ), (statx + 0) + 9, "/", 0, textfg%, textbg%

	s2 = ltrim$(str$(max))
	s2 = string( len( s2 ) - 4, 32 ) + s2

	text Dest, ( ( staty + 0 ) + 0 ), (statx + 0) + 11, s2, 0, textfg%, textbg%
	
end sub


sub inventory ( y as integer, x as integer, menu as string )

	dim as integer o = 0, xx = 0, yy = 0
	dim as string iname = string( 0, 0 )
	dim as single icost = 0.0
	for o = 0 to fix( len( menu ) / 8 ) - 1 step 1
		
		xx = ( o mod 5 ) * 3
		yy = fix( o / 5 ) * 3
				
		menu_value menu, o, iname, icost
		
		graphicput y + yy, x + xx, iname + string$( 4, "_" ) + "." + "24", 0

		text Dest, y + yy + 0, x + xx, "{{" + iname + "}}", 0, 15, 0, -2
		
		if icost > 0.0 then
			text Dest, y + yy + 2, x + xx, right$( string$( 4, 32 ) + ltrim$( str$( fix( icost ) ) ), 4 ), 0, 15, 0, -2
		end if
		
	next o
	
end sub

sub inventory_click ( menu as string = "", byref o as integer = -1 )
	
	dim as integer o2 = 0
	
	for o2 = 0 to fix( len( menu ) / 8 ) - 1 step 1				
		
		'iname = mid$( menu, o2 * 8 + 1, 4 )
		'icost = fix( CVL( mid$( menu, o2 * 8 + 5, 4 ) ) )

		menu_value menu, o2, iname, icost
		
		if lcase( c$ ) = iname then
			o = o2
			exit sub
		end if
	next o2
	
	o = -1
	
end sub

sub menu_value( menu as string = "cncl", o as integer = 0, byref item as string = "", byref cost as single = 0.0 )
	
	if o * 8 + 8 > len( menu ) then
		item = string$( 4, "_" )
		cost = 0.0
		exit sub
	end if
		
	item = mid$( menu, o * 8 + 1, 4 )
	cost = fix( CVL( mid$( menu, o * 8 + 5, 4 ) ) )
	
end sub

function load_sprite( img As Any Ptr, filename as string = "" ) as string
	
	dim c as string =  string$( 0, 0 )
	dim as integer z = 0, w = 0, h = 0
	dim as integer y = 0, b = 0
	dim as integer filemode = freefile
	dim as string header = string$( 0, 0 ), buffer = string$( 0, 0 )
	
	dim as string ret = string$( 0, 0 )
	
	'ret += "filename:"+chr$(34)+filename+chr$(34)+chr$(13)+chr$(10)
	
	if open( filename for binary as #filemode ) then
		
		'text Dest, 1, 1, filename, 0, 14, 6, -2
		
		close #filemode
		img = imagecreate( 24, 24, 0, 8 )
		
		'for offset = 0 to 5
		'
		'	line img,( offest, 0 )-( 23-offset, 23 ),12
		'	line img,( 23-offest, 0 )-( offset, 23 ),12
		'	
		'next offset
		
		for offset = 0 to 5
		
			select case offset and 1
			case 0
				line img,( 5-offset, 0 )-( 23-offset, 23 ),12,,&HAAAA
			case 1
				line img,( 23-offset, 0 )-( 5-offset, 23 ),12,,&HAAAA
			end select
			
		next offset
		
		load_sprite = ret
		'print ret
		exit function
	
	else
		buffer = string$( lof( filemode ), 0 )
		get #filemode, 1, buffer
		close #filemode
		
	end if
				
	header = left$( buffer, 11 )
	buffer = mid$( buffer, len( header ) + 1 )

				c = left$( header, 1 )
				
	if asc(c) <> &HFD then
		load_sprite = ret
		exit function
	end if

	z = cvshort( mid$( header, 6 , 2 ) ) and 32767
	w = cvshort( mid$( header, 8 , 2 ) ) and 32767
	h = cvshort( mid$( header, 10 , 2 ) ) and 32767
	
	'ret += "h:"+str$(len(header))+chr$(13)+chr$(10)
	'ret += "b:"+str$(len(buffer))+chr$(13)+chr$(10)
	'ret += "z:"+str$(z)+chr$(13)+chr$(10)
	'ret += "w:"+str$(w)+chr$(13)+chr$(10)
	'ret += "h:"+str$(h)+chr$(13)+chr$(10)

				img = imagecreate( w, h, 0, 8 )
		
	for y = 0 to h - 1 step 1
								for b = 0 to 3 step 1
											 putplane img, y, w, 2 ^ b, buffer
								next b
				next y
			
	'line img,( 0, 0 )-( 23, 23 ),2
	'line img,( 0, 23 )-( 23, 0 ),2
		
		'for offset = 0 to 5
		'
		'	select case offset and 1
		'	case 0
		'		line img,( 5-offset, 0 )-( 23-offset, 23 ),12,,&HAAAA
		'	case 1
		'		line img,( 23-offset, 0 )-( 5-offset, 23 ),12,,&HAAAA
		'	end select
		'	
		'next offset


	load_sprite = ret
	
	'print ret
	'flip
	'while inkey$="":wend
	
	exit function
	
end function

sub putplane (img As Any Ptr, y as integer, w as integer, bb as integer, byref buffer as string )

				dim c as string = string$( 1, 0 ), cb as integer
				dim x as integer
				c = " "

				for x = 0 to w - 1 step 1
								if (x and 7) = 0 then
			c = left$( buffer, 1 )
			cb = asc(c)
			buffer = mid$( buffer, 2 )
		end if

								pset img, (x, y), point(x, y, img) xor (bb and -cb \ 128)

								cb = cb + cb and &HFF
				next x

end sub

function ord_series( subject as string = "" ) as integer
	
	dim as integer offset = 0, result = 0
	
	for offset = 1 to len(subject) step 1
		result = ( result shl 8 ) or asc( mid$( subject, offset, 1 ) )
	next offset
	
	ord_series = result
	
end function

sub sprite_put( dest As Any Ptr, x as integer, y as integer, filename as string = "", op as string = "xor" )
	
	Dim As Any Ptr img

	if len( filenmae ) = 0 then
		text Dest, (y+0),(x+0),"bad",0,14,6,-2
		exit sub
	end if

	load_sprite img, filename
	
	dim as integer xx = ( x - 1 ) * 8, yy = ( y - 1 ) * 8
	
	select case dest
	case 0
		select case op
		case "xor"
			put ( xx, yy ), img, xor
		case "or"
			put ( xx, yy ), img, or
		case "and"
			put ( xx, yy ), img, and
		case "pset"
			put ( xx, yy ), img, pset
		case "preset"
			put ( xx, yy ), img, preset
		end select
	case else
		select case op
		case "xor"
			put dest, ( xx, yy ), img, xor
		case "or"
			put dest, ( xx, yy ), img, or
		case "and"
			put dest, ( xx, yy ), img, and
		case "pset"
			put dest, ( xx, yy ), img, pset
		case "preset"
			put dest, ( xx, yy ), img, preset
		end select
	end select
	
	imagedestroy img

	exit sub

	if debugmode then
		text Dest, 20,1, "justcard:" + chr$( 34 ) + left$( just_cardname( filename ), 4 ) + chr$( 34 ), 0, 12, 0, -2
	end if
	
	sync_gfx "", left$( just_cardname( filename ), 4 )

	if debugmode then
		text Dest, 22,1, _
			"filename:" + chr$( 34 ) + filename + chr$( 34 ), 0, 12, 0
	end if
		
end sub

sub sync_gfx( filename as string, lookup as string = "" )
	
	dim filemode as integer = freefile, e = 0, miss = 0, hit = 0

	dim as string r = "", label = "", value = "", temp = "", card = ""

	if len( filename ) = 0 then
		filename = "res\config\binding.cfg"
	end if

	if len(sync_data) = 0 then

		e = open( filename for input as #filemode )
	
		if e then
			exit sub
		end if
		
		sync_data = string$( lof( filemode ), 0 )
		
		get #filemode, 1, sync_data
		
	end if
	
	load_binding_options lookup
	
end sub

sub sync_refresh( filename as string = "", sync_dat as string = "" )
	
	dim filemode as integer = freefile, e = 0

	if len( filename ) = 0 then
		filename = "res\config\names.dat"
	end if

	if len( sync_dat ) = 0 then

		e = open( filename for input as #filemode )
	
		if e then
			exit sub
		end if
		
		sync_dat = string$( lof( filemode ), 0 )
		
		get #filemode, 1, sync_dat
		
	end if
	
end sub


sub load_binding_options( lookup1 as string = "" )
	
	
	dim as integer hit = 0

	dim as string r_sync = "", r = "", label = "", value = "", temp = "", card = "", lookup = ""

	lookup = left$( just_cardname( lookup1 ), 4 )
	
	if len( card ) = 0 then
		card = "blnk"
	end if
	
	r_sync = sync_data + chr$( 13 ) + chr$( 10 )
	
	do while not( eof( filemode ) ) and hit = 0
		
		r = left$( r_sync , instr( 1, r_sync , chr$( 13 ) + chr$( 10 ) ) - 1 )
		
		r_sync = mid$( r_sync , instr( 1, r_sync ,  chr$( 13 ) + chr$( 10 ) ) + 2 )
		
		card = left$( r, instr( 1, r, ":" ) - 1 )
		
		r = mid$( r, instr( 1, r, ":" ) + 1 )
	
		hit += 1
		
		if lcase$( card ) = lcase$( lookup ) then
			
			r += ",END"
			do while instr( 1, r, "," ) > 0
				
				temp = left$( r, instr( 1, r, "," ) - 1 )
				r = mid$( r, instr( 1, r, "," ) + 1 )
				
				if r = "END" then
					miss += 1
					exit do
				end if
				
				label = left$( temp, instr( 1, r, "=" ) - 1 )
				value = mid$( temp, instr( 1, r, "=" ) + 1 )
				
				select case lcase$( label )
				case "placeholder"
					bindcfg.placeholder_option = val( value )
					hit += 1
				case "hidden"
					bindcfg.hidden_option = val( value )
					hit += 1
				case "keybind"
					bindcfg.keybind_option = val( value )
					hit += 1
				case "sprite"
					bindcfg.sprite_option = val( value )
					hit += 1
				end select
				
			loop
		end if
		
		if miss = -1 then
			exit do
		end if
	loop
	
	if hit = 0 then
		bindcfg.hidden_option = 0
		bindcfg.placeholder_option = 1
		bindcfg.keybind_option = 1
		bindcfg.sprite_option = 1
	end if
	
	if debugmode then
		text Dest, 24,1, _
		ltrim$(str$(bindcfg.hidden_option)) + "," + _
		ltrim$(str$(bindcfg.placeholder_option)) + "," + _
		ltrim$(str$(bindcfg.keybind_option)) + "," + _
		ltrim$(str$(bindcfg.sprite_option)), 0, 12, 0
	end if
	
end sub

function just_cardname( filename as string ) as string
	
	dim as string filename2 = filename
	
	do while instr( 1, filename2, "\" ) > 0
		filename2 = mid$(filename2, instr( 1, filename2, "\" ) + 1 )
	loop

	do while instr( 1, filename2, "." ) > 0
		filename2 = left$(filename2, instr( 1, filename2, "." ) - 1 )
	loop	

	just_cardname = filename2

end function

function sync_name( lookup as string = "", table( Any, Any) as string ) as string

	dim as integer o = 0
	for o = lbound( table, 1 ) to ubound( table, 1 ) step 1
		if lcase$( lookup ) = lcase$( table( o, 0 ) ) then
			sync_name = table( o, 1 )
			exit function
		end if
	next o
	
	sync_name = string$( 0, 0 )
	exit function
	
end function

sub load_names( filename as string = "", table( Any, Any) as string )
	
	dim as string label = "", value = "", r = ""
	
	dim as integer filemode = freefile
	
	e=open(filename for input as #filemode)
	if e then
		close #filemode
		exit sub
	end if
	
	do while not( eof( filemode ) )
		
		line input #filemode, r
		
		if instr( 1, r, "=" ) > 0 then

			if ubound(table,0) = 0 then
				redim table( 0 to 0 , 0 to 1)

			else
				redim preserve table( 0 to ubound( table, 1 ) + 1, 0 to 1 )

			end if
		
			label = left$( r, instr( 1, r, "=" ) - 1 )

			value = mid$( r, instr( 1, r, "=" ) + 1 )

			table( ubound( table, 1 ), 0 ) = label

			table( ubound( table, 1 ), 1 ) = value

		end if
		
	loop
		
end sub

sub ellipse( Dest as any ptr = 0, x1 as integer = 32, y1 as integer = 32, x2 as integer = 128, y2 as integer = 128, fg as integer = 12, bitflip as integer = 0, lo as single = 0, hi as single = 1 )
	
	dim as single px = 0, py = 0
	
	for py = y1 to y2 step 1
	for px = x1 to x2 step 1
		
		if ellipsecheck( x1, y1, x2, y2, px, py, bitflip, lo, hi ) then
			if ( Dest = 0 ) = 0 then
				pset Dest, ( px, py ), fg
			else
				pset ( px, py ), fg
			end if
		else
			'pset Dest, ( px, py ), fg xor &H10
		end if
		
	next px
	next py
end sub

function ellipsecheck( x1 as integer = 32, y1 as integer = 32, x2 as integer = 128, y2 as integer = 128, px as single = 0, py as single = 0, bitflip as integer = 0, lo as single = 0, hi as single = 1 )
	
	dim as single x0 = 0, y0 = 0
	
	x0 = px - (x2 - x1) / 2
	y0 = py - (y2 - y1) / 2
	dim d as single = (x0-x1)^2/((x2-x1)/2)^2 + (y0-y1)^2/((y2-y1)/2)^2
	
	dim as integer dither = ( ( ( px xor py ) and 1 )  = 1 )
	
	if dither then
		if d >= lo and d <= hi then
	ellipsecheck = 1 xor bitflip
		else
	ellipsecheck = 0 xor bitflip
		end if
	end if
	
end function

sub quitoutro( Dest as any ptr )
	
	IF c$ = sync_name( "quit", names_table() ) THEN
		
		c$ = string$( 0, 0 )
		
		dim as double timerstart = timer
		
		screenset 1, 0
		color 15, 0
		cls
		
		dim as integer index = 0

		dim as string outro = "Goodnight Sweet Prince.."
		outro = string$( 2 + len(outro) * .325 , 32 ) + outro + string$( 2, 32 )
		
		redim as any ptr outroimage( any )
		redim as integer outro_w( any )
		redim as integer outro_h( any )
		
		redim outroimage( 0 to 1 )

		for index = lbound( outroimage, 1 ) to ubound( outroimage, 1 ) step 1
			imagedestroy outroimage( index )
		next index
		
		outroimage( 0 ) = imagecreate( len( outro ) * 8, 8, 0, 8)

		text outroimage( 0 ), 1, 1, outro, 0,13, 5, -2
		
		outroimage( 1 ) = imagecreate( 640, 32, 0, 8 )
		
		redim outro_w( lbound( outroimage, 1 ) to ubound( outroimage, 1 ) )
		redim outro_h( lbound( outroimage, 1 ) to ubound( outroimage, 1 ) )
		
		for index = lbound( outroimage, 1 ) to ubound( outroimage, 1 ) step 1
			imageinfo outroimage( index ), outro_w( index ), outro_h( index )
		next index

		region_scaler outroimage()
					
		put Dest, ( 319 - outro_w( 1 ) / 2, 239 - outro_h( 1 ) / 2 ), outroimage( 1 ), pset
		screencopy 1,0

		timerstart = timer
		do while ( len( c$ ) = 0 ) and ( timer - timerstart < 5.35 )
			c$ = inkey
		loop
		
		END

	END IF
	
END SUB

function image_scaler( source as any ptr, dest_w as integer = 24, dest_h as integer = 24 ) as any ptr
	
	dim as single rsng = 0.0, rrsng = 0.0
	dim as string rstr = "", rrstr = "", texts = ""
	dim as integer col = 0, row = 0
	redim as any ptr img( any )
	redim img( 0 to 8 )

	redim as integer w( any ), h ( any )
	redim w( 0 to 8 ), h ( 0 to 8 )
	
	imageinfo source, w(0), h(0)
	
	if w( 0 ) = 25 and h( 0 ) = 25 then
		img( 1 ) = imagecreate( 24, 24, 0, 8 )
		put img( 1 ), ( 0, 0 ), source, pset	
	else
		img( 1 ) = imagecreate( w(0), h(0), 0, 8 )
		put img(1), ( 0, 0 ), source, pset
	end if

	img( 8 ) = imagecreate( dest_w, dest_h, 0, 8 )	
	
	imageinfo img( 1 ) , w(1), h(1)		
	imageinfo img( 8 ) , w(8), h(8)
	
	get source, ( 0, 0 ) - ( w( 1 ) - 1, h( 1 ) - 1 ), img( 1 )

	for y = 0 to  h( 8 ) - 1 step 1
	for x = 0 to  w( 8 ) - 1 step 1
		
		x2 = ( x * ( w( 1 ) - 1 ) ) / ( w( 8 ) - 1 )
		y2 = ( y * ( h( 1 ) - 1 ) ) / ( h( 8 ) - 1 )
		
		pset img( 8 ), ( x, y ),  point( x2, y2, img( 1 ) )
		
	next x
	next y
		
	imagedestroy img( 1 )
	
	image_scaler = img( 8 )
	
end function

sub region_scaler( img( Any ) as any ptr )
	
	if ( lbound( img, 1 ) <= 0 and ubound( img, 1 ) >= 1 ) = 0 then
		exit sub
	end if
	
	dim as integer index = 0, x = 0, y = 0
	
	redim as integer w( lbound( img, 1 ) to ubound( img, 1 ) ), h ( lbound( img, 1 ) to ubound( img, 1 ) )
	
	for index = lbound( img, 1 ) to ubound( img, 1 ) step 1
		imageinfo img( index ), w( index ), h( index )
	next 
	
	for y = 0 to  h( 1 ) - 1 step 1
	for x = 0 to  w( 1 ) - 1 step 1
		
		x2 = ( x * ( w( 0 ) - 1 ) ) / ( w( 1 ) - 1 )
		y2 = ( y * ( h( 0 ) - 1 ) ) / ( h( 1 ) - 1 )
		
		
		pset img( 1 ), ( x, y ),  point( x2, y2, img( 0 ) )
		
	next x
	next y
	
end sub

function ucword( subject as string ) as string
	dim as integer o = 0
	
	subject = lcase$( subject )
	
	for o = 1 to len( subject ) step 1
	
		if o = 1 or mid$(subject, o - 1, 1 ) = string$( 1, 32 ) then
			mid$( subject, o ,1 ) = ucase$( mid$( subject, o ,1 ) )
		end if
	
	next o
	
	ucword = subject 
	exit function
	
end function

sub cute_clicks( Dest as any ptr, x as integer = -1, y as integer = -1, fg as integer = 15, bg as integer = 3)
	dim as integer index = 0
	for index = lbound( clickli, 1 ) to ubound( clickli, 1 ) step 1
		color fg,bg
		locate x+15, y + index
		print str$( index ) + ":" + quot + clickli( index ).label + quot
	next index
end sub

sub cute_text( Dest as any ptr, subject as string = "", byref x as integer = -1, byref y as integer = -1, fg as integer = 15, bg as integer = 0, wipe_clicks as integer = 0, spacing = -2 )
	
	if ( wipe_clicks = 0 ) = 0 then
		clicks% = 0
		redim clickli( 0 to clicks% )	
	end if
	
	dim as integer o = 0
	
	dim as string bind_open = "{{", bind_close = "}}"
	
	'locate ( y / 8 ) + 1, ( x / 8 ) + 1
	'color fg, bg
	'print quot + subject + quot

	do		
		open_offset = instr( 1, subject, bind_open )
		close_offset = instr( open_offset + len( bind_open ), subject, bind_close )
		
		if ( open_offset > 0 ) and ( close_offset >= open_offset + len( bind_open ) ) then
			
			if ubound( clickli, 1 ) = 0 then
				clicks% = 0
				redim clickli( 0 to 0 )
			else
				clicks% = ubound( clickli, 1 ) + 1	
				redim preserve clickli( 0 to clicks% )
			end if
			
			clickli( clicks% ).label = mid$( subject, open_offset + len( bind_close_open ) )
			clickli( clicks% ).label = left$( clickli( clicks% ).label, close_offset - open_offset )
			
			clickli( clicks% ).col = x + ( open_offset - len( bind_open ) ) * ( 8 + spacing )
			
			clickli( clicks% ).row = y

			subject = left$( subject, open_offset - 1 ) + clickli( clicks% ).label + mid$( subject, close_offset + len( bind_close ) )
						
		else
			exit do
		end if
	loop
	
	for o = len( subject ) to o step -1
		draw string ( x + o * ( 8 + spacing ), y - 1 ), str$( ubound( clickli, 1 ) ), bg
		draw string ( x + o * ( 8 + spacing ) + 1, y ), str$( ubound( clickli, 1 ) ), bg
		draw string ( x + o * ( 8 + spacing ), y + 1 ), str$( ubound( clickli, 1 ) ), bg
		draw string ( x + o * ( 8 + spacing ) - 1, y ), str$( ubound( clickli, 1 ) ), bg

		draw string ( x + o * ( 8 + spacing ), y ), str$( ubound( clickli, 1 ) ), fg
	
	next o
	
end sub

sub cute_splash( Dest as any ptr, buffer as string = "" )
	
	dim as integer x = 1, y = 1, fg = 11, bg = 3, wipe = 0, spacing = -2
	
	dim as integer filemode = 0
	dim as string extension = "", subject = "", filename = ""
	
	do
		o = instr( 1, buffer, crlf )
		if o > 0 then
			subject = left$( buffer, o )
			buffer = mid$( buffer, o + len( crlf ) )
		else
			subject = buffer
			buffer = string$( 0, 0 )
		end if

		select case left$( subject, 2 )
		case "@ "
			filename = mid$( subject, len( "@ " ) + 1 )
			filemode = freefile
			if open( filename for binary as #filemode) then
				close #filemode
			else
				extension = string$( lof( filemode ), 0 )
				get #filemode, 1, extension
				buffer = extension + crlf + buffer
				close #filemode
			end if
			subject = string$( 0, 0 )
		case "þ "
			select case mid$( subject, 3, instr( 4, subject, string$( 1, 32 ) ) )
			case "COLOR"
				fg = val( mid$( subject, len( "þ "+"COLOR" + " " ) + 1 ) )
			case else
				select case mid$( subject, 3 )
				case "page start"
					'buffer = "@ res\splash\" + sync_name( "file_title", config_table() )
				case "page end"
					suspend timer, 0
					y = 0
				case "end"
					suspend timer, 0
					exit do
				end select
			end select
			subject = string$( 0, 0 )
		case else
			x = 8
			y += 8
			if y > 320 then
				suspend timer, 0
				line( 0, 0 )-( 319, 199 ), 1, bf
				y = 0
			end if
			
			cute_text Dest, subject, x, y, fg, bg, wipe, spacing
		end select

	loop until ( len( buffer ) = 0 ) or ( c$ = sync_name( "quit", names_table() ) )
	
	suspend timer, 0

end sub
