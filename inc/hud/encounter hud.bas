
'''redim shared as names_type text_table( any )

declare sub encounter_hud( filename as string = "pndx", caption as string = "%%", subject as string = "" )

'#ifdef __encounter_script__
declare sub encounter_sync( filename as string = "pndx", caption as string = "%%", subject as string = "", text_table() as names_type )

declare sub encounter_text( filename as string = "pndx", caption as string = "%%", subject as string = "" )

declare sub load_encounter( filename as string = "pndx", encounter_table() as names_type )

sub load_encounter( filename as string = "pndx", encounter_table() as names_type )
	load_names( "data\talk\" + filename + ".dat", encounter_table() )
end sub

sub encounter_sync( filename as string = "pndx", caption as string = "%%", subject as string = "", text_table() as names_type )
	'''redim text_table( 0 )

	dim as string buffer = string$( 0, 0 ), sep = string$( 1 , 32 ), dump = string$( 0, 0 )
	dim as integer counter = 0
	buffer = subject
	
	do while instr( 1, buffer, sep ) > 0
		
		counter += 1
		
		dump += "text/" + ltrim$( str$( counter ) ) + "=" + left$( buffer, instr( 1, buffer, sep ) - 1 ) + crlf
		
		buffer = mid$( buffer, instr( 1, buffer, sep ) + 1 )
	loop
				
	if len( buffer ) > 0 then
		counter += 1
		dump += "text/" + ltrim$( str$( counter ) ) + "=" + buffer + crlf
	end if
	
	dump = "text/count=" + ltrim$( str$( counter ) ) + crlf + dump
	
	load_names_from_buffer( dump, text_table() )

#ifdef __encounter_debug__
	kill "res\encounter\" + filename + ".txt"
	save_names( "res\encounter\" + filename + ".txt", text_table() )
#endif

end sub

sub encounter_text( filename as string = "pndx", caption as string = "%%", subject as string = "" )
	
	dim as integer talkcount = 0, talkindex = 0 
	
	redim as names_type text_table( any ), encounter_table( any )
	
	#ifdef __test_encounter__
		filename = "pndx"
		
		caption="Poindexter"
		
		subject=string$( 0, 0 )
		
		subject+="Hi. How are you. My" + string$( 1, 32 )
		subject+="name is Poindexter. I" + string$( 1, 32 )
		subject+="am the greatest thief" + string$( 1, 32 )
		subject+="in the entire world!!"
	#else
		load_encounter( filename, encounter_table() )
		
		caption=name_as_string( sync_names( "talk/name", encounter_table() ) )

		talkcount = val( sync_names( "talk/count", encounter_table() ) )
		talkindex = fix(rnd(1)*talkcount)+1
		subject = sync_names( "talk/"+ltrim$(str$(talkindex)), encounter_table() )
		
	#endif
	
	dim as integer x1 = 24, y1 = 1, x2 = 40, y2 = 23, w = 0, h = 0, textcount = 0, counter = 0, x = 1, y = 1
	
	encounter_sync( filename, caption, subject, text_table() )

	dim as names_type huds(any)
	
	load_names ( "data\hud\hud data.dat", huds() )
	
	x1 = val( sync_names( "hud/encounter/border/x1", huds() ) )
	y1 = val( sync_names( "hud/encounter/border/y1", huds() ) )
	x2 = val( sync_names( "hud/encounter/border/x2", huds() ) )
	y2 = val( sync_names( "hud/encounter/border/y2", huds() ) )

	dim as string chunk = string$( 0, 0 ), word = string$( 0, 0 ), buffer = string$( 0, 0 ), sep = string$( 1, 32 )

	buffer = subject
	
	w = x2 - x1 - 1
	h = y2 - y1 - 1
	
	border( x1, y1, x2, y2, -1 )
		
	y+=2
	
	textcount = val( sync_names( "text/count", text_table() ) )
	
	text y1+1, x1+1, caption + ":", 9
	
	'''caption + ":" + sync_names( "text/count", text_table() ), 12
	
	for counter = 1 to textcount step 1
		
		word = sync_names( "text/"+ltrim$(str$(counter)), text_table() )
		
		while len( chunk ) > w
			text y1+y, x1+x, left$(chunk,w), 15
			y+=1
			chunk = mid$(chunk,w+1)
		wend

		if len(chunk) > 0 then
			if len( chunk + sep + word ) > w then
				text y1+y, x1+x, chunk, 15
				y+=1
				chunk = word
			else
				chunk += sep + word		
			end if
		else
			chunk = word		
		end if
	next counter

  	'text 5, viewx, "Poindexter:", 0
	'text 6, viewx, "Hi. How are you. My", 0
	'text 7, viewx, "name is Poindexter. I", 0
	'text 8, viewx, "am the greatest thief", 0
	'text 9, viewx, "in the entire world!!", 0
	x1 = val( sync_names( "hud/encounter/border/x1", huds() ) )
	
	graphicput y1, x2-3, "bsv\sprites\" + sync_names("talk/image", encounter_table() ) + "____.24"

	
	if len(chunk) > 0 then
		'gtext y1+y, x1+x, 12, 4, chunk
		text y1+y, x1+x, chunk, 15
	end if
	
end sub
'#endif

sub encounter_hud( filename as string = "pndx", caption as string = "%%", subject as string = "" )
	
	dim as integer x1 = 41, y1 = 26, x2 = 60, y2 = 45
	
	dim as names_type huds( any )
	
	load_names ( "data/hud data.dat", huds() )
	
	x1 = val( sync_names( "hud/encounter/border/x1", huds() ) )
	y1 = val( sync_names( "hud/encounter/border/y1", huds() ) )
	x2 = val( sync_names( "hud/encounter/border/x2", huds() ) )
	y2 = val( sync_names( "hud/encounter/border/y2", huds() ) )
	
	w = x2 - x1 + 1
	h = y2 - y1 + 1
	
	'''border( x1, y1, x2, y2, -1 )
	
	encounter_text( filename, caption, subject )
	'gtext y1, x1, 12, 4, subject
	
end sub
