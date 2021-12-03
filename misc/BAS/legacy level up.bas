DEFINT A-Z
SUB loadlvupdata (lvupfile$)

	load_names_by_file( "RES\CONFIG\" + sync_name( "file_lvup", config_table() ), level_table())

	for ti% = lbound( level_table, 1 ) to ubound( level_table, 1 ) step 1
	lv(ti%) = val( sync_name( ltrim$( str$( ti% ) ), level_table() ) )
	next ti%

	exit sub
	
	filemode% = FREEFILE
	OPEN ".\RES\STATS\" + lvupfile$ FOR INPUT AS #filemode%

	ti% = 0
	DO WHILE NOT (EOF(filemode%))
		INPUT #filemode%, lv(ti%)
		IF ti% >= 64 THEN EXIT DO
		ti% = ti% + 1
	LOOP

	CLOSE #filemode%

END SUB
