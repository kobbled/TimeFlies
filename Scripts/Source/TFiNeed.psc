Scriptname TFiNeed extends Quest

TimeFliesMain Property main Auto
TimeFliesMCM Property mcm Auto

int prefix
float waterskin_crafting_hour
int waterskin_crafting_hour_id
float barrel_crafting_hour
int barrel_crafting_hour_id
float bucket_crafting_hour
int bucket_crafting_hour_id
float keg_crafting_hour
int keg_crafting_hour_id
float water_distilling_minute
int water_distilling_minute_id
Form waterskin
Form barrel
Form bucket
Form keg
Form saltwater
ObjectReference furniture_using
string item_name

Function initialize()
    prefix = Game.getModByName("iNeed.esp")
	if prefix == 255
		main._debug("iNeed not installed " + prefix)
        return
    endif
    main._debug("iNeed initialized " + prefix)	

    waterskin = Game.getFormFromFile(0x0438c, "iNeed.esp")
    barrel = Game.getFormFromFile(0x1410f, "iNeed.esp")
    bucket = Game.getFormFromFile(0x28496, "iNeed.esp")
    keg = Game.getFormFromFile(0x45470, "iNeed.esp")
	saltwater = Game.getFormFromFile(0x587b6, "iNeed.esp")
	
EndFunction

Function load_defaults()
    waterskin_crafting_hour = 2.0
    barrel_crafting_hour = 3.0
    bucket_crafting_hour = 2.0
    keg_crafting_hour = 2.5
	water_distilling_minute = 20.0
EndFunction

bool Function handle_added_item(Form item)
	if main.get_prefix(item) != prefix  || item.getType() != 32 
        return False
    endif
	
	item_name = item.getName()		
	main._debug("iNeed Item - " + item_name)
	
	if item == waterskin
		main._debug("iNeed Waterskin made")
		if waterskin_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
		main.pass_time(waterskin_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
    elseif item == barrel
        main._debug("Water barrel made")
		if barrel_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(barrel_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
    elseif item == bucket
        main._debug("Water bucket made")
		if bucket_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(bucket_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
    elseif item == keg
        main._debug("Water keg made")
		if keg_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(keg_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
    else
        main._debug("iNeed misc item ignored")
    endif
    return True
EndFunction

bool Function handle_removed_item(Form item)
	Bool isInventoryMenuOpen = UI.IsMenuOpen("InventoryMenu")
	Bool isContainerMenuOpen = UI.IsMenuOpen("ContainerMenu")
	if main.get_prefix(item) != prefix || isInventoryMenuOpen || isContainerMenuOpen
		return False	
	elseif item == saltwater
		main._debug("Distilled salt water")
		main.pass_time(water_distilling_minute * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Alchemy") / 60)	
	else
		return False
    endif
EndFunction

Function save_settings()
    mcm.fiss.saveFloat("ineed_waterskin_crafting_hour", waterskin_crafting_hour)
    mcm.fiss.saveFloat("ineed_barrel_crafting_hour", barrel_crafting_hour)
    mcm.fiss.saveFloat("ineed_bucket_crafting_hour", bucket_crafting_hour)
    mcm.fiss.saveFloat("ineed_keg_crafting_hour", keg_crafting_hour)
	mcm.fiss.saveFloat("ineed_water_distilling_minute", water_distilling_minute)
EndFunction

Function load_settings()
    waterskin_crafting_hour = mcm.fiss.loadFloat( \
        "ineed_waterskin_crafting_hour")
    barrel_crafting_hour = mcm.fiss.loadFloat("ineed_barrel_crafting_hour")
    bucket_crafting_hour = mcm.fiss.loadFloat("ineed_bucket_crafting_hour")
    keg_crafting_hour = mcm.fiss.loadFloat("ineed_keg_crafting_hour")
	water_distilling_minute = mcm.fiss.loadFloat( \
        "ineed_water_distilling_minute")
EndFunction

bool Function handle_page(string page)
    if page != "$ineed"
        return False
    endif

    if prefix == 255
        mcm.addTextOption("", "$ineed_not_installed")
    else
        mcm.setCursorFillMode(mcm.TOP_TO_BOTTOM)
        mcm.addHeaderOption("$crafting")
        waterskin_crafting_hour_id = mcm.addSliderOption( \
            "$ineed_waterskin", waterskin_crafting_hour, "${2}hour")
        barrel_crafting_hour_id = mcm.addSliderOption( \
            "$ineed_barrel", barrel_crafting_hour, "${2}hour")
        bucket_crafting_hour_id = mcm.addSliderOption( \
            "$ineed_bucket", bucket_crafting_hour, "${2}hour")
        keg_crafting_hour_id = mcm.addSliderOption( \
            "$ineed_keg", keg_crafting_hour, "${2}hour")
		
		mcm.setCursorPosition(1)
		mcm.addHeaderOption("$activities")
		water_distilling_minute_id = mcm.addSliderOption( \
            "$water_distilling", water_distilling_minute, "${0}min")
    endif
    return True
EndFunction

bool Function handle_slider_opened(int option)
    if option == waterskin_crafting_hour_id
        mcm.setSliderDialogStartValue(waterskin_crafting_hour)
        mcm.setSliderDialogDefaultValue(2.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
    elseif option == barrel_crafting_hour_id
        mcm.setSliderDialogStartValue(barrel_crafting_hour)
        mcm.setSliderDialogDefaultValue(3.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
    elseif option == bucket_crafting_hour_id
        mcm.setSliderDialogStartValue(bucket_crafting_hour)
        mcm.setSliderDialogDefaultValue(2.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
    elseif option == keg_crafting_hour_id
        mcm.setSliderDialogStartValue(keg_crafting_hour)
        mcm.setSliderDialogDefaultValue(2.5)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
	elseif option == water_distilling_minute_id
        mcm.setSliderDialogStartValue(water_distilling_minute)
        mcm.setSliderDialogDefaultValue(20.0)
        mcm.setSliderDialogRange(0.0, 60.0)
        mcm.setSliderDialogInterval(1.0)
    else
        return False
    endif
    return True
EndFunction

bool Function handle_slider_accepted(int option, float value)
    if option == waterskin_crafting_hour_id
        waterskin_crafting_hour = value
        mcm.setSliderOptionValue(waterskin_crafting_hour_id, value, "${2}hour")
    elseif option == barrel_crafting_hour_id
        barrel_crafting_hour = value
        mcm.setSliderOptionValue(barrel_crafting_hour_id, value, "${2}hour")
    elseif option == bucket_crafting_hour_id
        bucket_crafting_hour = value
        mcm.setSliderOptionValue(bucket_crafting_hour_id, value, "${2}hour")
    elseif option == keg_crafting_hour_id
        keg_crafting_hour = value
        mcm.setSliderOptionValue(keg_crafting_hour_id, value, "${2}hour")
	elseif option == water_distilling_minute_id
        water_distilling_minute = value
        mcm.setSliderOptionValue(water_distilling_minute_id, value, "${0}min")
    else
        return False
    endif
    return True
EndFunction

bool Function handle_option_highlighted(int option)
    if option == waterskin_crafting_hour_id || \
            option == barrel_crafting_hour_id || \
            option == bucket_crafting_hour_id || \
            option == keg_crafting_hour_id || \
			option == water_distilling_minute_id || \
        mcm.setInfoText("$time_passed_performing_this_action")
    else
        return False
    endif
    return True
EndFunction
