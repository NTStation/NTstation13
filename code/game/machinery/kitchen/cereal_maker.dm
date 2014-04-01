/obj/machinery/cerealmaker
	name = "cereal maker"
	icon = 'icons/obj/cooking_machines.dmi'
	desc = "Now with Dann O's available!"
	icon_state = "cereal_off"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	var/on = 0 // Is it making cereal already?

/obj/machinery/cerealmaker/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(on)
		user << "<span class='warning'>The machine is already processing, please wait."
		return
	if(istype(O, /obj/item/weapon/grab)||istype(O, /obj/item/tk_grab))
		user << "<span class='warning'>That isn't going to fit.</span>"
		return
	if(istype(O, /obj/item/weapon/reagent_containers/glass/))
		user << "That would probably break the deep fryer."
		return
	if(!user.unEquip(O))
		user << "<span class='warning'>You cannot make cereal out of [O]."
		return
	else
		user << "<span class='warning'>You put [O] into [src]."
		on = 1
		user.drop_item()
		O.loc = src
		icon_state = "cereal_on"
		sleep(200)
		icon_state = "cereal_off"
		var/obj/item/weapon/reagent_containers/food/snacks/cereal/S = new(get_turf(src))
		var/image/I = new(O.icon, O.icon_state)
		I.transform *= 0.7
		if(istype(O, /obj/item/weapon/reagent_containers/))
			var/obj/item/weapon/reagent_containers/food = O
			food.reagents.trans_to(S, food.reagents.total_volume)
		S.overlays += I
		S.name = "box of [O] cereal"
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
		on = 0
		qdel(O)
		return

