Scriptname TFCampsite extends Quest

TimeFliesMain Property main Auto
TimeFliesMCM Property mcm Auto

int prefix
float tent_crafting_hour
int tent_crafting_hour_id
float cooking_pot_crafting_hour
int cooking_pot_crafting_hour_id
float fire_building_minute
int fire_building_minute_id
float tent_pitching_minute
int tent_pitching_minute_id

Form[] tent
Form campfire
Form cooking_pot

string item_name

Function initialize()
    prefix = Game.getModByName("Campsite.esp")
	if prefix == 255
		main._debug("Campsite not installed " + prefix)
        return
    endif
    main._debug("Campsite initialized " + prefix)
	
	cooking_pot = Game.getFormFromFile(0x2E20A, "Campsite.esp")
	campfire = Game.getFormFromFile(0x6f993, "Skyrim.esm")
	
    tent = new Form[4]
    tent[0] = Game.getFormFromFile(0x14c13, "Campsite.esp")
    tent[1] = Game.getFormFromFile(0x14c14, "Campsite.esp")
	tent[2] = Game.getFormFromFile(0x14c15, "Campsite.esp")
	tent[3] = Game.getFormFromFile(0x23F35, "Campsite.esp")
EndFunction

Function load_defaults()
    tent_crafting_hour = 2.5
    cooking_pot_crafting_hour = 2.0
	main.fire_building_minute = 15.0
	tent_pitching_minute = 15.0
EndFunction

bool Function handle_added_item(Form item)
    if main.get_prefix(item) != prefix
		return False
    endif
	
	item_name = item.getName()
	main._debug("Campsite Item - " + item_name)

    if item == cooking_pot
        main._debug("Cooking pot made")
		if cooking_pot_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(cooking_pot_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))	
    elseif tent.find(item) > -1
        main._debug("Tent made")
		if tent_crafting_hour >= main.transition_threshold
			main.Transition()
            main.pass_time(tent_crafting_hour * \
				main.random_time_multiplier())
        endif
    else
        main._debug("Campsite irrelevant item ignored")
    endif
    return True
EndFunction

bool Function handle_removed_item(Form item)
	if main.get_prefix(item) != prefix
		return False
	endif	
		
	if tent.find(item) > -1 
		Utility.Wait(3.0)
		if UI.isMenuOpen("MessageBoxMenu")
			return False
		else
			main._debug("Pitched tent")
			main.pass_time( \
				tent_pitching_minute * main.random_time_multiplier() / 60)
			return True
		endif
	elseif item == campfire 
		main._debug("Built campfire")
		main.pass_time( \
            main.fire_building_minute * main.random_time_multiplier() / 60)
		return True
    else
        return False
    endif
EndFunction

Function save_settings()
    mcm.fiss.saveFloat("cs_tent_crafting_hour", \
        tent_crafting_hour)
    mcm.fiss.saveFloat("cs_cooking_pot_crafting_hour", \
        cooking_pot_crafting_hour)
	mcm.fiss.saveFloat("cs_fire_building_minute", \
		main.fire_building_minute)
	mcm.fiss.saveFloat("cs_tent_pitching_minute", \
		tent_pitching_minute)
EndFunction

Function load_settings()
    tent_crafting_hour = \
        mcm.fiss.loadFloat("cs_tent_crafting_hour")
    cooking_pot_crafting_hour = \
        mcm.fiss.loadFloat("cs_cooking_pot_crafting_hour")
	main.fire_building_minute = \
		mcm.fiss.loadFloat("cs_fire_building_minute")	
	tent_pitching_minute = \
		mcm.fiss.loadFloat("tent_pitching_minute")	
EndFunction

bool Function handle_page(string page)
    if page != "$campsite"
        return False
    endif

    if prefix == 255
        mcm.addTextOption("", "$cs_not_installed")
    else
        mcm.setCursorFillMode(mcm.TOP_TO_BOTTOM)		
        mcm.addHeaderOption("$crafting")
		tent_crafting_hour_id = mcm.addSliderOption( \
            "$cs_tent", tent_crafting_hour, "${2}hour")
        cooking_pot_crafting_hour_id = mcm.addSliderOption( \
            "$cs_cooking_pot", cooking_pot_crafting_hour, "${2}hour")
	
		mcm.setCursorPosition(1)
		mcm.addHeaderOption("$activities")
		fire_building_minute_id = mcm.addSliderOption( \
            "$cs_fire_build", main.fire_building_minute, "${0}min")	
		tent_pitching_minute_id = mcm.addSliderOption( \
            "$cs_tent_pitch", tent_pitching_minute, "${0}min")	
    endif

    return True
EndFunction

bool Function handle_slider_opened(int option)
    if option == tent_crafting_hour_id
        mcm.setSliderDialogStartValue(tent_crafting_hour)
        mcm.setSliderDialogDefaultValue(2.5)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
    elseif option == cooking_pot_crafting_hour_id
        mcm.setSliderDialogStartValue(cooking_pot_crafting_hour)
        mcm.setSliderDialogDefaultValue(2.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
	elseif option == fire_building_minute_id
       mcm.setSliderDialogStartValue(main.fire_building_minute)
       mcm.setSliderDialogDefaultValue(15.0)
       mcm.setSliderDialogRange(0.0, 60.0)
       mcm.setSliderDialogInterval(1.0)	
	 elseif option == tent_pitching_minute_id
       mcm.setSliderDialogStartValue(tent_pitching_minute)
       mcm.setSliderDialogDefaultValue(15.0)
       mcm.setSliderDialogRange(0.0, 60.0)
       mcm.setSliderDialogInterval(1.0)	
    else
        return False
    endif
    return True
EndFunction

bool Function handle_slider_accepted(int option, float value)
    if option == tent_crafting_hour_id
        tent_crafting_hour = value
        mcm.setSliderOptionValue(tent_crafting_hour_id, value, "${2}hour")
    elseif option == cooking_pot_crafting_hour_id
        cooking_pot_crafting_hour = value
        mcm.setSliderOptionValue( \
            cooking_pot_crafting_hour_id, value, "${2}hour")
	elseif option == fire_building_minute_id
        main.fire_building_minute = value
        mcm.setSliderOptionValue(fire_building_minute_id, value, "${0}min")
	elseif option == tent_pitching_minute_id
        tent_pitching_minute = value
        mcm.setSliderOptionValue(tent_pitching_minute_id, value, "${0}min")			
    else
        return False
    endif
    return True
EndFunction

bool Function handle_option_highlighted(int option)
    if option == tent_crafting_hour_id || \			
            option == cooking_pot_crafting_hour_id || \
			option == tent_pitching_minute_id || \
			option == fire_building_minute_id
        mcm.setInfoText("$time_passed_performing_this_action")
    else
        return False
    endif
    return True
EndFunction
