Scriptname TFWounds extends Quest

TimeFliesMain Property main Auto
TimeFliesMCM Property mcm Auto

int prefix
float bandage_crafting_minute
int bandage_crafting_minute_id
float alcohol_crafting_hour
int alcohol_crafting_hour_id
float needle_crafting_hour
int needle_crafting_hour_id
float treatment_minute
int treatment_minute_id

Form[] bandage
Form[] alcohol
Form needle
Form treat_wounds

ObjectReference furniture_using

Function initialize()
    prefix = Game.getModByName("Wounds.esp")
	if prefix == 255
        main._debug("Wounds not installed " + prefix)
		return
    endif
    main._debug("Wounds initialized " + prefix)
	
	bandage = new Form[2]
    bandage[0] = Game.getFormFromFile(0x55bd, "Wounds.esp")
	bandage[1] = Game.getFormFromFile(0x01CC0651, "Update.esm")
	
	alcohol = new Form[2]
	alcohol[0] = Game.getFormFromFile(0xfcdf, "Wounds.esp")
	alcohol[1] = Game.getFormFromFile(0x01cc0645, "Update.esm")
	
	needle = Game.getFormFromFile(0x55bf, "Wounds.esp")
	
	treat_wounds = Game.getFormFromFile(0x17AFF, "Wounds.esp")
	
EndFunction

Function load_defaults()
    bandage_crafting_minute = 10.0
	alcohol_crafting_hour = 2.0
	needle_crafting_hour = 1.0
	treatment_minute = 15.0
EndFunction

bool Function handle_added_item(Form item)
	if !Game.getModByName("Complete Alchemy & Cooking Overhaul.esp")
		if main.get_prefix(item) != prefix
			return False	
		endif
	elseif main.get_prefix(item) != prefix && main.get_prefix(item) != 1
		return False
	endif
	
	string item_name = item.getName()
	main._debug("Wounds Item - " + item_name)
	
	if bandage.find(item) > -1
		main._debug("Wounds bandage made")
		main.pass_time(bandage_crafting_minute * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Alchemy") / 60)
	elseif alcohol.find(item) > -1
		main._debug("Wounds alcohol made")
		if alcohol_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
		main.pass_time(alcohol_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Alchemy"))
	elseif item == needle
		main._debug("Wounds needle made")
		if needle_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
		main.pass_time(needle_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Lockpicking"))
	else
        main._debug("Wounds misc item ignored")
		return False
	endif		
    return True
EndFunction

bool Function handle_spellcast(Form item)
	if main.get_prefix(item) != prefix
		return False
	endif

	if item == treat_wounds
		main._debug("Treated wounds")
		main.pass_time(treatment_minute * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Alchemy") / 60)
	endif
	return True
EndFunction


Function save_settings()
    mcm.fiss.saveFloat("bandage_crafting_minute", bandage_crafting_minute)
	mcm.fiss.saveFloat("alcohol_crafting_hour", alcohol_crafting_hour)
	mcm.fiss.saveFloat("needle_crafting_hour", needle_crafting_hour)
	mcm.fiss.saveFloat("treatment_minute", treatment_minute)	
EndFunction

Function load_settings()
    bandage_crafting_minute = mcm.fiss.loadFloat( \
        "bandage_crafting_minute")
	alcohol_crafting_hour = mcm.fiss.loadFloat( \
        "alcohol_crafting_hour")
    needle_crafting_hour = mcm.fiss.loadFloat( \
        "needle_crafting_hour")
	treatment_minute = mcm.fiss.loadFloat( \
        "treatment_minute")
EndFunction

bool Function handle_page(string page)
    if page != "$wounds"
        return False
    endif

    if prefix == 255
        mcm.addTextOption("", "$wounds_not_installed")
    else
        mcm.setCursorFillMode(mcm.TOP_TO_BOTTOM)
		
        mcm.addHeaderOption("$crafting")
        bandage_crafting_minute_id = mcm.addSliderOption( \
            "$wounds_bandage", bandage_crafting_minute, "${0}min")
        alcohol_crafting_hour_id = mcm.addSliderOption( \
            "$wounds_alcohol", alcohol_crafting_hour, "${2}hour")
        needle_crafting_hour_id = mcm.addSliderOption( \
            "$wounds_needle", needle_crafting_hour, "${2}hour")
		
		mcm.setCursorPosition(1)
		mcm.addHeaderOption("$activities")
		treatment_minute_id = mcm.addSliderOption( \
            "$wounds_treatment", treatment_minute, "${0}min")
    endif
    return True
EndFunction

bool Function handle_slider_opened(int option)
	if option == bandage_crafting_minute_id
        mcm.setSliderDialogStartValue(bandage_crafting_minute)
        mcm.setSliderDialogDefaultValue(10.0)
        mcm.setSliderDialogRange(0.0, 60.0)
        mcm.setSliderDialogInterval(1.0)
    elseif option == alcohol_crafting_hour_id
        mcm.setSliderDialogStartValue(alcohol_crafting_hour)
        mcm.setSliderDialogDefaultValue(2.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
    elseif option == needle_crafting_hour_id
        mcm.setSliderDialogStartValue(needle_crafting_hour)
        mcm.setSliderDialogDefaultValue(1.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
	elseif option == treatment_minute_id
        mcm.setSliderDialogStartValue(treatment_minute)
        mcm.setSliderDialogDefaultValue(15.0)
        mcm.setSliderDialogRange(0.0, 60.0)
        mcm.setSliderDialogInterval(1.0)
    else
        return False
    endif
    return True
EndFunction

bool Function handle_slider_accepted(int option, float value)
	if option == bandage_crafting_minute_id
        bandage_crafting_minute = value
        mcm.setSliderOptionValue(bandage_crafting_minute_id, value, "${0}min")
    elseif option == alcohol_crafting_hour_id
        alcohol_crafting_hour = value
        mcm.setSliderOptionValue(alcohol_crafting_hour_id, value, "${2}hour")
	elseif option == needle_crafting_hour_id
        needle_crafting_hour = value
        mcm.setSliderOptionValue(needle_crafting_hour_id, value, "${2}hour")
	elseif option == treatment_minute_id
        treatment_minute = value
        mcm.setSliderOptionValue(treatment_minute_id, value, "${0}min")	
	else
        return False
    endif
    return True
EndFunction

bool Function handle_option_highlighted(int option)
    if option == bandage_crafting_minute_id || \
			option == alcohol_crafting_hour_id || \
			option == needle_crafting_hour_id || \
			option == treatment_minute_id
        mcm.setInfoText("$time_passed_performing_this_action")
    else
        return False
    endif
    return True
EndFunction
