
	dim shared as integer rosecard = 0, roseaxis = 0, rosecardmin = 0, rosecardmax = 0, roseaxismin = 0, roseaxismax = 0

	redim shared as integer rose( any, any ), rosekey( any ), d( any, any )
	
	dim shared as integer stat = 0, member = 0, spell = 0

	dim shared as integer membercount = 0, spellcount = 0, statcount = 0

	redim shared as string memberimage( any ), membername( any ), spellname( any ), statname( any )

	redim shared as integer difficulty( any ), knowledge( any, any ), experience( any, any )

	redim shared as integer initialstats( any, any ), currentstats( any, any )
