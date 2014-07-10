/obj/item/weapon/powerarmor
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = "tesla"
	name = "power armor component"
	desc = "This is the base object, you should never see one."
	slowdown = 0 //how much the component slows down the wearer

	var/obj/item/clothing/suit/powered/parent //so the component knows which armor it belongs to.
	var/obj/effect/proc_holder/stat_button/button // for control panel
	var/shoesrequired = 0
	var/helmrequired = 0

/obj/item/weapon/powerarmor/proc/toggle()
	return
	//The child objects will use this proc

/obj/item/weapon/powerarmor/proc/is_subsystem()
	return 0

/obj/item/weapon/powerarmor/proc/add_to(var/obj/item/clothing/suit/powered/S)
	if(!istype(S))
		return

	if(loc != S)
		if(ismob(src.loc))
			var/mob/M = src.loc
			M.unEquip(src)

	src.loc = S
	src.parent = S

	if(slowdown)
		parent.slowdown += slowdown

/obj/item/weapon/powerarmor/proc/drop()
	if(!istype(loc, /obj/item/clothing/suit/powered))
		return
	src.loc = get_turf(src)

	if(slowdown)
		parent.slowdown -= slowdown

	if(src == parent.reactive)
		parent.reactive = null

	else if(src == parent.atmoseal)
		parent.atmoseal = null

	else if(src == parent.meele)
		parent.meele = null

	else if(src == parent.ranged_l)
		parent.ranged_l = null

	else if(src == parent.ranged_r)
		parent.ranged_r = null

	else if(src in parent.subsystems)
		parent.subsystems.Remove(src)

	src.parent = null

/obj/item/weapon/powerarmor/proc/load()
	return 0

/obj/item/weapon/powerarmor/proc/user_click(var/atom/A, var/proximity, var/mob/living/carbon/human/user, var/intent)
	return 0