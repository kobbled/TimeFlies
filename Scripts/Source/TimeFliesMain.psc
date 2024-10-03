Scriptname TimeFliesMain extends Quest

TimeFliesMods Property mods Auto
TFFishingAE Property fishingae Auto

GlobalVariable Property GameHour Auto
GlobalVariable Property GameDaysPassed Auto
GlobalVariable Property TimeScale Auto
Message Property notification_long Auto
Message Property notification_short Auto
Actor Property PlayerRef Auto
Location Property MarkarthLocation Auto
Location Property RiftenLocation Auto
Location Property SolitudeLocation Auto
Location Property WhiterunLocation Auto
Location Property WindhelmLocation Auto

bool debug_mode = True

Function _debug(string str)
	if debug_mode
        Debug.Trace("Time Flies: " + str)
    endif
EndFunction

;; General
bool Property is_enabled Auto
bool Property is_paused Auto
bool Property expertise_reduces_time Auto
bool Property random_crafting_time Auto
bool Property item_value_time Auto
float Property random_time_multiplier_min Auto
float Property random_time_multiplier_max Auto
bool Property show_day_notification Auto
bool Property show_notification Auto
float Property notification_threshold Auto
bool Property show_transition Auto
bool Property show_fullscreen_transition Auto
float Property transition_threshold Auto
float Property transition_duration Auto
int Property hotkey Auto
bool Property activate_key_pressed Auto
bool Property inventory_loot Auto

;; Combat
bool Property block_controls Auto
bool Property combat_warning Auto
bool Property block_menus Auto
bool Property block_objects Auto
bool Property block_journal Auto

;; Reading
float Property reading_time_multiplier Auto
float Property reading_increases_speech_multiplier Auto
float Property spell_learning_hour Auto

;; Training & Eating & Looting & Lockpicking & Trading
bool Property scaled_training Auto
float Property training_hour Auto
float Property eating_minute Auto
float Property looting_time_multiplier Auto
float Property lockpicking_time_multiplier Auto
float Property trading_time_multiplier Auto

;; Crafting
bool Property crafting_takes_time Auto
float Property helmet_crafting_hour Auto
float Property armor_crafting_hour Auto
float Property gauntlets_crafting_hour Auto
float Property boots_crafting_hour Auto
float Property shield_crafting_hour Auto
float Property clothes_crafting_hour Auto
float Property jewelry_crafting_hour Auto
float Property tool_crafting_hour Auto
float Property clutter_crafting_hour Auto
float Property staff_crafting_hour Auto
float Property bow_crafting_hour Auto
float Property ammo_crafting_hour Auto
float Property dagger_crafting_hour Auto
float Property sword_crafting_hour Auto
float Property waraxe_crafting_hour Auto
float Property mace_crafting_hour Auto
float Property greatsword_crafting_hour Auto
float Property battleaxe_crafting_hour Auto
float Property warhammer_crafting_hour Auto
float Property smelting_hour Auto
float Property leather_crafting_hour Auto
float Property armor_improving_minute Auto
float Property weapon_improving_minute Auto
float Property enchanting_hour Auto
float Property alchemy_minute Auto
float Property cooking_minute Auto
float Property harvesting_minute Auto
float Property mining_minute Auto
float Property lumbering_minute Auto
bool Property skinning_enabled Auto
float Property skinning_minute Auto
float Property fire_building_minute Auto

;; Baseline iron item evaluation
float Property helm_ival Auto
float Property cuirass_ival Auto
float Property gauntlets_ival Auto
float Property boots_ival Auto
float Property shield_ival Auto
float Property bow_ival Auto
float Property dagger_ival Auto
float Property sword_ival Auto
float Property greatsword_ival Auto
float Property waraxe_ival Auto
float Property battleaxe_ival Auto
float Property mace_ival Auto
float Property warhammer_ival Auto
float Property ammo_ival Auto

;; Baseline deadric item evaluation
float Property helm_dval Auto
float Property cuirass_dval Auto
float Property gauntlets_dval Auto
float Property boots_dval Auto
float Property shield_dval Auto
float Property bow_dval Auto
float Property dagger_dval Auto
float Property sword_dval Auto
float Property greatsword_dval Auto
float Property waraxe_dval Auto
float Property battleaxe_dval Auto
float Property mace_dval Auto
float Property warhammer_dval Auto
float Property ammo_dval Auto

;; Hearthfire
float Property butter_crafting_hour Auto
float Property milking_minute Auto

;; Fishing AE
float Property fishing_minute Auto
bool Property random_fishing_time Auto
float Property random_fishing_time_multiplier_min Auto
float Property random_fishing_time_multiplier_max Auto
bool Property fishing_junk Auto
bool fishing_ae_pole
bool is_fishing

;; Modded Actions
bool shovel
Form[] Property shovel_list Auto
float Property bury_hour Auto
Form[] Property pray Auto
float Property prayer_minute Auto
Form[] Property frostbite Auto
Form[] Property caco_items Auto
Form Property milk Auto
Form Property butter Auto
Form Property leather Auto
Form Property firewood_campsite Auto

;; Private variables
ObjectReference furniture_using
float time_started
float time_stopped
float game_time
float game_time_now
float cooking_time_to_pass = 0.0
float alchemy_time_to_pass = 0.0
float eating_time_to_pass = 0.0
float skinning_time_to_pass = 0.0
float harvesting_time_to_pass = 0.0
float solution_time_to_pass = 0.0
float skill_points
float skill_alchemy
float skill_onehanded
float skill_twohanded
float skill_marksman
float skill_block
float skill_smithing
float skill_heavyarmor
float skill_lightarmor
float skill_pickpocket
float skill_lockpicking
float skill_sneak
float skill_speechcraft
float skill_alteration
float skill_conjuration
float skill_destruction
float skill_illusion
float skill_restoration
float skill_enchanting
float skill_alchemy_now
float skill_onehanded_now
float skill_twohanded_now
float skill_marksman_now
float skill_block_now
float skill_smithing_now
float skill_heavyarmor_now
float skill_lightarmor_now
float skill_pickpocket_now
float skill_lockpicking_now
float skill_sneak_now
float skill_speechcraft_now
float skill_alteration_now
float skill_conjuration_now
float skill_destruction_now
float skill_illusion_now
float skill_restoration_now
float skill_enchanting_now
float skill_level_multiplier
int prefix
int food_eaten
int food_eaten_now
int potion_mixed
int poison_mixed
int spell_learned
int armor_improved
int weapon_improved
int item_enchanted
int item_harvested
int chests_looted
int people_killed  
int training_session
bool is_crafting_station = False	;; crafting via workstation
bool is_crafting_spell = False		;; crafting via spell
bool is_crafting_menu = False		;; crafting via non-workstation menu
bool is_looting = False
bool is_trading = True
bool is_reading = False
bool item_skin = False
bool item_other = False
bool take_all = False
bool time_advanced					;; time advanced via crafting workstation, spell, menu or improvement
bool game_time_obtained = False
bool suppress_fullscreen = False	;; suppress fullscreen transition for crafting without animations
bool inventory_activated = False
float item_val
bool day_elapsed
bool combat_message = False
bool dialogue_menu = False
bool loadgame
bool while_loop
bool in_interior
bool in_city
bool fast_travel


