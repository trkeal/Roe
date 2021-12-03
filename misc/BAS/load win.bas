DIM SHARED wini%

DEFINT A-Z
SUB loadwin ()
	filemode% = FREEFILE
	OPEN ".\RES\config\" + sync_name( "file_win", config_table() ) FOR INPUT AS #filemode%

	IF NOT (EOF(filemode%)) THEN
		INPUT #filemode%, range%
		REDIM win(-range% TO 2 * range%)
	END IF

	ttt% = 0
	DO WHILE NOT (EOF(filemode%)) AND ttt% <= range%
	
		LINE INPUT #filemode%, rr$

		win(1 + (ttt% - 1) * 2) = VAL(LEFT$(rr$, INSTR(1, rr$, ",") - 1))
		win(2 + (ttt% - 1) * 2) = VAL(MID$(rr$, INSTR(1, rr$, ",") + 1))
	
		IF ttt% = range% THEN
			EXIT DO
		END IF

		ttt% = ttt% + 1

	LOOP

	CLOSE #filemode%

END SUB
