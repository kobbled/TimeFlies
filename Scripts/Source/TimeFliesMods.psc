Scriptname TimeFliesMods extends Quest  

TimeFliesMCM Property mcm Auto

;; load mod supporting scripts as properties
TFHearthfire Property hearthfire Auto
TFHearthfireExtended Property hearthfireext Auto
TFCampfire Property campfire Auto
TFBasicCampGear Property basiccampgear Auto
TFCampsite Property campsite Auto
TFiNeed Property ineed Auto
TFSunHelm Property sunhelm Auto
TFLastSeed Property lastseed Auto
TFSkyrimFishing Property skyrimfishing Auto
TFFishingAE Property fishingae Auto
TFHuntingInSkyrim Property huntinginskyrim Auto
TFWounds Property wounds Auto

Function prepare_pages()
    ;; change page number if necessary
    mcm.pages = new string[17]
    ;; fixed pages
    mcm.pages[0] = "$general"
    mcm.pages[1] = "$crafting_config"
	mcm.pages[2] = "$crafting_times"
    mcm.pages[3] = "$activities"
	mcm.pages[4] = "$combat"	
    ;; DLC related pages
    mcm.pages[5] = "$hearthfire"
	mcm.pages[6] = "$fishing_ae"
	;; mod related pages
	mcm.pages[7] = "$basiccampgear"
    mcm.pages[8] = "$campfire"
	mcm.pages[9] = "$campsite"
    mcm.pages[10] = "$ineed"  
	mcm.pages[11] = "$lastseed"	
	mcm.pages[12] = "$sunhelm"
	mcm.pages[13] = "$hearthfire_ext"
	mcm.pages[14] = "$skyrimfishing"	
	mcm.pages[15] = "$huntinginskyrim"
	mcm.pages[16] = "$wounds"	
    ;; add more behind
EndFunction

Function update(int version)
    ;; if updating from old version (adding new mod(s) support),
    ;; call load_defaults() and initialize() from those mod support scripts
    ;if version >= x
	;	modname.load_defaults()
	;	modname.initialize()
	;endif
EndFunction

Function initialize()
    ;; prepare some variables like form lists needing to process
	hearthfire.initialize()
	fishingae.initialize()
	hearthfireext.initialize()
    campfire.initialize()
	basiccampgear.initialize()
	campsite.initialize()
    ineed.initialize()
	sunhelm.initialize()
	lastseed.initialize()
	skyrimfishing.initialize()
	huntinginskyrim.initialize()
	wounds.initialize()
EndFunction

Function load_defaults()
    ;; load default settings related to those mods
	hearthfire.load_defaults()
	fishingae.load_defaults()
	hearthfireext.load_defaults()
    campfire.load_defaults()
	basiccampgear.load_defaults()
	campsite.load_defaults()
    ineed.load_defaults()
	sunhelm.load_defaults()
	lastseed.load_defaults()
	skyrimfishing.load_defaults()
	huntinginskyrim.load_defaults()
	wounds.load_defaults()
EndFunction

bool Function handle_spellcast(Form item)
	if wounds.handle_spellcast(item)
        return True
    endif
	
	return False
EndFunction

bool Function handle_added_item(Form item)
    ;; called when player gets an item through crafting
    ;; if an item is handled by a mod, it should return True
    ;; then return True in this function
    ;; otherwise return False to handle it as a vanilla item
    if hearthfire.handle_added_item(item)
        return True
    endif
	
	if fishingae.handle_added_item(item)
        return True
    endif
	
	if hearthfireext.handle_added_item(item)
        return True
    endif

    if campfire.handle_added_item(item)
        return True
    endif

	if basiccampgear.handle_added_item(item)
        return True
    endif
	
	if campsite.handle_added_item(item)
        return True
    endif
	
    if ineed.handle_added_item(item)
        return True
    endif
	
	if sunhelm.handle_added_item(item)
        return True
    endif
	
	if lastseed.handle_added_item(item)
        return True
    endif
	
	if skyrimfishing.handle_added_item(item)
        return True
    endif
	
	if huntinginskyrim.handle_added_item(item)
        return True
    endif
	
	if wounds.handle_added_item(item)
        return True
    endif
	
    return False
EndFunction

bool Function handle_removed_item(Form item)
    ;; called when player loses an item through crafting
    ;; if an item is handled by a mod, it should return True
    ;; then return True in this function
    ;; otherwise return False to handle it as a vanilla item
    if campfire.handle_removed_item(item)
        return True		
    endif
	
	if basiccampgear.handle_removed_item(item)
        return True		
    endif
	
	if campsite.handle_removed_item(item)
        return True		
    endif
	
	if ineed.handle_removed_item(item)
        return True		
    endif
	
	if sunhelm.handle_removed_item(item)
        return True		
    endif
	
	if lastseed.handle_removed_item(item)
        return True		
    endif
	
	if skyrimfishing.handle_removed_item(item)
        return True		
    endif
		
	if huntinginskyrim.handle_removed_item(item)
        return True		
    endif
	
    return False
