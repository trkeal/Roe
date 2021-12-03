''#define __old_merchant__
#define __old_merchant_menu__

do_merchant:
 am$ = ctrl$
 GOSUB do_am
 IF am > 0 THEN
   renderfill 0, 0, 319, 199, textbg, 0
'LINE (0, 0)-(319, 199), textbg, BF
  GOSUB do_portal
  statx = 2
  GOSUB do_status
  viewx = 18

#ifndef __old_merchant__
	
	load_names( "data\merchant\"+"imp_"+".dat", merchant_table() )
	
	merchant_count = val( sync_names( "sell/count", merchant_table() ) )
	
	menu$ = ""
	
	for merchant_index = 1 to merchant_count step 1
		
		merchant_item = sync_names(  "sell/"+ltrim$(str$(merchant_index))+"/name", merchant_table() )
		
		merchant_cost = val( sync_names(  "sell/"+ltrim$(str$(merchant_index))+"/cost", merchant_table() ) )
		
		hasit$ = merchant_item
		GOSUB do_hasit
		IF ( hasit > 0 ) or ( merchant_cost = 0 ) THEN
			menu$ = menu$ + merchant_item + MKL$(merchant_cost)
		END IF
		
	next merchant_index
	
#endif

#ifdef __old_merchant__

menu$ = ""

  hasit$ = "dggr"
  GOSUB do_hasit
  IF hasit > 0 THEN
   menu$ = menu$ + "dggr" + MKL$(5)
  END IF
  hasit$ = "pike"
  GOSUB do_hasit
  IF hasit > 0 THEN
   menu$ = menu$ + "pike" + MKL$(20)
  END IF
  hasit$ = "grpl"
  GOSUB do_hasit
  IF hasit > 0 THEN
   menu$ = menu$ + "grpl" + MKL$(15)
  END IF
  hasit$ = "seed"
  GOSUB do_hasit
  IF hasit > 0 THEN
   menu$ = menu$ + "seed" + MKL$(15)
  END IF
  hasit$ = "wstf"
  GOSUB do_hasit
  IF hasit > 0 THEN
   menu$ = menu$ + "wstf" + MKL$(10)
  END IF
  menu$ = menu$ + "cncl" + MKL$(0)
  menuze = LEN(menu$) / 8
  inmenu = 0

#endif

#ifdef __old_talk__
  
  text 5, viewx, "Merchant", 0
  text 7, viewx, "Wha'du like?", 0
  graphicput 10, viewx + 6, "bsv\sprites\" + (MID$(e$(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 2), 1, 4) + "____.24")

#else
	talk_hud( "imp_" )
#endif

#ifdef __old_merchant_menu__
  FOR menuitem = 1 TO menuze
   menuitem$ = MID$(menu$, (menuitem - 1) * 8 + 1, 4)
   menucost = CVL(MID$(menu$, (menuitem - 1) * 8 + 5, 4))
   r$ = menuitem$
   GOSUB do_names
   IF menucost > 0 THEN
    text 12 + menuitem, viewx, is_selected_hud( 0 ) + rr$ + " " + STRING$((40 - viewx) - LEN(rr$) - 7, "-") + RIGHT$("----" + ltrim$(STR$(menucost)), LEN(ltrim$(STR$(menucost)))) + "$", 0
   END IF
   IF menucost = 0 THEN
    text 12 + menuitem, viewx, is_selected_hud( 0 ) + rr$, 0
   END IF
  NEXT menuitem
#endif

do_wwait1:
  GOSUB do_buttonwait
  menuselect$ = "____"
  menucost = 0
  IF lb = -1 THEN
   IF xm = viewx THEN
    IF ym >= 13 AND ym <= 12 + menuze THEN
     menuselect = ym - 12
     menuselect$ = MID$(menu$, (menuselect - 1) * 8 + 1, 4)
     menucost = CVL(MID$(menu$, (menuselect - 1) * 8 + 5, 4))
    END IF
   END IF
  END IF
  IF menuselect$ <> "lvup" AND menuselect$ <> "cncl" AND menuselect$ <> "____" THEN
   IF g(tx + (ty - 1) * AA, 6) >= menucost THEN
     c$ = "L"
    GOSUB do_abilitygain
    hashadit$ = menuselect$
    GOSUB do_hashadit
    g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 6) = g(tx + da(d, 1) * dis + (ty + da(d, 2) * dis - 1) * AA, 6) + menucost
    GOTO do_merchant
   END IF
   GOTO do_merchant
  END IF
  IF menuselect$ = "lvup" THEN
   IF g(tx + (ty - 1) * AA, 6) >= menucost THEN
    c$ = "L"
    GOSUB do_levelup
    GOTO do_merchant
   END IF
   GOTO do_merchant
  END IF
  IF menuselect$ = "cncl" THEN
   c$ = "L"
  ELSE
   GOTO do_wwait1
  END IF
 END IF
RETURN
