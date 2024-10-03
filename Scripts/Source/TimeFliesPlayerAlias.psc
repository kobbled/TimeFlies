Scriptname TimeFliesPlayerAlias extends ReferenceAlias Conditional

TimeFliesMain Property main Auto

Event OnItemAdded(Form item, int count, ObjectReference ref, ObjectReference src)
    main.handle_added_item(item, count, ref, src)
EndEvent

Event OnItemRemoved(Form item, int count, ObjectReference ref, ObjectReference dst)
    main.handle_removed_item(item, count, ref, dst)
EndEvent

Event OnSit(ObjectReference obj)
	main.handle_using_furniture(obj)
EndEvent

Event OnGetUp(ObjectReference obj)
    main.handle_leaving_furniture(obj)
EndEvent

Event OnSpellCast(Form item)
	main.handle_spellcast(item)
EndEvent

Event OnObjectEquipped(Form item, ObjectReference ref)
	main.handle_equipped(item, ref)
EndEvent

Event OnObjectUnequipped(Form item, ObjectReference ref)
	main.handle_unequipped(item, ref)
EndEvent

Event OnPlayerLoadGame()
	main.handle_loadgame()
EndEvent