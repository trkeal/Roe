
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
 REM // Puzzlum : Realm of Existence
 REM // 2.092.019 1997.07.20 18:52gmt-07
 REM // created by Tim Keal
 REM // copyright 1990-2000 Aquarius Games
 REM //
 REM // jargon@uswest.net icq#41981241
 REM // http://realm-of-existence.net
 REM //
 REM //*

startup:
 DEFINT A-Z
 DECLARE SUB text (yy%, xx%, ss$, sp%)
 DECLARE SUB graphicput (yy1%, xx1%, ss1$)
 DECLARE SUB suspend (start!, delay)
 COMMON SHARED AA
 COMMON SHARED DD
 COMMON SHARED ex
 COMMON SHARED dy
 COMMON SHARED textrate
 COMMON SHARED textdelay
 COMMON SHARED c$
 COMMON SHARED tx
 COMMON SHARED ty
 COMMON SHARED Xmouse%
 COMMON SHARED Ymouse%
 COMMON SHARED xm%
 COMMON SHARED ym%
 COMMON SHARED XXmouse%
 COMMON SHARED YYmouse%
 COMMON SHARED lb%
 COMMON SHARED rb%
 COMMON SHARED llb%
 COMMON SHARED rrb%
 COMMON SHARED lstart%
 COMMON SHARED rstart%
 COMMON SHARED jsx
 COMMON SHARED jsy
 COMMON SHARED jsa
 COMMON SHARED jsb
 DECLARE SUB MouseDriver (AX%, bx%, CX%, dx%)
 DECLARE FUNCTION MouseInit% ()
 DECLARE SUB mouseshow ()
 DECLARE SUB mousestatus (lb%, rb%, Xmouse%, Ymouse%)
 DECLARE SUB STICKS (joy0%, joy1%, joy2%, joy3%, but0%, but1%, but2%, but3%, but4%, but5%, but6%, but7%)
 DECLARE SUB PENS (tip0%, tip1%, tip2%, tip3%, tip4%, tip5%, tip6%, tip7%, tip8%, tip9%)
 DECLARE SUB cursorput ()
 DECLARE SUB cinput ()
 COMMON SHARED win
 COMMON SHARED map$
 COMMON SHARED lvup$
 map$ = "p2092019.vds"
 lvup$ = "roe_lvup.dat"
 OPEN map$ FOR INPUT AS 1
 INPUT #1, mapname$
 INPUT #1, AA
 INPUT #1, DD
 OPEN lvup$ FOR INPUT AS 2
 DIM SHARED e$(AA * DD, 4): REM'grid identity$
 DIM SHARED g(AA * DD, 16) AS DOUBLE: REM'grid statistics
 DIM SHARED d(4, 2): REM'direction (n,e,s,w)
 DIM SHARED t(64 * 64 + 8): REM'text image
 DIM SHARED l(64): REM'level up
 d(0, 1) = 0: d(0, 2) = 0: REM'
 d(1, 1) = 0: d(1, 2) = -1: REM'north
 d(2, 1) = 1: d(2, 2) = 0: REM'east
 d(3, 1) = 0: d(3, 2) = 1: REM'south
 d(4, 1) = -1: d(4, 2) = 0: REM'west
 ex = INT(AA / 2): REM'map pointer x
 dy = INT(DD / 2): REM'map pointer y
 mdx = INT(40 / 2): REM'screen cursor x
 mdy = INT(25 / 2): REM'screen cursor y
 textrate = .01
 textdelay = 2.5: REM'''.8: REM'''.55
 win = 4
 DIM SHARED mouse$
 DIM SHARED win(-win TO 2 * win)
 RANDOMIZE TIMER
 RESTORE
 mouse$ = SPACE$(57)
 FOR I% = 1 TO 57
  READ a$
  H$ = CHR$(VAL("&H" + a$))
  MID$(mouse$, I%, 1) = H$
 NEXT I%
 DATA 55,89,E5,8B,5E,0C,8B,07,50,8B,5E,0A,8B,07,50,8B
 DATA 5E,08,8B,0F,8B,5E,06,8B,17,5B,58,1E,07,CD,33,53
 DATA 8B,5E,0C,89,07,58,8B,5E,0A,89,07,8B,5E,08,89,0F
 DATA 8B,5E,06,89,17,5D,CA,08,00
 FOR ttt = 0 TO win
  READ win(1 + (ttt - 1) * 2)
  READ win(2 + (ttt - 1) * 2)
 NEXT ttt
 DATA  1, 1
 DATA  1, 4
 DATA  1, 8
 DATA  1,12
 DATA  1,16
 MS% = MouseInit%
 IF NOT MS% THEN
  REM''PRINT "Mouse not found"
  AMOUSE$ = "NO"
 END IF
 IF MS% THEN
  REM''PRINT "Mouse found and initialized"
  AMOUSE$ = "YES"
  REM''mouseshow
 END IF
 REM'level up data
 FOR t = 0 TO 64
  INPUT #2, l(t)
 NEXT t
 CLOSE 2
 ctrl$ = "plyrimp_"
 IF INT(RND(1) * 2) + 1 = 2 THEN ctrl$ = ctrl$ + "dust"
 FOR ty = 1 TO DD
 INPUT #1, r$
 LINE INPUT #1, bg$
 LINE INPUT #1, fg$
 LINE INPUT #1, rg$
 FOR tx = 1 TO AA
  rbg$ = MID$(bg$, (tx - 1) * 5 + 1, 4)
  rfg$ = MID$(fg$, (tx - 1) * 5 + 1, 4)
  rid! = VAL(MID$(rg$, (tx - 1) * 5 + 1, 4))
  e$(tx + (ty - 1) * AA, 2) = "____" + rbg$
  e$(tx + (ty - 1) * AA, 3) = MKL$(0) + "____" + MKL$(0): REM'command$
  e$(tx + (ty - 1) * AA, 4) = "________": REM'graphicsaction$
  IF rfg$ = "____" THEN
   GOSUB prflblnk
   prflidty! = rid!
   GOSUB prflset
  END IF
  IF rfg$ = "spdr" THEN
   GOSUB prflblnk
   prflidty$ = "Spider"
   prflactn$ = "movebiteweb_"
   prflgpic$ = "spdr"
   prflidty! = rid!
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
   SELECT CASE mapname$
   CASE "0001"
    IF prflidty! = 1 THEN
     prflactn$ = prflactn$ + "vnom"
    END IF
   END SELECT
   GOSUB prflset
  END IF
  IF rfg$ = "wall" THEN
   GOSUB prflblnk
   prflidty$ = "wall"
   prflgpic$ = "wall"
   prflidty! = 2
   GOSUB prflset
  END IF
  IF rfg$ = "web_" THEN
   GOSUB prflblnk
   prflidty$ = "Web"
   prflactn$ = "spdr"
   prflgpic$ = "web_"
   prflidty! = rid!
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
  END IF
  IF rfg$ = "grml" THEN
   GOSUB prflblnk
   prflidty$ = "Gremlin"
   prflactn$ = "movebitepnch"
   IF RND(1) > .2 THEN
    prflactn$ = prflactn$ + "dggr"
   END IF
   prflgpic$ = "grml"
   prflidty! = rid!
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
  END IF
  IF rfg$ = "plyr" THEN
   GOSUB prflblnk
   prflidty$ = "Poindexter"
   prflactn$ = "wstf"
   prflgpic$ = "plyr"
   prflidty! = rid!
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
  END IF
  IF rfg$ = "dtby" THEN
   GOSUB prflblnk
   prflidty$ = "Dust Bunny"
   prflactn$ = "movebitekickdtbydust"
   prflgpic$ = "dtby"
   prflidty! = rid!
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
  END IF
  IF rfg$ = "shkt" THEN
   GOSUB prflblnk
   prflidty$ = "Shiny Knight"
   prflactn$ = "movepnchdggr"
   prflgpic$ = "shkt"
   prflidty! = rid!
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
  END IF
  IF rfg$ = "emgd" THEN
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
   prflidty! = rid!
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
  END IF
  IF rfg$ = "door" THEN
   GOSUB prflblnk
   prflidty$ = "Door"
   prflgpic$ = "door"
   IF INT(RND(1) * 2) = 1 THEN
    prflactn$ = "loc1"
   ELSE
    prflactn$ = "loc2"
   END IF
   prflidty! = rid!
   prflhp! = 140
   prflstr! = 140
   prflarmr! = 5
   prflvalu! = 1
   prfllv! = 1
   prflhpmax! = 140
   prflstrmax! = 140
   GOSUB prflset
  END IF
  IF rfg$ = "imp_" THEN
   GOSUB prflblnk
   prflidty$ = "Little Imp"
   prflactn$ = "movewingfire"
   IF INT(RND(1) * 2) + 1 = 2 THEN
    prflidty$ = "Merchant"
    prflactn$ = prflactn$ + "dggrgrplseed"
   END IF
   prflgpic$ = "imp_"
   prflidty! = rid!
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
  END IF
  IF rfg$ = "chst" THEN
   GOSUB prflblnk
   prflidty$ = "Treasure chest"
   IF INT(RND(1) * 2) = 1 THEN
    prflactn$ = "key1"
   ELSE
    prflactn$ = "key2"
   END IF
   prflgpic$ = "chst"
   prflidty! = rid!
   prflhp! = 100
   prfllv! = 1
   prflhpmax! = 100
   GOSUB prflset
  END IF
  IF rfg$ = "bldr" THEN
   GOSUB prflblnk
   prflidty$ = "Big boulder"
   prflactn$ = ""
   prflgpic$ = "bldr"
   prflidty! = rid!
   prflhp! = 1000
   prflarmr! = 10
   prfllv! = 1
   prflhpmax! = 1000
   GOSUB prflset
  END IF
 NEXT tx
 NEXT ty
 CLOSE 1
