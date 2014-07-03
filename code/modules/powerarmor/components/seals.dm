/obj/item/weapon/powerarmor/atmoseal
	name = "power armor atmospheric seals"
	desc = "Keeps the bad stuff out."
	slowdown = 0
	var/sealed = 0

	toggle(sudden = 0)
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
				if(parent.glovesrequired)
					parent.gloves.gas_transfer_coefficient = 1
					parent.gloves.permeability_coefficient = 1
				if(parent.shoesrequired)
					parent.shoes.gas_transfer_coefficient = 1
					parent.shoes.permeability_coefficient = 1
					parent.shoes.max_heat_protection_temperature = null
					parent.shoes.min_cold_protection_temperature = null
				sealed = 0

			if(0)
				usr << "\blue Atmospheric seals engaged."
				parent.gas_transfer_coefficient = 0.01
				parent.permeability_coefficient = 0.02
				parent.flags |= STOPSPRESSUREDMAGE
				parent.max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
				parent.min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
				if(parent.helmrequired && parent.helm)
					parent.helm.gas_transfer_coefficient = 0.01
					parent.helm.permeability_coefficient = 0.02
					parent.helm.max_heat_protection_temperature = FIRE_HELM_MAX_TEMP_PROTECT
					parent.helm.min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
					parent.helm.flags |= STOPSPRESSUREDMAGE
					parent.helm.parent = parent
				if(parent.glovesrequired && parent.gloves)
					parent.gloves.gas_transfer_coefficient = 0.01
					parent.gloves.permeability_coefficient = 0.02
				if(parent.shoesrequired && parent.shoes)
					parent.shoes.gas_transfer_coefficient = 0.01
					parent.shoes.permeability_coefficient = 0.02
					parent.shoes.max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT
					parent.shoes.min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
				sealed = 1

	adminbus
		name = "AdminBUS power armor atmospheric seals"
		desc = "Made with the rare Badminium molecule."
		slowdown = 0

	optional
		name = "togglable power armor atmospheric seals"
		desc = "Keeps the bad stuff out, but lets you remove your helmet without having to turn the whole suit off."

		New()
			..()
			button = new(null, src, "Toggle")

		stat_button(var/name)
			if(name == "Toggle")
				helmtoggle(0, 1)

		Stat()
			..()
			if(!istype(parent))	return
			statpanel("Power Armor", "Helmet seals:", "")
			statpanel("Power Armor", parent.helm ? "\[ON\]" :"\[OFF\]", button)

		proc/helmtoggle(sudden = 0, manual = 0)
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
					parent.helm.max_heat_protection_temperature = FIRE_HELM_MAX_TEMP_PROTECT
					parent.helm.min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
					parent.helm.flags |= STOPSPRESSUREDMAGE
					user << "\blue Helmet atmospheric seals engaged."
					if(manual)
						for (var/armorvar in helm.armor)
							helm.armor[armorvar] = parent.armor[armorvar]
					return
				else
					if(manual)
						user << "\blue Helmet atmospheric seals disengaged."
					parent.helm.gas_transfer_coefficient = 1
					parent.helm.permeability_coefficient = 1
					parent.helm.max_heat_protection_temperature = null
					parent.helm.min_cold_protection_temperature = null
					parent.helm.flags &= ~STOPSPRESSUREDMAGE
					if(manual)
						for (var/armorvar in helm.armor)
							helm.armor[armorvar] = parent.reactive.togglearmor[armorvar]
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

		adminbus
			name = "AdminBUS togglable power armor atmospheric seals"
			desc = "Made with the rare Badminium molecule."
			slowdown = 0