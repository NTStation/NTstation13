/obj/item/weapon/powerarmor/reactive
	name = "AdminBUS power armor reactive plating"
	desc = "Made with the rare Badminium molecule."
	var/list/togglearmor = list(melee = 250, bullet = 100, laser = 100,energy = 100, bomb = 100, bio = 100, rad = 100)
	//Good lord an active energy axe does 150 damage a swing? Anyway, barring var editing, this armor loadout should be impervious to anything. Enjoy, badmins~ --NEO

	toggle(sudden = 0)
		switch(parent.active)
			if(1)
				if(!sudden)
					usr << "\blue Reactive armor systems disengaged."
			if(0)
				usr << "\blue Reactive armor systems engaged."
		var/list/switchover = list()
		for (var/armorvar in parent.armor)
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

	centcomm
		name = "power armor reactive plating"
		desc = "Pretty effective against everything, not perfect though."
		togglearmor = list(melee = 90, bullet = 70, laser = 60,energy = 80, bomb = 75, bio = 75, rad = 75)
		slowdown = 2