GOTO starttitle

starttitle:
 SCREEN 7, 0, 1, 0
 WIDTH 40, 25
 COLOR 15, 1
 CLS
 colr% = 15
 GOSUB title
 colr% = 11
 texts$ = " Puzzlum : Realm of Existence"
 GOSUB showtext
 texts$ = " 2.092.019 1997.07.20 18:52gmt-07"
 GOSUB showtext
 texts$ = " created by Tim Keal"
 GOSUB showtext
 texts$ = " copyright 1990-2000 Aquarius Games"
 GOSUB showtext
 texts$ = " "
 GOSUB showtext
 texts$ = " jargon@uswest.net icq#41981241"
 GOSUB showtext
 texts$ = " http://realm-of-existence.net"
 GOSUB showtext
 PRINT
 colr% = 9
 texts$ = " (H)elp"
 GOSUB showtext
 PRINT
 texts$ = " (C)ontinue"
 GOSUB showtext
 PRINT
 texts$ = " (R)estart"
 GOSUB showtext
 PRINT
 texts$ = " (Q)uit"
 GOSUB showtext
 GOSUB commandwait
 IF c$ = "r" OR c$ = "R" OR (ym% = 22 AND xm% = 3 AND lb% = -1) THEN
  GOSUB screenset
  RUN
 END IF
 IF c$ = "q" OR c$ = "Q" OR (ym% = 24 AND xm% = 3 AND lb% = -1) THEN
  GOSUB screenset
  END
 END IF
 IF c$ = "h" OR c$ = "H" OR (ym% = 18 AND xm% = 3 AND lb% = -1) THEN
  OPEN "roe92004.hlp" FOR INPUT AS 63
starthelp:
  LINE INPUT #63, r$
  IF r$ = "þ page start" THEN
   GOSUB title
   GOTO starthelp
  END IF
  IF r$ = "þ page end" THEN
   LOCATE 22, 1
   colr% = 9
   texts$ = " (C)ontinue"
   GOSUB showtext
   PRINT
   texts$ = " (T)itle"
   GOSUB showtext
continuehelp:
   GOSUB commandwait
   IF c$ = "t" OR c$ = "T" OR (ym% = 24 AND xm% = 3 AND lb% = -1) THEN
    CLOSE 63
    GOTO starttitle
   END IF
   IF NOT (c$ = "c" OR c$ = "C" OR (ym% = 22 AND xm% = 3 AND lb% = -1)) THEN
    GOTO continuehelp
   END IF
   GOTO starthelp
  END IF
  IF r$ = "þ end" THEN
   CLOSE 63
   GOTO starttitle
  END IF
  IF LEFT$(r$, 7) = "þ COLOR" THEN
   colr% = VAL(RIGHT$(r$, LEN(r$) - 7))
   GOTO starthelp
  END IF
  texts$ = r$
  IF r$ <> "" THEN
   GOSUB showtext
  ELSE
   PRINT
  END IF
  GOTO starthelp
 END IF
 IF c$ <> "c" AND c$ <> "C" AND NOT (ym% = 20 AND xm% = 3 AND lb% = -1) THEN
  GOTO starttitle
 END IF
 CLS
 PCOPY 1, 0
 COLOR 15, 0
 cinput
GOTO command

main:
 FOR tx = 1 TO AA
 FOR ty = 1 TO DD
  a = 0
  d = 0
  IF g(tx + (ty - 1) * AA, 9) = 0 THEN
   g(tx + (ty - 1) * AA, 9) = 1
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
  g(tx + (ty - 1) * AA, 9) = 0
 NEXT ty
 NEXT tx
GOTO command

command:
 tx = ex
 ty = dy
 LINE (0, 0)-(319, 199), 0, BF
 GOSUB portal
 PCOPY 1, 2
GOSUB command2
GOTO command3

command2:
 PCOPY 2, 1
 statx = 25
 framex1! = statx
 framex2! = 40
 framey1! = 2
 framey2! = 4
 framec1% = 6
 framec2% = 0
 GOSUB frameput
 SELECT CASE titled%
 CASE 0
  text 3, statx + 4, "Puzzlum", 5
 CASE 1
  text 3, statx + 4, "(T)itle", 9
 END SELECT
 am$ = ctrl$
 GOSUB am
 IF am > 0 THEN
  statx = 25
  GOSUB status
 END IF
 PCOPY 1, 3
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
 PCOPY 3, 1
 cursorput
 PCOPY 1, 0
 IF am > 0 THEN
  statx = 25
  GOSUB getaction
  IF ((c$ = "L") OR (ym% = 6 AND xm% = statx + 2 AND lb% = -1)) THEN
   c$ = "L"
   GOSUB paylevelup
   GOTO command
  END IF
  IF (ym% = 11 AND xm% = statx + 1 AND lb% = -1) AND d <> 0 THEN
   d = 0
   dis = 0
   GOSUB putaction
   GOSUB command2
  END IF
  IF (ym% = 10 AND xm% = statx + 1 AND lb% = -1) AND d <> 1 THEN
   d = 1
   dis = 0
   GOSUB putaction
   GOSUB command2
  END IF
  IF (ym% = 11 AND xm% = statx + 2 AND lb% = -1) AND d <> 2 THEN
   d = 2
   dis = 0
   GOSUB putaction
   GOSUB command2
  END IF
  IF (ym% = 12 AND xm% = statx + 1 AND lb% = -1) AND d <> 3 THEN
   d = 3
   dis = 0
   GOSUB putaction
   GOSUB command2
  END IF
  IF (ym% = 11 AND xm% = statx AND lb% = -1) AND d <> 4 THEN
   d = 4
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
 IF c$ = "t" OR c$ = "T" OR (ym% = 3 AND xm% = statx + 5 AND lb% = -1) THEN
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
 END IF
 IF INSTR(1, "L ||", RIGHT$(" " + c$, 1)) = 0 THEN
  GOTO command3
 END IF
 IF INSTR(1, "L||", RIGHT$(" " + c$, 1)) > 0 THEN
  GOTO command
 END IF
