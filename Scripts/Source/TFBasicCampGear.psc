Scriptname TFBasicCampGear extends Quest

TimeFliesMain Property main Auto
TimeFliesMCM Property mcm Auto

int prefix
float tent_crafting_hour
int tent_crafting_hour_id
float fire_crafting_minute
int fire_crafting_minute_id
float cooking_pot_crafting_hour
int cooking_pot_crafting_hour_id
float beartrap_crafting_hour
int beartrap_crafting_hour_id
float bedroll_crafting_hour
int bedroll_crafting_hour_id
float rug_crafting_hour
int rug_crafting_hour_id
float fire_building_minute
int fire_building_minute_id
float tent_pitching_minute
int tent_pitching_minute_id

Form[] tent
Form[] campfire
Form cooking_pot
Form beartrap
Form bedroll
Form rug

string item_name

Function initialize()
    prefix = Game.getModByName("BasicCampGear.esp")
	if prefix == 255
		main._debug("Basic Camp Gear not installed " + prefix)
        return
    endif
    main._debug("Basic Camp Gear initialized " + prefix)	

    cooking_pot = Game.getFormFromFile(0x901, "BasicCampGear.esp")
	beartrap = Game.getFormFromFile(0xa01, "BasicCampGear.esp")
	bedroll = Game.getFormFromFile(0xb01, "BasicCampGear.esp")
	rug = Game.getFormFromFile(0x801, "BasicCampGear.esp")
	
	campfire = new Form[2]
	campfire[0] = Game.getFormFromFile(0xf01, "BasicCampGear.esp")
	campfire[1] = Game.getFormFromFile(0xc01, "BasicCampGear.esp")

    tent = new Form[2]
    tent[0] = Game.getFormFromFile(0xd01, "BasicCampGear.esp")
    tent[1] = Game.getFormFromFile(0xee1, "BasicCampGear.esp")
EndFunction

Function load_defaults()
    tent_crafting_hour = 2.5
	fire_crafting_minute = 30.0
    cooking_pot_crafting_hour = 2.0
	beartrap_crafting_hour = 1.5
	bedroll_crafting_hour = 1.5
	rug_crafting_hour = 1.5
	fire_building_minute = 15.0
	tent_pitching_minute = 15.0
EndFunction

