DEFINT A-Z
FUNCTION carddeckmath% (cardidty$, value$, op$)
	
	success% = 1
	
	REM cardvarget cardidty$, oldvalue$
	REM cardvarput cardidty$, oldvalue$ + oldvalue$
	
	SELECT CASE LEN(oldvalue$)
	CASE 0 TO 14 * 4
		SELECT CASE op$
		CASE "+"
			SELECT CASE FIX(LEN(oldvalue$) / 4)
			CASE IS < 15
				success% = cardvarset%(cardidty$, oldvalue$ + oldvalue$)
			CASE ELSE
				success% = 0
			END SELECT
		CASE "-"
			o% = 1
			DO WHILE FIX(o% / 4) <= FIX(LEN(oldvalue$) / 4)
				SELECT CASE MID$(oldvalue$, o%, 4)
				CASE value$
					SELECT CASE o% + 4
					CASE IS <= LEN(oldvalue$)
						temp$ = MID$(oldvalue$, o% + 4)
					CASE ELSE
						temp$ = STRING$(0, 0)
					END SELECT
				
					oldvalue$ = LEFT$(oldvalue$, o% - 1) + temp$
					EXIT DO
				END SELECT
				o% = o% + 4
			LOOP
		END SELECT
	CASE IS > 15
		success% = 0
	CASE ELSE
		success% = 0
	END SELECT
	
	carddeckmath% = success%
END FUNCTION

DEFSNG A-Z
SUB cardload (cardidty$)

	card$ = STRING$(0, 0)

	filemode% = FREEFILE

	OPEN ".\res\cards\" + cardidty$ + ".dat" FOR INPUT AS filemode%

	REM GOSUB prflblnk

	dice% = 0
	roll% = 0

	DO WHILE NOT (EOF(filemode%))
		LINE INPUT #filemode%, rr$
		
		SELECT CASE LEFT$(rr$, 1)
		CASE "?"
			
			SELECT CASE INSTR(1, rr$, ":")
			CASE 6
				
	SELECT CASE MID$(rr$, 2, 4)
				CASE "?roll:"
					success% = cardvarset%("prflroll!", LTRIM$(STR$(diceroll%)))
	CASE "?dice:"
					
		SELECT CASE MID$(rr$, INSTR(1, rr$, ":") + 5, 4)
		CASE " to "
			success% = cardvarget%("prflroll!", value$)
			dice% = VAL(value$)
						
			SELECT CASE dice%
			CASE IS >= VAL(MID$(rr$, INSTR(1, rr$, " to ") - 4, 4))
							
				SELECT CASE dice%
				CASE IS <= VAL(MID$(rr$, INSTR(1, rr$, " to ") + 4, 4))
					
		op$ = MID$(rr$, INSTR(1, rr$, " to ") + 9, 1)
		o% = 10
		DO WHILE o% + 3 < LEN(rr$)
			success% = carddeckmath%(cardidty$, MID$(rr$, o%, 4), op$)
			o% = o% + 4
		LOOP
				END SELECT
				
			END SELECT
			
		END SELECT
					
	END SELECT
	
			END SELECT
			
		END SELECT
		
REM
REM        varmode$ = "set"
REM
REM        SELECT CASE varmode$
REM        CASE "get"
REM         success% = cardvarget%(tag$, value$)
REM        CASE "set"
REM         success% = cardvarset%(tag$, value$)
REM        CASE ELSE
REM         success% = 0
REM        END SELECT
REM
REM    GOSUB prflset
REM   SELECT

LOOP

CLOSE #filemode%
END SUB

DEFINT A-Z
FUNCTION cardstatmath% (cardidty$, value$, op$)
	success% = cardvarget%(cardidty$, oldvalue$)
	old% = VAL(oldvalue$)
	
	success% = 1
	
	SELECT CASE op$
	CASE "+"
		success% = cardvarset%(cardidty$, LTRIM$(STR$(old% + VAL(value$))))
	CASE "-"
		success% = cardvarset%(cardidty$, LTRIM$(STR$(old% - VAL(value$))))
	CASE "*"
		success% = cardvarset%(cardidty$, LTRIM$(STR$(old% * VAL(value$))))
	CASE "/"
		IF VAL(value$) <> 0 THEN
			success% = cardvarset%(cardidty$, LTRIM$(STR$(old% / VAL(value$))))
		ELSE
			success% = 0
		END IF
	CASE ELSE
		success% = 0
	END SELECT
	cardstatmath% = success%
