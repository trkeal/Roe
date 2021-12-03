
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
Const Pi = 4 * ATN(1)

dim shared as any ptr Dest

const crlf = chr$( 13 ) + chr$ ( 10 )
const quot = chr$( 34 )
const eq = "="

declare SUB suspend (start!, delay)

type clicktype
	label as string
	col as longint
	row as longint
end type

dim shared clicks as integer
REDIM SHARED as clicktype clickli( Any )

dim shared as string sync_data
sync_data = string$( 0, 0 )

#include once "bas\names.bas"
#include once "bas\head.bas"
#include once "bas\inbounds.bas"
#include once "bas\screen scaler.bas"
#include once "bas\cute text.bas"
#include once "bas\graphic put.bas"
#include once "bas\portal frame.bas"
#include once "bas\bind text.bas"
#include once "bas\mouse.bas"
#include once "bas\resources.bas"
#include once "bas\sprites.bas"

DIM SHARED debugmode as longint

cute_text Dest, "{{Hello}} {{world!}}", 16, 16, 11, 3, -1, -2
suspend timer, 0

cute_clicks Dest, 1, 1, 11, 3
suspend timer, 0
