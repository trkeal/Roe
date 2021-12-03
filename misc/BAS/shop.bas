
sub shop()
	
	dim as string menu = string$( 0, 0 )
	dim as integer index = 0
	
	redim as nametype level_table( Any ), item_table( Any )
	
	dim as string identity = MID$(e$(tx + (ty - 1) * AA, 2), 1, 4), experience = G(tx + (ty + -1) * AA, 6)
	dim as integer level = G(tx + (ty - 1) * AA, 10)
	
	dim as integer level_requirement = 0, experience_cost = 0
	
	load_names_by_file "\res\dat\level\" + identity + ".dat", level_table()

	load_items_by_file "\res\dat\shop\" + identity + ".dat", shop_table()
	
	for index = lbound( shop_table, 1 ) to ubound( shop_table, 1) step 1
		
		redim item_table( Any )
		
		load_names_by_buffer shop_table( index ).value, item_table(), ";", "::"
		
		item = sync_name( "item", item_table() );
		
		experience_cost = mkl$( val( sync_name( "cost", item_table() ) ) ) ;
		
		level_requirement = val( sync_name( "lreq", item_table() ) );
		
		if level >= level_requirement then
		
			if experience >= cost then
			end
		
		end if
	
	next index

end sub