Event OnKeyDown(int keycode)
	if !is_enabled || is_paused
		return
	endif
		
	if Game.GetPlayer().IsInInterior()
		in_interior = True
	else 
		in_interior = False
	endif
			
	if Game.GetPlayer().IsInLocation(MarkarthLocation) \
		|| Game.GetPlayer().IsInLocation(RiftenLocation) \
		|| Game.GetPlayer().IsInLocation(SolitudeLocation) \
		|| Game.GetPlayer().IsInLocation(WhiterunLocation) \
		|| Game.GetPlayer().IsInLocation(WindhelmLocation)
			in_city = True
	else
		in_city = False
	endif
	
	if (keycode == 19 || keycode == 278) \
		&& is_looting \
		&& !Game.GetPlayer().IsInCombat()
			_debug("Looting all from container")
			take_all = True
	
	elseif (keycode == 18 || keycode == 276) \
		&& fishing_ae_pole \
		&& !Game.GetPlayer().IsInCombat()
		Utility.Wait(1.0)
		if !(Game.IsMenuControlsEnabled())
			_debug("Player may be fishing")
			is_fishing = True
		endif
	
	elseif (keycode == 18 || keycode == 256 || keycode == 276) \
		&& UI.isMenuOpen("InventoryMenu") \
		&& !Game.GetPlayer().IsInCombat()
			_debug("Inventory item activated")
			inventory_activated = True
		Utility.Wait(1.0)	
		if shovel && !(Game.IsMenuControlsEnabled())								;; Shovels Bury Bodies
			_debug("Buried bodies")
			if bury_hour >= transition_threshold
				Transition()
			endif	
			pass_time(bury_hour * random_time_multiplier())
			shovel = False
		endif
	
	elseif (keycode == 18 || keycode == 256 || keycode == 276) \
		&& !(UI.isMenuOpen("Crafting Menu")) \
		&& !(UI.isMenuOpen("Dialogue Menu")) \
		&& !Game.GetPlayer().IsInCombat()
			activate_key_pressed = True
			Utility.Wait(2.0) ;; wait for possible open menu
			if UI.isMenuOpen("Crafting Menu") && furniture_using == None
				_debug("Crafting via Menu")
				is_crafting_menu = True
				suppress_fullscreen = True
			elseif !(Game.IsMovementControlsEnabled())
				_debug("Possible fast travel")
				fast_travel = True
				game_time = Utility.GetCurrentGameTime()				
				game_time_obtained = True
				Utility.Wait(2.0) ;; wait for loot totals
				GameTimeNotification()
			else 
				_debug("Not crafting or fast traveling")
				is_crafting_menu = False
				fast_travel = False
				suppress_fullscreen = False
			endif
		
	endif
EndEvent


Event OnUpdate()
	if block_controls	
		if Game.GetPlayer().IsInCombat()
			int ihotkey = Input.GetNthKeyPressed(0)
			bool is_hotkey_pressed = Input.IsKeyPressed(ihotkey)

			if !combat_message && combat_warning
				Debug.Notification("During combat, player controls are not accessible.")			
			endif
			
			if is_hotkey_pressed \
				&& ((ihotkey >= 2 && ihotkey <= 9) || ihotkey == 16 || ihotkey == 18 \ 
					|| ihotkey == 266 || ihotkey == 267 || ihotkey == 276) ;; hotkeys 1-8, Favorites menu, horse dismount
						is_hotkey_pressed = !is_hotkey_pressed
						Game.EnablePlayerControls()
						Input.TapKey(ihotkey)
						Game.DisablePlayerControls(false, false, false, false, false, block_menus, block_objects, block_journal)
			else
				Game.DisablePlayerControls(false, false, false, false, false, block_menus, block_objects, block_journal)
			endif		

			combat_message = True
			RegisterForSingleUpdate(0.25)
		
		else
			if combat_message && combat_warning
				Debug.Notification("Player controls are now accessible.")
			endif
			Game.EnablePlayerControls()
			combat_message = False
			RegisterForSingleUpdate(5.0)
		endif
	endif
EndEvent


Event OnMenuOpen(string menu)
	if !is_enabled || is_paused || Game.GetPlayer().IsInCombat()
		return
	endif
	_debug("Menu opened - " + menu)
	
	if menu == "Crafting Menu" 
		time_started = Utility.getCurrentRealTime()
		armor_improved = Game.queryStat("Armor Improved")
		weapon_improved = Game.queryStat("Weapons Improved")
		item_enchanted = Game.queryStat("Magic Items Made")
		potion_mixed = Game.queryStat("Potions Mixed")
		poison_mixed = Game.queryStat("Poisons Mixed")
		unregisterForKey(37)
	
	elseif menu == "Training Menu"
		training_session = Game.queryStat("Training Sessions")
		collect_skills()
	
	elseif menu == "ContainerMenu"
		registerForKey(19)
		registerForKey(276)			
		is_looting = True
		time_started = Utility.getCurrentRealTime()
		chests_looted = Game.queryStat("Chests Looted")
	
	elseif menu == "InventoryMenu"
		registerForKey(18)
		registerForKey(256)
		registerForKey(278)
		is_looting = False
		is_trading = False
		time_started = Utility.getCurrentRealTime()
		food_eaten = Game.queryStat("Food Eaten")
		spell_learned = Game.queryStat("Spells Learned")
	
	elseif menu == "BarterMenu" || menu == "GiftMenu"
		is_trading = True
		time_started = Utility.getCurrentRealTime()
				
	elseif menu == "Book Menu" ||  menu == "Lockpicking Menu"
		time_started = Utility.getCurrentRealTime()
		
	elseif menu == "Dialogue Menu"
		dialogue_menu = True
		game_time = Utility.GetCurrentGameTime()
		game_time_obtained = True
		
	elseif menu == "Loading Menu"
		if dialogue_menu
			dialogue_menu = False
			return		
		endif
			
	else  ;; vanilla/modded time skips
		game_time = Utility.GetCurrentGameTime()
		game_time_obtained = True
		
	endif
