
declare sub sync_gfx( filename as string, lookup as string = "" )

declare SUB graphicput ( yy1%, xx1%, ss1$, special as integer = 1 )

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
