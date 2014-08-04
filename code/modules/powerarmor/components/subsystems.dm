/obj/item/weapon/powerarmor/servos
	name = "movement assist servos"
	desc = "A set of movement assist servos for a powersuit."
	icon = 'icons/obj/module.dmi'
	icon_state = "servo"
	var/toggleslowdown = 7
	var/powerusage = 5
	origin_tech = "materials=2;programming=2;engineering=2"

/obj/item/weapon/powerarmor/servos/toggle(sudden = 0)
	switch(parent.active)
		if(1)
			if(!sudden)
				usr << "\blue Movement assist servos disengaged."
			parent.slowdown += toggleslowdown
		if(0)
			usr << "\blue Movement assist servos engaged."
			parent.slowdown -= toggleslowdown

/obj/item/weapon/powerarmor/servos/is_subsystem()
	return "servo"

/obj/item/weapon/powerarmor/servos/on_mob_move()
	parent.use_power(powerusage)

/obj/item/weapon/powerarmor/servos/cheap
	name = "cheap servos"
	desc = "A set of cheap and weak servos for a powersuit."
	toggleslowdown = 5
	powerusage = 3
	origin_tech = "materials=1;programming=1;engineering=2"



/obj/item/weapon/powerarmor/medinj
	name = "medical injector"
	desc = ""
	icon = 'icons/obj/module.dmi'
	icon_state = "injector"
	origin_tech = "materials=1;engineering=1;biotech=3"

	var/charges = 10
	var/max_charges = 10


/obj/item/weapon/powerarmor/medinj/toggle(sudden = 0)
	switch(parent.active)
		if(1)
			if(!sudden)
				usr << "\blue Medical injector disengaged."
		if(0)
			usr << "\blue Medical injector engaged."

/obj/item/weapon/powerarmor/medinj/is_subsystem()
	return "medinj"

/obj/item/weapon/powerarmor/medinj/Stat()
	..()
	if(!istype(parent))	return
	statpanel("Power Armor", "Medical injector:", "")
	statpanel("Power Armor", "\[[charges]/[max_charges]\]", button)

/obj/item/weapon/powerarmor/medinj/New()
	..()
	button = new(null, src, "Inject")

/obj/item/weapon/powerarmor/medinj/proc/Inject()
	if(!charges)
		return
	if(!parent.use_power(10))
		return

	for(var/mob/living/carbon/human/M in range(0, parent))
		if(M.wear_suit == parent)
			M << "\blue Medicals injected."
			M.reagents.add_reagent("doctorsdelight", 5)
			M.reagents.add_reagent("synaptizine", 5)
			M.reagents.add_reagent("anti_toxin", 5)
			M.reagents.add_reagent("tricordrazine", 10)
			charges--

/obj/item/weapon/powerarmor/medinj/stat_button(var/name)
	if(name == "Inject")
		Inject()



/obj/item/weapon/powerarmor/autoext
	name = "automatic fire extinguisher"
	desc = ""
	origin_tech = "materials=2;engineering=2"
	icon_state = "suit_autoext"


/obj/item/weapon/powerarmor/autoext/toggle(sudden = 0)
	switch(parent.active)
		if(1)
			if(!sudden)
				usr << "\blue Automatic fire extinguisher disengaged."
		if(0)
			usr << "\blue Automatic fire extinguisher engaged."

/obj/item/weapon/powerarmor/autoext/is_subsystem()
	return "autoext"

/obj/item/weapon/powerarmor/autoext/process()
	..()
	if(ishuman(parent.loc))
		var/mob/living/carbon/human/H = parent.loc
		if(H.on_fire && parent.use_power(150))
			H << "\blue *fssszt*"
			H << "\blue Fire extinguished."
			H.ExtinguishMob()
			H.bodytemperature -= rand(25,30)



/obj/item/weapon/powerarmor/grip/is_subsystem()
	return "grip"

/obj/item/weapon/powerarmor/grip/magnetic
	name = "magnetic grip modules"
	desc = "A pair of magnetic grip modules for keeping the user safely attached to the vehicle during extravehicular activity."
	icon_state = "magneticgrip"
	var/toggleslowdown = 1
	var/powerusage = 1
	var/active = 0

/obj/item/weapon/powerarmor/grip/magnetic/toggle(sudden = 0)
	switch(parent.active)
		if(1)
			if(active)
				toggle_grip(sudden)
			if(!sudden)
				usr << "\blue Magnetic grip modules disengaged."
		if(0)
			usr << "\blue Magnetic grip modules engaged."

/obj/item/weapon/powerarmor/grip/magnetic/on_mob_move()
	if(active)
		parent.use_power(powerusage)

/obj/item/weapon/powerarmor/grip/magnetic/proc/toggle_grip(sudden = 0)
	var/mob/living/carbon/human/user = usr

	if(active)
		if(!sudden)
			user << "\blue Magnetic grip modules deactivated."
		parent.slowdown -= toggleslowdown
		parent.shoes.flags &= ~NOSLIP
	else
		user << "\blue Magnetic grip modules activated."
		parent.slowdown += toggleslowdown
		parent.shoes.flags |= NOSLIP

	user.update_gravity(user.mob_has_gravity())

	active = !active

/obj/item/weapon/powerarmor/grip/magnetic/stat_button(var/name)
	if(name == "Toggle")
		toggle_grip()

/obj/item/weapon/powerarmor/grip/magnetic/Stat()
	..()
	if(!istype(parent))	return
	statpanel("Power Armor", "Magnetic grip:", "")
	statpanel("Power Armor", active ? "\[ON\]" : "\[OFF\]", button)

/obj/item/weapon/powerarmor/grip/magnetic/New()
	..()
	button = new(null, src, "Toggle")



/obj/item/weapon/powerarmor/orecollector
	name = "ore collector module"
	desc = "A module for collecting and storing loose ore."
	icon_state = "orecollector"
	var/max_ore = 120

/obj/item/weapon/powerarmor/orecollector/is_subsystem()
	return "storage"

/obj/item/weapon/powerarmor/orecollector/New()
	..()
	button = new(null, src, "Release")

/obj/item/weapon/powerarmor/orecollector/stat_button(var/name)
	if(name == "Release")
		drop_ore()

/obj/item/weapon/powerarmor/orecollector/proc/drop_ore()
	for(var/obj/item/I in contents)
		I.loc = get_turf(src)

/obj/item/weapon/powerarmor/orecollector/toggle(sudden = 0)
	switch(parent.active)
		if(1)
			if(!sudden)
				usr << "\blue Ore collector module disengaged."
		if(0)
			usr << "\blue Ore collector module engaged."

/obj/item/weapon/powerarmor/orecollector/Stat()
	..()
	if(!istype(parent))	return
	statpanel("Power Armor", "Ore collector:", "")
	statpanel("Power Armor", contents.len ? "\[[contents.len]/[max_ore]\]" : "\[EMPTY\]", button)


/obj/item/weapon/powerarmor/orecollector/user_click(var/atom/A, var/proximity, var/mob/living/carbon/human/user, var/intent)
	if(proximity && contents.len && istype(A, /obj/structure/ore_box))
		var/obj/structure/ore_box/box = A
		for(var/obj/item/weapon/ore/O in contents)
			O.loc = box
		user << "\blue You empty the ore collector into the box."
		return 1

/obj/item/weapon/powerarmor/orecollector/on_mob_move()
	if(contents.len < max_ore)
		for(var/obj/item/weapon/ore/O in get_turf(src))
			O.loc = src
			if(contents.len >= max_ore)
				break