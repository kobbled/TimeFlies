Scriptname TFSkyrimFishing extends Quest

TimeFliesMain Property main Auto
TimeFliesMCM Property mcm Auto

;;Crafting
int prefix
float fishingrod_crafting_hour
int fishingrod_crafting_hour_id
Form fishingrod

;;Fishing
float fishing_minute
bool random_fishing_time
float random_fishing_time_multiplier_min
float random_fishing_time_multiplier_max
int fishing_minute_id
int random_fishing_time_id
int random_fishing_time_multiplier_min_id
int random_fishing_time_multiplier_max_id

;; Private variables
float fishing_time_to_pass = 0.0
string item_name

ObjectReference furniture_using
int item_type

Function initialize()
    prefix = Game.getModByName("BBD_SkyrimFishing.esp")
	if prefix == 255
		main._debug("Skyrim Fishing not installed " + prefix)	
		return
    endif
    main._debug("Skyrim Fishing initialized " + prefix)	
	
    fishingrod = Game.getFormFromFile(0xd65, "BBD_SkyrimFishing.esp")
EndFunction

Function load_defaults()	
	;;Fishing
	fishing_minute = 30.0
	random_fishing_time = True
    random_fishing_time_multiplier_min = 0.10
    random_fishing_time_multiplier_max = 1.5
	
	;Crafting
	fishingrod_crafting_hour = 3.0
EndFunction