EndEvent


Event OnMenuClose(string menu)
	if !is_enabled || is_paused || Game.GetPlayer().IsInCombat()	
		return
	endif
    _debug("Menu closed - " + menu)
			
	if menu == "Crafting Menu"        
		float t = 0.0
		
		if (is_crafting_station || is_crafting_spell || is_crafting_menu)						
			int i = Game.queryStat("Armor Improved") - armor_improved					;; Improving armors
			if i > 0
				_debug(i + " armor(s) improved")
			endif
			while i > 0
				t += armor_improving_minute * \
					random_time_multiplier() * \
					self.expertise_multiplier("Smithing") / 60
				i -= 1
			endwhile

			int j = Game.queryStat("Weapons Improved") - weapon_improved				;; Improving weapons
			if j > 0
				_debug(j + " weapon(s) improved")
			endif
			while j > 0
				t += weapon_improving_minute * \
					random_time_multiplier() * \
					self.expertise_multiplier("Smithing") / 60
				j -= 1
			endwhile
			
			int k = Game.queryStat("Magic Items Made") - item_enchanted					;; Enchanting
			if k > 0
				_debug(k + " item(s) enchanted")
			endif
			while k > 0
				t += enchanting_hour * \
					random_time_multiplier() * \
					self.expertise_multiplier("Enchanting")
				k -= 1
			endwhile
			while_loop = True
		endif
		
		if cooking_time_to_pass > 0.0
			_debug("Food Cooked")
			if cooking_time_to_pass >= transition_threshold
				Transition()
			endif	
			pass_time(cooking_time_to_pass)												;; Cooking
			cooking_time_to_pass = 0.0
		endif
		
		if alchemy_time_to_pass > 0.0
			_debug("Potions/Poisons Made")												;; Alchemy
			if alchemy_time_to_pass >= transition_threshold
				Transition()
			endif	
			pass_time(alchemy_time_to_pass)
			alchemy_time_to_pass = 0.0
		endif

		;; if time not passed via crafting workstation, spell, menu or improvement, pass barter time
		if is_crafting_station
			_debug("Crafting via workstation")
		elseif is_crafting_spell
			_debug("Crafting via spell")
		elseif is_crafting_menu
			_debug("Crafting via non-workstation menu")
		elseif !time_advanced && furniture_using == None
			_debug("Trading")
			time_stopped = Utility.getCurrentRealTime()
			float time_passed = (time_stopped - time_started) * \
				TimeScale.getValue() / 60 / 60 * trading_time_multiplier
			pass_time(time_passed)														;; Trading	
			return
		endif
		
		if t >= transition_threshold
			Transition()
		endif	
		pass_time(t)
		
	elseif menu == "InventoryMenu"	
		if eating_time_to_pass > 0.0
			_debug("Eating from inventory")
			pass_time(eating_time_to_pass)												;; Eating from inventory
			eating_time_to_pass = 0.0	
		elseif is_reading
			is_reading = False
			return
		elseif inventory_loot
			_debug("Looting from inventory")
			time_stopped = Utility.getCurrentRealTime()
				float time_passed = (time_stopped - time_started) * \
					TimeScale.getValue() / 60 / 60 * looting_time_multiplier
				pass_time(time_passed)													;; Looting from inventory
		endif
	
	elseif menu == "Training Menu"
		_debug("Training")
		evaluate_skill_change()		
		int i = Game.queryStat("Training Sessions")
		float time_passed = (i - training_session) * \
			(training_hour * skill_level_multiplier)
		if time_passed >= transition_threshold
			Transition()
		endif		
		pass_time(time_passed)															;; Training
		
	elseif menu == "ContainerMenu"
		int chests_looted_now = Game.queryStat("Chests Looted")
		int people_killed_now = Game.queryStat("People Killed")
		
		Utility.Wait(2.0) ;; wait for loot all skinning/harvesting totals
				
		if skinning_enabled \
			&& chests_looted_now <= chests_looted \
			&& people_killed_now <= people_killed \
			&& (item_skin && !item_other) \
			&& (skinning_time_to_pass > 0.0 || harvesting_time_to_pass > 0.0)						
			_debug("Animal or creature parts skinned/harvested")
			if (skinning_time_to_pass + harvesting_time_to_pass) >= transition_threshold
				Transition()
			endif		
			pass_time(skinning_time_to_pass + harvesting_time_to_pass)					;; Skinning
							
		else			
			time_stopped = Utility.getCurrentRealTime()
			float time_passed = (time_stopped - time_started) * \
				TimeScale.getValue() / 60 / 60 * looting_time_multiplier				;; Looting
			_debug("Standard looting")
			pass_time(time_passed)	
		endif
					
		skinning_time_to_pass = 0.0	
		harvesting_time_to_pass = 0.0
		chests_looted = chests_looted_now
		people_killed = people_killed_now
		item_skin = False
		item_other = False
		is_trading = False
		is_looting = False
		take_all = False
		unregisterForKey(19)
		unregisterForKey(256)
		unregisterForKey(278)
					
	elseif menu == "Book Menu"
		time_stopped = Utility.getCurrentRealTime()
		float time_passed = (time_stopped - time_started) * \
			TimeScale.getValue() / 60 / 60 * \
			reading_time_multiplier * \
			self.expertise_multiplier("Speechcraft")
		pass_time(time_passed)															;; Reading

		float skill_increased = (time_stopped - time_started) * \
			reading_increases_speech_multiplier
		ActorValueInfo.getActorValueInfoByName("Speechcraft") \
			.addSkillExperience(skill_increased)										;; Reading increasing speech

		is_reading = True
			
	elseif menu == "Lockpicking Menu"
		time_stopped = Utility.getCurrentRealTime()
		float time_passed = (time_stopped - time_started) * \
			TimeScale.getValue() / 60 / 60 * \
			lockpicking_time_multiplier	* \
			self.expertise_multiplier("Lockpicking")
		pass_time(time_passed) 															;; Lockpicking

	elseif menu == "BarterMenu" || menu == "GiftMenu"
		time_stopped = Utility.getCurrentRealTime()
		float time_passed = (time_stopped - time_started) * \
			TimeScale.getValue() / 60 / 60 * \
			trading_time_multiplier 
		pass_time(time_passed)															;; Trading
		is_trading = False
	
	elseif menu == "Loading Menu" ;; check for time advance on Loading Menu close
		Utility.Wait(1.0) ; wait for possible inteior/exterior/city transition flag
		if loadgame
			loadgame = False
			return
		elseif (!in_interior && Game.GetPlayer().IsInInterior()) \
			|| (in_interior && !Game.GetPlayer().IsInInterior()) \
			|| (in_interior && Game.GetPlayer().IsInInterior()) \
			|| is_fishing
				_debug("Door Transition or Fishing")
				return
		elseif !in_interior \
			&& !Game.GetPlayer().IsInInterior() \
			&& in_city \
			&& !fast_travel
				_debug("City Gate Transition")
				return
		elseif !in_interior \
			&& !Game.GetPlayer().IsInInterior() \
			&& !in_city \
			&& !fast_travel
				_debug("Exterior Transition")
				return			
		elseif fast_travel
			_debug("Fast Travel")
			fast_travel = False
			GameTimeNotification()
		else
			GameTimeNotification()
		endif
	
	else ;; check for time advance on other menu close
		Utility.Wait(1.0)
		if UI.isMenuOpen("Crafting Menu") \
			|| UI.isMenuOpen("Lockpicking Menu") \
			|| UI.isMenuOpen("Book Menu") \
			|| UI.isMenuOpen("Training Menu") \
			|| UI.isMenuOpen("ContainerMenu") \
			|| UI.isMenuOpen("InventoryMenu")
			return
			
		else
			_debug("Checking for vanilla or modded time advance...")
			Utility.Wait(2.0) ; wait for loot totals
			GameTimeNotification()
			return

		endif

	endif
		
	;; reset when done
	activate_key_pressed = False
	is_crafting_station = False
	is_crafting_spell = False
	is_crafting_menu = False	
	time_advanced = False
