Scriptname TFFishingAE extends Quest

TimeFliesMain Property main Auto
TimeFliesMCM Property mcm Auto

;;Crafting
int prefix
float fishingrod_crafting_hour
int fishingrod_crafting_hour_id
float fishtanksm_crafting_hour
int fishtanksm_crafting_hour_id
float fishtanklg_crafting_hour
int fishtanklg_crafting_hour_id
float aquarium_crafting_hour
int aquarium_crafting_hour_id
Form[] fishingrod
Form[] fish_tank_small
Form[] fish_tank_large
Form aquarium

;;Fishing
float fishing_minute
bool random_fishing_time
float random_fishing_time_multiplier_min
float random_fishing_time_multiplier_max
bool fishing_junk
int fishing_minute_id
int random_fishing_time_id
int random_fishing_time_multiplier_min_id
int random_fishing_time_multiplier_max_id
int fishing_junk_id

;; Private variables
float fishing_time_to_pass = 0.0
string item_name
string equipped_weapon_name

ObjectReference furniture_using
int item_type


Function initialize()
    prefix = Game.getModByName("ccBGSSSE001-Fish.esm")
	if prefix == 255
		main._debug("Anniversary Edition Fishing not installed " + prefix)	
		return
    endif
    main._debug("Anniversary Edition Fishing initialized " + prefix)	
    
	fishingrod = new Form[4]
    fishingrod[0] = Game.getFormFromFile(0x84D, "ccBGSSSE001-Fish.esm")
    fishingrod[1] = Game.getFormFromFile(0x84E, "ccBGSSSE001-Fish.esm")
    fishingrod[2] = Game.getFormFromFile(0x84F, "ccBGSSSE001-Fish.esm")
	fishingrod[3] = Game.getFormFromFile(0x850, "ccBGSSSE001-Fish.esm")
	
	fish_tank_small = new Form[3]
    fish_tank_small[0] = Game.getFormFromFile(0xCBA, "ccBGSSSE001-Fish.esm")
    fish_tank_small[1] = Game.getFormFromFile(0xCBB, "ccBGSSSE001-Fish.esm")
    fish_tank_small[2] = Game.getFormFromFile(0xCBC, "ccBGSSSE001-Fish.esm")
	
	fish_tank_large = new Form[3]
    fish_tank_large[0] = Game.getFormFromFile(0xCB7, "ccBGSSSE001-Fish.esm")
    fish_tank_large[1] = Game.getFormFromFile(0xCB8, "ccBGSSSE001-Fish.esm")
    fish_tank_large[2] = Game.getFormFromFile(0xCB9, "ccBGSSSE001-Fish.esm")
	
	aquarium = Game.getFormFromFile(0xD02, "ccBGSSSE001-Fish.esm")	
EndFunction

Function load_defaults()
	;;Fishing
	main.fishing_minute = 30.0
	main.random_fishing_time = True
    main.random_fishing_time_multiplier_min = 0.10
    main.random_fishing_time_multiplier_max = 1.5
	main.fishing_junk = False
		
	;Crafting
	fishingrod_crafting_hour = 3.0
	fishtanksm_crafting_hour = 1.0
	fishtanklg_crafting_hour = 2.0
	aquarium_crafting_hour = 3.0
EndFunction


