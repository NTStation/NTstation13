/obj/item/weapon/powerarmor/atmoseal
	name = "atmospheric seals"
	desc = "Keeps the bad stuff out."
	slowdown = 0
	origin_tech = "materials=4;engineering=2"

	var/sealed = 0

	var/suit_max = FIRE_SUIT_MAX_TEMP_PROTECT
	var/suit_min = SPACE_SUIT_MIN_TEMP_PROTECT

	var/helmet_max = FIRE_HELM_MAX_TEMP_PROTECT
	var/helmet_min = SPACE_HELM_MIN_TEMP_PROTECT

	var/boots_max = SHOES_MAX_TEMP_PROTECT
	var/boots_min = SHOES_MIN_TEMP_PROTECT

/obj/item/weapon/powerarmor/atmoseal/toggle(sudden = 0)
	switch(parent.active)
		if(1)
			if(!sudden)
				usr << "\blue Atmospheric seals disengaged."
			parent.gas_transfer_coefficient = 1
			parent.permeability_coefficient = 1
			parent.flags &= ~STOPSPRESSUREDMAGE
			parent.max_heat_protection_temperature = null
			parent.min_cold_protection_temperature = null
			if(parent.helmrequired && parent.helm)
				parent.helm.gas_transfer_coefficient = 1
				parent.helm.permeability_coefficient = 1
				parent.helm.max_heat_protection_temperature = null
				parent.helm.min_cold_protection_temperature = null
				parent.helm.flags &= ~STOPSPRESSUREDMAGE
				parent.helm.parent = null
			parent.gloves.gas_transfer_coefficient = 1
			parent.gloves.permeability_coefficient = 1
			if(parent.shoesrequired)
				parent.shoes.gas_transfer_coefficient = 1
				parent.shoes.permeability_coefficient = 1
				parent.shoes.max_heat_protection_temperature = null
				parent.shoes.min_cold_protection_temperature = null
			sealed = 0

			parent.armor["bio"] = initial(parent.armor["bio"])
			if(parent.helm)
				parent.helm.armor["bio"] = initial(parent.helm.armor["bio"])
			if(parent.gloves)
				parent.gloves.armor["bio"] = initial(parent.gloves.armor["bio"])
			if(parent.shoes)
				parent.shoes.armor["bio"] = initial(parent.shoes.armor["bio"])

		if(0)
			usr << "\blue Atmospheric seals engaged."
			parent.gas_transfer_coefficient = 0.01
			parent.permeability_coefficient = 0.02
			parent.flags |= STOPSPRESSUREDMAGE
			parent.max_heat_protection_temperature = suit_max
			parent.min_cold_protection_temperature = suit_min
			if(parent.helmrequired && parent.helm)
				parent.helm.gas_transfer_coefficient = 0.01
				parent.helm.permeability_coefficient = 0.02
				parent.helm.max_heat_protection_temperature = helmet_max
				parent.helm.min_cold_protection_temperature = helmet_min
				parent.helm.flags |= STOPSPRESSUREDMAGE
				parent.helm.parent = parent
			parent.gloves.gas_transfer_coefficient = 0.01
			parent.gloves.permeability_coefficient = 0.02
			if(parent.shoesrequired && parent.shoes)
				parent.shoes.gas_transfer_coefficient = 0.01
				parent.shoes.permeability_coefficient = 0.02
				parent.shoes.max_heat_protection_temperature = boots_max
				parent.shoes.min_cold_protection_temperature = boots_min
			sealed = 1

			parent.armor["bio"] = 100
			if(parent.helm)
				parent.helm.armor["bio"] = 100
			if(parent.gloves)
				parent.gloves.armor["bio"] = 100
			if(parent.shoes)
				parent.shoes.armor["bio"] = 100


/obj/item/weapon/powerarmor/atmoseal/standard // Spaceproof, but not fireproof
	name = "atmospheric seals"
	desc = "Keeps the vacuum out."
	origin_tech = "materials=2;engineering=2"

	suit_max = SPACE_SUIT_MAX_TEMP_PROTECT
	helmet_max = SPACE_HELM_MAX_TEMP_PROTECT



/obj/item/weapon/powerarmor/atmoseal/optional
	name = "togglable atmospheric seals"
	desc = "Keeps the bad stuff out, but lets you remove your helmet without having to turn the whole suit off."
	origin_tech = "materials=4;engineering=3"

/obj/item/weapon/powerarmor/atmoseal/optional/New()
	..()
	button = new(null, src, "Toggle")

/obj/item/weapon/powerarmor/atmoseal/optional/stat_button(var/name)
	if(name == "Toggle")
		helmtoggle(0, 1)

/obj/item/weapon/powerarmor/atmoseal/optional/Stat()
	..()
	if(!istype(parent))	return
	statpanel("Power Armor", "Helmet seals:", "")
	statpanel("Power Armor", parent.helm ? "\[ON\]" :"\[OFF\]", button)

/obj/item/weapon/powerarmor/atmoseal/optional/proc/helmtoggle(sudden = 0, manual = 0)
	var/mob/living/carbon/human/user = usr
	var/obj/item/clothing/head/powered/helm
	if(user.head && istype(user.head,/obj/item/clothing/head/powered))
		helm = user.head

		if(!sealed)
			user << "\red Unable to initialize helmet seal, armor seals not active."
			return
		if(!helm.parent)
			user << "\blue Helmet locked."
			helm.flags |= NODROP
			parent.helm = helm
			helm.parent = parent
			sleep(20)
			parent.helm.gas_transfer_coefficient = 0.01
			parent.helm.permeability_coefficient = 0.02
			parent.helm.max_heat_protection_temperature = helmet_max
			parent.helm.min_cold_protection_temperature = helmet_min
			parent.helm.flags |= STOPSPRESSUREDMAGE
			user << "\blue Helmet atmospheric seals engaged."
			if(manual)
				for (var/armorvar in helm.armor)
					helm.armor[armorvar] = parent.armor[armorvar]
					helm.armor["bio"] = 100
			return
		else
			if(manual)
				user << "\blue Helmet atmospheric seals disengaged."
			parent.helm.gas_transfer_coefficient = 1
			parent.helm.permeability_coefficient = 1
			parent.helm.max_heat_protection_temperature = null
			parent.helm.min_cold_protection_temperature = null
			parent.helm.flags &= ~STOPSPRESSUREDMAGE
			if(manual && parent.reactive)
				for (var/armorvar in helm.armor)
					helm.armor[armorvar] = parent.reactive.togglearmor[armorvar]
					helm.armor["bio"] = initial(helm.armor["bio"])
			if(parent.helm.on)
				parent.helm.on = 0
				parent.helm.update_icon()
				user.SetLuminosity(user.luminosity - parent.helm:brightness_on)
			if(!sudden)
				if(manual)
					sleep(20)
					user << "\blue Helmet unlocked."
				helm.flags &= ~NODROP
				parent.helm = null
				helm.parent = null

/obj/item/weapon/powerarmor/atmoseal/optional/standard // Spaceproof, but not fireproof
	name = "togglable atmospheric seals"
	desc = "Keeps the vacuum out, but lets you remove your helmet without having to turn the whole suit off."
	origin_tech = "materials=2;engineering=3"

	suit_max = SPACE_SUIT_MAX_TEMP_PROTECT
	helmet_max = SPACE_HELM_MAX_TEMP_PROTECT
