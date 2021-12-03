
declare SUB StringPut (XXXX as integer = 0, YYYY as integer = 0, GGGG as string = "" )

declare sub nimgput( x0 as integer = 1, y0 as integer = 1, c0 as string = "" )

DEFINT A-Z
SUB StringPut (XXXX as integer = 0, YYYY as integer = 0, GGGG as string = "" )

	'IF GGGG = 0 THEN 10001
	'IF GGGG = 3 THEN GGGG = GGGG + INT(gc)
	
 	dim as integer t = 0, tempord = 0
	dim as integer XXX = 0, YYY = 0
	dim as string GGGR = string$( 0, 0 )
	
	FOR t = 1 TO LEN( GGGG ) step 1
		
		XXX = XXXX + (t - 1) * 8
		YYY = YYYY
		
		IF XXX > 960 - 8 THEN
			XXX = XXX - 960 - 8
			YYY = YYY + 8
		END IF
		
		IF XXX > 960 - 8 THEN
			XXX = 0
		END IF
		
		tempord = ASC(MID$(GGGG, t, 1))
		
		IF tempord >= 33 AND tempord <= 255 THEN
			
			GGGR = "font_"+RIGHT$(STR$(1000 + tempord), 3) + ".til"
			
			#ifdef __old_graphics__				
				DEF SEG = VARSEG(g01(0)): BLOAD "tiles\font\" + GGGR, VARPTR(g01(0))
				PUT (XXX, YYY), g01, PSET
			#endif
			
			#ifndef __old_graphics__
				sprite_put 0, XXX, YYY, "tiles\font\" + GGGR, "pset"
			#endif
			
		END IF
		
	NEXT t

'10001 :

END SUB


sub nimgput( x0 as integer = 1, y0 as integer = 1, c0 as string = "" )
	
	dim as string sptemp = string$( 0, 0 )
	
	#ifdef __old_graphics__
		
		GraphicPut( ( x0 - 1 ) * 8, ( y0 - 1 ) * 8, "tiles\map\map_" + RIGHT$( STR$( 1000 + ASC( c0 ) ), 3 ) + ".til" )
		
	#else
		
		select case len( c0 )
		case 4
			sptemp = "tiles\party\" + c0 + "_001.TIL"
						
			'locate 25, 1
			'print sptemp;
		
			'stringput( 1, 25, sptemp )
		
		case 3
			sptemp = "tiles\font\font_" + c0 + ".TIL"
						
			'locate 25, 1
			'print sptemp;
			
		case 1
			
			sptemp = "tiles\map\map_" + RIGHT$( STR$( 1000 + ASC( c0 ) ), 3 ) + ".til"			
			
		end select
		
		sprite_put 0, ( x0 - 1 ) * 8, ( y0 - 1 ) * 8, sptemp, "pset"
		
	#endif

end sub
