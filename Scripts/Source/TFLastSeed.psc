Scriptname TFLastSeed extends Quest

TimeFliesMain Property main Auto
TimeFliesMCM Property mcm Auto

int prefix
float waterskin_crafting_hour
int waterskin_crafting_hour_id
float rainbarrel_crafting_hour
int rainbarrel_crafting_hour_id
float water_distilling_minute
int water_distilling_minute_id
float water_purifying_minute
int water_purifying_minute_id
Form waterskin
Form rainbarrel
Form saltwater
Form[] dirtywater

ObjectReference furniture_using
string item_name

Function initialize()
    prefix = Game.getModByName("LastSeed.esp")
	if prefix == 255
        main._debug("Last Seed not installed " + prefix)
		return
    endif
    main._debug("Last Seed initialized " + prefix)

	waterskin = Game.GetFormFromFile(0x10895, "LastSeed.esp")
	rainbarrel = Game.GetFormFromFile(0x27e410, "LastSeed.esp")
    saltwater = Game.getFormFromFile(0x10894, "LastSeed.esp")
	
	dirtywater = new Form[3]
    dirtywater[0] = Game.getFormFromFile(0x1088e, "LastSeed.esp")
    dirtywater[1] = Game.getFormFromFile(0x10890, "LastSeed.esp")
	dirtywater[2] = Game.getFormFromFile(0x10892, "LastSeed.esp")
EndFunction

Function load_defaults()
    waterskin_crafting_hour = 2.0
	rainbarrel_crafting_hour = 3.0
	water_distilling_minute = 20.0
	water_purifying_minute = 20.0
EndFunction

bool Function handle_added_item(Form item)
	if main.get_prefix(item) != prefix
		return False
    endif

	item_name = item.getName()		
	main._debug("Last Seed Item - " + item_name)
	
	if item == waterskin
		main._debug("Last Seed Waterskin made")
		if waterskin_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
		main.pass_time(waterskin_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
	elseif item == rainbarrel
		main._debug("Rain barrel made")
		if rainbarrel_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
		main.pass_time(rainbarrel_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
	else
        main._debug("Last Seed misc item ignored")
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
	elseif dirtywater.find(item) > -1
		main._debug("Purified dirty water")
		main.pass_time(water_purifying_minute * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Alchemy") / 60)
	else
		return False
    endif
EndFunction

Function save_settings()
    mcm.fiss.saveFloat("lastseed_waterskin_crafting_hour", waterskin_crafting_hour)
	mcm.fiss.saveFloat("lastseed_rainbarrel_crafting_hour", rainbarrel_crafting_hour)
	mcm.fiss.saveFloat("lastseed_water_distilling_minute", water_distilling_minute)
	mcm.fiss.saveFloat("lastseed_water_purifying_minute", water_purifying_minute)
EndFunction

Function load_settings()
    waterskin_crafting_hour = mcm.fiss.loadFloat( \
        "lastseed_waterskin_crafting_hour")
	rainbarrel_crafting_hour = mcm.fiss.loadFloat( \
        "lastseed_rainbarrel_crafting_hour")
	water_distilling_minute = mcm.fiss.loadFloat( \
        "lastseed_water_distilling_minute")
	water_purifying_minute = mcm.fiss.loadFloat( \
        "lastseed_water_purifying_minute")
EndFunction

bool Function handle_page(string page)
    if page != "$lastseed"
        return False
    endif

    if prefix == 255
        mcm.addTextOption("", "$lastseed_not_installed")
    else
        mcm.setCursorFillMode(mcm.TOP_TO_BOTTOM)
		
        mcm.addHeaderOption("$crafting")
        waterskin_crafting_hour_id = mcm.addSliderOption( \
            "$lastseed_waterskin", waterskin_crafting_hour, "${2}hour")
		rainbarrel_crafting_hour_id = mcm.addSliderOption( \
            "$lastseed_rainbarrel", rainbarrel_crafting_hour, "${2}hour")
		
		mcm.setCursorPosition(1)
		mcm.addHeaderOption("$activities")
		water_distilling_minute_id = mcm.addSliderOption( \
            "$water_distilling", water_distilling_minute, "${0}min")
		water_purifying_minute_id = mcm.addSliderOption( \
            "$water_purifying", water_purifying_minute, "${0}min")
    endif
    return True
EndFunction

bool Function handle_slider_opened(int option)
    if option == waterskin_crafting_hour_id
        mcm.setSliderDialogStartValue(waterskin_crafting_hour)
        mcm.setSliderDialogDefaultValue(2.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
	elseif option == rainbarrel_crafting_hour_id
        mcm.setSliderDialogStartValue(rainbarrel_crafting_hour)
        mcm.setSliderDialogDefaultValue(3.0)
        mcm.setSliderDialogRange(0.0, 0.25)
        mcm.setSliderDialogInterval(0.25)
	elseif option == water_distilling_minute_id
        mcm.setSliderDialogStartValue(water_distilling_minute)
        mcm.setSliderDialogDefaultValue(20.0)
        mcm.setSliderDialogRange(0.0, 60.0)
        mcm.setSliderDialogInterval(1.0)
	elseif option == water_purifying_minute_id
        mcm.setSliderDialogStartValue(water_purifying_minute)
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
	elseif option == rainbarrel_crafting_hour_id
        rainbarrel_crafting_hour = value
        mcm.setSliderOptionValue(rainbarrel_crafting_hour_id, value, "${2}hour")
	elseif option == water_distilling_minute_id
        water_distilling_minute = value
        mcm.setSliderOptionValue(water_distilling_minute_id, value, "${0}min")
    elseif option == water_purifying_minute_id
        water_purifying_minute = value
        mcm.setSliderOptionValue(water_purifying_minute_id, value, "${0}min")
    else
        return False
    endif
    return True
EndFunction

bool Function handle_option_highlighted(int option)
    if option == waterskin_crafting_hour_id || \
			option == rainbarrel_crafting_hour_id || \
			option == water_distilling_minute_id || \
			option == water_purifying_minute_id
        mcm.setInfoText("$time_passed_performing_this_action")
    else
        return False
    endif
    return True
EndFunction
