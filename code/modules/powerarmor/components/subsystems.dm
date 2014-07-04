/obj/item/weapon/powerarmor/servos
	name = "movement assist servos"
	desc = "A set of movement assist servos for a powersuit."
	icon = 'icons/obj/module.dmi'
	icon_state = "servo"
	var/toggleslowdown = 7
	var/powerusage = 6

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

/obj/item/weapon/powerarmor/servos/proc/onmove()
	parent.use_power(powerusage)

/obj/item/weapon/powerarmor/servos/cheap
	name = "cheap servos"
	desc = "A set of cheap and weak servos for a powersuit."
	toggleslowdown = 5
	powerusage = 4



/obj/item/weapon/powerarmor/medinj
	name = "medical injector"
	desc = ""
	icon = 'icons/obj/module.dmi'
	icon_state = "injector"
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
	statpanel("Power Armor", "Medical Injector:", "")
	statpanel("Power Armor", "\[[charges]/[max_charges]\]", button)

/obj/item/weapon/powerarmor/medinj/New()
	..()
	button = new(null, src, "Inject")

/obj/item/weapon/powerarmor/medinj/proc/Inject()
	if(!charges)
		return
	if(!parent.use_power(2))
		return

	for(var/mob/living/carbon/human/M in range(0, parent))
		if(M.wear_suit == parent)
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