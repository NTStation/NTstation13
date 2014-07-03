/obj/item/weapon/powerarmor/servos
	name = "movement assist servos"
	desc = ""
	icon = 'icons/obj/module.dmi'
	icon_state = "servo"
	var/toggleslowdown = 7
	var/powerusage = 6

	toggle(sudden = 0)
		switch(parent.active)
			if(1)
				if(!sudden)
					usr << "\blue Movement assist servos disengaged."
				parent.slowdown += toggleslowdown
			if(0)
				usr << "\blue Movement assist servos engaged."
				parent.slowdown -= toggleslowdown

	is_subsystem()
		return 1

	proc/onmove()
		parent.use_power(powerusage)


/obj/item/weapon/powerarmor/medinj
	name = "medical injector"
	desc = ""
	icon = 'icons/obj/module.dmi'
	icon_state = "injector"
	var/charges = 10
	var/max_charges = 10

	toggle(sudden = 0)
		switch(parent.active)
			if(1)
				if(!sudden)
					usr << "\blue Medical injector disengaged."
			if(0)
				usr << "\blue Medical injector engaged."

	is_subsystem()
		return 1

	Stat()
		..()
		if(!istype(parent))	return
		statpanel("Power Armor", "Medical Injector:", "")
		statpanel("Power Armor", "\[[charges]/[max_charges]\]", button)


	New()
		..()
		button = new(null, src, "Inject")

	proc/Inject()
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

	stat_button(var/name)
		if(name == "Inject")
			Inject()


/obj/item/weapon/powerarmor/autoext
	name = "automatic fire extinguisher"
	desc = ""
	icon_state = "suit_autoext"

	toggle(sudden = 0)
		switch(parent.active)
			if(1)
				if(!sudden)
					usr << "\blue Automatic fire extinguisher disengaged."
			if(0)
				usr << "\blue Automatic fire extinguisher engaged."

	is_subsystem()
		return 1

	process()
		..()
		if(ishuman(parent.loc))
			var/mob/living/carbon/human/H = parent.loc
			if(H.on_fire && parent.use_power(150))
				H << "\blue *fssszt*"
				H << "\blue Fire extinguished."
				H.ExtinguishMob()
				H.bodytemperature -= rand(25,30)