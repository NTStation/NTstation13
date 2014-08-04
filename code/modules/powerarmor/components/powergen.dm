/obj/item/weapon/powerarmor/power
	name = "Badminium power generator"
	desc = "A generator for power armor. Runs on the rare Badminium molecule."
	origin_tech = "powerstorage=6;engineering=4;materials=8"
	var/powergen = 100
	var/on = 1

/obj/item/weapon/powerarmor/power/is_subsystem()
	return "powergen"

/obj/item/weapon/powerarmor/power/New()
	..()
	button = new(null, src, "Toggle")

/obj/item/weapon/powerarmor/power/stat_button(var/name)
	if(name == "Toggle")
		on = !on

/obj/item/weapon/powerarmor/power/process()
	if(parent.powercell && parent.powercell.charge < parent.powercell.maxcharge)
		return parent.powercell.give(powergen)
	else
		return powergen



// Plasma Generator
/obj/item/weapon/powerarmor/power/plasma
	name = "miniaturized plasma generator"
	desc = "A generator for power armor. Runs on plasma."
	slowdown = 1
	origin_tech = "plasmatech=2;powerstorage=2;engineering=2"

	var/fuel = 0
	var/maxfuel = 75
	powergen = 30

/obj/item/weapon/powerarmor/power/plasma/Stat()
	..()
	if(!istype(parent))	return
	statpanel("Power Armor", "Plasma Generator:", "")
	statpanel("Power Armor", "Fuel:", fuel)
	statpanel("Power Armor", on ? "\[ON\]" :"\[OFF\]", button)

/obj/item/weapon/powerarmor/power/plasma/process()
	if(!on) return

	if(fuel <= 0)
		on = 0
		return

	if(..() == powergen)
		return

	fuel--
	if(!prob(reliability))
		fuel--

/obj/item/weapon/powerarmor/power/plasma/load(var/item, var/mob/user)
	if(istype(item, /obj/item/stack/sheet/mineral/plasma))
		var/obj/item/stack/S = item
		if(fuel < maxfuel)
			user << "\blue You feed some plasma into the armor's generator."
			fuel += 25
			S.use(1)
		else
			user << "\red The generator already has plenty of plasma."
			return 1

	if(istype(item, /obj/item/weapon/ore/plasma))
		if(fuel < maxfuel)
			user << "\blue You feed plasma ore into the armor's generator."
			fuel += 15
			//raw plasma has impurities, so it doesn't provide as much fuel. --NEO
			del(item)
		else
			user << "\red The generator already has plenty of plasma."
			return 1
	return 0


// Nuclear Generator
/obj/item/weapon/powerarmor/power/nuclear
	name = "miniaturized nuclear generator"
	desc = "A generator for power armor. For all your radioactive needs!"
	origin_tech = "powerstorage=3;engineering=3;materials=3"
	slowdown = 1.5
	powergen = 20

/obj/item/weapon/powerarmor/power/nuclear/Stat()
	..()
	if(!istype(parent))	return
	statpanel("Power Armor", "Nuclear Generator:", "")
	if(crit_fail)
		statpanel("Power Armor", "\[CRITICAL FAILURE\]", "")
		return
	statpanel("Power Armor", on ? "\[ON\]" : "\[OFF\]", button)

/obj/item/weapon/powerarmor/power/nuclear/process()
	if(crit_fail)			return
	if(!on)					return
	if(..() == powergen)	return

	if(!prob(reliability))
		if(prob(reliability)) //Only a minor failure, enjoy your radiation.
			for (var/mob/living/M in range(0,src.parent))
				if (src.parent in M.contents)
					M << "\red Your armor feels pleasantly warm for a moment."
					M.radiation += rand(1,20)
				else
					M << "\red You feel a warm sensation."
				M.apply_effect(rand(1,15),IRRADIATE,0)
			if(!prob(reliability))
				reliability -= 5
		else //Big failure, TIME FOR RADIATION BITCHES
			for (var/mob/living/M in range(2,src.parent))
				if (src.parent in M.contents)
					M << "\red Your armor's reactor overloads!"
					M.radiation += 60
				M << "\red You feel a wave of heat wash over you."
				M.apply_effect(40,IRRADIATE,0)
			crit_fail = 1 //broken~