GOTO main

swapdata:
 FOR t = 0 TO 1
  SWAP e$(tx + (ty - 1) * AA, t), e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, t)
 NEXT t
 temp1$ = MID$(e$(tx + (ty - 1) * AA, 2), 1, 4)
 temp2$ = MID$(e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2), 1, 4)
 SWAP temp1$, temp2$
 MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) = temp1$
 MID$(e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2), 1, 4) = temp2$
 FOR t = 3 TO 4
  SWAP e$(tx + (ty - 1) * AA, t), e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, t)
 NEXT t
 FOR t = 0 TO 16
  SWAP g(tx + (ty - 1) * AA, t), g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, t)
 NEXT t
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
 IF g(tx + (ty - 1) * AA, 2) >= struse AND g(tx + (ty - 1) * AA, 3) >= essuse THEN
  IF 1 = 1 THEN
   MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = attackpic$
   MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = attackname$
   g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) - struse
   g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) - essuse
   evadeattack = g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 15)
   evadeattack = evadeattack + RND(1) * (1 - evadeattack)
   attackblocked = attackdamage * (evadeattack) - g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 5)
   IF attackblocked < 0 THEN attackblocked = 0
   attackdamage = attackdamage * (1 - evadeattack) + attackblocked
   g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 1) = g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 1) - attackdamage
   GOSUB battleattack
   IF g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 1) <= 0 THEN
    GOSUB victory
   END IF
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
 attackdamage = 5 + INT(g(tx + (ty - 1) * AA, 10) / 4)
 strdamage = 2
 GOSUB battle
RETURN

attkpnch:
 attackpic$ = "pnch"
 attackname$ = "pnch"
 struse = 12
 essuse = 0
 attackdamage = 3 + INT(g(tx + (ty - 1) * AA, 10) / 6)
 strdamage = 2 + INT(g(tx + (ty - 1) * AA, 10) / 8)
 GOSUB battle
RETURN

attkwstf:
 attackpic$ = "wstf"
 attackname$ = "wstf"
 struse = 20
 essuse = 0
 attackdamage = 5 + INT(g(tx + (ty - 1) * AA, 10) / 4)
 strdamage = 4 + INT(g(tx + (ty - 1) * AA, 10) / 6)
 GOSUB battle
RETURN

attkkick:
 attackpic$ = "kick"
 attackname$ = "kick"
 struse = 14
 essuse = 0
 attackdamage = 4 + INT(g(tx + (ty - 1) * AA, 10) / 5)
 strdamage = 3 + INT(g(tx + (ty - 1) * AA, 10) / 7)
 GOSUB battle
RETURN

attkvnom:
 attackpic$ = "vnom"
 attackname$ = "vnom"
 struse = 0
 essuse = 15
 attackdamage = 7 + INT(g(tx + (ty - 1) * AA, 10) / 4)
 strdamage = 10 + INT(g(tx + (ty - 1) * AA, 10) / 4)
 GOSUB battle
RETURN

attkdggr:
 attackpic$ = "dggr"
 attackname$ = "dggr"
 struse = 18
 essuse = 0
 attackdamage = 8 + INT(g(tx + (ty - 1) * AA, 10) / 4)
 strdamage = 1 + INT(g(tx + (ty - 1) * AA, 10) / 10)
 GOSUB battle
RETURN

attkpike:
 attackpic$ = "pike"
 attackname$ = "pike"
 struse = 24
 essuse = 0
 attackdamage = 12 + INT(g(tx + (ty - 1) * AA, 10) / 3)
 strdamage = 8 + INT(g(tx + (ty - 1) * AA, 10) / 5)
 GOSUB battle
RETURN

attkburn:
 attackpic$ = "____"
 attackname$ = "burn"
 struse = 5
 essuse = 5
 attackdamage = 12 + INT(g(tx + (ty - 1) * AA, 10) / 2)
 strdamage = 15 + INT(g(tx + (ty - 1) * AA, 10) / 4)
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
 attackdamage = 15 + INT(g(tx + (ty - 1) * AA, 10) / 2)
 strdamage = 20 + INT(g(tx + (ty - 1) * AA, 10) / 4)
 GOSUB battle
RETURN

attkweb:
 attackpic$ = "____"
 attackname$ = "web_"
 struse = 22
 essuse = 0
 attackdamage = 0
 strdamage = 15 + INT(g(tx + (ty - 1) * AA, 10) / 5)
 GOSUB battle
RETURN

attktngl:
 attackpic$ = "____"
 attackname$ = "tngl"
 struse = 0
 essuse = 0
 attackdamage = 0
 strdamage = 10 + INT(g(tx + (ty - 1) * AA, 10) / 6)
 GOSUB battle
RETURN

attklash:
 attackpic$ = "____"
 attackname$ = "lash"
 struse = 0
 essuse = 0
 attackdamage = 5 + INT(g(tx + (ty - 1) * AA, 10) / 5)
 strdamage = 8 + INT(g(tx + (ty - 1) * AA, 10) / 7)
 GOSUB battle
RETURN

usecure:
 IF g(tx + (ty - 1) * AA, 3) >= 8 THEN
  IF 1 = 1 THEN
   MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "cure"
   MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "cure"
   AA$ = "cure"
   GOSUB attackusing
   g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) - 8
   g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 1) = g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 1) + 12 + g(tx + (ty - 1) * AA, 10)
   g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2) = g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2) + 15 + g(tx + (ty - 1) * AA, 10)
   IF g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2) <= 0 THEN
    g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2) = 0
   END IF
   IF g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 1) <= 0 THEN
    GOSUB victory
   END IF
  END IF
 ELSE
  IF 1 = 1 THEN
   MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
   MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "____"
  END IF
 END IF
RETURN

useslep:
 IF g(tx + (ty - 1) * AA, 3) >= 8 THEN
  IF 1 = 1 THEN
   MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
   MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "slep"
   AA$ = "slep"
   GOSUB attackusing
   g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) - 8
   MID$(e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 4), 1, 4) = "____"
   MID$(e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 4), 5, 4) = "zzzz"
   slepadd% = INT(g(tx + (ty - 1) * AA, 10) / 10)
   temptx = tx
   tempty = ty
   tx = tx + d(d, 1) * dis
   ty = ty + d(d, 2) * dis
   GOSUB tempget
   IF tempaction$ <> "zzzz" THEN
    tempaction$ = "zzzz"
    tempdis = 5 + INT(RND(1) * 6) + slepadd%
    GOSUB tempput
   END IF
   tx = temptx
   ty = tempty
   g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2) = g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2) - 15
   IF g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2) <= 0 THEN
    g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2) = 0
   END IF
   IF g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 1) <= 0 THEN
    GOSUB victory
   END IF
  END IF
 ELSE
  IF 1 = 1 THEN
   MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
   MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "____"
  END IF
 END IF
RETURN

victory:
 GOSUB prflblnk
 prflidty$ = "pouch"
 prflactn$ = e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 1)
 prflgpic$ = "pwch"
 prflhp! = g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 1)
 prflstr! = g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2)
 prfless! = g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 3)
 prflexp! = g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 6)
 prflvalu! = g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 7)
 prfllv! = 1
 prflhpmax! = 99999
 GOSUB prflmake
RETURN

pillage:
 expgain = g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 6)
 expgain = expgain + g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 7)
 g(tx + (ty + -1) * AA, 6) = g(tx + (ty + -1) * AA, 6) + expgain
 strgain = g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2)
 g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) + strgain
 GOSUB defeated
 GOSUB windggr
 GOSUB winpike
 GOSUB wingrpl
 GOSUB winseed
 GOSUB winkey1
 GOSUB winkey2
RETURN

paylevelup:
 am$ = ctrl$
 GOSUB am
 IF am > 0 THEN
  LINE (0, 0)-(319, 199), 0, BF
  GOSUB portal
  PCOPY 1, 2
