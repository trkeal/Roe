SUB logoput (yy1%, xx1%, ss1$)
	SELECT CASE LEN(ss1$)
	CASE 11
		
		dim ta(0 to 56 * 56 + 5) as integer

		'dim as fb.image ptr timg

		ss2$ = ss1$ + "y"  
		'timg = loadbsv( "RES\LOGOS\" + ss2$,4)
		'PUT ((xx1% - 1) * 8, (yy1% - 1) * 8), timg, AND
		'imagedestroy timg
		
		ss3$ = ss1$ + "x"
		'timg = loadbsv( "RES\LOGOS\" + ss3$,4)
		'PUT ((xx1% - 1) * 8, (yy1% - 1) * 8), timg, OR
		'imagedestroy timg
		
	CASE ELSE
		LOCATE yy1% + 1, xx1% + 1: PRINT ".";
	END SELECT
REM''END IF

END SUB
