
#include once ".\gamedata\names.bas"

dim shared gamedata_table( any ) as names_type

load_names( ".\res\gamedata.dat", gamedata_table() )

#include once ".\gamedata\gamedata declarations.bas"

#include once ".\gamedata\load gamedata.bas"

load_gamedata()

'===

dim shared text_table( any ) as names_type


