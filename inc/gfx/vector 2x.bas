
declare sub line1x( x1 as integer = 0, y1 as integer = 0, x2 as integer = 0, y2 as integer = 0, fg as integer = 15 )

declare sub rect1x( x1 as integer = 0, y1 as integer = 0, x2 as integer = 0, y2 as integer = 0, fg as integer = 0 )

declare sub rectfill1x( x1 as integer = 0, y1 as integer = 0, x2 as integer = 0, y2 as integer = 0, bg as integer = 0 )

sub line1x( x1 as integer = 0, y1 as integer = 0, x2 as integer = 0, y2 as integer = 0, fg as integer = 15 )

	dim as integer x_adjust = 0, y_adjust = 0
	
	for y_adjust = 0 to 1 step 1
	for x_adjust = 0 to 1 step 1
		
		LINE ( x1 shl 1 or x_adjust, y1 shl 1 or y_adjust)-( x2 shl 1 or x_adjust, y2 shl 1 or y_adjust), fg
	
	next x_adjust
	next y_adjust
end sub


sub rect1x( x1 as integer = 0, y1 as integer = 0, x2 as integer = 0, y2 as integer = 0, fg as integer = 0 )
	
	dim as integer x_adjust = 0, y_adjust = 0
	
	for y_adjust = 0 to 1 step 1
	for x_adjust = 0 to 1 step 1
		
		LINE ( x1 shl 1 or x_adjust, y1 shl 1 or y_adjust)-( x2 shl 1 or x_adjust, y2 shl 1 or y_adjust), fg, b
	
	next x_adjust
	next y_adjust
end sub

sub rectfill1x( x1 as integer = 0, y1 as integer = 0, x2 as integer = 0, y2 as integer = 0, bg as integer = 0 )
	
	dim as integer x_adjust = 0, y_adjust = 0
	
	for y_adjust = 0 to 1 step 1
	for x_adjust = 0 to 1 step 1
		
		LINE ( x1 shl 1 or x_adjust, y1 shl 1 or y_adjust)-( x2 shl 1 or x_adjust, y2 shl 1 or y_adjust), bg, bf
	
	next x_adjust
	next y_adjust
end sub
