Scriptname TFHuntingInSkyrim extends Quest

TimeFliesMain Property main Auto
TimeFliesMCM Property mcm Auto

;;Crafting
float fishingrod_crafting_hour
int fishingrod_crafting_hour_id
float arrowkit_crafting_hour
int arrowkit_crafting_hour_id
float trapkit_crafting_hour
int trapkit_crafting_hour_id
float mortarpestle_crafting_hour
int mortarpestle_crafting_hour_id
Form arrowkit
Form[] trapkit
Form[] mortarpestle
Form[] fishingrod

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
int is_enabled_id
int prefix
string item_name

ObjectReference furniture_using
int item_type

Function initialize()
    prefix = Game.getModByName("Hunting in Skyrim.esp")    
    if prefix == 255
		main._debug("Hunting in Skyrim not installed " + prefix)
        return
    endif	
	main._debug("Hunting in Skyrim initialized " + prefix)

	arrowkit = Game.getFormFromFile(0x31dffd, "Hunting in Skyrim.esp")
	
	trapkit = new Form[9]
	trapkit[0] = Game.getFormFromFile(0x135a43, "Hunting in Skyrim.esp")
	trapkit[1] = Game.getFormFromFile(0x136fe4, "Hunting in Skyrim.esp")
	trapkit[2] = Game.getFormFromFile(0x136fe5, "Hunting in Skyrim.esp")
	trapkit[3] = Game.getFormFromFile(0x136fe6, "Hunting in Skyrim.esp")
	trapkit[4] = Game.getFormFromFile(0x13a609, "Hunting in Skyrim.esp")
	trapkit[5] = Game.getFormFromFile(0x137551, "Hunting in Skyrim.esp")
	trapkit[6] = Game.getFormFromFile(0x137552, "Hunting in Skyrim.esp")
	trapkit[7] = Game.getFormFromFile(0x137553, "Hunting in Skyrim.esp")
	trapkit[8] = Game.getFormFromFile(0x124560, "Hunting in Skyrim.esp")
	
	mortarpestle = new Form[4]
	mortarpestle[0] = Game.getFormFromFile(0x40e1ee, "Hunting in Skyrim.esp")
	mortarpestle[1] = Game.getFormFromFile(0x37e3b2, "Hunting in Skyrim.esp")
	mortarpestle[2] = Game.getFormFromFile(0x37e3b3, "Hunting in Skyrim.esp")
	mortarpestle[3] = Game.getFormFromFile(0x37e3b4, "Hunting in Skyrim.esp")
	
	fishingrod = new Form[3]
    fishingrod[0] = Game.getFormFromFile(0x45d28d, "Hunting in Skyrim.esp")
    fishingrod[1] = Game.getFormFromFile(0x45d29d, "Hunting in Skyrim.esp")
    fishingrod[2] = Game.getFormFromFile(0x45d29e, "Hunting in Skyrim.esp")
EndFunction

Function load_defaults()	
	;;Fishing
	fishing_minute = 30.0
	random_fishing_time = True
    random_fishing_time_multiplier_min = 0.10
    random_fishing_time_multiplier_max = 1.5
	
	;Crafting
	arrowkit_crafting_hour = 1.5
	trapkit_crafting_hour = 1.5
	mortarpestle_crafting_hour = 2.0
	fishingrod_crafting_hour = 3.0
EndFunction