reshow1:
  PCOPY 2, 1
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
  menu$ = menu$ + "lvup" + MKL$(l(g(tx + (ty - 1) * AA, 10)))
  IF MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) = "plyr" THEN
   IF g(tx + (ty - 1) * AA, 10) >= 1 THEN
    haveit$ = "ispt"
    GOSUB haveit
    IF haveit = 0 THEN
     menu$ = menu$ + "ispt" + MKL$(0)
    END IF
   END IF
   IF g(tx + (ty - 1) * AA, 10) >= 1 THEN
    haveit$ = "move"
    GOSUB haveit
    IF haveit = 0 THEN
     menu$ = menu$ + "move" + MKL$(0)
    END IF
   END IF
   IF g(tx + (ty - 1) * AA, 10) >= 1 THEN
    haveit$ = "bite"
    GOSUB haveit
    IF haveit = 0 THEN
     menu$ = menu$ + "bite" + MKL$(2)
    END IF
   END IF
   IF g(tx + (ty - 1) * AA, 10) >= 1 THEN
    haveit$ = "pnch"
    GOSUB haveit
    IF haveit = 0 THEN
     menu$ = menu$ + "pnch" + MKL$(2)
    END IF
   END IF
   IF g(tx + (ty - 1) * AA, 10) >= 2 THEN
    haveit$ = "kick"
    GOSUB haveit
    IF haveit = 0 THEN
     menu$ = menu$ + "kick" + MKL$(10)
    END IF
   END IF
   IF g(tx + (ty - 1) * AA, 10) >= 3 THEN
    haveit$ = "cure"
    GOSUB haveit
    IF haveit = 0 THEN
     menu$ = menu$ + "cure" + MKL$(20)
    END IF
   END IF
   IF g(tx + (ty - 1) * AA, 10) >= 7 THEN
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
  FOR menuitem = 1 TO menusize
   menuitem$ = MID$(menu$, (menuitem - 1) * 8 + 1, 4)
   menucost = CVL(MID$(menu$, (menuitem - 1) * 8 + 5, 4))
   r$ = menuitem$
   GOSUB names
   IF menucost > 0 THEN
    text 10 + menuitem, 15, "ú" + rr$ + " " + STRING$((40 - 15) - LEN(rr$) - 7, "-") + RIGHT$("----" + RIGHT$(STR$(menucost), LEN(STR$(menucost)) - 1) + "$", 5), 0
   END IF
   IF menucost = 0 THEN
    text 10 + menuitem, 15, "ú" + rr$, 0
   END IF
  NEXT menuitem
wwait0:
  GOSUB buttonwait
  menuselect$ = "____"
  menucost = 0
  IF lb% = -1 THEN
   IF xm% = 15 THEN
    IF ym% >= 11 AND ym% <= 10 + menusize THEN
     menuselect = ym% - 10
     menuselect$ = MID$(menu$, (menuselect - 1) * 8 + 1, 4)
     menucost = CVL(MID$(menu$, (menuselect - 1) * 8 + 5, 4))
    END IF
   END IF
  END IF
  IF menuselect$ <> "lvup" AND menuselect$ <> "cncl" AND menuselect$ <> "____" THEN
   IF g(tx + (ty - 1) * AA, 6) >= menucost THEN
     c$ = "L"
    GOSUB abilitygain
   END IF
   GOTO reshow1
  END IF
  IF menuselect$ = "lvup" THEN
   IF g(tx + (ty - 1) * AA, 6) >= menucost THEN
    c$ = "L"
    GOSUB levelup
   END IF
   GOTO reshow1
  END IF
  IF menuselect$ = "cncl" THEN
   c$ = "L"
  ELSE
   GOTO wwait0
  END IF
  PCOPY 2, 1
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
  text 5, viewx, "Merchant", 0
  text 7, viewx, "Wha'du like?", 0
  graphicput 10, viewx + 6, (MID$(e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2), 1, 4) + "____.24")
  FOR menuitem = 1 TO menusize
   menuitem$ = MID$(menu$, (menuitem - 1) * 8 + 1, 4)
   menucost = CVL(MID$(menu$, (menuitem - 1) * 8 + 5, 4))
   r$ = menuitem$
   GOSUB names
   IF menucost > 0 THEN
    text 12 + menuitem, viewx, "ú" + rr$ + " " + STRING$((40 - viewx) - LEN(rr$) - 7, "-") + RIGHT$("----" + RIGHT$(STR$(menucost), LEN(STR$(menucost)) - 1) + "$", 5), 0
   END IF
   IF menucost = 0 THEN
    text 12 + menuitem, viewx, "ú" + rr$, 0
   END IF
  NEXT menuitem
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
   IF g(tx + (ty - 1) * AA, 6) >= menucost THEN
     c$ = "L"
    GOSUB abilitygain
    hashadit$ = menuselect$
    GOSUB hashadit
    g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 6) = g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 6) + menucost
    GOTO merchant
   END IF
   GOTO merchant
  END IF
  IF menuselect$ = "lvup" THEN
   IF g(tx + (ty - 1) * AA, 6) >= menucost THEN
    c$ = "L"
    GOSUB levelup
    GOTO merchant
   END IF
   GOTO merchant
  END IF
  IF menuselect$ = "cncl" THEN
   c$ = "L"
  ELSE
   GOTO wwait1
  END IF
 END IF
RETURN

talk0001:
 am$ = ctrl$
 GOSUB am
 IF am > 0 THEN
  PCOPY 1, 4
  PCOPY 2, 1
  LINE (0, 0)-(319, 199), 0, BF
  PCOPY 1, 2
reshow3:
  GOSUB portal
  statx = 2
  GOSUB status
  viewx = 18
  menu$ = ""
  menu$ = menu$ + "bye_" + MKL$(0)
  menusize = LEN(menu$) / 8
  inmenu = 0
  text 5, viewx, "Poindexter:", 0
  text 6, viewx, "Hi. How are you. My", 0
  text 7, viewx, "name is Poindexter. I", 0
  text 8, viewx, "am the greatest thief", 0
  text 9, viewx, "in the entire world!!!", 0
  graphicput 10, viewx + 6, (MID$(e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2), 1, 4) + "____.24")
  FOR menuitem = 1 TO menusize
   menuitem$ = MID$(menu$, (menuitem - 1) * 8 + 1, 4)
   menucost = CVL(MID$(menu$, (menuitem - 1) * 8 + 5, 4))
   r$ = menuitem$
   GOSUB names
   IF menucost > 0 THEN
    text 12 + menuitem, viewx, "ú" + rr$ + " =" + STR$(menucost), 0
   END IF
   IF menucost = 0 THEN
    text 12 + menuitem, viewx, "ú" + rr$, 0
   END IF
  NEXT menuitem
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
   c$ = "L"
  ELSE
   GOTO wwait1
  END IF
  PCOPY 4, 1
 END IF
RETURN

abilitygain:
 e$(tx + (ty - 1) * AA, 1) = e$(tx + (ty - 1) * AA, 1) + menuselect$
 g(tx + (ty - 1) * AA, 6) = g(tx + (ty - 1) * AA, 6) - menucost
 am$ = ctrl$
 GOSUB am
 IF am > 0 THEN
  LINE ((25 - 1) * 8, 0)-(319, 199), 0, BF
  PCOPY 1, 2
  GOSUB portal
  GOSUB avgframe
  text 5, 25, e$(tx + (ty - 1) * AA, 0), textrate
  text 7, 25, "gained", textrate
  r$ = menuselect$
  GOSUB names
  text 9, 25, rr$, textrate
  GOSUB okbutton
  PCOPY 2, 1
 END IF
RETURN

