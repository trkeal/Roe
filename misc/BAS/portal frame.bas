
declare SUB renderframe ( Dest as any ptr, framex1!, framey1!, framex2!, framey2!, framec1% = 12, framec2% = 4, bg1% = 0, bg2% = 8)

declare SUB renderportal

DEFINT A-Z
SUB renderframe ( Dest as any ptr, framex1!, framey1!, framex2!, framey2!, framec1% = 12, framec2% = 4, bg1% = 0, bg2% = 8)
	
	dim as ulongint framex3 = 0, framey3 = 0
	dim as ulongint o = 0, px = 0
	
	dim as ulongint fx1 = ( fix( framex1! ) - 2 ) * 8 + 7
	dim as ulongint fy1 = ( fix( framey1! ) - 1 ) * 8 + 7
	
	dim as ulongint fx2 = ( fix( framex2! ) - 1 ) * 8
	dim as ulongint fy2 = ( fix( framey2! ) - 1 ) * 8
	
	dim as ulongint fxs = ( fx2 - fx1 ), fys = ( fy2 - fy1 )

	dim as ulongint fx3 = 0, fy3 = 0
	
	for o = 0 to fxs * fys - 1 step 1
		
		fx3 = o mod fxs
		fy3 = fix( o / fxs )
		
		if ( fx3 and 1 ) xor ( fy3 and 1 ) then
			if bg1% >= 0 then
				pset Dest, ( fx3 + fx1, fy3 + fy1 ), bg1%
			end if
		else
			if bg2% >= 0 then
				pset Dest, ( fx3 + fx1, fy3 + fy1 ), bg2%
			end if
		end if
		
	next o
	
	'LINE ((framex1! - 2) * 8 + 7, (framey1! - 1) * 8 + 7)-((framex2! - 1) * 8, (framey2! - 1) * 8), 0, BF
	
	LINE Dest, ((framex1! - 2) * 8 + 7, (framey1! - 1) * 8 + 5)-((framex2! - 1) * 8, (framey2! - 1) * 8 + 2), framec1%, B
	LINE Dest, ((framex1! - 2) * 8 + 5, (framey1! - 1) * 8 + 7)-((framex2! - 1) * 8 + 2, (framey2! - 1) * 8), framec1%, B
	LINE Dest, ((framex1! - 2) * 8 + 6, (framey1! - 1) * 8 + 6)-((framex2! - 1) * 8 + 1, (framey2! - 1) * 8 + 1), framec2%, B
	
	PSET Dest, ((framex1! - 2) * 8 + 6, (framey1! - 1) * 8 + 6), framec1%
	PSET Dest, ((framex2! - 1) * 8 + 1, (framey2! - 1) * 8 + 1), framec1%
	PSET Dest, ((framex1! - 2) * 8 + 6, (framey2! - 1) * 8 + 1), framec1%
	PSET Dest, ((framex2! - 1) * 8 + 1, (framey1! - 1) * 8 + 6), framec1%
	
END SUB

SUB renderportal

	framex1! = ((-3) * 3 + 13 - 1)
	framex2! = ((4) * 3 + 13 - 1)
	framey1! = ((-3) * 3 + 13 - 1) - 1
	framey2! = ((4) * 3 + 13 - 1)
	framec1% = 1
	framec2% = 9

	renderframe Dest, framex1!, framey1!, framex2!, framey2!, framec1%, framec2%

	PSET (((3) * 3 + 13 - 1) * 8 + 16, ((7.5 * ty / DD - 3) * 3 + 13 - 2.5) * 8 - 8), 3
	LINE -(((3) * 3 + 13 - 1) * 8 + 18, ((7.5 * ty / DD - 3) * 3 + 13 - 2.5) * 8 - 8), 3
	PSET (((7.5 * tx / AA - 3) * 3 + 13 - 2.5) * 8 - 8, ((3) * 3 + 13 - 1) * 8 + 16), 3
	LINE -(((7.5 * tx / AA - 3) * 3 + 13 - 2.5) * 8 - 8, ((3) * 3 + 13 - 1) * 8 + 18), 3
	dx1 = tx - 3
	dy1 = ty - 3
	dx2 = tx + 3
	dy2 = ty + 3
	IF dx1 < 1 THEN
		dx1 = 1
	END IF
	IF dy1 < 1 THEN
		dy1 = 1
	END IF
	IF dx2 > AA THEN
		dx2 = AA
	END IF
	IF dy2 > DD THEN
		dy2 = DD
	END IF
	FOR ttx = dx1 TO dx2
	FOR tty = dy1 TO dy2
		graphicput ((tty - ty) * 3 + 13 - 1), ((ttx - tx) * 3 + 13 - 1), (MID$(e$(ttx + (tty - 1) * AA, 2), 5, 4) + "____" + ".24")
		graphicput ((tty - ty) * 3 + 13 - 1), ((ttx - tx) * 3 + 13 - 1), (MID$(e$(ttx + (tty - 1) * AA, 2), 1, 4) + MID$(e$(ttx + (tty - 1) * AA, 4), 1, 4) + ".24")
		temptx = tx
		tempty = ty
		tx = ttx
		ty = tty
	
		fntempget
	
		tx = temptx
		ty = tempty
		IF tempaction$ = "zzzz" THEN
			graphicput ((tty - ty) * 3 + 13 - 1), ((ttx - tx) * 3 + 13 - 1), ("zzzz____.24")
		END IF
	NEXT tty
	NEXT ttx
	FOR ttx = dx1 TO dx2
	FOR tty = dy1 TO dy2
		temptx = tx
		tempty = ty
		tx = ttx
		ty = tty
		fntempget
		tx = temptx
		ty = tempty
		IF tempaction$ = "grpl" OR tempaction$ = "rapl" THEN
			IF tempdis > 0 THEN
					tempy1! = (tty - ty) * 3 + 13 - 1
					tempx1! = (ttx - tx) * 3 + 13 - 1
					tempy2! = (tty - ty + da(tempd, 2) * tempdis) * 3 + 13 - 1
					tempx2! = (ttx - tx + da(tempd, 1) * tempdis) * 3 + 13 - 1
					PSET ((tempx1! - 1) * 8 + 12, (tempy1! - 1) * 8 + 12), 6
					LINE -((tempx2! - 1) * 8 + 12, (tempy2! - 1) * 8 + 12), 6
				FOR ts! = 0 TO tempdis STEP tempdis / 8
					tempy! = (tty - ty + da(tempd, 2) * ts!) * 3 + 13 - 1
					tempx! = (ttx - tx + da(tempd, 1) * ts!) * 3 + 13 - 1
					tt! = ts!
					IF tempdis <= 1 THEN
						tt! = ts!
					ELSE
						IF ts! < tempdis - 1 THEN
							tt! = -1
						ELSE
							tt! = ts! - tempdis + 1
						END IF
					END IF
					IF tt! >= 0 THEN
						PSET ((tempx! - 1) * 8 + 12, (tempy! - 1) * 8 + 12 - tt!), 7
						PSET ((tempx! - 1) * 8 + 12 + tt!, (tempy! - 1) * 8 + 12), 7
						PSET ((tempx! - 1) * 8 + 12, (tempy! - 1) * 8 + 12 + tt!), 7
						PSET ((tempx! - 1) * 8 + 12 - tt!, (tempy! - 1) * 8 + 12), 7
					END IF
				NEXT ts!
			END IF
		END IF
	NEXT tty
	NEXT ttx

END SUB
