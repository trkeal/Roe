declare function just_cardname( filename as string ) as string

declare function load_sprite( img As Any Ptr, filename as string = "" ) as string

declare sub putplane (img As Any Ptr, y as integer, w as integer, bb as integer, byref buffer as string )

declare sub sprite_put( dest As Any Ptr, x as integer, y as integer, filename as string = "", op as string = "xor" )

function load_sprite( img As Any Ptr, filename as string = "" ) as string
	
	dim c as string =  string$( 0, 0 )
	dim as integer z = 0, w = 0, h = 0
	dim as integer y = 0, b = 0
	dim as integer filemode = freefile
	dim as string header = string$( 0, 0 ), buffer = string$( 0, 0 )
	
	dim as string ret = string$( 0, 0 )
	
	'ret += "filename:"+chr$(34)+filename+chr$(34)+chr$(13)+chr$(10)
	
	if open( filename for binary as #filemode ) then
		
		'text Dest, 1, 1, filename, 0, 14, 6, -2
		
		close #filemode
		img = imagecreate( 24, 24, 0, 8 )
		
		'for offset = 0 to 5
		'
		'	line img,( offest, 0 )-( 23-offset, 23 ),12
		'	line img,( 23-offest, 0 )-( offset, 23 ),12
		'	
		'next offset
		
		for offset = 0 to 5
		
			select case offset and 1
			case 0
				line img,( 5-offset, 0 )-( 23-offset, 23 ),12,,&HAAAA
			case 1
				line img,( 23-offset, 0 )-( 5-offset, 23 ),12,,&HAAAA
			end select
			
		next offset
		
		load_sprite = ret
		'print ret
		exit function
	
	else
		buffer = string$( lof( filemode ), 0 )
		get #filemode, 1, buffer
		close #filemode
		
	end if
				
	header = left$( buffer, 11 )
	buffer = mid$( buffer, len( header ) + 1 )

				c = left$( header, 1 )
				
	if asc(c) <> &HFD then
		load_sprite = ret
		exit function
	end if

	z = cvshort( mid$( header, 6 , 2 ) ) and 32767
	w = cvshort( mid$( header, 8 , 2 ) ) and 32767
	h = cvshort( mid$( header, 10 , 2 ) ) and 32767
	
	'ret += "h:"+str$(len(header))+chr$(13)+chr$(10)
	'ret += "b:"+str$(len(buffer))+chr$(13)+chr$(10)
	'ret += "z:"+str$(z)+chr$(13)+chr$(10)
	'ret += "w:"+str$(w)+chr$(13)+chr$(10)
	'ret += "h:"+str$(h)+chr$(13)+chr$(10)

				img = imagecreate( w, h, 0, 8 )
		
	for y = 0 to h - 1 step 1
								for b = 0 to 3 step 1
											 putplane img, y, w, 2 ^ b, buffer
								next b
				next y
			
	'line img,( 0, 0 )-( 23, 23 ),2
	'line img,( 0, 23 )-( 23, 0 ),2
		
		'for offset = 0 to 5
		'
		'	select case offset and 1
		'	case 0
		'		line img,( 5-offset, 0 )-( 23-offset, 23 ),12,,&HAAAA
		'	case 1
		'		line img,( 23-offset, 0 )-( 5-offset, 23 ),12,,&HAAAA
		'	end select
		'	
		'next offset


	load_sprite = ret
	
	'print ret
	'flip
	'while inkey$="":wend
	
	exit function
	
end function

sub putplane (img As Any Ptr, y as integer, w as integer, bb as integer, byref buffer as string )

				dim c as string = string$( 1, 0 ), cb as integer
				dim x as integer
				c = " "

				for x = 0 to w - 1 step 1
								if (x and 7) = 0 then
			c = left$( buffer, 1 )
			cb = asc(c)
			buffer = mid$( buffer, 2 )
		end if

								pset img, (x, y), point(x, y, img) xor (bb and -cb \ 128)

								cb = cb + cb and &HFF
				next x

end sub

function ord_series( subject as string = "" ) as integer
	
	dim as integer offset = 0, result = 0
	
	for offset = 1 to len(subject) step 1
		result = ( result shl 8 ) or asc( mid$( subject, offset, 1 ) )
	next offset
	
	ord_series = result
	
end function

sub sprite_put( dest As Any Ptr, x as integer, y as integer, filename as string = "", op as string = "xor" )
	
	Dim As Any Ptr img

	if len( filenmae ) = 0 then
		text Dest, (y+0),(x+0),"bad",0,14,6,-2
		exit sub
	end if

	load_sprite img, filename
	
	dim as integer xx = ( x - 1 ) * 8, yy = ( y - 1 ) * 8
	
	select case dest
	case 0
		select case op
		case "xor"
			put ( xx, yy ), img, xor
		case "or"
			put ( xx, yy ), img, or
		case "and"
			put ( xx, yy ), img, and
		case "pset"
			put ( xx, yy ), img, pset
		case "preset"
			put ( xx, yy ), img, preset
		end select
	case else
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
		end select
	end select
	
	imagedestroy img

	exit sub

	if debugmode then
		text Dest, 20,1, "justcard:" + chr$( 34 ) + left$( just_cardname( filename ), 4 ) + chr$( 34 ), 0, 12, 0, -2
	end if
	
	sync_gfx "", left$( just_cardname( filename ), 4 )

	if debugmode then
		text Dest, 22,1, _
			"filename:" + chr$( 34 ) + filename + chr$( 34 ), 0, 12, 0
	end if
		
end sub

sub sync_gfx( filename as string, lookup as string = "" )
	
	dim filemode as integer = freefile, e = 0, miss = 0, hit = 0

	dim as string r = "", label = "", value = "", temp = "", card = ""

	if len( filename ) = 0 then
		filename = "res\config\binding.cfg"
	end if

	if len(sync_data) = 0 then

		e = open( filename for input as #filemode )
	
		if e then
			exit sub
		end if
		
		sync_data = string$( lof( filemode ), 0 )
		
		get #filemode, 1, sync_data
		
	end if
	
	load_binding_options lookup
	
end sub

DEFINT A-Z
SUB graphicput ( yy1%, xx1%, ss1$, special as integer = 1 )
	
	dim as integer special_text = 1
	
	dim as string path = "res\sprites\"
	dim as string erasure_mask = "", shade_mask = ""
	dim as string justss = "", scaless = ""
	dim as integer scale = 0

	scaless = ss1$
	do while instr( 1, scaless, "." ) > 0
		scaless = mid$( scaless, instr( 1, scaless, "." ) + 1 )
	loop
	
	'scaless = left$( scaless, len( scaless ) - 1 )
	
	scale = val( scaless )
	
	justss = just_cardname( ss1$ )
				
	justss += string$( 8 - len( justss ), "_" )

	if justss = string$( 8, "_" ) then
		exit sub
	end if
	
	erasure_mask = justss + "." + scaless + "y"
	shade_mask = justss + "." + scaless + "x"
	
	sprite_put 0, xx1%, yy1%, path + erasure_mask, "and"
	sprite_put 0, xx1%, yy1%, path + shade_mask$, "or"

	'if special and special_text then
	'
	'	if left$( justss, 4 ) <> string$( 4, "_" ) then
	'		text Dest, yy1%+1, xx1%, left$( justss, 4 ), 0, 15, 0, -2
	'	end if
	'	
	'	if mid$( justss, 5, 4 ) <> string$( 4, "_" ) then
	'		text Dest, yy1%+2, xx1%, mid$( justss, 5, 4 ), 0, 15, 0, -2
	'	end if
	'end if
	
	'if debugmode then
	'	text Dest, 20, 1, path + erasure_mask, 0, 14, 6, -1
	'	text Dest, 21, 1, path + shade_mask, 0, 14, 6, -1
	'end if
	
END SUB
