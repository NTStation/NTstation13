/obj/machinery/oven
	name = "oven"
	desc = "Cookies are ready, dear."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "oven_off"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	var/on = FALSE	//Is it making food already?
	var/list/food_choices = list()
/obj/machinery/oven/New()
	..()
	for(var/U in typesof(/obj/item/weapon/reagent_containers/food/snacks/customizable/cook)-(/obj/item/weapon/reagent_containers/food/snacks/customizable/cook))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/cook/V = new U
		src.food_choices += V
	return
/obj/machinery/oven/attackby(obj/item/I, mob/user)
	if(on)
		user << "The machine is already running."
		return
	if(!istype(I,/obj/item/weapon/reagent_containers/food/snacks/))
		user << "That isn't food."
		return
	else
		var/obj/item/weapon/reagent_containers/food/snacks/F = I
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/C
		C = input("Select food to make.", "Cooking", C) in food_choices
		if(!C)
			return
		else
			user << "You put [F] into [src] for cooking."
			user.drop_item()
			F.loc = src
			on = TRUE
			icon_state = "oven_on"
			sleep(200)
			on = FALSE
			icon_state = "oven_off"
			var/obj/item/weapon/reagent_containers/food/snacks/customizable/V = new C
			V.loc = get_turf(src)
			V.attackby(F,user)
			playsound(loc, 'sound/machines/ding.ogg', 50, 1)
			return
