sub quitoutro( Dest as any ptr )
	
	IF c$ = sync_name( "quit", names_table() ) THEN
		
		c$ = string$( 0, 0 )
		
		dim as double timerstart = timer
		
		screenset 1, 0
		color 15, 0
		cls
		
		dim as integer index = 0

		dim as string outro = "Goodnight Sweet Prince.."
		outro = string$( 2 + len(outro) * .325 , 32 ) + outro + string$( 2, 32 )
		
		redim as any ptr outroimage( any )
		redim as integer outro_w( any )
		redim as integer outro_h( any )
		
		redim outroimage( 0 to 1 )

		for index = lbound( outroimage, 1 ) to ubound( outroimage, 1 ) step 1
			imagedestroy outroimage( index )
		next index
		
		outroimage( 0 ) = imagecreate( len( outro ) * 8, 8, 0, 8)

		text outroimage( 0 ), 1, 1, outro, 0,13, 5, -2
		
		outroimage( 1 ) = imagecreate( 640, 32, 0, 8 )
		
		redim outro_w( lbound( outroimage, 1 ) to ubound( outroimage, 1 ) )
		redim outro_h( lbound( outroimage, 1 ) to ubound( outroimage, 1 ) )
		
		for index = lbound( outroimage, 1 ) to ubound( outroimage, 1 ) step 1
			imageinfo outroimage( index ), outro_w( index ), outro_h( index )
		next index

		region_scaler outroimage()
					
		put Dest, ( 319 - outro_w( 1 ) / 2, 239 - outro_h( 1 ) / 2 ), outroimage( 1 ), pset
		screencopy 1,0

		timerstart = timer
		do while ( len( c$ ) = 0 ) and ( timer - timerstart < 5.35 )
			c$ = inkey
		loop
		
		END

	END IF
	
END SUB

function image_scaler( source as any ptr, dest_w as integer = 24, dest_h as integer = 24 ) as any ptr
	
	dim as single rsng = 0.0, rrsng = 0.0
	dim as string rstr = "", rrstr = "", texts = ""
	dim as integer col = 0, row = 0
	redim as any ptr img( any )
	redim img( 0 to 8 )

	redim as integer w( any ), h ( any )
	redim w( 0 to 8 ), h ( 0 to 8 )
	
	imageinfo source, w(0), h(0)
	
	if w( 0 ) = 25 and h( 0 ) = 25 then
		img( 1 ) = imagecreate( 24, 24, 0, 8 )
		put img( 1 ), ( 0, 0 ), source, pset	
	else
		img( 1 ) = imagecreate( w(0), h(0), 0, 8 )
		put img(1), ( 0, 0 ), source, pset
	end if

	img( 8 ) = imagecreate( dest_w, dest_h, 0, 8 )	
	
	imageinfo img( 1 ) , w(1), h(1)		
	imageinfo img( 8 ) , w(8), h(8)
	
	get source, ( 0, 0 ) - ( w( 1 ) - 1, h( 1 ) - 1 ), img( 1 )

	for y = 0 to  h( 8 ) - 1 step 1
	for x = 0 to  w( 8 ) - 1 step 1
		
		x2 = ( x * ( w( 1 ) - 1 ) ) / ( w( 8 ) - 1 )
		y2 = ( y * ( h( 1 ) - 1 ) ) / ( h( 8 ) - 1 )
		
		pset img( 8 ), ( x, y ),  point( x2, y2, img( 1 ) )
		
	next x
	next y
		
	imagedestroy img( 1 )
	
	image_scaler = img( 8 )
	
end function

sub region_scaler( img( Any ) as any ptr )
	
	if ( lbound( img, 1 ) <= 0 and ubound( img, 1 ) >= 1 ) = 0 then
		exit sub
	end if
	
	dim as integer index = 0, x = 0, y = 0
	
	redim as integer w( lbound( img, 1 ) to ubound( img, 1 ) ), h ( lbound( img, 1 ) to ubound( img, 1 ) )
	
	for index = lbound( img, 1 ) to ubound( img, 1 ) step 1
		imageinfo img( index ), w( index ), h( index )
	next 
	
	for y = 0 to  h( 1 ) - 1 step 1
	for x = 0 to  w( 1 ) - 1 step 1
		
		x2 = ( x * ( w( 0 ) - 1 ) ) / ( w( 1 ) - 1 )
		y2 = ( y * ( h( 0 ) - 1 ) ) / ( h( 1 ) - 1 )
		
		
		pset img( 1 ), ( x, y ),  point( x2, y2, img( 0 ) )
		
	next x
	next y
	
end sub