levelup:
 IF MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) <> "____" THEN
  IF g(tx + (ty - 1) * AA, 6) >= l(g(tx + (ty - 1) * AA, 10)) THEN
   g(tx + (ty - 1) * AA, 6) = g(tx + (ty - 1) * AA, 6) - l(g(tx + (ty - 1) * AA, 10))
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
   GOSUB am
   IF am > 0 THEN
    LINE ((25 - 1) * 8, 0)-(319, 199), 0, BF
    PCOPY 1, 2
    GOSUB portal
    GOSUB avgframe
    text 5, 25, e$(tx + (ty - 1) * AA, 0), textrate
    text 7, 25, "      level up!", textrate
    text 9, 25, "HPmax +", textrate
    text 9, 35, RIGHT$(STRING$(5, " ") + STR$(r1), 5), textrate
    text 11, 25, "STRmax +", textrate
    text 11, 35, RIGHT$(STRING$(5, " ") + STR$(r2), 5), textrate
    text 13, 25, "ESSmax +", textrate
    text 13, 35, RIGHT$(STRING$(5, " ") + STR$(r3), 5), textrate
    text 15, 25, "STRspd up!", textrate
    text 16, 25, "ESSspd up!", textrate
   END IF
   IF g(tx + (ty - 1) * AA, 10) < 64 THEN
    g(tx + (ty - 1) * AA, 10) = g(tx + (ty - 1) * AA, 10) + 1
    am$ = ctrl$
    GOSUB am
    IF am > 0 THEN
     text 18, 25, "reached LV#", textrate
     text 18, 37, RIGHT$(STRING$(3, " ") + STR$(g(tx + (ty - 1) * AA, 10)), 3), textrate
     IF l(g(tx + (ty - 1) * AA, 10)) - g(tx + (ty - 1) * AA, 6) >= 0 THEN
      text 20, 25, "next:", textrate
      text 20, 34, RIGHT$(STRING$(5, " ") + STR$(l(g(tx + (ty - 1) * AA, 10)) - g(tx + (ty - 1) * AA, 6)), 5) + "$", textrate
     END IF
    END IF
   END IF
   am$ = ctrl$
   GOSUB am
   IF am > 0 THEN
    GOSUB okbutton
    PCOPY 2, 1
   END IF
   IF g(tx + (ty - 1) * AA, 10) >= 2 AND MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) = "spdr" THEN
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
  PCOPY 1, 2
  GOSUB portal
  GOSUB avgframe
  text 5, 25, e$(tx + (ty - 1) * AA, 0), textrate
  text 7, 25, "gained", textrate
  r$ = getit$
  GOSUB names
  text 9, 25, rr$, textrate
  GOSUB okbutton
  PCOPY 2, 1
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
   PCOPY 1, 2
   GOSUB portal
   GOSUB avgframe
   text 5, 25, e$(tx + (ty - 1) * AA, 0), textrate
   text 6, 25, "gained", textrate
   r$ = getit$
   GOSUB names
   text 7, 25, rr$, textrate
   text 8, 25, "from", textrate
   text 9, 25, e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 0) + "!", textrate
   GOSUB okbutton
   PCOPY 2, 1
  END IF
 END IF
RETURN

attackusing:
 am$ = ctrl$
 GOSUB am
 are$ = ctrl$
 GOSUB are
 IF am > 0 OR are > 0 THEN
  PCOPY 1, 2
  LINE (0, 0)-(319, 199), 0, BF
  GOSUB portal
  GOSUB avgframe
  text 5, 25, e$(tx + (ty - 1) * AA, 0), 0
  text 6, 25, "used", 0
  r$ = AA$
  GOSUB names
  text 7, 25, rr$, 0
  text 8, 25, "on", 0
  text 9, 25, e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 0), 0
  GOSUB okbutton
  PCOPY 2, 1
 END IF
RETURN

battleattack:
 am$ = ctrl$
 GOSUB am
 are$ = ctrl$
 GOSUB are
 IF am > 0 OR are > 0 THEN
  PCOPY 1, 2
  LINE (0, 0)-(319, 199), 0, BF
  GOSUB portal
  GOSUB avgframe
  text 5, 25, e$(tx + (ty - 1) * AA, 0), 0
  text 6, 25, "used", 0
  r$ = MID$(e$(tx + (ty - 1) * AA, 4), 5, 4)
  GOSUB names
  text 7, 25, rr$, 0
  text 9, 25, e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 0), 0
  text 11, 25, "HP -", 0
  text 11, 35, RIGHT$(STRING$(5, " ") + STR$(attackdamage), 5), 0
  text 12, 25, "STR-", 0
  text 12, 35, RIGHT$(STRING$(5, " ") + STR$(strdamage), 5), 0
  GOSUB okbutton
  PCOPY 2, 1
 END IF
RETURN

defeated:
 am$ = ctrl$
 GOSUB am
 are$ = ctrl$
 GOSUB are
 IF am > 0 OR are > 0 THEN
  PCOPY 1, 2
  LINE (0, 0)-(319, 199), 0, BF
  GOSUB portal
  GOSUB avgframe
  text 5, 25, e$(tx + (ty - 1) * AA, 0), 0
  text 6, 25, "pillaged", 0
  text 7, 25, e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 0), 0
  text 9, 25, "EXP+", 0
  text 9, 34, RIGHT$(STRING$(5, " ") + STR$(expgain), 5) + "$", 0
  text 10, 25, "EXP:", 0
  text 10, 34, RIGHT$(STRING$(5, " ") + STR$(g(tx + (ty - 1) * AA, 6)), 5) + "$", 0
  text 12, 25, "STR+", 0
  text 12, 35, RIGHT$(STRING$(5, " ") + STR$(strgain), 5), 0
  text 13, 25, "STR:", 0
  text 13, 35, RIGHT$(STRING$(5, " ") + STR$(g(tx + (ty - 1) * AA, 2)), 5), 0
  GOSUB okbutton
  PCOPY 2, 1
 END IF
RETURN

portal:
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
     tempy2! = (tty - ty + d(tempd, 2) * tempdis) * 3 + 13 - 1
     tempx2! = (ttx - tx + d(tempd, 1) * tempdis) * 3 + 13 - 1
     PSET ((tempx1! - 1) * 8 + 12, (tempy1! - 1) * 8 + 12), 6
     LINE -((tempx2! - 1) * 8 + 12, (tempy2! - 1) * 8 + 12), 6
    FOR t! = 0 TO tempdis STEP tempdis / 8
     tempy! = (tty - ty + d(tempd, 2) * t!) * 3 + 13 - 1
     tempx! = (ttx - tx + d(tempd, 1) * t!) * 3 + 13 - 1
     tt! = t!
     IF tempdis <= 1 THEN
      tt! = t!
     ELSE
      IF t! < tempdis - 1 THEN
       tt! = -1
      ELSE
       tt! = t! - tempdis + 1
      END IF
     END IF
     IF tt! >= 0 THEN
      PSET ((tempx! - 1) * 8 + 12, (tempy! - 1) * 8 + 12 - tt!), 7
      PSET ((tempx! - 1) * 8 + 12 + tt!, (tempy! - 1) * 8 + 12), 7
      PSET ((tempx! - 1) * 8 + 12, (tempy! - 1) * 8 + 12 + tt!), 7
      PSET ((tempx! - 1) * 8 + 12 - tt!, (tempy! - 1) * 8 + 12), 7
     END IF
    NEXT t!
   END IF
  END IF
 NEXT tty
 NEXT ttx
RETURN

title:
 CLS
 graphicput 1, 2, "aquagame.56"
 colr% = 9
 text 4, 10, "AquariusúGames - AG47", colr%
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
 text 5, statx, e$(tx + (ty - 1) * AA, 0), 0
 text 6, statx, "LV", 0
 text 6, statx + 3, RIGHT$(STR$(100 + g(tx + (ty - 1) * AA, 10)), 2), 0
 text 6, statx + 9, (RIGHT$("     " + STR$(g(tx + (ty - 1) * AA, 6)), 5) + "$"), 0
 text 6, statx + 2, "ú", 0
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

