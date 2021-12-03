
type nametype
	label as string
	value as string
end type

redim shared as nametype names_table( Any ), level_table( Any ), config_table( Any ), text_table( Any )

declare function sync_name( lookup as string = "", table( Any ) as nametype ) as string

declare sub load_names_by_file( filename as string = "", table( Any ) as nametype, d_crlf as string = chr$( 13 ) + chr$( 10 ), d_eq as string = "=", d_quot as string = chr$( 34 ) )

declare sub load_names_by_buffer( buffer as string = "", table( Any ) as nametype, d_crlf as string = chr$( 13 ) + chr$( 10 ), d_eq as string = "=", d_quot as string = chr$( 34 )  )

declare SUB resconfig ( filename as string = "", table( Any ) as nametype )

load_names_by_file "RES\CONFIG\NAMES.DAT", names_table()

function sync_name( lookup as string = "", table( Any ) as nametype ) as string

	dim as integer o = 0
	for o = lbound( table, 1 ) to ubound( table, 1 ) step 1
		if lcase$( lookup ) = lcase$( table( o ).label ) then
			sync_name = table( o ).value
			exit function
		end if
	next o
	
	sync_name = string$( 0, 0 )
	exit function
	
end function

sub load_names_by_file( filename as string = "", table( Any ) as nametype, d_crlf as string = chr$( 13 ) + chr$( 10 ), d_eq as string = "=", d_quot as string = chr$( 34 ) )
	
	dim as string label = "", value = "", r = ""
	dim as string subject = "", buffer = ""
	
	dim as integer filemode = freefile
	
	if open( filename for input as #filemode ) then
		close #filemode
		exit sub
	else
		buffer = string$( lof( filemode ), 0 )
		get #filemode, 1, buffer
		close #filemode
	end if
	
	load_names_by_file buffer, table(), d_crlf, d_eq, d_quot
	
end sub

sub load_names_by_buffer( buffer as string = "", table( Any ) as nametype, d_crlf as string = chr$( 13 ) + chr$( 10 ), d_eq as string = "=", d_quot as string = chr$( 34 ) )
	
	dim as string label = "", value = "", r = ""
	dim as string subject = ""
	
	do while len( buffer ) > 0
		
		if instr( 1, buffer, d_crlf ) > 0 then
			subject = left$( buffer, instr( 1, buffer, d_crlf ) - 1 )
			buffer = mid$( buffer, instr( 1, buffer, d_crlf ) + len( d_crlf ) )
		else
			subject = buffer
			buffer = string$( 0, 0 )
		end if
		
		if instr( 1, subject, d_eq ) > 0 then
			
			if ubound( table, 0 ) = 0 then
				redim table( 0 to 0 )
			else
				redim preserve table( 0 to ubound( table, 1 ) + 1 )
			end if
			
			table( ubound( table, 1 ) ).label = left$( subject, instr( 1, subject, d_eq ) - 1 )
			
			table( ubound( table, 1 ) ).value = mid$( subject, instr( 1, subject, d_eq ) + len( d_eq ) )
			
		end if
		
	loop
		
end sub

SUB resconfig (filename as string = "", table( Any ) as nametype )

	load_names_by_file( filename, table() )
	windowtitle sync_name( "window_title", table() )
	debugmode = ( val( sync_name( "debug", table() ) ) = 0 ) = 0

END SUB
