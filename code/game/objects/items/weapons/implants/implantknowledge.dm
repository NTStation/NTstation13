
/obj/item/weapon/implant/wire_knowledge/implanted(mob/M)
	if(!M.mind)
		return 0
	M.mind.store_memory("If you're reading this, Blame the nearest online Admin")
	return 1

/obj/item/weapon/implant/wire_knowledge/door/implanted(mob/M)
	if(!M.mind)
		return 0
	M.mind.store_memory(all_solved_wires[/obj/machinery/door/airlock])
	return 1

/obj/item/weapon/implant/wire_knowledge
	name = "Wire Knowledge: Blank"
	desc = "This doesn't do ANYTHING"


/obj/item/weapon/implant/wire_knowledge/door
	name = "Wire Knowledge: Doors"
	desc = "Grants you knowledge of the NT Door and Airlock wiring systems"