sttsgpic:
 GOSUB getaction
 SELECT CASE d
 CASE 0
  graphicput 10, statx, "bttnself.24"
 CASE 1
  graphicput 10, statx, "bttnnrth.24"
 CASE 2
  graphicput 10, statx, "bttneast.24"
 CASE 3
  graphicput 10, statx, "bttnsuth.24"
 CASE 4
  graphicput 10, statx, "bttnwest.24"
 END SELECT
 graphicput 10, statx + 6, (MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) + "____.24")
 graphicput 10, statx + 3, (MID$(e$(tx + (ty - 1) * AA, 3), 5, 4) + "____.24")
RETURN

sttsitms:
 FOR t = 1 TO LEN(e$(tx + (ty - 1) * AA, 1)) / 4
  r$ = MID$(e$(tx + (ty - 1) * AA, 1), (t - 1) * 4 + 1, 4)
  GOSUB names
  IF action$ <> r$ THEN
   text 12 + (t) * 1, statx, "ú" + rr$, 0
  ELSE
   text 12 + (t) * 1, statx, "þ" + rr$, 0
  END IF
 NEXT t
RETURN

names:
 IF r$ = "" THEN
  r$ = "____"
 END IF
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
RETURN

move:
 MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "move"
 MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "move"
 are$ = "____pwch"
 GOSUB are
 IF g(tx + (ty - 1) * AA, 2) >= 1 AND are > 0 THEN
  move = 1
  here$ = "watr"
  GOSUB here
  IF here > 0 THEN move = 0
  there$ = "watr"
  GOSUB there
  IF there > 0 THEN move = 0
  here$ = "hole"
  GOSUB here
  there$ = "holestpsstp2"
  GOSUB there
  IF here > 0 AND there <= 0 THEN move = 0
  IF move = 1 THEN
   IF tx = ex AND ty = dy THEN
    am$ = ctrl$
    GOSUB am
    IF am > 0 THEN
     ex = tx + d(d, 1) * dis
     dy = ty + d(d, 2) * dis
    END IF
   END IF
   g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) - 1
   GOSUB swapdata
  END IF
 END IF
RETURN

wingmove:
 MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "move"
 MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "move"
 are$ = "____pwch"
 GOSUB are
 IF g(tx + (ty - 1) * AA, 2) >= 3 AND are > 0 THEN
  move = 1
  IF move = 1 THEN
   IF tx = ex AND ty = dy THEN
    am$ = ctrl$
    GOSUB am
    IF am > 0 THEN
     ex = tx + d(d, 1) * dis
     dy = ty + d(d, 2) * dis
    END IF
   END IF
   g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) - 3
   GOSUB swapdata
  END IF
 END IF
RETURN

firemove:
 IF g(tx + (ty - 1) * AA, 2) >= 1 THEN
  IF 1 = 1 THEN
   IF tx = ex AND ty = dy THEN
    am$ = ctrl$
    GOSUB am
    IF am > 0 THEN
     ex = tx + d(d, 1) * dis
     dy = ty + d(d, 2) * dis
    END IF
   END IF
   MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
   MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "move"
   g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) - 1
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
   ex = tx + d(d, 1) * dis
   dy = ty + d(d, 2) * dis
  END IF
 END IF
 MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "move"
 MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "move"
 g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) - 1
 GOSUB swapdata
RETURN

castfire:
 IF g(tx + (ty - 1) * AA, 3) >= 20 THEN
  MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
  MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "fire"
  g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) - 20
  GOSUB prflblnk
  prflidty$ = "Flame"
  prflactn$ = "moveburn"
  prflgpic$ = "fire"
  prflcmnd$ = MKL$(d) + "move" + MKL$(0)
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
 IF g(tx + (ty - 1) * AA, 3) >= 8 THEN
  MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
  MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "dust"
  g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) - 8
  GOSUB prflblnk
  prflidty$ = "Sleepy dust"
  prflactn$ = "move"
  prflgpic$ = "dust"
  prflcmnd$ = MKL$(d) + "move" + MKL$(0)
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
 IF g(tx + (ty - 1) * AA, 3) >= 220 THEN
  g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) - 220
  GOSUB prflblnk
  prflidty$ = "Web"
  prflactn$ = "spdr"
  prflgpic$ = "web_"
  prflcmnd$ = MKL$(d) + "move" + MKL$(0)
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
 IF g(tx + (ty - 1) * AA, 3) >= 320 THEN
  g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) - 320
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
 IF g(tx + (ty - 1) * AA, 3) >= 160 THEN
  g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) - 160
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

delete:
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
 g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) + g(tx + (ty - 1) * AA, 4)
 g(tx + (ty - 1) * AA, 3) = g(tx + (ty - 1) * AA, 3) + g(tx + (ty - 1) * AA, 14)
RETURN

statmax:
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
  d = INT(RND(1) * 4) + 1
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
 d = CVL(MID$(e$(tx + (ty - 1) * AA, 3), 1, 4))
 action$ = MID$(e$(tx + (ty - 1) * AA, 3), 5, 4)
 dis = CVL(MID$(e$(tx + (ty - 1) * AA, 3), 9, 4))
RETURN

putaction:
 MID$(e$(tx + (ty - 1) * AA, 3), 1, 4) = MKL$(d)
 MID$(e$(tx + (ty - 1) * AA, 3), 5, 4) = action$
 MID$(e$(tx + (ty - 1) * AA, 3), 9, 4) = MKL$(dis)
RETURN

tempget:
 tempd = CVL(MID$(e$(tx + (ty - 1) * AA, 3), 1, 4))
 tempaction$ = MID$(e$(tx + (ty - 1) * AA, 3), 5, 4)
 tempdis = CVL(MID$(e$(tx + (ty - 1) * AA, 3), 9, 4))
RETURN

tempput:
 MID$(e$(tx + (ty - 1) * AA, 3), 1, 4) = MKL$(tempd)
 MID$(e$(tx + (ty - 1) * AA, 3), 5, 4) = tempaction$
 MID$(e$(tx + (ty - 1) * AA, 3), 9, 4) = MKL$(tempdis)
RETURN

inbounds:
 IF tx + d(d, 1) * dis >= 1 AND tx + d(d, 1) * dis <= AA AND ty + d(d, 2) * dis >= 1 AND ty + d(d, 2) * dis <= DD THEN
  inbounds = 1
 ELSE
  inbounds = 0
 END IF
RETURN

haveit:
 haveit = 0
 t$ = e$(tx + (ty - 1) * AA, 1)
 t = LEN(t$) / 4
 FOR tt = 1 TO t
  tt$ = MID$(t$, (tt - 1) * 4 + 1, 4)
  IF tt$ = haveit$ THEN
   haveit = haveit + 1
  END IF
 NEXT tt
RETURN

hasit:
 hasit = 0
 t$ = e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 1)
 t = LEN(t$) / 4
 FOR tt = 1 TO t
  tt$ = MID$(t$, (tt - 1) * 4 + 1, 4)
  IF tt$ = hasit$ THEN
   hasit = hasit + 1
  END IF
 NEXT tt
RETURN

havehadit:
 t$ = e$(tx + (ty - 1) * AA, 1)
 t = LEN(t$) / 4
 FOR tt = 1 TO t
  tt$ = MID$(t$, (tt - 1) * 4 + 1, 4)
  IF tt$ = havehadit$ THEN
   t$ = LEFT$(t$, (tt - 1) * 4) + RIGHT$(t$, t * 4 + 1 - tt * 4 - 1)
   tt = t
  END IF
 NEXT tt
 e$(tx + (ty - 1) * AA, 1) = t$
RETURN

hashadit:
 t$ = e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 1)
 t = LEN(t$) / 4
 FOR tt = 1 TO t
  tt$ = MID$(t$, (tt - 1) * 4 + 1, 4)
  IF tt$ = hashadit$ THEN
   t$ = LEFT$(t$, (tt - 1) * 4) + RIGHT$(t$, t * 4 + 1 - tt * 4 - 1)
   tt = t
  END IF
 NEXT tt
 e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 1) = t$
