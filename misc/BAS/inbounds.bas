declare FUNCTION isinbounds (x as longint, y as longint, x1 as longint, y1 as longint, x2 as longint, y2 as longint) as longint

DEFSNG A-Z
FUNCTION isinbounds (x as longint, y as longint, x1 as longint, y1 as longint, x2 as longint, y2 as longint) as longint
	isinbounds = (x >= x1 AND y >= y1 AND x <= x2 AND y <= y2)
END FUNCTION
