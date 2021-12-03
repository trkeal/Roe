dim shared as string menu, iname
menu = string$(0,0)
iname = string$(0,0)

dim shared as single icost = 0.0

declare sub inventory_click ( menu as string = "", byref o as integer = -1 )

declare sub menu_value( menu as string = "cncl", o as integer = 0, byref item as string = "", byref cost as single = 0.0 )

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
