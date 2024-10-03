Scriptname TFSunHelm extends Quest

TimeFliesMain Property main Auto
TimeFliesMCM Property mcm Auto

int prefix
float waterskin_crafting_hour
int waterskin_crafting_hour_id
float water_distilling_minute
int water_distilling_minute_id
Form waterskin
Form[] saltwater

ObjectReference furniture_using
string item_name

Function initialize()
    prefix = Game.getModByName("SunHelmSurvival.esp")
	if prefix == 255
        main._debug("SunHelm not installed " + prefix)
		return
    endif
    main._debug("SunHelm initialized " + prefix)

	waterskin = Game.GetFormFromFile(0x4de9Ad, "SunHelmSurvival.esp")
	
	saltwater = new Form[4]
    saltwater[0] = Game.getFormFromFile(0x4edcc1, "SunHelmSurvival.esp")
    saltwater[1] = Game.getFormFromFile(0x265be3, "SunHelmSurvival.esp")
    saltwater[2] = Game.getFormFromFile(0x265be7, "SunHelmSurvival.esp")
	saltwater[3] = Game.getFormFromFile(0x326258, "SunHelmSurvival.esp")
EndFunction

Function load_defaults()
    waterskin_crafting_hour = 2.0
	water_distilling_minute = 20.0
EndFunction

bool Function handle_added_item(Form item)
	if main.get_prefix(item) != prefix
		return False
    endif

	item_name = item.getName()		
	main._debug("SunHelm Item - " + item_name)
	
	if item == waterskin
		main._debug("SunHelm Waterskin made")
		if waterskin_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
		main.pass_time(waterskin_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
	else
        main._debug("SunHelm misc item ignored")
	endif		
    return True
EndFunction

bool Function handle_removed_item(Form item)
	Bool isInventoryMenuOpen = UI.IsMenuOpen("InventoryMenu")
	Bool isContainerMenuOpen = UI.IsMenuOpen("ContainerMenu")
	if main.get_prefix(item) != prefix || isInventoryMenuOpen || isContainerMenuOpen
		return False	
	elseif saltwater.find(item) > -1
		main._debug("Distilled saltwater")
		main.pass_time(water_distilling_minute * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Alchemy") / 60)
	else
		return False
    endif
EndFunction

Function save_settings()
    mcm.fiss.saveFloat("sunhelm_waterskin_crafting_hour", waterskin_crafting_hour)
	mcm.fiss.saveFloat("sunhelm_water_distilling_minute", water_distilling_minute)
EndFunction

Function load_settings()
    waterskin_crafting_hour = mcm.fiss.loadFloat( \
        "sunhelm_waterskin_crafting_hour")
	water_distilling_minute = mcm.fiss.loadFloat( \
        "sunhelm_water_distilling_minute")
EndFunction

bool Function handle_page(string page)
    if page != "$sunhelm"
        return False
    endif

    if prefix == 255
        mcm.addTextOption("", "$sunhelm_not_installed")
    else
        mcm.setCursorFillMode(mcm.TOP_TO_BOTTOM)
		
        mcm.addHeaderOption("$crafting")
        waterskin_crafting_hour_id = mcm.addSliderOption( \
            "$sunhelm_waterskin", waterskin_crafting_hour, "${2}hour")
		
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
			option == water_distilling_minute_id
        mcm.setInfoText("$time_passed_performing_this_action")
    else
        return False
    endif
    return True
EndFunction