bool Function handle_added_item(Form item)
	if main.get_prefix(item) != prefix
        return False
	endif
	
	item_name = item.getName()
	main._debug("AE Fishing Item - " + item_name)
		
    if fishingrod.find(item) > -1 && UI.IsMenuOpen("Crafting Menu")
		main._debug("Fishing rod made")
		if fishingrod_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
		main.pass_time(fishingrod_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
		return True
	elseif fish_tank_small.find(item) > -1
		main._debug("Small fish tank made")
		if fishtanksm_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
		main.pass_time(fishtanksm_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
		return True	
	elseif fish_tank_large.find(item) > -1
		main._debug("Large fish tank made")
		if fishtanklg_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
		main.pass_time(fishtanksm_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
		return True
	elseif item == aquarium
		main._debug("Small fish tank made")
		if aquarium_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
		main.pass_time(aquarium_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
		return True			
    else
        main._debug("Fishing AE misc item ignored")
		return False
    endif
EndFunction

Function save_settings()
    mcm.fiss.saveFloat("fishingrod_crafting_hour", \
		fishingrod_crafting_hour)
	mcm.fiss.saveFloat("fishtanksm_crafting_hour", \
		fishtanksm_crafting_hour)	
	mcm.fiss.saveFloat("fishtanklg_crafting_hour", \
		fishtanklg_crafting_hour)
	mcm.fiss.saveFloat("aquarium_crafting_hour", \
		aquarium_crafting_hour)	
	mcm.fiss.saveFloat("fishing_minute", \
		main.fishing_minute)
	mcm.fiss.saveBool("random_fishing_time", \
		main.random_fishing_time)
	mcm.fiss.saveFloat("random_fishing_time_multiplier_min", \
		main.random_fishing_time_multiplier_min)
	mcm.fiss.saveFloat("random_fishing_time_multiplier_max", \
		main.random_fishing_time_multiplier_max)
	mcm.fiss.saveBool("fishing_junk", \
		main.fishing_junk)
EndFunction

Function load_settings()
    fishingrod_crafting_hour = \
		mcm.fiss.loadFloat("fishingrod_crafting_hour")
	fishtanksm_crafting_hour = \
		mcm.fiss.loadFloat("fishtanksm_crafting_hour")	
	fishtanklg_crafting_hour = \
		mcm.fiss.loadFloat("fishtanklg_crafting_hour")
	aquarium_crafting_hour = \
		mcm.fiss.loadFloat("aquarium_crafting_hour")
	main.fishing_minute = \
		mcm.fiss.loadFloat("fishing_minute")
	main.random_fishing_time = \
		mcm.fiss.loadBool("random_fishing_time")
	main.random_fishing_time_multiplier_min = \
		mcm.fiss.loadFloat("random_fishing_time_multiplier_min")	
	main.random_fishing_time_multiplier_max = \
		mcm.fiss.loadFloat("random_fishing_time_multiplier_max")
	main.fishing_junk = \
		mcm.fiss.loadBool("fishing_junk")
EndFunction

bool Function handle_page(string page)
    if page != "$fishing_ae"
        return False
    endif

    if prefix == 255
        mcm.addTextOption("", "$fishing_ae_not_installed")
    else
        mcm.setCursorFillMode(mcm.TOP_TO_BOTTOM)
        mcm.addHeaderOption("$crafting")
        fishingrod_crafting_hour_id = mcm.addSliderOption( \
            "$fishingrod", fishingrod_crafting_hour, "${2}hour")
		fishtanksm_crafting_hour_id = mcm.addSliderOption( \
            "$fishtanksm", fishtanksm_crafting_hour, "${2}hour")
		fishtanklg_crafting_hour_id = mcm.addSliderOption( \
            "$fishtanklg", fishtanklg_crafting_hour, "${2}hour")
		aquarium_crafting_hour_id = mcm.addSliderOption( \
            "$aquarium", aquarium_crafting_hour, "${2}hour")
		
		mcm.setCursorPosition(1)
		mcm.addHeaderOption("$activities")		
		fishing_minute_id = mcm.addSliderOption( \
            "$fishing", main.fishing_minute, "${0}min")
		
		fishing_junk_id = mcm.addToggleOption( \
            "$fishing_junk", main.fishing_junk)
		
		random_fishing_time_id = mcm.addToggleOption( \
            "$random_fishing_time", main.random_fishing_time)
		if main.random_fishing_time			
			random_fishing_time_multiplier_min_id = mcm.addSliderOption( \
				"$random_time_multiplier_min", \
				main.random_fishing_time_multiplier_min, "$x{2}", mcm.OPTION_FLAG_NONE)
			random_fishing_time_multiplier_max_id = mcm.addSliderOption( \
				"$random_time_multiplier_max", \
				main.random_fishing_time_multiplier_max, "$x{2}", mcm.OPTION_FLAG_NONE)

		else			
			random_fishing_time_multiplier_min_id = mcm.addSliderOption( \
				"$random_time_multiplier_min", \
				main.random_fishing_time_multiplier_min, "$x{2}", mcm.OPTION_FLAG_DISABLED)
			random_fishing_time_multiplier_max_id = mcm.addSliderOption( \
				"$random_time_multiplier_max", \
				main.random_fishing_time_multiplier_max, "$x{2}", mcm.OPTION_FLAG_DISABLED)
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
			main.random_fishing_time = True
			mcm.setOptionFlags(random_fishing_time_multiplier_min_id, mcm.OPTION_FLAG_NONE)
			mcm.setOptionFlags(random_fishing_time_multiplier_max_id, mcm.OPTION_FLAG_NONE)
		else
			main.random_fishing_time = False
			mcm.setOptionFlags(random_fishing_time_multiplier_min_id, mcm.OPTION_FLAG_DISABLED)
			mcm.setOptionFlags(random_fishing_time_multiplier_max_id, mcm.OPTION_FLAG_DISABLED)
		endif
	elseif option == fishing_junk_id
        main.fishing_junk = !main.fishing_junk
        mcm.setToggleOptionValue(fishing_junk_id, \
            main.fishing_junk)
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
	elseif option == fishtanksm_crafting_hour_id
       mcm.setSliderDialogStartValue(fishtanksm_crafting_hour)
       mcm.setSliderDialogDefaultValue(1.0)
       mcm.setSliderDialogRange(0.0, 8.0)
       mcm.setSliderDialogInterval(0.25)
	elseif option == fishtanklg_crafting_hour_id
       mcm.setSliderDialogStartValue(fishtanklg_crafting_hour)
       mcm.setSliderDialogDefaultValue(2.0)
       mcm.setSliderDialogRange(0.0, 8.0)
       mcm.setSliderDialogInterval(0.25)
	elseif option == aquarium_crafting_hour_id
       mcm.setSliderDialogStartValue(aquarium_crafting_hour)
       mcm.setSliderDialogDefaultValue(3.0)
       mcm.setSliderDialogRange(0.0, 8.0)
       mcm.setSliderDialogInterval(0.25)
    elseif option == fishing_minute_id
       mcm.setSliderDialogStartValue(main.fishing_minute)
       mcm.setSliderDialogDefaultValue(30.0)
       mcm.setSliderDialogRange(0.0, 60.0)
       mcm.setSliderDialogInterval(1.0)
	elseif option == random_fishing_time_multiplier_min_id
       mcm.setSliderDialogStartValue(main.random_fishing_time_multiplier_min)
       mcm.setSliderDialogDefaultValue(0.10)
       mcm.setSliderDialogRange(0.05, 1.00)
       mcm.setSliderDialogInterval(0.01)
    elseif option == random_fishing_time_multiplier_max_id
       mcm.setSliderDialogStartValue(main.random_fishing_time_multiplier_max)
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
	elseif option == fishtanksm_crafting_hour_id
        fishtanksm_crafting_hour = value
        mcm.setSliderOptionValue(fishtanksm_crafting_hour_id, value, "${2}hour")
	elseif option == fishtanklg_crafting_hour_id
        fishtanklg_crafting_hour = value
        mcm.setSliderOptionValue(fishtanklg_crafting_hour_id, value, "${2}hour")
	elseif option == aquarium_crafting_hour_id
        aquarium_crafting_hour = value
        mcm.setSliderOptionValue(aquarium_crafting_hour_id, value, "${2}hour")	
	elseif option == fishing_minute_id
        main.fishing_minute = value
        mcm.setSliderOptionValue(fishing_minute_id, value, "${0}min")	
	elseif option == random_fishing_time_multiplier_min_id
        main.random_fishing_time_multiplier_min = value
        mcm.setSliderOptionValue(random_fishing_time_multiplier_min_id, value, "$x{2}")
    elseif option == random_fishing_time_multiplier_max_id
        main.random_fishing_time_multiplier_max = value
        mcm.setSliderOptionValue(random_fishing_time_multiplier_max_id, value, "$x{2}")
    else
        return False
    endif
    return True
EndFunction

bool Function handle_option_set_default(int option)
	if option == random_fishing_time_id
        main.random_fishing_time = True
        mcm.setToggleOptionValue(random_fishing_time_id, True)
	elseif option == fishing_junk_id
        main.fishing_junk = False
        mcm.setToggleOptionValue(fishing_junk_id, False)
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
	elseif option == fishing_junk_id
		mcm.setInfoText("$fishing_junk_info")
    else
        return False
    endif
    return True
EndFunction