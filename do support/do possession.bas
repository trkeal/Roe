
do_haveit:
 haveit = 0
 t$ = e$(tx + (ty - 1) * AA, 1)
 tint = LEN(t$) / 4
 FOR tt = 1 TO tint
  tt$ = MID$(t$, (tt - 1) * 4 + 1, 4)
  IF tt$ = haveit$ THEN
   haveit = haveit + 1
  END IF
 NEXT tt
RETURN

do_hasit:
 hasit = 0
 t$ = e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 1)
 tint = LEN(t$) / 4
 FOR tt = 1 TO tint
  tt$ = MID$(t$, (tt - 1) * 4 + 1, 4)
  IF tt$ = hasit$ THEN
   hasit = hasit + 1
  END IF
 NEXT tt
RETURN

do_havehadit:
 t$ = e$(tx + (ty - 1) * AA, 1)
 tint = LEN(t$) / 4
 FOR tt = 1 TO tint
  tt$ = MID$(t$, (tt - 1) * 4 + 1, 4)
  IF tt$ = havehadit$ THEN
   t$ = LEFT$(t$, (tt - 1) * 4) + RIGHT$(t$, tint * 4 + 1 - tt * 4 - 1)
   tt = tint
  END IF
 NEXT tt
 e$(tx + (ty - 1) * AA, 1) = t$
RETURN

do_hashadit:
 t$ = e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 1)
 tint = LEN(t$) / 4
 FOR tt = 1 TO tint
  tt$ = MID$(t$, (tt - 1) * 4 + 1, 4)
  IF tt$ = hashadit$ THEN
   t$ = LEFT$(t$, (tt - 1) * 4) + RIGHT$(t$, tint * 4 + 1 - tt * 4 - 1)
   tt = tint
  END IF
 NEXT tt
 e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 1) = t$
RETURN

do_havegotit:
 t$ = e$(tx + (ty - 1) * AA, 1)
 e$(tx + (ty - 1) * AA, 1) = t$ + havegotit$
RETURN

do_hasgotit:
 t$ = e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 1)
 e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 1) = t$ + hasgotit$
RETURN
