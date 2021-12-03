
declare sub line1x( x1 as integer = 0, y1 as integer = 0, x2 as integer = 0, y2 as integer = 0, fg as integer = 15 )

declare sub rect1x( x1 as integer = 0, y1 as integer = 0, x2 as integer = 0, y2 as integer = 0, fg as integer = 0 )

declare sub rectfill1x( x1 as integer = 0, y1 as integer = 0, x2 as integer = 0, y2 as integer = 0, bg as integer = 0 )

sub line1x( x1 as integer = 0, y1 as integer = 0, x2 as integer = 0, y2 as integer = 0, fg as integer = 15 )

	dim as integer x_adjust = 0, y_adjust = 0
			
	LINE ( x1, y1)-( x2, y2 ), fg

end sub


sub rect1x( x1 as integer = 0, y1 as integer = 0, x2 as integer = 0, y2 as integer = 0, fg as integer = 0 )
			
	LINE ( x1, y1)-( x2, y2 ), fg, b

end sub

sub rectfill1x( x1 as integer = 0, y1 as integer = 0, x2 as integer = 0, y2 as integer = 0, bg as integer = 0 )
	
	LINE ( x1, y1 )-( x2, y2 ), bg, bf
	
end sub
