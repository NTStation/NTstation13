/obj/item/weapon/powerarmor/reactive
	name = "AdminBUS reactive armor plating"
	desc = "Made with the rare Badminium plates."
	icon_state = "armor_plates"
	origin_tech = "materials=8"
	var/list/togglearmor = list(melee = 250, bullet = 100, laser = 100,energy = 100, bomb = 100, bio = 100, rad = 100)
	//Good lord an active energy axe does 150 damage a swing? Anyway, barring var editing, this armor loadout should be impervious to anything. Enjoy, badmins~ --NEO

/obj/item/weapon/powerarmor/reactive/toggle(sudden = 0)
	switch(parent.active)
		if(1)
			if(!sudden)
				usr << "\blue Reactive armor systems disengaged."
		if(0)
			usr << "\blue Reactive armor systems engaged."
	var/list/switchover = list()
	for (var/armorvar in parent.armor)
		if(armorvar == "bio")
			continue

		switchover[armorvar] = togglearmor[armorvar]
		togglearmor[armorvar] = parent.armor[armorvar]
		parent.armor[armorvar] = switchover[armorvar]
		//Probably not the most elegant way to have the vars switch over, but it works. Also propagates the values to the other objects.
		if(parent.helm)
			parent.helm.armor[armorvar] = parent.armor[armorvar]
		if(parent.gloves)
			parent.gloves.armor[armorvar] = parent.armor[armorvar]
		if(parent.shoes)
			parent.shoes.armor[armorvar] = parent.armor[armorvar]


/obj/item/weapon/powerarmor/reactive/proc/add_armor(var/list/add)
	for(var/i in add)
		togglearmor[i] += add[i]

/obj/item/weapon/powerarmor/reactive/centcomm
	name = "reactive armor plating"
	desc = "Pretty effective against everything, not perfect though."
	origin_tech = "materials=6"
	togglearmor = list(melee = 90, bullet = 70, laser = 60, energy = 80, bomb = 75, bio = 50, rad = 75)
	slowdown = 2

/obj/item/weapon/powerarmor/reactive/standard
	name = "standard armor plating"
	desc = "A set of standard radiation shielded armor plating."
	origin_tech = "materials=3"
	togglearmor = list(melee = 15, bullet = 10, laser = 15, energy = 10, bomb = 15, bio = 50, rad = 60)
	slowdown = 2

	var/list/upgrades = list("diamond" = 0, "goliath" = 0, "plasteel" = 0,
							"xenochitin" = 0, "welder" = 0, "screwdriver" = 0)

/obj/item/weapon/powerarmor/reactive/standard/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/asteroid/goliath_hide) && upgrades["goliath"] < 4)
		upgrades["goliath"]++
		add_armor(list(melee = 10, bullet = 4, laser = 2, bomb = 5, rad = 8))
		user << "<span class='info'>You strengthen [src], improving its resistance against radiation and melee attacks.</span>"
		user.unEquip(W)
		del(W)

	else if(istype(W, /obj/item/weapon/screwdriver) && !upgrades["screwdriver"])
		upgrades["screwdriver"]++
		slowdown--
		user << "<span class='info'>You refit some joints on [src], making it easier to use.</span>"

	else if(istype(W, /obj/item/weapon/weldingtool) && upgrades["welder"] < 4)
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(1, user))
			upgrades["welder"]++
			add_armor(list(melee = 1, bullet = 1, laser = 1, energy = 1, bomb = 1))
			user << "<span class='info'>You strengthen [src]'s weak points.</span>"

	else if(istype(W, /obj/item/stack))
		var/obj/item/stack/S = W

		if(istype(S, /obj/item/stack/sheet/plasteel) && upgrades["plasteel"] < 4)
			upgrades["plasteel"]++
			add_armor(list(melee = 4, bullet = 8, energy = 2, bomb = 8, rad = 2))
			user << "<span class='info'>You strengthen [src], improving its resistance against bullets and bombs.</span>"
			S.use(1)

		else if(istype(S, /obj/item/stack/sheet/xenochitin) && upgrades["xenochitin"] < 4)
			upgrades["xenochitin"]++
			add_armor(list(melee = 2, energy = 10))
			user << "<span class='info'>You strengthen [src], improving its resistance against energy attacks.</span>"
			S.use(1)

		else if(istype(S, /obj/item/stack/sheet/mineral/diamond) && upgrades["diamond"] < 4)
			upgrades["diamond"]++
			add_armor(list(melee = 1, bullet = 2, laser = 10, energy = 4))
			user << "<span class='info'>You strengthen [src], improving its resistance against lasers.</span>"
			S.use(1)