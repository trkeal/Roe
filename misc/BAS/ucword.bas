
function ucword( subject as string ) as string
	dim as integer o = 0
	
	subject = lcase$( subject )
	
	for o = 1 to len( subject ) step 1
	
		if o = 1 or mid$(subject, o - 1, 1 ) = string$( 1, 32 ) then
			mid$( subject, o ,1 ) = ucase$( mid$( subject, o ,1 ) )
		end if
	
	next o
	
	ucword = subject 
	exit function
	
end function