bool Function handle_added_item(Form item)	
    if main.get_prefix(item) != prefix
		return False
    endif
	
	item_name = item.getName()
	main._debug("Basic Camp Gear Item - " + item_name)

    if item == cooking_pot
        main._debug("Cooking pot made")
		if cooking_pot_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(cooking_pot_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
	elseif item == beartrap
        main._debug("Beartrap made")
		if beartrap_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(beartrap_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
	elseif item == bedroll
        main._debug("Bedroll made")
		if bedroll_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(bedroll_crafting_hour * \
			main.random_time_multiplier())
	elseif item == rug
        main._debug("Rug made")
		if rug_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(rug_crafting_hour * \
			main.random_time_multiplier())
	elseif campfire.find(item) > -1
        main._debug("Campfire or cookfire made")
        main.pass_time(fire_crafting_minute * \
			main.random_time_multiplier() / 60)
    elseif tent.find(item) > -1
        main._debug("Tent made")
		if tent_crafting_hour >= main.transition_threshold
			main.Transition()
            main.pass_time(tent_crafting_hour * \
				main.random_time_multiplier())
        endif
    else
        main._debug("Basic Camp Gear irrelevant item ignored")
    endif
    return True
EndFunction

bool Function handle_removed_item(Form item)
	if main.get_prefix(item) != prefix
		return False
	elseif tent.find(item) > -1 
		main._debug("Pitched tent")
		main.pass_time(tent_pitching_minute * \
			main.random_time_multiplier() / 60)
		return True
	elseif campfire.find(item) > -1 
		main._debug("Built fire")
		main.pass_time(fire_building_minute * \
			main.random_time_multiplier() / 60)
		return True
    else
        return False
    endif
EndFunction

Function save_settings()
    mcm.fiss.saveFloat("bcg_tent_crafting_hour", \
        tent_crafting_hour)
	mcm.fiss.saveFloat("bcg_fire_crafting_minute", \
        fire_crafting_minute)
    mcm.fiss.saveFloat("bcg_cooking_pot_crafting_hour", \
        cooking_pot_crafting_hour)
	mcm.fiss.saveFloat("bcg_beartrap_crafting_hour", \
        cooking_pot_crafting_hour)
	mcm.fiss.saveFloat("bcg_bedroll_crafting_hour", \
        cooking_pot_crafting_hour)
	mcm.fiss.saveFloat("bcg_rug_crafting_hour", \
        cooking_pot_crafting_hour)
	mcm.fiss.saveFloat("bcg_fire_building_minute", fire_building_minute)
	mcm.fiss.saveFloat("bcg_tent_pitching_minute", tent_pitching_minute)
EndFunction

Function load_settings()
    tent_crafting_hour = \
        mcm.fiss.loadFloat("bcg_tent_crafting_hour")
	fire_crafting_minute = \
        mcm.fiss.loadFloat("bcg_fire_crafting_minute")
    cooking_pot_crafting_hour = \
        mcm.fiss.loadFloat("bcg_cooking_pot_crafting_hour")
	beartrap_crafting_hour = \
        mcm.fiss.loadFloat("bcg_beartrap_crafting_hour")
	bedroll_crafting_hour = \
        mcm.fiss.loadFloat("bcg_bedroll_crafting_hour")
	rug_crafting_hour = \
        mcm.fiss.loadFloat("bcg_rug_crafting_hour")
	fire_building_minute = mcm.fiss.loadFloat("bcg_fire_building_minute")	
	tent_pitching_minute = mcm.fiss.loadFloat("tent_pitching_minute")	
EndFunction

bool Function handle_page(string page)
    if page != "$basiccampgear"
        return False
    endif

    if prefix == 255
        mcm.addTextOption("", "$bcg_not_installed")
    else
        mcm.setCursorFillMode(mcm.TOP_TO_BOTTOM)		
        mcm.addHeaderOption("$crafting")
		tent_crafting_hour_id = mcm.addSliderOption( \
            "$bcg_tent", tent_crafting_hour, "${2}hour")
		fire_crafting_minute_id = mcm.addSliderOption( \
            "$bcg_fire_crafting", fire_crafting_minute, "${0}min")
        cooking_pot_crafting_hour_id = mcm.addSliderOption( \
            "$bcg_cooking_pot", cooking_pot_crafting_hour, "${2}hour")
		beartrap_crafting_hour_id = mcm.addSliderOption( \
            "$bcg_beartrap", beartrap_crafting_hour, "${2}hour")
		bedroll_crafting_hour_id = mcm.addSliderOption( \
            "$bcg_bedroll", bedroll_crafting_hour, "${2}hour")
		rug_crafting_hour_id = mcm.addSliderOption( \
            "$bcg_rug", rug_crafting_hour, "${2}hour")
	
		mcm.setCursorPosition(1)
		mcm.addHeaderOption("$activities")
		fire_building_minute_id = mcm.addSliderOption( \
            "$bcg_fire_build", fire_building_minute, "${0}min")	
		tent_pitching_minute_id = mcm.addSliderOption( \
            "$bcg_tent_pitch", tent_pitching_minute, "${0}min")	
    endif

    return True
EndFunction

bool Function handle_slider_opened(int option)
    if option == tent_crafting_hour_id
        mcm.setSliderDialogStartValue(tent_crafting_hour)
        mcm.setSliderDialogDefaultValue(2.5)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
	elseif option == fire_crafting_minute_id
       mcm.setSliderDialogStartValue(fire_crafting_minute)
       mcm.setSliderDialogDefaultValue(30.0)
       mcm.setSliderDialogRange(0.0, 60.0)
       mcm.setSliderDialogInterval(1.0)	
    elseif option == cooking_pot_crafting_hour_id
        mcm.setSliderDialogStartValue(cooking_pot_crafting_hour)
        mcm.setSliderDialogDefaultValue(2.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
	elseif option == beartrap_crafting_hour_id
        mcm.setSliderDialogStartValue(beartrap_crafting_hour)
        mcm.setSliderDialogDefaultValue(1.5)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
	elseif option == bedroll_crafting_hour_id
        mcm.setSliderDialogStartValue(bedroll_crafting_hour)
        mcm.setSliderDialogDefaultValue(1.5)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
	elseif option == rug_crafting_hour_id
        mcm.setSliderDialogStartValue(rug_crafting_hour)
        mcm.setSliderDialogDefaultValue(1.5)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
	elseif option == fire_building_minute_id
       mcm.setSliderDialogStartValue(fire_building_minute)
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
	elseif option == fire_crafting_minute_id
        fire_crafting_minute = value
        mcm.setSliderOptionValue(fire_crafting_minute_id, value, "${0}min")	
    elseif option == cooking_pot_crafting_hour_id
        cooking_pot_crafting_hour = value
        mcm.setSliderOptionValue( \
            cooking_pot_crafting_hour_id, value, "${2}hour")
	elseif option == beartrap_crafting_hour_id
        beartrap_crafting_hour = value
        mcm.setSliderOptionValue( \
            beartrap_crafting_hour_id, value, "${2}hour")
	elseif option == bedroll_crafting_hour_id
        bedroll_crafting_hour = value
        mcm.setSliderOptionValue( \
            bedroll_crafting_hour_id, value, "${2}hour")
	elseif option == rug_crafting_hour_id
        rug_crafting_hour = value
        mcm.setSliderOptionValue( \
            rug_crafting_hour_id, value, "${2}hour")
	elseif option == fire_building_minute_id
        fire_building_minute = value
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
			option == fire_crafting_minute_id || \
            option == cooking_pot_crafting_hour_id || \
			option == beartrap_crafting_hour_id || \
			option == bedroll_crafting_hour_id || \
			option == rug_crafting_hour_id || \
			option == tent_pitching_minute_id || \
			option == fire_building_minute_id
        mcm.setInfoText("$time_passed_performing_this_action")
    else
        return False
    endif
    return True
EndFunction
