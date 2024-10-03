Scriptname TFHearthfireExtended extends Quest

TimeFliesMain Property main Auto
TimeFliesMCM Property mcm Auto

int prefix
float building_crafting_hour
int building_crafting_hour_id
float furniture_crafting_hour
int furniture_crafting_hour_id
float brewer_crafting_hour
int brewer_crafting_hour_id
float trophy_crafting_hour
int trophy_crafting_hour_id
float shrine_crafting_hour
int shrine_crafting_hour_id
float enchanter_crafting_hour
int enchanter_crafting_hour_id
float alchemylab_crafting_hour
int alchemylab_crafting_hour_id
float dungeonfurniture_crafting_hour
int dungeonfurniture_crafting_hour_id
float apiary_crafting_hour
int apiary_crafting_hour_id
float well_crafting_hour
int well_crafting_hour_id
float road_crafting_hour
int road_crafting_hour_id
float mill_crafting_hour
int mill_crafting_hour_id
float windmill_crafting_hour
int windmill_crafting_hour_id
float misc_crafting_hour
int misc_crafting_hour_id
float mead_crafting_hour
int mead_crafting_hour_id

Form windmill
Form road
Form[] meads
Form[] workbenches
Form[] apiaries
Form[] mills
Form[] wells
Form[] brewers
Form[] trophies
Form[] shrines
Form[] alchemylabs
Form[] enchanters
Form[] dungeonfurniture

ObjectReference furniture_using

string item_name

