
type names_type
	label as string
	value as string
end type

declare function name_as_string( subject as string ) as string

declare function name_ref_as_string( subject as string, names( any ) as names_type ) as string

declare function sync_names( lookup as string, names_table( any ) as names_type ) as string

declare sub load_names( filename as string = "", names_table( any ) as names_type )

declare sub load_names_from_buffer( buffer as string = "", names_table( any ) as names_type )

declare sub load_names_from_file( filename as string = "", names_table( any ) as names_type )

declare sub save_names( filename as string = "", names_table( any ) as names_type )

declare function ucword( subject as string ) as string

function name_as_string( subject as string ) as string
	
	if left$( subject, 1 ) = quot and right$( subject, 1 ) = quot then
		name_as_string = ucword( mid$( subject, 2, len(subject) - 2 ) )
	else
		name_as_string = ucword( subject )
	end if
	
end function


function name_ref_as_string( subject as string, names( any ) as names_type ) as string
	
	dim as integer open_offset =0, close_offset = 0
	dim as string open_sep = string$( 0 ,0 ), close_sep = string$( 0, 0 )
	
	open_sep = "{{"
	close_sep = "}}"

	do
	
		open_offset = instr(1, subject, open_sep)
		close_offset = instr( open_offset + len( open_sep ), subject, close_sep)
		
		if not( open_offset > 0 and close_offset > open_offset ) then
			exit do
		end if
		
		subject = left$( subject, open_offset - 1 ) + sync_names( mid$( subject, open_offset, close_offset - open_offset - len( open_offset ) ), names() ) + mid$( subject, close_offset + len( close_sep ) )
	
	loop

	name_ref_as_string = subject

end function

function sync_names( lookup as string, names_table( any ) as names_type ) as string
	dim as integer index = lbound( names_table, 1 )
	do while index <= ubound( names_table, 1 )
		if lcase$( lookup ) = lcase$( names_table( index ).label ) then
			sync_names = lcase$( names_table( index ).value )
			exit function
		end if
		index += 1
	loop
	
	sync_names = "%%"
	exit function
	
end function

sub load_names( filename as string = "", names_table( any ) as names_type )
	
	load_names_from_file( filename, names_table() )

end sub

sub load_names_from_buffer( buffer as string = "", names_table( any ) as names_type )
	
	dim as string subject = string$( 0, 0 )
	
	do while instr( 1, buffer, crlf ) > 0
		
		subject = left$( buffer, instr( 1, buffer, crlf ) - 1 )
		
		buffer = mid$( buffer, len( subject ) + len( crlf ) + 1 )
		
		if instr( subject, eq ) > 0 then
			
			if ubound( names_table, 0 ) > 0 then
				redim preserve names_table( lbound( names_table, 1 ) to ubound( names_table, 1 ) + 1 )
			else
				redim names_table( 0 to 0 )
			end if
			
			names_table( ubound( names_table, 1 ) ).label = left$( subject, instr( subject, eq ) - 1 )
			
			names_table( ubound( names_table, 1 ) ).value = mid$( subject, instr( subject, eq ) + len( eq ) )
			
		end if
	loop
	
	subject = buffer
	buffer = string$( 0, 0 )
	
	if instr( subject, eq ) > 0 then
		
		if ubound( names_table, 0 ) > 0 then		
			redim preserve names_table( lbound( names_table, 1 ) to ubound( names_table, 1 ) + 1 )
		else
			redim names_table( 0 to 0 )
		end if
		
		names_table( ubound( names_table, 1 ) ).label = left$( subject, instr( subject, eq ) - 1 )
		
		names_table( ubound( names_table, 1 ) ).value = mid$( subject, instr( subject, eq ) + len( eq ) )
	
	end if

end sub

sub load_names_from_file( filename as string = "", names_table( any ) as names_type )
	dim as integer filemode = freefile
	if open( filename for binary as #filemode ) then
		close #filemode
		exit sub
	end if
	dim as string buffer = string$( lof( filemode ), 0 )
	get #filemode, 1, buffer
	close #filemode
	
	load_names_from_buffer buffer, names_table()
	
end sub


sub save_names( filename as string = "", names_table( any ) as names_type )
	
	dim as integer filemode = freefile, index = 0
	dim as string buffer = string$( 0, 0 )
	
	kill filename
	
	if open( filename for binary as filemode ) then
		close #filemode
		exit sub
	end if
	
	for index = lbound( names_table, 1 ) to ubound( names_table, 1 ) step 1
		
		if index > lbound( names_table, 1 ) then
			buffer += crlf
		end if
		
		buffer += names_table( index ).label + "=" + names_table( index ).value
		
	next index
	
	put #filemode, 1, buffer
	close #filemode

end sub

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