RETURN

havegotit:
 t$ = e$(tx + (ty - 1) * AA, 1)
 e$(tx + (ty - 1) * AA, 1) = t$ + havegotit$
RETURN

hasgotit:
 t$ = e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 1)
 e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 1) = t$ + hasgotit$
RETURN

winexp:
 getit = g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 6)
 IF getit > 0 THEN
  getit$ = STR$(getit) + " EXP"
  getit$ = RIGHT$(getit$, LEN(getit$) - 1)
  g(tx + (ty - 1) * AA, 1) = g(tx + (ty - 1) * AA, 1) + getit
  GOSUB getit
  g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 6) = 0
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
 FOR t = 1 TO LEN(am$) / 4
  IF MID$(am$, (t - 1) * 4 + 1, 4) = MID$(e$(tx + (ty - 1) * AA, 2), 1, 4) THEN
   am = am + 1
  END IF
 NEXT t
RETURN

are:
 are = 0
 FOR t = 1 TO LEN(are$) / 4
  IF MID$(are$, (t - 1) * 4 + 1, 4) = MID$(e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2), 1, 4) THEN
   are = are + 1
  END IF
 NEXT t
RETURN

here:
 here = 0
 FOR t = 1 TO LEN(here$) / 4
  IF MID$(here$, (t - 1) * 4 + 1, 4) = MID$(e$(tx + (ty - 1) * AA, 2), 5, 4) THEN
   here = here + 1
  END IF
 NEXT t
RETURN

there:
 there = 0
 FOR t = 1 TO LEN(there$) / 4
  IF MID$(there$, (t - 1) * 4 + 1, 4) = MID$(e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2), 5, 4) THEN
   there = there + 1
  END IF
 NEXT t
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
 text 23, 25, "úOk", 0
wwait:
 GOSUB buttonwait
 IF ((c$ = "O" OR c$ = CHR$(13) OR c$ = "o") OR (ym% = 23 AND xm% = 25 AND lb% = -1)) THEN
  c$ = "L"
 ELSE
  GOTO wwait
 END IF
RETURN

buttonwait:
 PCOPY 1, 3
 cinput
 cursorput
 PCOPY 1, 0
 PCOPY 3, 1
RETURN
  
commandwait:
 PCOPY 1, 2
 c$ = "%%"
 lb% = 0
 WHILE c$ = "%%" AND lb% = 0
  cinput
  cursorput
  PCOPY 1, 0
  PCOPY 2, 1
 WEND
RETURN

frameput:
 LINE ((framex1! - 2) * 8 + 7, (framey1! - 1) * 8 + 7)-((framex2! - 1) * 8, (framey2! - 1) * 8), 0, BF
 LINE ((framex1! - 2) * 8 + 7, (framey1! - 1) * 8 + 5)-((framex2! - 1) * 8, (framey2! - 1) * 8 + 2), framec1%, B
 LINE ((framex1! - 2) * 8 + 5, (framey1! - 1) * 8 + 7)-((framex2! - 1) * 8 + 2, (framey2! - 1) * 8), framec1%, B
 LINE ((framex1! - 2) * 8 + 6, (framey1! - 1) * 8 + 6)-((framex2! - 1) * 8 + 1, (framey2! - 1) * 8 + 1), framec2%, B
 PSET ((framex1! - 2) * 8 + 6, (framey1! - 1) * 8 + 6), framec1%
 PSET ((framex2! - 1) * 8 + 1, (framey2! - 1) * 8 + 1), framec1%
 PSET ((framex1! - 2) * 8 + 6, (framey2! - 1) * 8 + 1), framec1%
 PSET ((framex2! - 1) * 8 + 1, (framey1! - 1) * 8 + 6), framec1%
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

screenset:
 PCOPY 2, 1
 PCOPY 1, 0
 SCREEN 7, 0, 0, 0
 COLOR 15, 1
RETURN

findcrsr:
 crsry% = CSRLIN
 crsrx% = POS(0)
RETURN

showtext:
 GOSUB findcrsr
 text crsry%, crsrx%, texts$, colr%
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
 g(tx + (ty - 1) * AA, 0) = prflidty!
 g(tx + (ty - 1) * AA, 1) = prflhp!
 g(tx + (ty - 1) * AA, 2) = prflstr!
 g(tx + (ty - 1) * AA, 3) = prfless!
 g(tx + (ty - 1) * AA, 4) = prflspd!
 g(tx + (ty - 1) * AA, 5) = prflarmr!
 g(tx + (ty - 1) * AA, 6) = prflexp!
 g(tx + (ty - 1) * AA, 7) = prflvalu!
 g(tx + (ty - 1) * AA, 8) = prflpirc!
 g(tx + (ty - 1) * AA, 9) = prflchck!
 g(tx + (ty - 1) * AA, 10) = prfllv!
 g(tx + (ty - 1) * AA, 11) = prflhpmax!
 g(tx + (ty - 1) * AA, 12) = prflstrmax!
 g(tx + (ty - 1) * AA, 13) = prflessmax!
 g(tx + (ty - 1) * AA, 14) = prflessspd!
 g(tx + (ty - 1) * AA, 15) = prflevad!
 g(tx + (ty - 1) * AA, 16) = prflblnk!
RETURN

prflmake:
 e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 0) = prflidty$
 e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 1) = prflactn$
 MID$(e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2), 1, 4) = prflgpic$
 e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 3) = prflcmnd$
 e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 4) = prflgpicactn$
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 0) = prflidty!
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 1) = prflhp!
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 2) = prflstr!
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 3) = prfless!
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 4) = prflspd!
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 5) = prflarmr!
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 6) = prflexp!
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 7) = prflvalu!
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 8) = prflpirc!
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 9) = prflchck!
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 10) = prfllv!
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 11) = prflhpmax!
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 12) = prflstrmax!
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 13) = prflessmax!
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 14) = prflessspd!
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 15) = prflevad!
 g(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 16) = prflblnk!
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
 IF blankcheck = -1 THEN RETURN
 GOSUB move
RETURN

actnwing:
 dis = 1
 blankcheck$ = "____"
 GOSUB blankcheck
 IF blankcheck = -1 THEN RETURN
 GOSUB wingmove
RETURN

actnwstf:
 dis = 1
 blankcheck$ = "bldr"
 GOSUB blankcheck
 IF blankcheck > 0 THEN
  dis = 2
  blankcheck$ = "____pwch"
  GOSUB blankcheck
  IF blankcheck > 0 THEN
   temptx = tx
   tempty = ty
   tx = tx + d(d, 1)
   ty = ty + d(d, 2)
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
   GOSUB delete
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
   GOSUB delete
  END IF
 END IF
RETURN

actnispt:
 dis = 1
 GOSUB putaction
 blankcheck$ = "____"
 GOSUB blankcheck
 IF blankcheck = -1 OR blankcheck > 0 THEN RETURN
 IF e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 0) = "Merchant" THEN
  GOSUB merchant
  RETURN
 END IF
 IF e$(tx + d(d, 1) * dis + (ty + d(d, 2) * dis - 1) * AA, 0) = "Poindexter" THEN
  GOSUB talk0001
  RETURN
 END IF
 blankcheck$ = "pwchchst"
 GOSUB blankcheck
 IF blankcheck > 0 THEN
  GOSUB pillage
  blankcheck$ = "pwch"
  IF blankcheck > 0 THEN
   GOSUB delete
  END IF
  RETURN
 END IF
RETURN
 