EndEvent


Function Transition()
	if show_transition && !is_paused
		if show_fullscreen_transition && !suppress_fullscreen			
			UI.InvokeString("HUD Menu", "_global.skse.CloseMenu", "Crafting Menu")
			UI.SetFloat("HUD Menu", "_alpha", 0)			
			Game.FadeOutGame(true, true, 0.0, transition_duration)
			Utility.Wait(transition_duration * 0.94)		
			Debug.SendAnimationEvent(Game.GetPlayer(), "IdleForceDefaultState")
			UI.SetFloat("HUD Menu", "_alpha", 100)
			Game.FadeOutGame(false, true, 0.0, 5.0)			
		else
			Game.FadeOutGame(true, true, 0.0, transition_duration)
			Utility.Wait(transition_duration * 0.94)
			Game.FadeOutGame(false, true, 0.0, 5.0)
		endif
	endif
	
	suppress_fullscreen = False
EndFunction


int Function GetPassedGameDays() 
	float days = GameDaysPassed.getValue()
	return days as int
EndFunction


;;Check for vanilla or mod time advances
Function GameTimeNotification()
	if show_notification && !fishing_ae_pole && !loadgame && !while_loop && !is_paused		
		float time_passed
		game_time_now = Utility.GetCurrentGameTime()
		time_passed = ((game_time_now - (game_time As Float)) * 24)
	
		if (time_passed >= (notification_threshold / 60)) && game_time_obtained	
			int hour_passed = Math.floor(time_passed)
			int minute_passed = Math.floor((time_passed - hour_passed) * 60)
			_debug("Vanilla or mod time passed - " + hour_passed + " hour(s), " + \
				minute_passed + " minute(s) (" + time_passed + ")")
		
			if hour_passed > 0
				notification_long.show(hour_passed, minute_passed)
			else
				notification_short.show(minute_passed)
			endif
			game_time_obtained = False
			game_time = game_time_now
			
		endif
	endif
	while_loop = False
EndFunction


Function handle_loadgame()
	loadgame = True
	is_fishing = False
	fast_travel = False
	if show_day_notification
		int days_passed = GetPassedGameDays()
		Utility.Wait(5.0)
		Debug.Notification("Day " + days_passed)
		time_advanced = False
	endif
EndFunction


Function handle_using_furniture(ObjectReference obj) 	
	if !is_enabled || is_paused || is_reading
        return
    endif	
    _debug("Using furniture")
    furniture_using = obj
	if UI.isMenuOpen("Crafting Menu")
		is_crafting_station = True
		is_trading = False
	endif
EndFunction


Function handle_leaving_furniture(ObjectReference obj)
    if !is_enabled || is_paused || is_reading
        return
    endif	
    _debug("Leaving furniture") 
    furniture_using = None
	is_crafting_station = False  ;; reset when done
	activate_key_pressed = False
EndFunction


Function handle_spellcast(Form item)
	if !is_enabled || is_paused
		return
	endif
		
	if mods.handle_spellcast(item)
		_debug("Another mod handling spell...")
		return
	endif
	
	string spell_name = item.GetName()
	
	Spell spellcast = item as Spell
	Utility.Wait(2.0)	;; wait for possible open menu
	if spellcast && UI.isMenuOpen("Crafting Menu")
		_debug("Crafting spell " + spell_name + " cast")
		is_trading = False
		is_crafting_spell = True
		suppress_fullscreen = True
	elseif pray.find(item) > -1
		_debug("Prayer spell " + spell_name + " cast")
		pass_time(prayer_minute / 60)
	else
		_debug("Spell " + spell_name + " cast")
	endif
EndFunction


Function handle_equipped(Form item, ObjectReference ref)	
	if item.hasKeywordString("ccBGSSSE001_FishingPoleKW")
		_debug("Fishing AE pole equipped")	
		fishing_ae_pole = True
	elseif shovel_list.find(item) > -1
		_debug("Shovel equipped")
		shovel = True
	endif
EndFunction


Function handle_unequipped(Form item, ObjectReference ref)	
	if item.hasKeywordString("ccBGSSSE001_FishingPoleKW")
		_debug("Fishing AE pole unequipped")
		fishing_ae_pole = False
	endif
EndFunction


