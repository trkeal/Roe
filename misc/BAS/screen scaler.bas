
declare sub screen_scaler( srcpage as integer = 1, destpage as integer = 7 )

sub screen_scaler( srcpage as integer = 1, destpage as integer = 7 )
	
	redim as integer src( 0 to 319, 0 to 199)
	redim as integer dest( 0 to 639, 0 to 479)
		
	screenset srcpage, 0

	for y = 0 to ubound( src, 2 ) step 1
	for x = 0 to ubound( src, 1 ) step 1
		
		src( x, y ) = point( x, y )
		
	next x
	next y
	
	for y = 0 to ubound( dest, 2 ) step 1
	for x = 0 to ubound( dest, 1 ) step 1
		
		x2 = ( x * ubound( src, 1 ) ) / ubound( dest, 1 )
		y2 = ( y * ubound( src, 2 ) ) / ubound( dest, 2 )
		
		dest( x, y ) = src( x2, y2 )
		
	next x
	next y
	
	screenset destpage, 0
	
	for y = 0 to ubound( dest, 2 ) step 1
	for x = 0 to ubound( dest, 1 ) step 1
		
		pset ( x, y ), dest( x, y )
		
	next x
	next y
	
	screenset srcpage, 0
	screencopy destpage, srcpage
	screencopy srcpage, 0
	
end sub
