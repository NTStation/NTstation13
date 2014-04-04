/obj/machinery/deepfryer
	name = "deep fryer"
	desc = "Deep fried <i>everything</i>."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "fryer_off"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	var/on = FALSE	//Is it deep frying already?

/obj/machinery/deepfryer/attackby(obj/item/I, mob/user)
	if(on)
		user << "<span class='notice'>[src] is already active, please wait.</span>"
		return
	if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/deepfryholder))
		user << "<span class='userdanger'>[I] is already deepfried, you vomituous deviant. This attempt has been recorded.</span>"
		return
	if(istype(I, /obj/item/weapon/grab) || istype(I, /obj/item/tk_grab))
		user << "<span class='warning'>That isn't going to fit.</span>"
		return
	if(istype(I, /obj/item/weapon/reagent_containers/glass/))
		user << "<span class='warning'>That would probably break [src].</span>"
		return
	if(!user.unEquip(I))
		user << "<span class='warning'>You cannot deepfry [I].</span>"
		return
	else
		user << "<span class='notice'>You put [I] into [src].</span>"
		on = TRUE
		user.drop_item()
		I.loc = src
		icon_state = "fryer_on"
		sleep(200)
		icon_state = "fryer_off"
		on = FALSE
		var/obj/item/weapon/reagent_containers/food/snacks/deepfryholder/S = new(get_turf(src))
		if(istype(I, /obj/item/weapon/reagent_containers/))
			var/obj/item/weapon/reagent_containers/food = I
			food.reagents.trans_to(S, food.reagents.total_volume)
		S.color = "#FFAD33"
		S.icon = I.icon
		S.icon_state = I.icon_state
		S.name = "deep fried [I.name]"
		S.desc = I.desc
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
		qdel(I)