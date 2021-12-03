
sub vds_gen()
	
	dim as integer AA = 16, DD = 16
	dim as string magic
	
	magic = "0001"
	
	empty = AA * DD
	
	dim vds(0 to AA-1,0 to DD-1, 0 to 3) as string
	
	do while empty > 0
		
		roomw=rnd(1)*5+1
		roomh=rnd(1)*5+1
		
		x1= rnd(1)*(AA-roomw-1)
		y1= rnd(1)*(DD-roomh-1)
		
		for(x=x1 to x1+roomw) step 1
			if len(vds(x,y,2)) = 0 then
				vds(x,y,2) = 0
			end if
		next x1
		
		for(y=y1 to y1+roomh) step 1
			if 
		next y1
	loop
	
end sub