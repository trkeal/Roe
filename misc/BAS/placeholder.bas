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

