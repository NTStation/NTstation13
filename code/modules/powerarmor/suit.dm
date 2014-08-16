/obj/item/clothing/suit/powered
	name = "powered armor"
	desc = "Not for rookies."
	icon_state = "riot"
	item_state = "swat"
	w_class = 4//bulky item

	heat_protection = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS
	armor = list(melee = 40, bullet = 30, laser = 20,energy = 15, bomb = 25, bio = 10, rad = 10)
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/gun, /obj/item/weapon/handcuffs, /obj/item/weapon/tank)
	slowdown = 6

	var/list/togglearmor = list(melee = 90, bullet = 70, laser = 60,energy = 40, bomb = 75, bio = 75, rad = 75)
	var/active = 0

	var/helmrequired = 0
	var/obj/item/clothing/head/powered/helm
	var/obj/item/clothing/gloves/powered/gloves
	var/shoesrequired = 1
	var/obj/item/clothing/shoes/powered/shoes

	var/obj/effect/proc_holder/stat_button/button

	var/list/subsystems = list()

	var/obj/item/weapon/powerarmor/reactive/reactive
	var/obj/item/weapon/powerarmor/atmoseal/atmoseal

	var/obj/item/weapon/powerarmor/weapon/melee/melee
	var/obj/item/weapon/powerarmor/weapon/ranged/ranged_l
	var/obj/item/weapon/powerarmor/weapon/ranged/ranged_r

	var/obj/item/weapon/stock_parts/cell/powercell

/obj/item/clothing/suit/powered/New()
	button = new(null, src, "Toggle armor")
	powercell = new /obj/item/weapon/stock_parts/cell/high(src)

/obj/item/clothing/suit/powered/proc/get_power()
	if(!powercell)		return 0
	return powercell.charge

/obj/item/clothing/suit/powered/proc/use_power(var/amount)
	if(!get_power())
		powerdown(1)
	. = powercell.use(amount)
	return .

/obj/item/clothing/suit/powered/on_mob_move()
	if(active)
		for(var/obj/item/weapon/powerarmor/S in src)
			S.on_mob_move()

/obj/item/clothing/suit/powered/process()
	if(!active)
		processing_objects.Remove(src)
		return
	for(var/obj/item/weapon/powerarmor/I in src)
		I.process()

	if(helm)		helm.process()

/obj/item/clothing/suit/powered/proc/poweron()
	var/mob/living/carbon/human/user = usr

	if(user.wear_suit != src)	return
	if(active)					return

	if(!get_power())
		user << "\red Power source missing or depleted."
		return

	powerup()

/obj/item/clothing/suit/powered/proc/powerup() // separated for powerarmor-wearing corpses
	var/mob/living/carbon/human/user = src.loc
	if(helmrequired && !istype(user.head, /obj/item/clothing/head/powered))
		user << "\red Helmet missing, unable to initiate power-on procedure."
		return

	if(!istype(user.gloves, /obj/item/clothing/gloves/powered))
		user << "\red Gloves missing, unable to initiate power-on procedure."
		return

	if(shoesrequired && !istype(user.shoes, /obj/item/clothing/shoes/powered))
		user << "\red Shoes missing, unable to initiate power-on procedure."
		return

	verbs -= /obj/item/clothing/suit/powered/proc/poweron
	user << "\blue Suit interlocks engaged."
	if(helmrequired)
		helm = user.head
		helm.flags |= NODROP
	gloves = user.gloves
	gloves.flags |= NODROP
	if(shoesrequired)
		shoes = user.shoes
		shoes.flags |= NODROP
	flags |= NODROP
	sleep(40)

	if(atmoseal)
		atmoseal.toggle()
		sleep(40)

	if(reactive)
		reactive.toggle()
		sleep(40)

	if(subsystems.len)
		user << "\blue Engaging subsystems..."
		for(var/obj/item/weapon/powerarmor/I in subsystems)
			sleep(20)
			I.toggle()

	user << "\blue All systems online."
	active = 1
	processing_objects.Add(src)

/obj/item/clothing/suit/powered/proc/powerdown(sudden = 0)
	var/delay = sudden?0:40
	var/mob/living/carbon/human/user = usr
	if(!istype(user)) 			return
	if(user.wear_suit != src)	return
	if(!active)					return

	if(atmoseal)
		if(istype(atmoseal, /obj/item/weapon/powerarmor/atmoseal/optional) && helm)
			var/obj/item/weapon/powerarmor/atmoseal/optional/O = atmoseal
			O.helmtoggle(sudden)
		atmoseal.toggle(sudden)
		sleep(delay)

	if(subsystems.len)
		if(!sudden)
			user << "\blue Disengaging subsystems..."
		for(var/obj/item/weapon/powerarmor/I in subsystems)
			sleep(delay/2)
			I.toggle(sudden)

	if(helm && helm.on)
		helm.on = 0
		helm.update_icon()
		user.SetLuminosity(user.luminosity - helm.brightness_on)

	if(!sudden)
		usr << "\blue Suit interlocks disengaged."
		if(helm)
			helm.flags &= ~NODROP
			helm = null
		if(gloves)
			gloves.flags &= ~NODROP
			gloves = null
		if(shoes)
			shoes.flags &= ~NODROP
			gloves = null
		flags &= ~NODROP
		//Not a tabbing error, the thing only unlocks if you intentionally power-down the armor. --NEO
	sleep(delay)

	if(sudden)
		user.visible_message("<span class='warning'>[user]'s armor loses power!</span>",
		"<span class='warning'>Your armor loses power!</span>",
		"<span class='notice'>You hear a click!</span>")
	else
		user << "\blue All systems disengaged."

	active = 0