Function handle_added_item(Form item, int count, \
        ObjectReference ref, ObjectReference src)	
	if !is_enabled || is_paused || Game.GetPlayer().IsInCombat()
		return
	endif
	
	;; Enable notifications when CCOR is installed
	int ccor = Game.getModByName("Complete Crafting Overhaul_Remastered.esp")
	if ccor != 255
		Utility.SetINIBool("bShowHUDMessages:Interface", true)
    endif
		
	string item_name = item.getName()
    int type = item.getType()	
	item_val = item.getGoldValue()

	if furniture_using \
		&& caco_items.find(item) > -1 \
		&& (furniture_using.hasKeywordString("CraftingCookpot") || furniture_using.hasKeywordString("isCraftingOven"))
			_debug("handle CACO addition of items at cookpot/ovens")
			return
	endif
			
	;; handle CCOR category filter additions - requires CCOR 2.5.9+
	if item.hasKeywordString("CCO_MenuCategory")
		return
	endif
	
	_debug("Item added - " + item_name + " (" + type + ") " + "(" + count + ")")

	;; Activities	
	int item_harvested_now = Game.queryStat("Ingredients Harvested")										;; Harvesting
	if item_harvested_now > item_harvested \
		&& !(item.hasKeywordString("VendorItemClutter"))	; exclude Coin Purses
			_debug("Ingredients harvested")
			pass_time(harvesting_minute * \
				random_time_multiplier() / 60)
			item_harvested = item_harvested_now
	endif
	
	if skinning_enabled \
		&& (UI.IsMenuOpen("ContainerMenu") || take_all)														;; Skinning
			if item_name == "" 	;; exclude phantom items
				item_other = False
			elseif item.hasKeywordString("VendorItemAnimalHide") \	
				|| item.hasKeywordString("VendorItemAnimalPart") \
				|| item.hasKeywordString("VendorItemFoodRaw") \
				|| item.hasKeywordString("VendorItemFoodUncooked")	;; possibly skinning
					_debug("Possible animal or creature part skinned")				
					skinning_time_to_pass += ((skinning_minute * \
						random_time_multiplier() / 60) * \
						count)			  
					item_skin = True 
			elseif item.hasKeywordString("VendorItemIngredient") \
				|| item.hasKeywordString("VendorItemPoison")	;; possibly harvesting  
					_debug("Possible animal or creature ingredient harvested")
					harvesting_time_to_pass += ((harvesting_minute * \
						random_time_multiplier() / 60)	* \
						count)	  	 			
					item_skin = True 
			else 
				item_other = True				
			endif
	endif
	
	if furniture_using != None
		if furniture_using.hasKeywordString("isPickaxeWall") \
			|| furniture_using.hasKeywordString("isPickaxeFloor") \
			|| furniture_using.hasKeywordString("isPickaxeTable") \
			|| furniture_using.hasKeywordString("DLC2IsPickaxeWall") \
			|| furniture_using.hasKeywordString("DLC2IsPickaxeFloor") \
			|| furniture_using.hasKeywordString("DLC2IsPickaxeTable")										;; Mining 
				_debug("Ore mined")
				pass_time(mining_minute * random_time_multiplier() / 60)
			
		elseif furniture_using.hasKeywordString("FurnitureWoodChoppingBlock") 								;; Lumbering
			_debug("Wood chopped")
			pass_time(lumbering_minute * random_time_multiplier() / 60)	
			
		elseif furniture_using.hasKeywordString("CraftingSmelter")											;; Smelting
			_debug("Using smelter")
			if smelting_hour >= transition_threshold
				Transition()
			endif
			pass_time(smelting_hour * \
				random_time_multiplier() * \
				self.expertise_multiplier("Smithing"))
		endif
	endif
		
	if is_fishing \
		&& furniture_using == None \
		&& !(UI.IsMenuOpen("Crafting Menu")) \
		&& !(UI.IsMenuOpen("BarterMenu")) \
		&& !(UI.IsMenuOpen("GiftMenu")) \
		&& !(UI.IsMenuOpen("ContainerMenu"))																;; AE Fishing
			if !fishing_junk 
				if (type == 30 || item.hasKeywordString("VendorItemFoodRaw"))
					_debug("AE fishing without junk")
					pass_time(fishing_minute * random_fishing_time_multiplier() / 60)
					is_fishing = False
				endif
			elseif fishing_junk
				if (type == 30 || type == 32 || item.hasKeywordString("VendorItemFoodRaw"))
					_debug("AE fishing with junk")
					pass_time(fishing_minute * random_fishing_time_multiplier() / 60)
					is_fishing = False
				endif
			endif
	endif
		
	;; allow mods to handle cow milking
	if activate_key_pressed && item == milk
		_debug("Cow milked")
		pass_time(milking_minute * random_time_multiplier() / 60)
		activate_key_pressed = False
		return
	endif
	
	;; allow mods to handle butter churn
	if UI.isMenuOpen("Crafting Menu") && item == butter
		_debug("Butter made")
		pass_time(butter_crafting_hour * random_time_multiplier())
		is_crafting_menu = False
		return
	endif
		
	;; Crafting
	_debug("Crafting via Workstation (" + is_crafting_station + "), Spell (" + is_crafting_spell + "), Menu (" + is_crafting_menu + ")")
	
	if (!is_crafting_station && !is_crafting_spell && !is_crafting_menu) \
		|| src \
		|| UI.isMenuOpen("Console") 
		time_advanced = False
		return
    endif
    
	if get_prefix(item) == 255
		_debug("Standard handling...")
	elseif is_crafting_spell
		_debug("Crafting spell handling...")
    elseif mods.handle_added_item(item)
        _debug("Another mod handling item...")
		return
	else	
		_debug("No handling captured...")
    endif
	
	if type  == 46	;; potion, poison or food
        Potion p = item as Potion
		int potion_mixed_now = Game.queryStat("Potions Mixed")
		int poison_mixed_now = Game.queryStat("Poisons Mixed")
		
        if p.isFood() 
				_debug("Cooking food")
				cooking_time_to_pass += (cooking_minute * \
					random_time_multiplier() * \
					self.expertise_multiplier("Alchemy") / 60)
		elseif (potion_mixed_now > potion_mixed || poison_mixed_now > poison_mixed)
				_debug("Crafting potions/poisons")
				alchemy_time_to_pass += (alchemy_minute * \
					random_time_multiplier() * \
					self.expertise_multiplier("Alchemy") / 60)
				potion_mixed = potion_mixed_now
				poison_mixed = poison_mixed_now
		endif
		    
	elseif type == 26	;; armor
        Armor a = item as Armor
        if a.isHelmet()
            _debug("Helmet made")
			if helmet_crafting_hour >= transition_threshold
				Transition()
			endif			
			pass_time(helmet_crafting_hour * \
				random_time_multiplier() * \
				item_value_multiplier(item) * \
				self.expertise_multiplier("Smithing"))
        elseif a.isCuirass()
            _debug("Armor made")
			if armor_crafting_hour >= transition_threshold
				Transition()
			endif
            pass_time(armor_crafting_hour * \
				random_time_multiplier() * \
				item_value_multiplier(item) * \
				self.expertise_multiplier("Smithing"))
        elseif a.isGauntlets()
            _debug("Gauntlets made")
			if gauntlets_crafting_hour >= transition_threshold
				Transition()
			endif
			pass_time(gauntlets_crafting_hour * \
				random_time_multiplier()* \
				item_value_multiplier(item) * \
				self.expertise_multiplier("Smithing"))
        elseif a.isBoots()
            _debug("Boots made")
			if boots_crafting_hour >= transition_threshold
				Transition()
			endif
			pass_time(boots_crafting_hour * \
				random_time_multiplier() * \
				item_value_multiplier(item) * \
				self.expertise_multiplier("Smithing"))
        elseif a.isShield()
            _debug("Shield made")
			if shield_crafting_hour >= transition_threshold
				Transition()
			endif
			pass_time(shield_crafting_hour * \
				random_time_multiplier() * \
				item_value_multiplier(item) * \
				self.expertise_multiplier("Smithing"))
        elseif a.isJewelry()
            _debug("Jewelry made")
			if jewelry_crafting_hour >= transition_threshold
				Transition()
			endif
			pass_time(jewelry_crafting_hour * \
				random_time_multiplier() * \
				self.expertise_multiplier("Smithing"))
        elseif a.isClothing()
            _debug("Clothes made")
			if clothes_crafting_hour >= transition_threshold
				Transition()
			endif
			pass_time(clothes_crafting_hour * \
			random_time_multiplier() * \
			self.expertise_multiplier("Smithing"))
        else
            _debug("Vendor is crafting or unknown armor made")
		endif
	
	elseif type == 41	;; weapon
        Weapon w = item as Weapon
        if w.isBow()
            _debug("Bow made")
			if bow_crafting_hour >= transition_threshold
				Transition()
			endif
			pass_time(bow_crafting_hour * \
			random_time_multiplier() * \
			item_value_multiplier(item) * \
			self.expertise_multiplier("Smithing"))
        elseif w.isDagger()
            _debug("Dagger made")
			if dagger_crafting_hour >= transition_threshold
				Transition()
			endif
			pass_time(dagger_crafting_hour * \
				random_time_multiplier() * \
				item_value_multiplier(item) * \
				self.expertise_multiplier("Smithing"))
        elseif w.isSword()
            _debug("Sword made")
			if sword_crafting_hour >= transition_threshold
				Transition()
			endif
			pass_time(sword_crafting_hour * \
				random_time_multiplier() * \
				item_value_multiplier(item) * \
				self.expertise_multiplier("Smithing"))
        elseif w.isWarAxe()
            _debug("Waraxe made")
			if waraxe_crafting_hour >= transition_threshold
				Transition()
			endif
			pass_time(waraxe_crafting_hour * \
			random_time_multiplier() * \
			item_value_multiplier(item) * \
			self.expertise_multiplier("Smithing"))
        elseif w.isMace()
			_debug("Mace made")
			if mace_crafting_hour >= transition_threshold
				Transition()
			endif
			pass_time(mace_crafting_hour * \
			random_time_multiplier() * \
			item_value_multiplier(item) * \
			self.expertise_multiplier("Smithing"))
        elseif w.isGreatSword()
            _debug("Greatsword made")
			if greatsword_crafting_hour >= transition_threshold
				Transition()
			endif
			pass_time(greatsword_crafting_hour * \
				random_time_multiplier() * \
				item_value_multiplier(item) * \
				self.expertise_multiplier("Smithing"))
        elseif w.isBattleAxe()
            _debug("Battleaxe made")
			if battleaxe_crafting_hour >= transition_threshold
				Transition()
			endif
			pass_time(battleaxe_crafting_hour * \
				random_time_multiplier() * \
				item_value_multiplier(item) * \
				self.expertise_multiplier("Smithing"))
        elseif w.isWarhammer()
            _debug("Warhammer made")
			if warhammer_crafting_hour >= transition_threshold
				Transition()
			endif
			pass_time(warhammer_crafting_hour * \
				random_time_multiplier() * \
				item_value_multiplier(item) * \
				self.expertise_multiplier("Smithing"))
        elseif w.isStaff()
            _debug("Staff made")
			if staff_crafting_hour >= transition_threshold
				Transition()
			endif
			pass_time(staff_crafting_hour * \
				random_time_multiplier() * \
				self.expertise_multiplier("Smithing"))
        else
            _debug("Unknown weapon made")
        endif
    
	elseif type == 42	;; ammo
        _debug("Ammo made")
		if ammo_crafting_hour >= transition_threshold
			Transition()
		endif
        pass_time(ammo_crafting_hour * \
			random_time_multiplier() * \
			item_value_multiplier(item) * \
			self.expertise_multiplier("Smithing"))
    
	elseif type == 32 	;; misc items
		if item == leather
            _debug("Leather made")
			if leather_crafting_hour >= transition_threshold
				Transition()
			endif
            pass_time(leather_crafting_hour * \
			random_time_multiplier() * \
			self.expertise_multiplier("Smithing"))		
		elseif item.hasKeywordString("VendorItemPotion")																;; Misc. Potions
			_debug("Misc. potions being created")
			alchemy_time_to_pass += (alchemy_minute * \
				random_time_multiplier() * \
				self.expertise_multiplier("Alchemy") / 60)
		elseif item.hasKeywordString("VendorItemTool") \ 
			|| item.hasKeywordString("VendorItemLockpicks")																;; Misc. Tools
				_debug("Tool made")
				pass_time(tool_crafting_hour * \
				random_time_multiplier() * \
				self.expertise_multiplier("Smithing"))
		elseif item.hasKeywordString("VendorItemClutter") 																;; Misc. Clutter
			_debug("Clutter made")
			pass_time(clutter_crafting_hour * \
			random_time_multiplier() * \
			self.expertise_multiplier("Smithing"))
		endif
	
	else 
        _debug("Irrelevant item added")		
		time_advanced = False
    endif
	
	;; Disable notifications when CCOR is installed
	if ccor != 255
		Utility.SetINIBool("bShowHUDMessages:Interface", false)
    endif
	
	activate_key_pressed = False
