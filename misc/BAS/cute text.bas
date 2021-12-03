
DIM SHARED clickbutton1 as longint
DIM SHARED clickbutton2 as longint
DIM SHARED clickhover as longint

declare sub cute_clicks( Dest as any ptr, x as integer = -1, y as integer = -1, fg as integer = 15, bg as integer = 3)

declare sub cute_text( Dest as any ptr, subject as string = "", byref x as integer = -1, byref y as integer = -1, fg as integer = 15, bg as integer = 0, wipe_clicks as integer = 0, spacing as integer = -2 )

declare sub cute_splash( Dest as any ptr, buffer as string = "" )


sub cute_clicks( Dest as any ptr, x as integer = -1, y as integer = -1, fg as integer = 15, bg as integer = 3)
	dim as integer index = 0
	for index = lbound( clickli, 1 ) to ubound( clickli, 1 ) step 1
		color fg,bg
		locate x+15, y + index
		print str$( index ) + ":" + quot + clickli( index ).label + quot
	next index
end sub

sub cute_text( Dest as any ptr, subject as string = "", byref x as integer = -1, byref y as integer = -1, fg as integer = 15, bg as integer = 0, wipe_clicks as integer = 0, spacing as integer = -2 )
	
	if ( wipe_clicks = 0 ) = 0 then
		clicks = 0
		redim clickli( 0 to clicks )	
	end if
	
	dim as integer o = 0
	
	dim as string bind_open = "{{", bind_close = "}}"
	
	'locate ( y / 8 ) + 1, ( x / 8 ) + 1
	'color fg, bg
	'print quot + subject + quot

	do		
		open_offset = instr( 1, subject, bind_open )
		close_offset = instr( open_offset + len( bind_open ), subject, bind_close )
		
		if ( open_offset > 0 ) and ( close_offset >= open_offset + len( bind_open ) ) then
			
			if ubound( clickli, 1 ) = 0 then
				clicks = 0
				redim clickli( 0 to 0 )
			else
				clicks = ubound( clickli, 1 ) + 1	
				redim preserve clickli( 0 to clicks )
			end if
			
			clickli( clicks ).label = mid$( subject, open_offset + len( bind_close_open ) )
			clickli( clicks ).label = left$( clickli( clicks ).label, close_offset - open_offset )
			
			clickli( clicks ).col = x + ( open_offset - len( bind_open ) ) * ( 8 + spacing )
			
			clickli( clicks ).row = y

			subject = left$( subject, open_offset - 1 ) + clickli( clicks ).label + mid$( subject, close_offset + len( bind_close ) )
						
		else
			exit do
		end if
	loop
	
	for o = len( subject ) to o step -1
		draw string ( x + o * ( 8 + spacing ), y - 1 ), str$( ubound( clickli, 1 ) ), bg
		draw string ( x + o * ( 8 + spacing ) + 1, y ), str$( ubound( clickli, 1 ) ), bg
		draw string ( x + o * ( 8 + spacing ), y + 1 ), str$( ubound( clickli, 1 ) ), bg
		draw string ( x + o * ( 8 + spacing ) - 1, y ), str$( ubound( clickli, 1 ) ), bg

		draw string ( x + o * ( 8 + spacing ), y ), str$( ubound( clickli, 1 ) ), fg
	
	next o
	
end sub

sub cute_splash( Dest as any ptr, buffer as string = "" )
	
	dim as integer x = 1, y = 1, fg = 11, bg = 3, wipe = 0, spacing = -2
	
	dim as integer filemode = 0
	dim as string extension = "", subject = "", filename = ""
	
	do
		o = instr( 1, buffer, crlf )
		if o > 0 then
			subject = left$( buffer, o )
			buffer = mid$( buffer, o + len( crlf ) )
		else
			subject = buffer
			buffer = string$( 0, 0 )
		end if

		select case left$( subject, 2 )
		case "@ "
			filename = mid$( subject, len( "@ " ) + 1 )
			filemode = freefile
			if open( filename for binary as #filemode) then
				close #filemode
			else
				extension = string$( lof( filemode ), 0 )
				get #filemode, 1, extension
				buffer = extension + crlf + buffer
				close #filemode
			end if
			subject = string$( 0, 0 )
		case "þ "
			select case mid$( subject, 3, instr( 4, subject, string$( 1, 32 ) ) )
			case "COLOR"
				fg = val( mid$( subject, len( "þ "+"COLOR" + " " ) + 1 ) )
			case else
				select case mid$( subject, 3 )
				case "page start"
					'buffer = "@ res\splash\" + sync_name( "file_title", config_table() )
				case "page end"
					suspend timer, 0
					y = 0
				case "end"
					suspend timer, 0
					exit do
				end select
			end select
			subject = string$( 0, 0 )
		case else
			x = 8
			y += 8
			if y > 320 then
				suspend timer, 0
				line( 0, 0 )-( 319, 199 ), 1, bf
				y = 0
			end if
			
			cute_text Dest, subject, x, y, fg, bg, wipe, spacing
		end select

	loop until ( len( buffer ) = 0 ) or ( c$ = sync_name( "quit", names_table() ) )
	
	suspend timer, 0

end sub
