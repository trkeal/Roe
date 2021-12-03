sub statput( staty as integer = 0, statx as integer = 0, stat as string = "HP", cur as integer = 0, max as integer = 0, fg% = 15, bg% = 0 )

	text Dest, ( staty + 0 ), (statx + 0),  stat, 0, textfg%, textbg%

	dim as string s2 = string$(0,0)

	text Dest, ( staty + 0 ), (statx + 0),  stat, 0, textfg%, textbg%

	s2 = ltrim$(str$(cur))
	s2 = string( len( s2 ) - 4, 32 ) + s2

	text Dest, ( staty + 0 ), (statx + 0) + 4, s2, 0, textfg%, textbg%
	text Dest, ( staty + 0 ), (statx + 0) + 9, "/", 0, textfg%, textbg%

	s2 = ltrim$(str$(max))
	s2 = string( len( s2 ) - 4, 32 ) + s2

	text Dest, ( ( staty + 0 ) + 0 ), (statx + 0) + 11, s2, 0, textfg%, textbg%
	
end sub