/obj/item/clothing/suit/powered/Stat()
	if(!(src in usr))	return
	if(!active)
		statpanel("Power Armor", button)
		return

	statpanel("Power Armor", "Control Panel", button)
	if(powercell)
		statpanel("Power Armor", "Power:", "[powercell.charge]/[powercell.maxcharge]")
	else
		statpanel("Power Armor", "Power:", "\[MISSING\]")
	statpanel("Power Armor", "", " ")

	if(helm)
		helm.Stat(1)

	var/i = ""
	for(var/obj/item/weapon/powerarmor/I in src)
		i += "  "
		I.Stat()

/obj/item/clothing/suit/powered/examine()
	..()
	if(powercell)
		usr << "It has a power cell in it."
	else
		usr << "It's power cell is missing!"
	if(ranged_r)
		usr << "It has [ranged_r] on it's right hand."
	if(ranged_l)
		usr << "It has [ranged_l] on it's left hand."


/obj/item/clothing/suit/powered/stat_button(var/name)
	if(name == "Toggle armor")
		if(active)
			powerdown()
		else
			poweron()

/obj/item/clothing/suit/powered/emp_act(severity)
	..()
	for(var/atom/A in src)
		A.emp_act(severity)

/obj/item/clothing/suit/powered/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(powercell)
		if(istype(W, /obj/item/weapon/screwdriver))
			user.visible_message("<span class='warning'>[user] removes [src]'s power cell!</span>",
			"<span class='warning'>You remove [src]'s power cell!</span>",
			"<span class='notice'>You hear a click!</span>")
			powercell.loc = get_turf(src)
			powercell = null
			return

	else if(istype(W, /obj/item/weapon/stock_parts/cell))
		user << "\blue You insert power cell into [src]."
		user.unEquip(W)
		powercell = W
		powercell.loc = src
		return

	else if(!active)
		if(istype(W, /obj/item/weapon/crowbar))
			if(subsystems.len)
				for(var/obj/item/weapon/powerarmor/I in subsystems)
					I.drop()
				user.visible_message("<span class='warning'>[user] removes [src]'s subsystems!</span>",
				"<span class='warning'>You remove [src]'s subsystems!</span>",
				"<span class='notice'>You hear a click!</span>")

			else if(melee)
				user.visible_message("<span class='warning'>[user] removes [melee] from [src]!</span>",
				"<span class='warning'>You remove [melee] from [src]!</span>",
				"<span class='notice'>You hear a click!</span>")
				melee.drop()

			else if(ranged_l)
				user.visible_message("<span class='warning'>[user] removes [ranged_l] from [src]!</span>",
				"<span class='warning'>You remove [ranged_l] from [src]!</span>",
				"<span class='notice'>You hear a click!</span>")
				ranged_l.drop()

			else if(ranged_r)
				user.visible_message("<span class='warning'>[user] removes [ranged_r] from [src]!</span>",
				"<span class='warning'>You remove [ranged_r] from [src]!</span>",
				"<span class='notice'>You hear a click!</span>")
				ranged_r.drop()

			else if(reactive)
				user.visible_message("<span class='warning'>[user] removes [src]'s armor plating!</span>",
				"<span class='warning'>You remove [src]'s armor plating!</span>",
				"<span class='notice'>You hear a crunch!</span>")
				reactive.drop()

			return

		if(istype(W, /obj/item/weapon/powerarmor))
			var/obj/item/weapon/powerarmor/C = W
			var/installed = 0
			if(C.is_subsystem())
				for(var/obj/item/weapon/powerarmor/A in subsystems)
					if(C.is_subsystem() == A.is_subsystem())
						return
				if(C.shoesrequired && !shoesrequired)
					return
				if(C.helmrequired && !helmrequired)
					return
				subsystems.Add(C)
				installed = 1

			else if(istype(C, /obj/item/weapon/powerarmor/weapon/melee) && !melee)
				melee = C
				installed = 1

			else if(istype(C, /obj/item/weapon/powerarmor/weapon/ranged) && !ranged_r)
				ranged_r = C
				installed = 1

			else if(istype(C, /obj/item/weapon/powerarmor/weapon/ranged) && !ranged_l)
				ranged_l = C
				installed = 1

			else if(istype(C, /obj/item/weapon/powerarmor/reactive) && !reactive)
				reactive = C
				installed = 1

			if(installed)
				C.add_to(src)
				user.visible_message("<span class='notice'>[user] attaches [C] to [src].</span>",
				"<span class='notice'>You attach [C] to [src].</span>",
				"<span class='notice'>You hear a click!</span>")

	for(var/obj/item/weapon/powerarmor/S in subsystems)
		if(S.load(W, user))
			return

	if(istype(ranged_l) && ranged_l.load(W, user))
		return

	if(istype(ranged_r) && ranged_r.load(W, user))
		return
	..()