actnfiremove:
 dis = 1
 blankcheck$ = "____pwch"
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
 blankcheck$ = "____pwch"
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
 blankcheck$ = "____pwch"
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
 IF dis = 0 AND g(tx + (ty - 1) * AA, 2) < 10 THEN
  action$ = "____pwch"
  GOSUB putaction
  RETURN
 END IF
 IF dis = 0 THEN
  g(tx + (ty - 1) * AA, 2) = g(tx + (ty - 1) * AA, 2) - 10
 END IF
 IF dis < 3 THEN
  dis = dis + 1
 END IF
 blankcheck$ = "____pwch"
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
  action$ = "____pwch"
  dis = 0
  GOSUB putaction
  MID$(e$(tx + (ty - 1) * AA, 4), 1, 4) = "____"
  MID$(e$(tx + (ty - 1) * AA, 4), 5, 4) = "____"
  RETURN
 END IF
 blankcheck$ = "____pwch"
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
  blankcheck$ = "____pwch"
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
     ex = tx + d(d, 1) * dis
     dy = ty + d(d, 2) * dis
    END IF
   END IF
   GOSUB swapdata
   temptx = tx
   tempty = ty
   tx = tx + d(d, 1)
   ty = ty + d(d, 2)
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
 here$ = "watr"
 GOSUB here
 IF here > 0 THEN
  MID$(e$(tx + (ty - 1) * AA, 2), 5, 4) = "hole"
 END IF
 here$ = "stp2"
 GOSUB here
 IF here > 0 THEN
  MID$(e$(tx + (ty - 1) * AA, 2), 5, 4) = "stps"
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
 SELECT CASE CVL(action$)
 END SELECT
 GOSUB autolevelup
RETURN

SUB cinput
XXmouse% = Xmouse%
YYmouse% = Ymouse%
l1b% = lb%
r1b% = rb%
c$ = INKEY$: IF c$ = "" THEN c$ = "%%"
REM''STICKS joy0%, joy1%, joy2%, joy3%, but0%, but1%, but2%, but3%, but4%, but5%, but6%, but7%
REM''PENS tip0%, tip1%, tip2%, tip3%, tip4%, tip5%, tip6%, tip7%, tip8%, tip9%
mousestatus lb%, rb%, Xmouse%, Ymouse%
Xmouse% = Xmouse% / 2
ym% = INT(Ymouse% / 8) + 1
xm% = INT(Xmouse% / 8) + 1
jsx = 0: REM'joy0% - 100
jsy = 0: REM'joy1% - 100
jsa = 0: REM'but0%
jsb = 0: REM'but1%
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

SUB cursorput
REM''DEF SEG = VARSEG(t(0))
REM''BLOAD sss$, VARPTR(t(0))
REM''PUT ((xx% + ttt - 2) * 8, (yy% - 1) * 8), t(0), AND
REM''DEF SEG = VARSEG(t(0))
REM''BLOAD sss$, VARPTR(t(0))
REM''PUT ((xx% + ttt - 2) * 8, (yy% - 1) * 8), t(0), OR
REM''IF lb% = 0 THEN
  LINE (Xmouse% - 2, Ymouse% - 2)-(Xmouse% + 2, Ymouse% + 2), 9
  LINE (Xmouse% + 2, Ymouse% - 2)-(Xmouse% - 2, Ymouse% + 2), 9
REM''END IF
REM''IF lb% = -1 THEN
  REM''LINE (Xmouse% - 3, Ymouse% - 3)-(Xmouse% + 3, Ymouse% + 3), 9
  REM''LINE (Xmouse% + 3, Ymouse% - 3)-(Xmouse% - 3, Ymouse% + 3), 9
REM''END IF
END SUB

SUB graphicput (yy1%, xx1%, ss1$)
REM''IF ABS(yy1% - dy) <= 2 AND ABS(xx1% - ex) <= 2 THEN
 IF LEN(ss1$) = 11 AND ss1$ <> "________.24" THEN
  ss2$ = ss1$ + "y"
  DEF SEG = VARSEG(t(0))
  BLOAD ss2$, VARPTR(t(0))
  PUT ((xx1% - 1) * 8, (yy1% - 1) * 8), t(0), AND
  ss3$ = ss1$ + "x"
  DEF SEG = VARSEG(t(0))
  BLOAD ss3$, VARPTR(t(0))
  PUT ((xx1% - 1) * 8, (yy1% - 1) * 8), t(0), OR
 END IF
 IF LEN(ss1$) <> 11 THEN
  LOCATE yy1% + 1, xx1% + 1: PRINT ".";
 END IF
REM''END IF
END SUB

DEFSNG A-Z
SUB MouseDriver (AX%, bx%, CX%, dx%)
  DEF SEG = VARSEG(mouse$)
  mouse% = SADD(mouse$)
  CALL Absolute(AX%, bx%, CX%, dx%, mouse%)
END SUB

SUB MouseHide
 AX% = 2
 MouseDriver AX%, 0, 0, 0
END SUB

FUNCTION MouseInit%
  AX% = 0
  MouseDriver AX%, 0, 0, 0
  MouseInit% = AX%

END FUNCTION

SUB mouseput
  AX% = 4
  CX% = x%
  dx% = y%
  MouseDriver AX%, 0, CX%, dx%
END SUB

SUB mouseshow
  AX% = 1
  MouseDriver AX%, 0, 0, 0
END SUB

SUB mousestatus (lb%, rb%, Xmouse%, Ymouse%)
  AX% = 3
  MouseDriver AX%, bx%, CX%, dx%
  lb% = ((bx% AND 1) <> 0)
  rb% = ((bx% AND 2) <> 0)
  Xmouse% = CX%
  Ymouse% = dx%
END SUB

DEFINT A-Z
SUB PENS (tip0%, tip1%, tip2%, tip3%, tip4%, tip5%, tip6%, tip7%, tip8%, tip9%)
tip0% = PEN(0)
tip1% = PEN(1)
tip2% = PEN(2)
tip3% = PEN(3)
tip4% = PEN(4)
tip5% = PEN(5)
tip6% = PEN(6)
tip7% = PEN(7)
tip8% = PEN(8)
tip9% = PEN(9)
END SUB

DEFSNG A-Z
SUB STICKS (joy0%, joy1%, joy2%, joy3%, but0%, but1%, but2%, but3%, but4%, but5%, but6%, but7%)
joy0% = STICK(0)
joy1% = STICK(1)
joy2% = STICK(2)
joy3% = STICK(3)

but0% = STRIG(0)
but1% = STRIG(1)
but2% = STRIG(2)
but3% = STRIG(3)
but4% = STRIG(4)
but5% = STRIG(5)
but6% = STRIG(6)
but7% = STRIG(7)

END SUB

DEFINT A-Z
SUB suspend (start!, delay)
  PCOPY 1, 3
  cinput
  cursorput
  PCOPY 1, 0
  PCOPY 3, 1
  DO
    REM' commands to do while suspended
    cinput
    cursorput
    PCOPY 1, 0
    PCOPY 3, 1
  LOOP UNTIL (TIMER < start!) OR (TIMER >= start! + delay): REM'check before ending loop
END SUB

SUB text (yy%, xx%, ss$, sp%)
 IF sp% >= 1 AND sp% <= 15 THEN
  ssp% = sp%
 ELSE
  ssp% = 15
 END IF
 COLOR ssp%
 LINE ((xx% - 1) * 8, (yy% - 1) * 8)-((xx% + LEN(ss$) - 2) * 8 + 7, (yy% - 1) * 8 + 7), ssp%, BF
 FOR t = 1 TO LEN(ss$)
  ss% = ASC(MID$(ss$, t, 1))
  IF (ss% >= 32 AND ss% <= 126) OR ss% = 250 OR ss% = 254 THEN
   IF 1 = 1 THEN
    IF ss% >= 97 AND ss% <= 122 THEN
     ss% = ss% - 32
    END IF
    DEF SEG = VARSEG(t(0))
    BLOAD ("lttr" + RIGHT$(STR$(1000 + ss%), 3) + "_.08x"), VARPTR(t(0))
    PUT ((xx% + t - 2) * 8, (yy% - 1) * 8), t(0), AND
   END IF
  ELSE
   IF 1 = 1 THEN
    LOCATE yy%, xx% + t - 1
    PRINT CHR$(ss%);
   END IF
  END IF
 NEXT t
 COLOR 15
END SUB

