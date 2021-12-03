
sub talk_hud( filename as string = "pndx" )
	
	redim as names_type talk_table( any )
	
	load_names( "data\talk\" + filename + ".dat", talk_table() )
	
	dim as string talk_buffer
	talk_buffer = string$( 0, 0 )
	
	dim as integer talk_index = 1, talk_count = val( sync_names( "talk/count", talk_table() ) )
	
	talk_index = fix( rnd( 1 ) * talk_count ) + 1
	
	talk_buffer += name_as_string( sync_names( "talk/" + ltrim$( str$( talk_index ) ), talk_table() ) )

	#ifdef __encounter_debug__
		kill "res\talk hud.txt"
		save_names( "res\talk hud.txt", talk_table() )
	#endif
	
	encounter_hud( filename, name_as_string( sync_names( "talk/name", talk_table() ) ), talk_buffer )
	
end sub
