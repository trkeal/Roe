
#lang "fblite"
option gosub

#include once "crt/math.bi"
#include once "file.bi"
'#include once "windows.bi"
#include once "fbgfx.bi"

declare sub load_sprite( img As Any Ptr, filename as string = "" )

declare sub sprite_put( dest As Any Ptr, x as integer, y as integer, filename as string = "", op as string = "xor" )

sub load_sprite( img As Any Ptr, filename as string = "" )
	dim c as string = string$( 0, 0 )
	dim as integer z = 0, w = 0, h = 0, ww = 0, hh = 0
	dim as integer y = 0, b = 0
	dim as integer cb = 0, x = 0

	dim as integer filemode = freefile
	dim as string header = string$( 0, 0 ), buffer = string$( 0, 0 )
	
	dim as string ret = string$( 0, 0 )
	
	if open( filename for binary as #filemode ) then
		
		close #filemode
		img = imagecreate( 24, 24, 0, 8 )
		
		for offset = 0 to 5
			
			select case offset and 1
			case 0
				line img,( 5-offset, 0 )-( 23-offset, 23 ),12,,&HAAAA
			case 1
				line img,( 23-offset, 0 )-( 5-offset, 23 ),12,,&HAAAA
			end select
			
		next offset
		
		exit sub
		
	else
		buffer = string$( lof( filemode ), 0 )
		get #filemode, 1, buffer
		close #filemode
		
	end if
		
	header = left$( buffer, 11 )
	buffer = mid$( buffer, len( header ) + 1 )
	
	c = left$( header, 1 )
	
	if asc(c) <> &HFD then
		exit sub
	end if
	
	z = cvshort( mid$( header, 6 , 2 ) ) and 32767
	w = cvshort( mid$( header, 8 , 2 ) ) and 32767
	h = cvshort( mid$( header, 10 , 2 ) ) and 32767
	
	if w = 25 and h = 25  then
		img = imagecreate( 24, 24, 0, 8 )
		ww = 24
		hh = 24
	else
		img = imagecreate( w, h, 0, 8 )
		ww = w
		hh = h
	end if
	
	for y = 0 to h - 1 step 1
		for b = 0 to 3 step 1			
			for x = 0 to w - 1 step 1
				
				if (x and 7) = 0 then			
					cb = asc( left$( buffer, 1 ) )
					buffer = mid$( buffer, 2 )			
				end if

				pset img, (x, y), point(x, y, img) xor ( ( 1 shl b ) and -cb \ &H80 )
				
				cb = cb + cb and &HFF
			
			next x
		next b
	next y
	
	dim image2x as any ptr
	image2x = imagecreate( ww shl 1, hh shl 1, 0, 8 )
	
	for y = 0 to hh - 1 step 1
	for x = 0 to ww - 1 step 1
		line image2x, ( x shl 1, y shl 1 )-( ( x shl 1 ) or 1, ( y shl 1 ) or 1 ), point( x, y, img ), bf
	next x
	next y
	
	imagedestroy img
	img = image2x
	
	exit sub
	
end sub

sub sprite_put( dest As Any Ptr, x as integer, y as integer, filename as string = "", op as string = "xor" )
	
	Dim As Any Ptr img
		
	load_sprite img, filename
	
	'dim as integer xx = ( x - 1 ) * 8, yy = ( y - 1 ) * 8
	
	dim as integer xx = x shl 1, yy = y shl 1
	
	select case op
	case "xor"
		put dest, ( xx, yy ), img, xor
	case "or"
		put dest, ( xx, yy ), img, or
	case "and"
		put dest, ( xx, yy ), img, and
	case "pset"
		put dest, ( xx, yy ), img, pset
	case "preset"
		put dest, ( xx, yy ), img, preset
	case else
		put dest, ( xx, yy ), img, xor
	end select
	
	imagedestroy img
	
	exit sub	
	
end sub