EndFunction


Function handle_removed_item(Form item, int count, \
        ObjectReference ref, ObjectReference dst)
	if !is_enabled || is_paused || is_looting || is_trading || UI.isMenuOpen("Console") || Game.GetPlayer().IsInCombat()
        return
    endif
	
    string item_name = item.getName()
	int type = item.getType()
	
	if furniture_using \
		&& caco_items.find(item) > -1 \
		&& (furniture_using.hasKeywordString("CraftingCookpot") || furniture_using.hasKeywordString("isCraftingOven"))
			_debug("handle CACO removal of items at cookpot/ovens")
			return
	endif
	
    _debug("Item removed - " + item_name + " (" + type + ") " + "(" + count + ")")
		
    if mods.handle_removed_item(item)
		return
    endif
	
	bool isInventoryMenuOpen = UI.IsMenuOpen("InventoryMenu")
	
	if type == 46 \	
		&& !UI.IsMenuOpen("Crafting Menu")	;; food
			food_eaten_now = Game.queryStat("Food Eaten")
			
		if food_eaten_now > food_eaten \
			&& isInventoryMenuOpen
				_debug("Food eaten from inventory menu")
				eating_time_to_pass += (eating_minute * random_time_multiplier() / 60)
				food_eaten = food_eaten_now
		
		elseif food_eaten_now > food_eaten \
			&& !isInventoryMenuOpen \		
			&& !(frostbite.find(item) > -1) ;; exclude Frostfall effects																		
					_debug("Food eaten outside inventory menu") 
					
					float t = 0.0  					
					int i = Game.queryStat("Food Eaten") - food_eaten
					
					if i > 0
						_debug(i + " food eaten")
					endif
					while i > 0
						t += eating_minute * \
							random_time_multiplier() / 60
						i -= 1
					endwhile
					
					pass_time(t)
					food_eaten = food_eaten_now
					while_loop = True
					return
		endif
		
	elseif type == 27	;; book
		int spell_learned_now = Game.queryStat("Spells Learned")		
		if spell_learned_now > spell_learned
				_debug("Spell learned")
				if spell_learning_hour >= transition_threshold
					Transition()
				endif	
				pass_time(spell_learning_hour * \
					random_time_multiplier() * \
					self.expertise_multiplier("Speechcraft"))
				spell_learned = spell_learned_now
		endif
				
	endif
	
	if item == firewood_campsite && inventory_activated
		_debug("Built Campsite fire")																	;; Campsite firebuilding
		pass_time(fire_building_minute * random_time_multiplier() / 60)
    endif
	
	inventory_activated = False
	activate_key_pressed = False