Function initialize()
    prefix = Game.getModByName("hearthfireextended.esp")
    if prefix == 255
        return
		main._debug("Hearthfire Extended not installed " + prefix)
    endif
	main._debug("Hearthfire Extended initialized  " + prefix)
	
	windmill = Game.getFormFromFile(0x92FD, "hearthfireextended.esp")
	road = Game.getFormFromFile(0xEC88C, "hearthfireextended.esp")
	
    ;; craftable workbenches that should not be ignored
    workbenches = new Form[20]
    workbenches[0] = Game.getFormFromFile(0x02A029, "hearthfireextended.esp")
    workbenches[1] = Game.getFormFromFile(0x052FDB, "hearthfireextended.esp")
	workbenches[2] = Game.getFormFromFile(0x14A2BC, "hearthfireextended.esp")
    workbenches[3] = Game.getFormFromFile(0x159638, "hearthfireextended.esp")
	workbenches[4] = Game.getFormFromFile(0x16DA95, "hearthfireextended.esp")
    workbenches[5] = Game.getFormFromFile(0x16DA97, "hearthfireextended.esp")
	workbenches[6] = Game.getFormFromFile(0x16DA98, "hearthfireextended.esp")
    workbenches[7] = Game.getFormFromFile(0x16DA99, "hearthfireextended.esp")
	workbenches[8] = Game.getFormFromFile(0x178302, "hearthfireextended.esp")
    workbenches[9] = Game.getFormFromFile(0x17D42E, "hearthfireextended.esp")
	workbenches[10] = Game.getFormFromFile(0x17D430, "hearthfireextended.esp")
    workbenches[11] = Game.getFormFromFile(0x17D431, "hearthfireextended.esp")
	workbenches[12] = Game.getFormFromFile(0x17D432, "hearthfireextended.esp")
    workbenches[13] = Game.getFormFromFile(0x17D433, "hearthfireextended.esp")
	workbenches[14] = Game.getFormFromFile(0x187E3C, "hearthfireextended.esp")
    workbenches[15] = Game.getFormFromFile(0x18CF68, "hearthfireextended.esp")
	workbenches[16] = Game.getFormFromFile(0x18CF6A, "hearthfireextended.esp")
    workbenches[17] = Game.getFormFromFile(0x18CF6B, "hearthfireextended.esp")
	workbenches[18] = Game.getFormFromFile(0x18CF6C, "hearthfireextended.esp")
    workbenches[19] = Game.getFormFromFile(0x18CF6D, "hearthfireextended.esp")
		
	meads = new Form[8]
	meads[0] = Game.getFormFromFile(0x034C5E, "Skyrim.esm")
	meads[1] = Game.getFormFromFile(0x034C5D, "Skyrim.esm")
	meads[2] = Game.getFormFromFile(0x0508CA, "Skyrim.esm")
	meads[3] = Game.getFormFromFile(0x0555E8, "Skyrim.esm")
	meads[4] = Game.getFormFromFile(0x107A8A, "Skyrim.esm")
	meads[5] = Game.getFormFromFile(0x065C39, "Skyrim.esm")
	meads[6] = Game.getFormFromFile(0x065C38, "Skyrim.esm")
	meads[7] = Game.getFormFromFile(0x03572F, "Dragonborn.esm")
	
	apiaries = new Form[4]
	apiaries[0] = Game.getFormFromFile(0x4227, "hearthfireextended.esp")
	apiaries[1] = Game.getFormFromFile(0x6278, "hearthfireextended.esp")
	apiaries[2] = Game.getFormFromFile(0x92FC, "hearthfireextended.esp")
	apiaries[3] = Game.getFormFromFile(0xFAF3, "hearthfireextended.esp") 
	apiaries[4] = Game.getFormFromFile(0x1515c, "hearthfires.esm") 
	
	mills = new Form[2]
	mills[0] = Game.getFormFromFile(0x0072A5, "hearthfireextended.esp")
	mills[1] = Game.getFormFromFile(0x0072A5, "hearthfireextended.esp")
	
	wells = new Form[2]
	wells[0] = Game.getFormFromFile(0x55EA9, "hearthfireextended.esp")
	wells[1] = Game.getFormFromFile(0x55EAA, "hearthfireextended.esp") 
	wells[2] = Game.getFormFromFile(0xEF326, "Skyrim.esm") 
	
	shrines = new Form[9]
	shrines[0] = Game.getFormFromFile(0x67796, "hearthfireextended.esp")
    shrines[1] = Game.getFormFromFile(0x67797, "hearthfireextended.esp")
	shrines[2] = Game.getFormFromFile(0x67798, "hearthfireextended.esp")
    shrines[3] = Game.getFormFromFile(0x67799, "hearthfireextended.esp")
	shrines[4] = Game.getFormFromFile(0x6779A, "hearthfireextended.esp")
    shrines[5] = Game.getFormFromFile(0x6779B, "hearthfireextended.esp")
	shrines[6] = Game.getFormFromFile(0x6779C, "hearthfireextended.esp")
    shrines[7] = Game.getFormFromFile(0x6779D, "hearthfireextended.esp")
	shrines[8] = Game.getFormFromFile(0x6779E, "hearthfireextended.esp")
	
	brewers = new Form[14]
	brewers[0] = Game.getFormFromFile(0x11B6E3, "hearthfireextended.esp")
	brewers[1] = Game.getFormFromFile(0x11B6E4, "hearthfireextended.esp")
	brewers[2] = Game.getFormFromFile(0x1782E0, "hearthfireextended.esp")	
	brewers[3] = Game.getFormFromFile(0x1782E1, "hearthfireextended.esp")
	brewers[4] = Game.getFormFromFile(0x187E1A, "hearthfireextended.esp")
	brewers[5] = Game.getFormFromFile(0x187E1B, "hearthfireextended.esp")
	brewers[6] = Game.getFormFromFile(0x035B82, "hearthfireextended.esp")
	brewers[7] = Game.getFormFromFile(0x035B83, "hearthfireextended.esp")
	brewers[8] = Game.getFormFromFile(0x11B6E5, "hearthfireextended.esp")
	brewers[9] = Game.getFormFromFile(0x11B6E6, "hearthfireextended.esp")
	brewers[10] = Game.getFormFromFile(0x1782E2, "hearthfireextended.esp")
	brewers[11] = Game.getFormFromFile(0x1782E3, "hearthfireextended.esp")
	brewers[12] = Game.getFormFromFile(0x187E1C, "hearthfireextended.esp")
	brewers[13] = Game.getFormFromFile(0x187E1D, "hearthfireextended.esp")
	
	trophies = new Form[27]
    trophies[0] = Game.getFormFromFile(0x12A1EB, "hearthfireextended.esp")
    trophies[1] = Game.getFormFromFile(0x12A1F6, "hearthfireextended.esp")
	trophies[2] = Game.getFormFromFile(0x12A1F7, "hearthfireextended.esp")
    trophies[3] = Game.getFormFromFile(0x12A1F8, "hearthfireextended.esp")
	trophies[4] = Game.getFormFromFile(0x12A1FA, "hearthfireextended.esp")
    trophies[5] = Game.getFormFromFile(0x12A1FB, "hearthfireextended.esp")
	trophies[6] = Game.getFormFromFile(0x12A202, "hearthfireextended.esp")
    trophies[7] = Game.getFormFromFile(0x12A1F2, "hearthfireextended.esp")
	trophies[8] = Game.getFormFromFile(0x12A1EC, "hearthfireextended.esp")
    trophies[9] = Game.getFormFromFile(0x12A1ED, "hearthfireextended.esp")
	trophies[10] = Game.getFormFromFile(0x12A203, "hearthfireextended.esp")
    trophies[11] = Game.getFormFromFile(0x12A1F4, "hearthfireextended.esp")
	trophies[12] = Game.getFormFromFile(0x12A205, "hearthfireextended.esp")
    trophies[13] = Game.getFormFromFile(0x12A1FC, "hearthfireextended.esp")
	trophies[14] = Game.getFormFromFile(0x12A1F9, "hearthfireextended.esp")
    trophies[15] = Game.getFormFromFile(0x12A1EE, "hearthfireextended.esp")
	trophies[16] = Game.getFormFromFile(0x12A1EF, "hearthfireextended.esp")
    trophies[17] = Game.getFormFromFile(0x12A1FE, "hearthfireextended.esp")
	trophies[18] = Game.getFormFromFile(0x12A1FF, "hearthfireextended.esp")
    trophies[19] = Game.getFormFromFile(0x12A1F0, "hearthfireextended.esp")	
	trophies[20] = Game.getFormFromFile(0x12A200, "hearthfireextended.esp")
    trophies[21] = Game.getFormFromFile(0x12A1F1, "hearthfireextended.esp")
	trophies[22] = Game.getFormFromFile(0x12A201, "hearthfireextended.esp")
    trophies[23] = Game.getFormFromFile(0x12A1F5, "hearthfireextended.esp")
	trophies[24] = Game.getFormFromFile(0x12A1F3, "hearthfireextended.esp")
    trophies[25] = Game.getFormFromFile(0x12A204, "hearthfireextended.esp")
	trophies[26] = Game.getFormFromFile(0x12A1FD, "hearthfireextended.esp")
	
	enchanters = new Form[4]
	enchanters[0] = Game.getFormFromFile(0x2A028, "hearthfireextended.esp")
	enchanters[1] = Game.getFormFromFile(0x14A2C3, "hearthfireextended.esp")
	enchanters[2] = Game.getFormFromFile(0x178309, "hearthfireextended.esp")	
	enchanters[3] = Game.getFormFromFile(0x187E43, "hearthfireextended.esp")
	
	alchemylabs = new Form[4]
	alchemylabs[0] = Game.getFormFromFile(0x2A027, "hearthfireextended.esp")
	alchemylabs[1] = Game.getFormFromFile(0x14A2B8, "hearthfireextended.esp")
	alchemylabs[2] = Game.getFormFromFile(0x1782FE, "hearthfireextended.esp")
	alchemylabs[3] = Game.getFormFromFile(0x187E38, "hearthfireextended.esp")
	
	dungeonfurniture = new Form[15]
	dungeonfurniture[0] = Game.getFormFromFile(0x14F3E0, "hearthfireextended.esp")
	dungeonfurniture[1] = Game.getFormFromFile(0x1782F8, "hearthfireextended.esp")
	dungeonfurniture[2] = Game.getFormFromFile(0x187E32, "hearthfireextended.esp")
	dungeonfurniture[3] = Game.getFormFromFile(0x14F3DF, "hearthfireextended.esp")
	dungeonfurniture[4] = Game.getFormFromFile(0x1782F9, "hearthfireextended.esp")
	dungeonfurniture[5] = Game.getFormFromFile(0x187E33, "hearthfireextended.esp")
	dungeonfurniture[6] = Game.getFormFromFile(0x11B6EF, "hearthfireextended.esp")
	dungeonfurniture[7] = Game.getFormFromFile(0x178310, "hearthfireextended.esp")
	dungeonfurniture[8] = Game.getFormFromFile(0x187E4A, "hearthfireextended.esp")
	dungeonfurniture[9] = Game.getFormFromFile(0x11B6F4, "hearthfireextended.esp")
	dungeonfurniture[10] = Game.getFormFromFile(0x11B6F5, "hearthfireextended.esp")
	dungeonfurniture[11] = Game.getFormFromFile(0x178316, "hearthfireextended.esp")
	dungeonfurniture[12] = Game.getFormFromFile(0x178317, "hearthfireextended.esp")
	dungeonfurniture[13] = Game.getFormFromFile(0x187E50, "hearthfireextended.esp")
	dungeonfurniture[14] = Game.getFormFromFile(0x187E51, "hearthfireextended.esp")
