
declare sub load_gamedata()

sub load_gamedata()
	screenres 960,720,8,8
	screenset 0,1
	
	rosecard = 0
	roseaxis = 0
'redim shared as names_type gamedata_table( any )

	'load_names "res\rose.dat", gamedata_table()
	
	rosecardmin = val( sync_names( "rose/card/min", gamedata_table() ) )
	rosecardmax = val( sync_names( "rose/card/max", gamedata_table() ) )
	roseaxismin = val( sync_names( "rose/axis/min", gamedata_table() ) )
	roseaxismax = val( sync_names( "rose/axis/max", gamedata_table() ) )

	redim preserve rose( rosecardmin to rosecardmax, roseaxismin to roseaxismax )
	redim preserve rosekey( rosecardmin to rosecardmax )
	redim preserve d( rosecardmin to rosecardmax, roseaxismin to roseaxismax )
	
	for rosecard = rosecardmin to rosecardmax step 1
	for roseaxis = roseaxismin to roseaxismax step 1
	
		rose( rosecard, roseaxis ) = val( sync_names( "rose(" + ltrim$( str$( rosecard ) ) + "," + ltrim$( str$( roseaxis ) ) + ")", gamedata_table() ) )
		
		d( rosecard, roseaxis ) = rose( rosecard, roseaxis )
		
		gtext 40 + roseaxis*2, 20 + rosecard * 7, 15, 0, ltrim$(str$(rose( rosecard, roseaxis )))

	next roseaxis
		
		'rosekey( rosecard ) = name_as_string( sync_names( "rose/key/" + ltrim$( str$( rosecard ) ), gamedata_table() ) )

		'gtext 40 + roseaxis*2, 20 + rosecard * 7, 15, 0, rosekey( rosecard )

		gtext 40, 20 + rosecard * 7, 15, 0, name_as_string( sync_names( "rose/key/" + ltrim$( str$( rosecard ) ), gamedata_table() ) )

	next rosecard


	'load_names( "res\gamedata.dat", gamedata_table() )
	
	'save_names( "res\gamedata.txt", gamedata_table() )
	
	stat = 0
	member = 0
	spell = 0

	membercount = val( sync_names( "party/count", gamedata_table() ) )
	spellcount = val( sync_names( "spell/count", gamedata_table() ) )
	statcount = val( sync_names( "stat/count", gamedata_table() ) )

	redim preserve memberimage( 1 to membercount )

	redim preserve membername( 1 to membercount )
	redim preserve spellname( 1 to spellcount )
	redim preserve statname( 1 to statcount )

	redim preserve difficulty( 1 to spellcount )

	redim preserve knowledge( 1 to membercount, 1 to spellcount )
	redim preserve experience( 1 to membercount, 1 to spellcount )

	redim preserve initialstats( 1 to membercount, 1 to statcount )
	redim preserve currentstats( 1 to membercount, 1 to statcount )
	
	for member = 1 to membercount step 1
		
		membername( member ) = name_as_string( sync_names( "party/" + ltrim$( str$( member ) ) + "/name", gamedata_table() ) )
	
		memberimage( member ) = sync_names( "party/" + membername( member ) + "/image", gamedata_table() )
		
		sprite_put 0, 0, ( member - 1 ) * 8, "tiles\party\" + ucase$( memberimage( member ) ) + "_001.TIL", "pset"

		gtext member, 3, 15, 0, membername( member )
	
	next member
	
	for stat = 1 to statcount step 1
		
		statname( stat ) = name_as_string( sync_names( "stat/" + ltrim$( str$( stat ) ) + "/name", gamedata_table() ) )
		
		gtext stat, 15, 15, 0, statname( stat )

	next stat
	
	for spell = 1 to spellcount step 1
		
		spellname( spell ) = name_as_string( sync_names( "spell/" + ltrim$( str$( spell ) ) + "/name", gamedata_table() ) )
		difficulty( spell ) = val( sync_names( "spell/" + spellname( spell ) + "/difficulty", gamedata_table() ) )
		
		gtext spell, 25, 15, 0, spellname( spell )
		gtext spell, 35, 15, 0, ltrim$( str$( difficulty( spell ) ) )

	next spell

	for member = 1 to membercount step 1
	for spell = 1 to spellcount step 1
		
		knowledge( member, spell ) = val( sync_names( "party/" + membername( member ) + "/spell/" + spellname( spell ) + "/knw", gamedata_table() ) )
		
		experience( member, spell ) = val( sync_names( "party/" + membername( member ) + "/spell/" + spellname( spell ) + "/exp", gamedata_table() ) )
		
		gtext spell+10, member*7, 15, 0, truncate(str$(knowledge( member, spell )),3)
		gtext spell+10, member*7, 15, 0, truncate(str$(experience( member, spell )),3)

	next spell
	next member

	for member = 1 to membercount step 1
	for stat = 1 to statcount step 1

		initialstats( member, stat ) = val( sync_names( "party/" + membername( member ) + "/stat/" + statname( stat ) + "/initial", gamedata_table() ) )
		
		currentstats( member, stat ) = val( sync_names( "party/" + membername( member ) + "/stat/" + statname( stat ) + "/current" , gamedata_table() ) )

		gtext stat+20, member*7, 15, 0, truncate(str$(initialstats( member, stat )),3)
		gtext stat+20, member*7, 15, 0, truncate(str$(currentstats( member, stat )),3)

		
	next stat
	next member

	flip
	sleep


end sub