EndFunction

Function save_settings()
    ;; save settings related to those mods
    hearthfire.save_settings()
	fishingae.save_settings()
	hearthfireext.save_settings()
    campfire.save_settings()
	basiccampgear.save_settings()
	campsite.save_settings()
    ineed.save_settings()
	sunhelm.save_settings()
	lastseed.save_settings()
	skyrimfishing.save_settings()
	huntinginskyrim.save_settings()
	wounds.save_settings()
EndFunction

Function load_settings()
    ;; load settings related to those mods
    hearthfire.load_settings()
	fishingae.load_settings()
	hearthfireext.load_settings()
    campfire.load_settings()
	basiccampgear.load_settings()
	campsite.load_settings()
    ineed.load_settings()
	sunhelm.load_settings()
	lastseed.load_settings()
	skyrimfishing.load_settings()
	wounds.load_settings()
EndFunction

Function handle_page(string page)
    ;; draw UI when selecting mod-related pages
    ;; if a page is handled by a mod, it should return True
    if hearthfire.handle_page(page)
	elseif fishingae.handle_page(page)
	elseif hearthfireext.handle_page(page)
    elseif campfire.handle_page(page)
	elseif basiccampgear.handle_page(page)
	elseif campsite.handle_page(page)
    elseif ineed.handle_page(page)
	elseif sunhelm.handle_page(page)
	elseif lastseed.handle_page(page)
	elseif skyrimfishing.handle_page(page)
	elseif huntinginskyrim.handle_page(page)
	elseif wounds.handle_page(page)
    endif
EndFunction

Function handle_option_selected(int option)
    ;; called when an mod-related option is selected
    ;; if an option is handled by a mod, it should return True
	if fishingae.handle_option_selected(option)
    elseif skyrimfishing.handle_option_selected(option)
    elseif huntinginskyrim.handle_option_selected(option)
    endif
EndFunction

Function handle_slider_opened(int option)
    ;; called when an mod-related slider is opened
    ;; if an option is handled by a mod, it should return True
    if hearthfire.handle_slider_opened(option)
	elseif fishingae.handle_slider_opened(option)
	elseif hearthfireext.handle_slider_opened(option)
    elseif campfire.handle_slider_opened(option)
	elseif basiccampgear.handle_slider_opened(option)
	elseif campsite.handle_slider_opened(option)
    elseif ineed.handle_slider_opened(option)
	elseif sunhelm.handle_slider_opened(option)
	elseif lastseed.handle_slider_opened(option)
	elseif skyrimfishing.handle_slider_opened(option)
	elseif huntinginskyrim.handle_slider_opened(option)
	elseif wounds.handle_slider_opened(option)
    endif
EndFunction

Function handle_slider_accepted(int option, float value)
    ;; called when an mod-related slider is accepted
    ;; if an option is handled by a mod, it should return True
    if hearthfire.handle_slider_accepted(option, value)
	elseif fishingae.handle_slider_accepted(option, value)
	elseif hearthfireext.handle_slider_accepted(option, value)
    elseif campfire.handle_slider_accepted(option, value)
	elseif basiccampgear.handle_slider_accepted(option, value)
	elseif campsite.handle_slider_accepted(option, value)
    elseif ineed.handle_slider_accepted(option, value)
	elseif sunhelm.handle_slider_accepted(option, value)
	elseif lastseed.handle_slider_accepted(option, value)
	elseif skyrimfishing.handle_slider_accepted(option, value)
	elseif huntinginskyrim.handle_slider_accepted(option, value)
	elseif wounds.handle_slider_accepted(option, value)
    endif
EndFunction

Function handle_option_set_default(int option)
    ;; called when an mod-related option is reset to its default value
    ;; if an option is handled by a mod, it should return True
	if fishingae.handle_option_set_default(option)
    elseif skyrimfishing.handle_option_set_default(option)
    elseif huntinginskyrim.handle_option_set_default(option)
    endif
EndFunction

Function handle_option_highlighted(int option)
    ;; called when an mod-related option is highlighted
    ;; if an option is handled by a mod, it should return True
    if hearthfire.handle_option_highlighted(option)
	elseif fishingae.handle_option_highlighted(option)	
	elseif hearthfireext.handle_option_highlighted(option)
    elseif campfire.handle_option_highlighted(option)
	elseif basiccampgear.handle_option_highlighted(option)
	elseif campsite.handle_option_highlighted(option)
    elseif ineed.handle_option_highlighted(option)
	elseif sunhelm.handle_option_highlighted(option)
	elseif lastseed.handle_option_highlighted(option)
	elseif skyrimfishing.handle_option_highlighted(option)
	elseif wounds.handle_option_highlighted(option)
    endif
EndFunction