EndFunction


float Function collect_skills()
	skill_alchemy = self.get_skill("Alchemy")
	skill_onehanded = self.get_skill("OneHanded")
	skill_twohanded = self.get_skill("TwoHanded")
	skill_marksman = self.get_skill("Marksman")
	skill_block = self.get_skill("Block")
	skill_smithing = self.get_skill("Smithing")
	skill_heavyarmor = self.get_skill("HeavyArmor")
	skill_lightarmor = self.get_skill("LightArmor")
	skill_pickpocket = self.get_skill("Pickpocket")
	skill_lockpicking = self.get_skill("Lockpicking")
	skill_sneak = self.get_skill("Sneak")
	skill_speechcraft = self.get_skill("Speechcraft")
	skill_alteration = self.get_skill("Alteration")
	skill_conjuration = self.get_skill("Conjuration")
	skill_destruction = self.get_skill("Destruction")
	skill_illusion = self.get_skill("Illusion")
	skill_restoration = self.get_skill("Restoration")
	skill_enchanting = self.get_skill("Enchanting")
EndFunction


;; Scaled training	
float Function evaluate_skill_change()
	if scaled_training
		skill_alchemy_now = self.get_skill("Alchemy")
		skill_onehanded_now = self.get_skill("OneHanded")
		skill_twohanded_now = self.get_skill("TwoHanded")
		skill_marksman_now = self.get_skill("Marksman")
		skill_block_now = self.get_skill("Block")
		skill_smithing_now = self.get_skill("Smithing")
		skill_heavyarmor_now = self.get_skill("HeavyArmor")
		skill_lightarmor_now = self.get_skill("LightArmor")
		skill_pickpocket_now = self.get_skill("Pickpocket")
		skill_lockpicking_now = self.get_skill("Lockpicking")
		skill_sneak_now = self.get_skill("Sneak")
		skill_speechcraft_now = self.get_skill("Speechcraft")
		skill_alteration_now = self.get_skill("Alteration")
		skill_conjuration_now = self.get_skill("Conjuration")
		skill_destruction_now = self.get_skill("Destruction")
		skill_illusion_now = self.get_skill("Illusion")
		skill_restoration_now = self.get_skill("Restoration")
		skill_enchanting_now = self.get_skill("Enchanting")
		
		if skill_alchemy_now > skill_alchemy
			_debug("Alchemy Improved")
			skill_level_multiplier = ((75 + skill_alchemy_now) / 100)
		elseif skill_onehanded_now > skill_onehanded
			_debug("One Handed Improved")
			skill_level_multiplier = ((75 + skill_onehanded_now) / 100)
		elseif skill_twohanded_now > skill_twohanded
			_debug("Two Handed Improved")
			skill_level_multiplier = ((75 + skill_twohanded_now) / 100)
		elseif skill_marksman_now > skill_marksman
			_debug("Marksman Improved")
			skill_level_multiplier = ((75 + skill_marksman_now) / 100)
		elseif skill_block_now > skill_block
			_debug("Block Improved")
			skill_level_multiplier = ((75 + skill_block_now) / 100)
		elseif skill_smithing_now > skill_smithing
			_debug("Smithing Improved")
			skill_level_multiplier = ((75 + skill_smithing_now) / 100)
		elseif skill_heavyarmor_now > skill_heavyarmor
			_debug("Heavy Armor Improved")
			skill_level_multiplier = ((75 + skill_heavyarmor_now) / 100)		
		elseif skill_lightarmor_now > skill_lightarmor
			_debug("Light Armor Improved")
			skill_level_multiplier = ((75 + skill_lightarmor_now) / 100)
		elseif skill_pickpocket_now > skill_pickpocket
			_debug("Pickpocket Improved")
			skill_level_multiplier = ((75 + skill_pickpocket_now) / 100)
		elseif skill_lockpicking_now > skill_lockpicking
			_debug("Lockpicking Improved")
			skill_level_multiplier = ((75 + skill_lockpicking_now) / 100)
		elseif skill_sneak_now > skill_sneak
			_debug("Sneak Improved")
			skill_level_multiplier = ((75 + skill_sneak_now) / 100)
		elseif skill_speechcraft_now > skill_speechcraft
			_debug("Speechcraft Improved")
			skill_level_multiplier = ((75 + skill_speechcraft_now) / 100)
		elseif skill_alteration_now > skill_alteration
			_debug("Alteration Improved")
			skill_level_multiplier = ((75 + skill_alteration_now) / 100)
		elseif skill_conjuration_now > skill_conjuration
			_debug("Conjuration Improved")
			skill_level_multiplier = ((75 + skill_conjuration_now) / 100)
		elseif skill_destruction_now > skill_destruction
			_debug("Destruction Improved")
			skill_level_multiplier = ((75 + skill_destruction_now) / 100)
		elseif skill_illusion_now > skill_illusion
			_debug("Illusion Improved")
			skill_level_multiplier = ((75 + skill_illusion_now) / 100)
		elseif skill_restoration_now > skill_restoration
			_debug("Restoration Improved")
			skill_level_multiplier = ((75 + skill_restoration_now) / 100)
		elseif skill_enchanting_now > skill_enchanting
			_debug("Enchanting Improved")
			skill_level_multiplier = ((75 + skill_enchanting_now) / 100)
		else
			skill_level_multiplier = 1.0
		endif
	else
		skill_level_multiplier = 1.0
	endif