bool Function handle_added_item(Form item)
	if main.get_prefix(item) != prefix
        return False
    endif
	
	item_name = item.getName()
	main._debug("Hunting in Skyrim Item - " + item_name)
	
	if item == arrowkit
		main._debug("Arrow crafting kit made")
		if arrowkit_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
		main.pass_time(arrowkit_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
	elseif trapkit.find(item) > -1
		main._debug("Animal trap or trap repair kit made")
		if trapkit_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
		main.pass_time(trapkit_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))	
	elseif mortarpestle.find(item) > -1
		main._debug("Mortar & pestle made")
		if mortarpestle_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
		main.pass_time(mortarpestle_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
	elseif fishingrod.find(item) > -1
		main._debug("Fishing rod made")
		if fishingrod_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
		main.pass_time(fishingrod_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
    else
        main._debug("Hunting in Skyrim misc item ignored")
    endif
    return True
EndFunction

bool Function handle_removed_item(Form item)
	item_name = item.getName()
	
	if main.get_prefix(item) != prefix \
		|| UI.IsMenuOpen("InventoryMenu") \
		|| UI.IsMenuOpen("ContainerMenu") \
		|| UI.IsMenuOpen("BarterMenu") \
		|| UI.IsMenuOpen("Crafting Menu")
        return False
	elseif item_name == "Fishing Rod (Cheap)" \
		|| item_name == "Fishing Rod (Standard)" \
		|| item_name == "Fishing Rod (Quality)"
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
    mcm.fiss.saveFloat("arrowkit_crafting_hour", \
		arrowkit_crafting_hour)
	mcm.fiss.saveFloat("trapkit_crafting_hour", \
		trapkit_crafting_hour)
	mcm.fiss.saveFloat("mortarpestle_crafting_hour", \
		mortarpestle_crafting_hour)
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
    arrowkit_crafting_hour = \
		mcm.fiss.loadFloat("arrowkit_crafting_hour")
	trapkit_crafting_hour = \
		mcm.fiss.loadFloat("trapkit_crafting_hour")	
	mortarpestle_crafting_hour = \
		mcm.fiss.loadFloat("mortarpestle_crafting_hour")
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
    if page != "$huntinginskyrim"
        return False
    endif

    if prefix == 255
        mcm.addTextOption("", "$huntinginskyrim_not_installed")
    else
        mcm.setCursorFillMode(mcm.TOP_TO_BOTTOM)
        mcm.addHeaderOption("$crafting")
        arrowkit_crafting_hour_id = mcm.addSliderOption( \
            "$arrowkit", arrowkit_crafting_hour, "${2}hour")
		trapkit_crafting_hour_id = mcm.addSliderOption( \
            "$trapkit", trapkit_crafting_hour, "${2}hour")
		mortarpestle_crafting_hour_id = mcm.addSliderOption( \
            "$mortarpestle", mortarpestle_crafting_hour, "${2}hour")			
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
		elseif !random_fishing_time
			mcm.setOptionFlags(random_fishing_time_multiplier_min_id, mcm.OPTION_FLAG_DISABLED)
			mcm.setOptionFlags(random_fishing_time_multiplier_max_id, mcm.OPTION_FLAG_DISABLED)			
		endif
	else
		return False
	endif
	return True
EndFunction

bool Function handle_slider_opened(int option)
    if option == arrowkit_crafting_hour_id
       mcm.setSliderDialogStartValue(arrowkit_crafting_hour)
       mcm.setSliderDialogDefaultValue(1.5)
       mcm.setSliderDialogRange(0.0, 8.0)
       mcm.setSliderDialogInterval(0.25)
    elseif option == trapkit_crafting_hour_id
       mcm.setSliderDialogStartValue(trapkit_crafting_hour)
       mcm.setSliderDialogDefaultValue(1.5)
       mcm.setSliderDialogRange(0.0, 8.0)
       mcm.setSliderDialogInterval(0.25)
	elseif option == mortarpestle_crafting_hour_id
       mcm.setSliderDialogStartValue(mortarpestle_crafting_hour)
       mcm.setSliderDialogDefaultValue(2.0)
       mcm.setSliderDialogRange(0.0, 8.0)
       mcm.setSliderDialogInterval(0.25)
    elseif option == fishingrod_crafting_hour_id
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
    if option == arrowkit_crafting_hour_id
        arrowkit_crafting_hour = value
        mcm.setSliderOptionValue(arrowkit_crafting_hour_id, value, "${2}hour")
    elseif option == trapkit_crafting_hour_id
        trapkit_crafting_hour = value
        mcm.setSliderOptionValue(trapkit_crafting_hour_id, value, "${2}hour")
	elseif option == mortarpestle_crafting_hour_id
        mortarpestle_crafting_hour = value
        mcm.setSliderOptionValue(mortarpestle_crafting_hour_id, value, "${2}hour")
    elseif option == fishingrod_crafting_hour_id
        fishingrod_crafting_hour = value
        mcm.setSliderOptionValue(fishingrod_crafting_hour_id, value, "${2}hour")
	elseif option == fishing_minute_id
        fishing_minute = value
        mcm.setSliderOptionValue(fishing_minute_id, value, "${0}min")	
	elseif option == random_fishing_time_multiplier_min_id
        random_fishing_time_multiplier_min = value
        mcm.setSliderOptionValue(random_fishing_time_multiplier_min_id, value, "$x{2}")
    elseif option == random_fishing_time_multiplier_max_id
        random_fishing_time_multiplier_max = value
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
    if option == arrowkit_crafting_hour_id || \
			option == trapkit_crafting_hour_id || \
			option == mortarpestle_crafting_hour_id || \
			option == fishingrod_crafting_hour_id || \
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