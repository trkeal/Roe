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