EndFunction

Function load_defaults()
    building_crafting_hour = 3.0
    furniture_crafting_hour = 3.0
	brewer_crafting_hour = 3.0
	trophy_crafting_hour = 2.0
	shrine_crafting_hour = 2.0
	enchanter_crafting_hour = 3.0
	alchemylab_crafting_hour = 3.0
	dungeonfurniture_crafting_hour = 3.0
	apiary_crafting_hour = 2.0
	well_crafting_hour = 4.0
	road_crafting_hour = 4.0
	mill_crafting_hour = 3.0
	windmill_crafting_hour = 8.0
    misc_crafting_hour = 2.0
    mead_crafting_hour = 2.0
EndFunction

bool Function handle_added_item(Form item)
    item_name = item.getName()
	if main.get_prefix(item) != prefix && !(meads.find(item) > -1)
        return False
    endif
	
	item_name = item.getName()		
	main._debug("Hearthfire Extended Item - " + item_name)

    if item.hasKeywordString("BYOHHouseCraftingCategoryBuilding")
        main._debug("Building part constructed")
		if building_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(building_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
    elseif item.hasKeywordString("BYOHHouseCraftingCategoryShelf") || \
            item.hasKeywordString("BYOHHouseCraftingCategoryExterior") || \
            item.hasKeywordString("BYOHHouseCraftingCategoryFurniture") || \
            item.hasKeywordString("BYOHHouseCraftingCategoryContainers") || \
            item.hasKeywordString("BYOHHouseCraftingCategoryWeaponRacks")
        main._debug("Furniture made")
		if furniture_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(furniture_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
    ;; ignore drafting, carpenter's workbench and small objects like nail	
	elseif StringUtil.find(item_name, "Addition") > -1 || \
            StringUtil.find(item_name, "Workbench") > -1 && \
            workbenches.find(item) < 0 || \
            item.hasKeywordString("BYOHHouseCraftingCategorySmithing")
	elseif brewers.find(item) > -1
        main._debug("Brewer made")
		if brewer_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(brewer_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))	
	elseif trophies.find(item) > -1
        main._debug("Trophy made")
		if trophy_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(trophy_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
	elseif shrines.find(item) > -1
        main._debug("Shrine made")
		if shrine_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(shrine_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))	
	elseif enchanters.find(item) > -1
        main._debug("Arcane Enchanter made")
		if enchanter_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(enchanter_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Enchanting"))
	elseif alchemylabs.find(item) > -1
        main._debug("Alchemy Lab made")
		if alchemylab_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(alchemylab_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Alchemy"))
	elseif dungeonfurniture.find(item) > -1
        main._debug("Dungeon furniture made")
		if dungeonfurniture_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(dungeonfurniture_crafting_hour * \
			main.random_time_multiplier()  * \
			self.main.expertise_multiplier("Smithing"))	
	elseif apiaries.find(item) > -1
        main._debug("Apiary made")
		main._debug(apiary_crafting_hour)
		if apiary_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(apiary_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))			
	elseif wells.find(item) > -1
        main._debug("Well made")
		if well_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(well_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))	
	elseif item == road
        main._debug("Road made")
		if road_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(road_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
	elseif mills.find(item) > -1
        main._debug("Mill made")
		if mill_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(mill_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
	elseif item == windmill
        main._debug("Windmill made")
		if windmill_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(windmill_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))		
	elseif meads.find(item) > -1
		main._debug("Mead made")
		if mead_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
		main.pass_time(mead_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Alchemy"))		
    else
        main._debug("Hearthfire Extended misc item made")
		if misc_crafting_hour >= main.transition_threshold
			main.Transition()
		endif
        main.pass_time(misc_crafting_hour * \
			main.random_time_multiplier() * \
			self.main.expertise_multiplier("Smithing"))
    endif
	main.activate_key_pressed = False
    return True
EndFunction

Function save_settings()
	mcm.fiss.saveFloat("hearthfire_ext_building_crafting_hour", \
        building_crafting_hour)
    mcm.fiss.saveFloat("hearthfire_ext_furniture_crafting_hour", \
        furniture_crafting_hour)
	mcm.fiss.saveFloat("hearthfire_ext_brewer_crafting_hour", \
        brewer_crafting_hour)
	mcm.fiss.saveFloat("hearthfire_ext_trophy_crafting_hour", \
        trophy_crafting_hour)
	mcm.fiss.saveFloat("hearthfire_ext_shrine_crafting_hour", \
        shrine_crafting_hour)
	mcm.fiss.saveFloat("hearthfire_ext_enchanter_crafting_hour", \
        apiary_crafting_hour)
	mcm.fiss.saveFloat("hearthfire_ext_alchemylab_crafting_hour", \
        alchemylab_crafting_hour)
	mcm.fiss.saveFloat("hearthfire_ext_dungeonfurniture_crafting_hour", \
        dungeonfurniture_crafting_hour)	
	mcm.fiss.saveFloat("hearthfire_ext_apiary_crafting_hour", \
        apiary_crafting_hour)
	mcm.fiss.saveFloat("hearthfire_ext_well_crafting_hour", \
        well_crafting_hour)
	mcm.fiss.saveFloat("hearthfire_ext_road_crafting_hour", \
        road_crafting_hour)
	mcm.fiss.saveFloat("hearthfire_ext_mill_crafting_hour", \
        mill_crafting_hour)
	mcm.fiss.saveFloat("hearthfire_ext_windmill_crafting_hour", \
        windmill_crafting_hour)
	mcm.fiss.saveFloat("hearthfire_ext_misc_crafting_hour", \
		misc_crafting_hour)
	mcm.fiss.saveFloat("hearthfire_ext_mead_crafting_hour", \
        mead_crafting_hour)
EndFunction

Function load_settings()
    building_crafting_hour = \
        mcm.fiss.loadFloat("hearthfire_ext_building_crafting_hour")
    furniture_crafting_hour = \
        mcm.fiss.loadFloat("hearthfire_ext_furniture_crafting_hour")
	shrine_crafting_hour = \
        mcm.fiss.loadFloat("hearthfire_ext_shrine_crafting_hour")
	brewer_crafting_hour = \
        mcm.fiss.loadFloat("hearthfire_ext_brewer_crafting_hour")
	trophy_crafting_hour = \
        mcm.fiss.loadFloat("hearthfire_ext_trophy_crafting_hour")
	enchanter_crafting_hour = \
        mcm.fiss.loadFloat("hearthfire_ext_enchanter_crafting_hour")
	alchemylab_crafting_hour = \
        mcm.fiss.loadFloat("hearthfire_ext_alchemylab_crafting_hour")
	dungeonfurniture_crafting_hour = \
        mcm.fiss.loadFloat("hearthfire_ext_dungeonfurniture_crafting_hour")
	apiary_crafting_hour = \
        mcm.fiss.loadFloat("hearthfire_ext_apiary_crafting_hour")
	well_crafting_hour = \
        mcm.fiss.loadFloat("hearthfire_ext_well_crafting_hour")
	road_crafting_hour = \
        mcm.fiss.loadFloat("hearthfire_ext_road_crafting_hour")
	mill_crafting_hour = \
        mcm.fiss.loadFloat("hearthfire_ext_mill_crafting_hour")
	windmill_crafting_hour = \
        mcm.fiss.loadFloat("hearthfire_ext_windmill_crafting_hour")		
    misc_crafting_hour = \
		mcm.fiss.loadFloat("hearthfire_ext_misc_crafting_hour")
	mead_crafting_hour = \
        mcm.fiss.loadFloat("hearthfire_ext_mead_crafting_hour")
EndFunction

bool Function handle_page(string page)
    if page != "$hearthfire_ext"
        return False
    endif

    if prefix == 255
        mcm.addTextOption("", "$hearthfire_ext_not_installed")
    else
        mcm.setCursorFillMode(mcm.TOP_TO_BOTTOM)
        mcm.addHeaderOption("$crafting")

        building_crafting_hour_id = mcm.addSliderOption( \
            "$hearthfire_ext_building_parts", building_crafting_hour, "${2}hour")

		furniture_crafting_hour_id = mcm.addSliderOption( \
            "$hearthfire_ext_furniture", furniture_crafting_hour, "${2}hour")
			
		alchemylab_crafting_hour_id = mcm.addSliderOption( \
            "$hearthfire_ext_alchemylab", alchemylab_crafting_hour, "${2}hour")
			
		apiary_crafting_hour_id = mcm.addSliderOption( \
            "$hearthfire_ext_apiary", apiary_crafting_hour, "${2}hour")
			
		brewer_crafting_hour_id = mcm.addSliderOption( \
            "$hearthfire_ext_brewer", brewer_crafting_hour, "${2}hour")
			
		dungeonfurniture_crafting_hour_id = mcm.addSliderOption( \
            "$hearthfire_ext_dungeonfurniture", dungeonfurniture_crafting_hour, "${2}hour")
			
		enchanter_crafting_hour_id = mcm.addSliderOption( \
            "$hearthfire_ext_enchanter", enchanter_crafting_hour, "${2}hour")
			
		mill_crafting_hour_id = mcm.addSliderOption( \
            "$hearthfire_ext_mill", mill_crafting_hour, "${2}hour")
			
		road_crafting_hour_id = mcm.addSliderOption( \
            "$hearthfire_ext_road", road_crafting_hour, "${2}hour")
			
		shrine_crafting_hour_id = mcm.addSliderOption( \
            "$hearthfire_ext_shrine", shrine_crafting_hour, "${2}hour")
			
		trophy_crafting_hour_id = mcm.addSliderOption( \
            "$hearthfire_ext_trophy", trophy_crafting_hour, "${2}hour")
			
		well_crafting_hour_id = mcm.addSliderOption( \
            "$hearthfire_ext_well", well_crafting_hour, "${2}hour")
			
		windmill_crafting_hour_id = mcm.addSliderOption( \
            "$hearthfire_ext_windmill", windmill_crafting_hour, "${2}hour")
			
        misc_crafting_hour_id = mcm.addSliderOption( \
            "$hearthfire_ext_misc", misc_crafting_hour, "${2}hour")
		
		mcm.setCursorPosition(1)
		mcm.addHeaderOption("$activities")		
        mead_crafting_hour_id = mcm.addSliderOption( \
            "$hearthfire_ext_mead", mead_crafting_hour, "${2}hour")	
    endif
    return True
EndFunction

bool Function handle_slider_opened(int option)
    if option == building_crafting_hour_id
        mcm.setSliderDialogStartValue(building_crafting_hour)
        mcm.setSliderDialogDefaultValue(3.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
		
    elseif option == furniture_crafting_hour_id
        mcm.setSliderDialogStartValue(furniture_crafting_hour)
        mcm.setSliderDialogDefaultValue(3.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)	

	elseif option == brewer_crafting_hour_id
        mcm.setSliderDialogStartValue(brewer_crafting_hour)
        mcm.setSliderDialogDefaultValue(3.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
		
	elseif option == trophy_crafting_hour_id
        mcm.setSliderDialogStartValue(trophy_crafting_hour)
        mcm.setSliderDialogDefaultValue(2.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
		
	elseif option == shrine_crafting_hour_id
        mcm.setSliderDialogStartValue(shrine_crafting_hour)
        mcm.setSliderDialogDefaultValue(2.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
		
	elseif option == enchanter_crafting_hour_id
        mcm.setSliderDialogStartValue(enchanter_crafting_hour)
        mcm.setSliderDialogDefaultValue(3.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
		
	elseif option == alchemylab_crafting_hour_id
        mcm.setSliderDialogStartValue(alchemylab_crafting_hour)
        mcm.setSliderDialogDefaultValue(3.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
		
	elseif option == dungeonfurniture_crafting_hour_id
        mcm.setSliderDialogStartValue(dungeonfurniture_crafting_hour)
        mcm.setSliderDialogDefaultValue(3.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
	
	elseif option == apiary_crafting_hour_id
        mcm.setSliderDialogStartValue(apiary_crafting_hour)
        mcm.setSliderDialogDefaultValue(2.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
	
	elseif option == well_crafting_hour_id
        mcm.setSliderDialogStartValue(well_crafting_hour)
        mcm.setSliderDialogDefaultValue(4.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
	
	elseif option == road_crafting_hour_id
        mcm.setSliderDialogStartValue(road_crafting_hour)
        mcm.setSliderDialogDefaultValue(4.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)

	elseif option == mill_crafting_hour_id
        mcm.setSliderDialogStartValue(mill_crafting_hour)
        mcm.setSliderDialogDefaultValue(3.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
		
	elseif option == windmill_crafting_hour_id
        mcm.setSliderDialogStartValue(windmill_crafting_hour)
        mcm.setSliderDialogDefaultValue(8.0)
        mcm.setSliderDialogRange(0.0, 24.0)
        mcm.setSliderDialogInterval(1.00)	
		
    elseif option == misc_crafting_hour_id
        mcm.setSliderDialogStartValue(misc_crafting_hour)
        mcm.setSliderDialogDefaultValue(2.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)
		
	elseif option == mead_crafting_hour_id
        mcm.setSliderDialogStartValue(mead_crafting_hour)
        mcm.setSliderDialogDefaultValue(2.0)
        mcm.setSliderDialogRange(0.0, 8.0)
        mcm.setSliderDialogInterval(0.25)			
    else
        return False
    endif
    return True
EndFunction

bool Function handle_slider_accepted(int option, float value)
    if option == building_crafting_hour_id
        building_crafting_hour = value
        mcm.setSliderOptionValue(building_crafting_hour_id, value, "${2}hour")
    elseif option == furniture_crafting_hour_id
        furniture_crafting_hour = value
        mcm.setSliderOptionValue(furniture_crafting_hour_id, value, "${2}hour")	
	elseif option == brewer_crafting_hour_id
        brewer_crafting_hour = value
        mcm.setSliderOptionValue(brewer_crafting_hour_id, value, "${2}hour")
	elseif option == trophy_crafting_hour_id
        trophy_crafting_hour = value
        mcm.setSliderOptionValue(trophy_crafting_hour_id, value, "${2}hour")
	elseif option == shrine_crafting_hour_id
        shrine_crafting_hour = value
        mcm.setSliderOptionValue(shrine_crafting_hour_id, value, "${2}hour")
	elseif option == enchanter_crafting_hour_id
        enchanter_crafting_hour = value
        mcm.setSliderOptionValue(enchanter_crafting_hour_id, value, "${2}hour")
	elseif option == alchemylab_crafting_hour_id
        alchemylab_crafting_hour = value
        mcm.setSliderOptionValue(alchemylab_crafting_hour_id, value, "${2}hour")
	elseif option == dungeonfurniture_crafting_hour_id
        shrine_crafting_hour = value
        mcm.setSliderOptionValue(dungeonfurniture_crafting_hour_id, value, "${2}hour")
	elseif option == apiary_crafting_hour_id
        apiary_crafting_hour = value
        mcm.setSliderOptionValue(apiary_crafting_hour_id, value, "${2}hour")
	elseif option == well_crafting_hour_id
        well_crafting_hour = value
        mcm.setSliderOptionValue(well_crafting_hour_id, value, "${2}hour")
	elseif option == road_crafting_hour_id
        road_crafting_hour = value
        mcm.setSliderOptionValue(road_crafting_hour_id, value, "${2}hour")
	elseif option == mill_crafting_hour_id
        mill_crafting_hour = value
        mcm.setSliderOptionValue(mill_crafting_hour_id, value, "${2}hour")
	elseif option == windmill_crafting_hour_id
        windmill_crafting_hour = value
        mcm.setSliderOptionValue(windmill_crafting_hour_id, value, "${2}hour")
    elseif option == misc_crafting_hour_id
        misc_crafting_hour = value
        mcm.setSliderOptionValue(misc_crafting_hour_id, value, "${2}hour")
	elseif option == mead_crafting_hour_id
        mead_crafting_hour = value
        mcm.setSliderOptionValue(mead_crafting_hour_id, value, "${2}hour")
    else
        return False
    endif
    return True
EndFunction

bool Function handle_option_highlighted(int option)
    if option == building_crafting_hour_id \
			|| option == furniture_crafting_hour_id \
			|| option == windmill_crafting_hour_id \
			|| option == road_crafting_hour_id \
			|| option == apiary_crafting_hour_id \
			|| option == mill_crafting_hour_id \
			|| option == well_crafting_hour_id \
			|| option == shrine_crafting_hour_id \
			|| option == brewer_crafting_hour_id \
			|| option == trophy_crafting_hour_id \
			|| option == enchanter_crafting_hour_id \
			|| option == alchemylab_crafting_hour_id \
			|| option == mead_crafting_hour_id
        mcm.setInfoText("$time_passed_performing_this_action")
    elseif option == misc_crafting_hour_id
        mcm.setInfoText("$hearthfire_ext_misc_info")
    else
        return False
    endif
    return True
EndFunction