bool Function handle_added_item(Form item)
	if main.get_prefix(item) != prefix
		return False
    endif

	item_name = item.getName()
	main._debug("Skyrim Fishing Item - " + item_name)
	
    if item == fishingrod && UI.IsMenuOpen("CraftingMenu")
		main._debug("Fishing rod made")
		if fishingrod_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
		main.pass_time(fishingrod_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
		return True
    else
        main._debug("Skyrim Fishing misc item ignored")
		return False
    endif
EndFunction

bool Function handle_removed_item(Form item)	
	item_name = item.getName()
	
	if main.get_prefix(item) != prefix \
		|| UI.IsMenuOpen("InventoryMenu") \
		|| UI.IsMenuOpen("ContainerMenu") \
		|| UI.IsMenuOpen("BarterMenu") \
		|| UI.IsMenuOpen("Crafting Menu")
        return False
	elseif item_name == "Fishing Rod"
		main._debug("Went fishing")
		main.pass_time( \
			fishing_minute * random_fishing_time_multiplier() / 60)	
		return True
	else
        return False
    endif
EndFunction

float Function random_fishing_time_multiplier()
    if random_fishing_time
        return Utility.randomFloat(random_fishing_time_multiplier_min, \
           random_fishing_time_multiplier_max)
    else
        return 1.0
    endif
EndFunction



Function save_settings()
    mcm.fiss.saveFloat("fishingrod_crafting_hour", \
		fishingrod_crafting_hour)
	mcm.fiss.saveFloat("fishing_minute", \
		fishing_minute)
	mcm.fiss.saveBool("random_fishing_time", \
		random_fishing_time)
	mcm.fiss.saveFloat("random_fishing_time_multiplier_min", \
		random_fishing_time_multiplier_min)
	mcm.fiss.saveFloat("random_fishing_time_multiplier_max", \
		random_fishing_time_multiplier_max)
EndFunction

Function load_settings()
    fishingrod_crafting_hour = \
		mcm.fiss.loadFloat("fishingrod_crafting_hour")
	fishing_minute = \
		mcm.fiss.loadFloat("fishing_minute")
	random_fishing_time = \
		mcm.fiss.loadBool("random_fishing_time")
	random_fishing_time_multiplier_min = \
		mcm.fiss.loadFloat("random_fishing_time_multiplier_min")	
	random_fishing_time_multiplier_max = \
		mcm.fiss.loadFloat("random_fishing_time_multiplier_max")
	EndFunction

bool Function handle_page(string page)
    if page != "$skyrimfishing"
        return False
    endif

    if prefix == 255
        mcm.addTextOption("", "$skyrimfishing_not_installed")
    else
        mcm.setCursorFillMode(mcm.TOP_TO_BOTTOM)
        mcm.addHeaderOption("$crafting")
        fishingrod_crafting_hour_id = mcm.addSliderOption( \
            "$fishingrod", fishingrod_crafting_hour, "${2}hour")
		
		mcm.setCursorPosition(1)
		mcm.addHeaderOption("$activities")		
		fishing_minute_id = mcm.addSliderOption( \
            "$fishing", fishing_minute, "${0}min")
			
		random_fishing_time_id = mcm.addToggleOption( \
            "$random_fishing_time", random_fishing_time)
		if random_fishing_time 
			random_fishing_time_multiplier_min_id = mcm.addSliderOption( \
				"$random_time_multiplier_min", \
				random_fishing_time_multiplier_min, "$x{2}", mcm.OPTION_FLAG_NONE)
			random_fishing_time_multiplier_max_id = mcm.addSliderOption( \
				"$random_time_multiplier_max", \
				random_fishing_time_multiplier_max, "$x{2}", mcm.OPTION_FLAG_NONE)
		else
			random_fishing_time_multiplier_min_id = mcm.addSliderOption( \
				"$random_time_multiplier_min", \
				random_fishing_time_multiplier_min, "$x{2}", mcm.OPTION_FLAG_DISABLED)
			random_fishing_time_multiplier_max_id = mcm.addSliderOption( \
				"$random_time_multiplier_max", \
				random_fishing_time_multiplier_max, "$x{2}", mcm.OPTION_FLAG_DISABLED)
		endif
        		
    endif
    return True
EndFunction

bool Function handle_option_selected(int option)
    if option == random_fishing_time_id
        random_fishing_time = !random_fishing_time
        mcm.setToggleOptionValue(random_fishing_time_id, \
            random_fishing_time)
		if random_fishing_time 
			mcm.setOptionFlags(random_fishing_time_multiplier_min_id, mcm.OPTION_FLAG_NONE)
			mcm.setOptionFlags(random_fishing_time_multiplier_max_id, mcm.OPTION_FLAG_NONE)
		else
			mcm.setOptionFlags(random_fishing_time_multiplier_min_id, mcm.OPTION_FLAG_DISABLED)
			mcm.setOptionFlags(random_fishing_time_multiplier_max_id, mcm.OPTION_FLAG_DISABLED)
		endif
	else	
		return False
	endif
	return True
EndFunction

bool Function handle_slider_opened(int option)
    if option == fishingrod_crafting_hour_id
       mcm.setSliderDialogStartValue(fishingrod_crafting_hour)
       mcm.setSliderDialogDefaultValue(3.0)
       mcm.setSliderDialogRange(0.0, 8.0)
       mcm.setSliderDialogInterval(0.25)
    elseif option == fishing_minute_id
       mcm.setSliderDialogStartValue(fishing_minute)
       mcm.setSliderDialogDefaultValue(30.0)
       mcm.setSliderDialogRange(0.0, 60.0)
       mcm.setSliderDialogInterval(1.0)
	elseif option == random_fishing_time_multiplier_min_id
       mcm.setSliderDialogStartValue(random_fishing_time_multiplier_min)
       mcm.setSliderDialogDefaultValue(0.10)
       mcm.setSliderDialogRange(0.05, 1.00)
       mcm.setSliderDialogInterval(0.01)
    elseif option == random_fishing_time_multiplier_max_id
       mcm.setSliderDialogStartValue(random_fishing_time_multiplier_max)
       mcm.setSliderDialogDefaultValue(1.50)
       mcm.setSliderDialogRange(1.00, 3.00)
       mcm.setSliderDialogInterval(0.01)   	   
	else
        return False
    endif
    return True
EndFunction

bool Function handle_slider_accepted(int option, float value)
    if option == fishingrod_crafting_hour_id
        fishingrod_crafting_hour = value
        mcm.setSliderOptionValue(fishingrod_crafting_hour_id, value, "${2}hour")
	elseif option == fishing_minute_id
        fishing_minute = value
        mcm.setSliderOptionValue(fishing_minute_id, value, "${0}min")	
	elseif option == random_fishing_time_multiplier_min_id
        main.random_time_multiplier_min = value
        mcm.setSliderOptionValue(random_fishing_time_multiplier_min_id, value, "$x{2}")
    elseif option == random_fishing_time_multiplier_max_id
        main.random_time_multiplier_max = value
        mcm.setSliderOptionValue(random_fishing_time_multiplier_max_id, value, "$x{2}")		
    else
        return False
    endif
    return True
EndFunction

bool Function handle_option_set_default(int option)
	if option == random_fishing_time_id
        random_fishing_time = True
        mcm.setToggleOptionValue(random_fishing_time_id, True)
	else
		return False
	endif
	return True
EndFunction

bool Function handle_option_highlighted(int option)
    if option == fishingrod_crafting_hour_id || \
			option == fishing_minute_id
        mcm.setInfoText("$time_passed_performing_this_action")
	elseif option == random_fishing_time_id
		mcm.setInfoText("$use_random_multiplier_calculating_fishing_time")
	elseif option == random_fishing_time_multiplier_min_id
		mcm.setInfoText("$random_multiplier_minimum")
	elseif option == random_fishing_time_multiplier_max_id
		mcm.setInfoText("$random_multiplier_maximum")
    else
        return False
    endif
    return True
EndFunction