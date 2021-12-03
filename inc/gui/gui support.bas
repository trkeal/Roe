
declare function pickup( subject as string = "" ) as string

declare sub gtext( row as integer = 1, col as integer = 1, fg as integer = 9, bg as integer = 0, subject as string = "" )

declare function gtext_true_len(subject as string) as integer

declare sub border( x1 as integer = 1, y1 as integer = 1, x2 as integer = 40, y2 as integer = 25, method as integer = -1 )

declare function truncate( subject as string = "", length as integer = 1 ) as string

function pickup( subject as string = "" ) as string

	select case lcase$(subject)
	case "m" 'mp+
		pickup = "ô"
	case "g" 'gold
		pickup = "ø"
	case "h" ' heal
		pickup = "ì"
	case "k" 'key
		pickup = "ç"
	case "b" 'bomb
		pickup = "ç"
	case "gain character"
		pickup = "ç"
	case "mystic orb"
		pickup = "ñ"
	case else
		pickup = subject
	end select
	
end function


sub gtext( row as integer = 1, col as integer = 1, fg as integer = 9, bg as integer = 0, subject as string = "" )
	dim as string qopen = "{{", qclose = "}}"
	
	dim as integer offest = 0, o = 0
	dim as string c0 = string$(0,0)
	for offset = 1 to len(subject) step 1
		if mid$(subject,offset,len(qopen)) = qopen and mid$(subject,offset+len(qopen)+1,len(qclose)) = qclose then
			
			c0 = pickup( mid$(subject,offset+len(qopen),1) )
			sprite_put 0, (col + o - 1) * 8, (row - 1) * 8, "tiles\map\map_"+RIGHT$(STR$(1000 + asc(c0)), 3) + ".til", "pset"

			offset += len(qopen+qclose)
		elseif mid$(subject,offset,len(qopen)) = qopen and mid$(subject,offset+len(qopen)+2,len(qclose)) = qclose then
			
			c0 = chr$( val("&H" + mid$(subject,offset+len(qopen),2) ) )
			sprite_put 0, (col + o - 1) * 8, (row - 1) * 8, "tiles\map\map_"+RIGHT$(STR$(1000 + asc(c0)), 3) + ".til", "pset"

			offset += len(qopen+qclose)+1
		else
			c0 = mid$(subject,offset,1)
			
			stringput( ( col + o - 1 ) * 8, ( row - 1 ) * 8, c0 )

			'locate row, col + o
			'color fg, bg
			'print c0;
		end if
		o += 1
	next offset
	''sprite_put 0, (x0 - 1) * 8, (y0 - 1) * 8, "tiles\"+RIGHT$(STR$(1000 + ASC(c0$)), 3) + "b0808.til", "pset"

end sub

function gtext_true_len(subject as string) as integer
	
	dim as string qopen = "{{", qclose = "}}"
	
	dim as integer offest = 0, o = 0
	dim as string c0 = string$(0,0)
	for offset = 1 to len(subject) step 1
		if mid$(subject,offset,len(qopen)) = qopen and mid$(subject,offset+len(qopen)+1,len(qclose)) = qclose then
			
			c0 = pickup( mid$(subject,offset+len(qopen),1) )
			''sprite_put 0, (col + o - 1) * 8, (row - 1) * 8, "tiles\map\map_"+RIGHT$(STR$(1000 + asc(c0)), 3) + ".til", "pset"

			offset += len(qopen+qclose)
		elseif mid$(subject,offset,len(qopen)) = qopen and mid$(subject,offset+len(qopen)+2,len(qclose)) = qclose then
			
			c0 = chr$( val("&H" + mid$(subject,offset+len(qopen),2) ) )
			''sprite_put 0, (col + o - 1) * 8, (row - 1) * 8, "tiles\map\map_"+RIGHT$(STR$(1000 + asc(c0)), 3) + ".til", "pset"

			offset += len(qopen+qclose)+1
		else
			c0 = mid$(subject,offset,1)
			
			''stringput( ( col + o - 1 ) * 8, ( row - 1 ) * 8, c0 )

			'locate row, col + o
			'color fg, bg
			'print c0;
		end if
		o += 1
	next offset
	''sprite_put 0, (x0 - 1) * 8, (y0 - 1) * 8, "tiles\"+RIGHT$(STR$(1000 + ASC(c0$)), 3) + "b0808.til", "pset"
	gtext_true_len = o
end function

sub border( x1 as integer = 1, y1 as integer = 1, x2 as integer = 40, y2 as integer = 25, method as integer = -1 )
	
	'refreshcount += 1
	
	dim as integer row = 0

	if method = -1 then
		rectfill1x( ( x1 - 1 ) * 8, ( y1 - 1 ) * 8,( x2 - 1 ) * 8, ( y2 - 1 ) * 8, 0 )
	end if

	'top frame
	stringput( ( x1 - 1 ) * 8, ( y1 - 1 ) * 8, "Ú" + string$( x2 - x1 - 1, "Ä") + "¿" )

	'bottom frame
	stringput( ( x1 - 1 ) * 8, ( y2 - 1 ) * 8, "À" + string$( x2 - x1 - 1, "Ä") + "Ù" )

	FOR row = y1 + 1 TO y2 - 1 step 1

		'left frame
		stringput( ( x1 - 1 ) * 8, ( row - 1 ) * 8, "³" )

		'right frame
		stringput( ( x2 - 1 ) * 8, ( row - 1 ) * 8, "³" )

	NEXT row

end sub

function truncate( subject as string = "", length as integer = 1 ) as string
	do while ( left$( subject, 1 ) = "0" or left$( subject, 1 ) = string$( 1, 32 ) ) and len( subject ) > 1
		subject = mid$(subject,1)
	loop
	truncate = string$( length - len( subject ), 32 ) + subject
end function