EndFunction


float Function get_skill(string skill)
	skill_points = Game.getPlayer().getActorValue(skill)
	return skill_points
EndFunction


;; Expertise reduces crafting time
float Function expertise_multiplier(string skill)
	if expertise_reduces_time
		skill_points = Game.getPlayer().getActorValue(skill)
		if skill_points < 0
			skill_points = 0.0
		elseif skill_points > 150
			skill_points = 150.0
		endif
		return (100 - skill_points / 2) / 100
	else
		return 1.0
	endif
EndFunction


;; Item value modifies crafting time
float Function item_value_multiplier(Form item)
	if item_value_time	
		int type = item.getType()
		if type == 26	;; armor
			Armor a = item as Armor
			if a.isHelmet()
				if item_val == helm_dval
					return 4.0
				else
					return (helm_dval - helm_ival) / (helm_dval - item_val)
				endif
			elseif a.isCuirass()
				if item_val == cuirass_dval
					return 4.0
				else
					return (cuirass_dval - cuirass_ival) / (cuirass_dval - item_val)
				endif
			elseif a.isGauntlets()
				if item_val == gauntlets_dval
					return 4.0
				else
					return (gauntlets_dval - gauntlets_ival) / (gauntlets_dval - item_val)
				endif
			elseif a.isBoots()
				if item_val == boots_dval
					return 4.0
				else
					return (boots_dval - boots_ival) / (boots_dval - item_val)
				endif
			elseif a.isShield()
				if item_val == shield_dval
					return 4.0
				else
					return (shield_dval - shield_ival) / (shield_dval - item_val)
				endif
			else
				return 1.0
			endif
	
		elseif type == 41	;; weapon
			Weapon w = item as Weapon
			if w.isBow()
				if item_val == bow_dval
					return 4.0
				else
					return (bow_dval - bow_ival) / (bow_dval - item_val)
				endif
			elseif w.IsDagger()
				if item_val == dagger_dval
					return 4.0
				else
					return (dagger_dval - dagger_ival) / (dagger_dval - item_val)
				endif
			elseif w.isSword()
				if item_val == sword_dval
					return 4.0
				else
					return (sword_dval - sword_ival) / (sword_dval - item_val)
				endif
			elseif w.isGreatSword()
				if item_val == greatsword_dval
					return 4.0
				else
					return (greatsword_dval - greatsword_ival) / (greatsword_dval - item_val)
				endif
			elseif w.isWarAxe()	
				if item_val == waraxe_dval
					return 4.0
				else
					return (waraxe_dval - waraxe_ival) / (waraxe_dval - item_val)
				endif
			elseif w.isBattleAxe()
				if item_val == battleaxe_dval
					return 4.0
				else
					return (battleaxe_dval - battleaxe_ival) / (battleaxe_dval - item_val)
				endif
			elseif w.isMace()
				if item_val == mace_dval
					return 4.0
				else
					return (mace_dval - mace_ival) / (mace_dval - item_val)
				endif
			elseif w.isWarhammer()
				if item_val == warhammer_dval
					return 4.0
				else
					return (warhammer_dval - warhammer_ival) / (warhammer_dval - item_val)
				endif
			else
				return 1.0
			endif
					
		elseif type == 42 ;; ammo
			if item_val == ammo_dval
					return 4.0
			else
				return (ammo_dval - ammo_ival) / (ammo_dval - item_val)
			endif
		else			
			return 1.0
		endif
		
	else
		return 1.0
	endif 
EndFunction


float Function random_time_multiplier()
    if random_crafting_time
        return Utility.randomFloat(random_time_multiplier_min, \
            random_time_multiplier_max)
    else
        return 1.0
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


Function pass_time(float time_passed)
    if time_passed <= 0 || is_paused
        return
    endif
	
    float time = GameHour.getValue()
    time += time_passed
    int hour_passed = Math.floor(time_passed)
    int minute_passed = Math.floor((time_passed - hour_passed) * 60)
    _debug("Time passed - " + hour_passed + " hour(s), " + \
        minute_passed + " minute(s) (" + time_passed + ")")
    
    if show_notification
        if hour_passed > 0
            notification_long.show(hour_passed, minute_passed)
        elseif minute_passed >= notification_threshold
            notification_short.show(minute_passed)
        endif
    endif
	
    GameHour.setValue(time)
	time_advanced = True
EndFunction


int Function get_prefix(Form f)
    if f == None
        return -1
    else
        return Math.rightShift(f.getFormID(), 24)
    endif
EndFunction