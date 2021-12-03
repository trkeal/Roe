
#lang "fb"

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

screenres 640,480,8,8
screenset 1,0