END FUNCTION

DEFSNG A-Z
FUNCTION cardvarget% (tag$, value$)
	
	success% = 1
	
	SELECT CASE RIGHT$(tag$, 1)
	CASE "$"
		
		SELECT CASE MID$(tag$, 5)
		CASE "idty"
			prflidty$ = value$
		CASE "actn"
			prflactn$ = value$
		CASE "gpic"
			prflgpic$ = value$
		CASE ELSE
			success% = 0
		END SELECT
	
	CASE "!"
		SELECT CASE MID$(tag$, 5)
		CASE "idty"
			value$ = LTRIM$(STR$(prflidty!))
		CASE "hp"
			value$ = LTRIM$(STR$(prflhp!))
		CASE "str"
			value$ = LTRIM$(STR$(prflstr!))
		CASE "ess"
			value$ = LTRIM$(STR$(prfless!))
		CASE "spd"
			value$ = LTRIM$(STR$(prflspd!))
		CASE "armr"
			value$ = LTRIM$(STR$(prflarmr!))
		CASE "exp"
			value$ = LTRIM$(STR$(prflexp!))
		CASE "valu"
			value$ = LTRIM$(STR$(prflvalu!))
		CASE "pirc"
			value$ = LTRIM$(STR$(prflpirc!))
		CASE "lv"
			value$ = LTRIM$(STR$(prfllv!))
		CASE "hpmax"
			value$ = LTRIM$(STR$(prflhpmax!))
		CASE "strmax"
			value$ = LTRIM$(STR$(prflstrmax!))
		CASE "essmax"
			value$ = LTRIM$(STR$(prflessmax!))
		CASE "essspd"
			value$ = LTRIM$(STR$(prflessspd!))
		CASE "evad"
			value$ = LTRIM$(STR$(prflevad!))
		CASE ELSE
			success% = 0
		END SELECT
	CASE ELSE
			success% = 0
	END SELECT
	
	cardvarget% = success%

END FUNCTION

FUNCTION cardvarset% (tag$, value$)
	
	success% = 1
	
	SELECT CASE RIGHT$(tag$, 1)
	CASE "$"
		
		SELECT CASE MID$(tag$, 5)
		CASE "idty"
			prflidty$ = value$
		CASE "actn"
			prflactn$ = value$
		CASE "gpic"
			prflgpic$ = value$
		CASE ELSE
			success% = 0
		END SELECT
	
	CASE "!"
		SELECT CASE MID$(tag$, 5)
		CASE "idty"
			prflidty! = VAL(value$)
		CASE "hp"
			prflhp! = VAL(value$)
		CASE "str"
			prflstr! = VAL(value$)
		CASE "ess"
			prfless! = VAL(value$)
		CASE "spd"
			prflspd! = VAL(value$)
		CASE "armr"
			prflarmr! = VAL(value$)
		CASE "exp"
			prflexp! = VAL(value$)
		CASE "valu"
			prflvalu! = VAL(value$)
		CASE "pirc"
			prflpirc! = VAL(value$)
		CASE "lv"
			prfllv! = VAL(value$)
		CASE "hpmax"
			prflhpmax! = VAL(value$)
		CASE "strmax"
			prflstrmax! = VAL(value$)
		CASE "essmax"
			prflessmax! = VAL(value$)
		CASE "essspd"
			prflessspd! = VAL(value$)
		CASE "evad"
			prflevad! = VAL(value$)
		CASE ELSE
			success% = 0
		END SELECT
	CASE ELSE
		success% = 0
	END SELECT
	cardvarset% = success%
END FUNCTION
