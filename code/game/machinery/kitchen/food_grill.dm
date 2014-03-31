/obj/machinery/foodgrill
	name = "Grill"
	icon = 'icons/obj/cooking_machines.dmi'
	desc = "Backyard grilling, IN SPACE."
	icon_state = "grill_off"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	var/on = 0 // Is it grilling food already?

/obj/machinery/foodgrill/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(on)
		user << "<span class='warning'>The machine is already processing, please wait."
		return
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/deepfryholder))
		user << "<span class='warning'>Universe wide cooking regulations say to not even think about grilling deep fried foods."
		return
	if(!user.unEquip(O))
		user << "<span class='warning'>You cannot grill [O]."
		return
	else
		user << "You put [O] onto [src]."
		on = 1
		user.drop_item()
		O.loc = src
		icon_state = "grill_on"
		var/image/I = new(O.icon, O.icon_state)
		I.pixel_y = 5
		overlays += I
		sleep(200)
		overlays.Cut()
		I.color = "#C28566"
		I.pixel_y = 5
		overlays += I
		sleep(200)
		overlays.Cut()
		I.color = "#A34719"
		I.pixel_y = 5
		overlays += I
		sleep(50)
		overlays.Cut()
		on = 0
		icon_state = "grill_off"
		if(istype(O, /obj/item/weapon/reagent_containers/))
			var/obj/item/weapon/reagent_containers/food = O
			food.reagents.add_reagent("nutriment", 10)
			food.reagents.trans_to(O, food.reagents.total_volume)
		O.loc = get_turf(src)
		O.color = "#A34719"
		var/tempname = O.name
		O.name = "grilled [tempname]"
		return