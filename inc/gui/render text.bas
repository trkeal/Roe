
declare SUB text (yy AS INTEGER, xx AS INTEGER, ss AS STRING, sp AS INTEGER)

declare function is_selected_hud( toggle as integer = 0 ) as string

declare sub renderfill( x1 as integer = 0, y1 as integer = 0, x2 as integer = 319, y2 as integer = 199, dither1 as integer = 0, dither2 as integer = -1 )

declare SUB graphicput ( y AS INTEGER, x AS INTEGER, subject as string, textfg as integer = 15 )

SUB text (yy AS INTEGER, xx AS INTEGER, ss AS STRING, sp AS INTEGER)
 IF sp >= 1 AND sp <= 15 THEN
  ssp = sp
 ELSE
  ssp = 15
 END IF
 COLOR ssp
 textfg = ssp
 'LINE ((xx - 1) * 8, (yy - 1) * 8)-((xx + LEN(ss) - 2) * 8 + 7, (yy - 1) * 8 + 7), ssp, BF
 FOR tint = 1 TO LEN(ss)
  ssord = ASC(MID$(ss, tint, 1))
  IF (ssord >= 32 AND ssord <= 126) OR ssord = 250 OR ssord = 254 THEN
   IF 1 = 1 THEN
    IF ssord >= 97 AND ssord <= 122 THEN
     ssord = ssord - 32
    END IF
    
	x=xx + tint - 1
	y=yy
	
'	DEF SEG = VARSEG(t(0))
 '   BLOAD "font\" + ("lttr" + RIGHT$(STR$(1000 + ssord), 3) + "_.08x"), VARPTR(t(0))
	'PUT ((xx + tint - 2) * 8, (yy - 1) * 8), t(0), AND
	ss1$ = "bsv\font\" + "lttr" + RIGHT$(STR$(1000 + ssord), 3) + "_.08x"
	graphicput y, x, ss1$, ssp
	
   END IF
  ELSE
   LOCATE yy, xx + tint - 1
   color textfg
   PRINT CHR$(ssord);
  END IF
 NEXT tint
 COLOR 15
END SUB

function is_selected_hud( toggle as integer = 0 ) as string
	select case toggle
	case 0
	is_selected_hud = CHR$( 250 )
	case is <> 0
	is_selected_hud = CHR$( 254 )
	end select
end function

sub renderfill( x1 as integer = 0, y1 as integer = 0, x2 as integer = 319, y2 as integer = 199, dither1 as integer = 0, dither2 as integer = -1 )
	dim as integer x = 0, y = 0
	for y = y1 to y2 step 1
	for x = x1 to x2 step 1
		select case (x xor y xor 1) and 1
		case 0
			select case dither1
			case -1
			case else
				pset (x,y),fg
			end select
		case 1
			select case dither2
			case -1
			case else
				pset (x,y),bg
			end select
		end select
	next x
	next y
end sub

SUB graphicput ( y AS INTEGER, x AS INTEGER, subject as string, textfg as integer = 15 )
	dim as any ptr img
	dim as string erasure, shades, path, ext
	
	erasure = string$( 0, 0 )
	shades = string$( 0, 0 )
	
	path = string$( 0, 0 )
	WHILE INSTR(1, subject, "\") > 0
		path += LEFT$(subject, INSTR(1, subject, "\"))
		subject = MID$(subject, INSTR(1, subject, "\") + 1)
	WEND
	
	ext=string$( 0, 0 )
	IF INSTR(1, subject, ".") > 0 then
		ext = MID$(subject, INSTR(1, subject, ".") + 1)
		subject = LEFT$(subject, INSTR(1, subject, ".") - 1)
	END IF
	
	if right$( ext, 1 ) = "x" then
		
		erasure = path + subject + "." + ext
		
		load_sprite img, erasure
		
		imageinfo(img,w,h)

		''[!!!]'line ( ( x - 1 ) * 8, ( y - 1 ) * 8 ) - ( ( x - 1 ) * 8 + 7, ( y - 1 ) * 8 + 7 ), textbg, bf
			
		for row = 0 to h - 1
		for col = 0 to w - 1
			if ( point( col, row, img ) = 0 ) = 0 then
				'[..]'textfg = 15
				pset ( ( x - 1 ) * 8 + col, ( y - 1 ) * 8 + row ), textfg
				'pset ( ( x - 1 ) * 8 + col, ( y - 1 ) * 8 + row ), point( col, row, img ) and point( ( x - 1 ) * 8 + col, ( y - 1 ) * 8 + row )
			'else
				'pset ( ( x - 1 ) * 8 + col, ( y - 1 ) * 8 + row ), textbg
			end if
		next col
		next row
		
		'put ( ( x - 1 ) * 8, ( y - 1 ) * 8 ),img, or
		imagedestroy img
		
	else
		
		erasure = path + subject + "." + ext + "y"
		
		load_sprite img, erasure
		put ( ( x - 1 ) * 8, ( y - 1 ) * 8 ), img, and
		imagedestroy img
		
		shades = path + subject + "." + ext + "x"
		
		load_sprite img, shades
		put ( ( x - 1 ) * 8, ( y - 1 ) * 8 ), img, or
		imagedestroy img
		
	end if
  
END SUB
