/obj/item/clothing/suit/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat"
	item_state = "labcoat"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|ARMS
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/weapon/dnainjector,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper,/obj/item/weapon/melee/telebaton)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

	verb/togglecoat()
		set name = "Toggle Coat"
		set category = "Object"
		set src in usr
		if(!usr.canmove || usr.stat || usr.restrained())
			return
		if(!can_toggle)
			usr << "This suit cannot be toggled!"
			return
		if(src.is_toggled == 2)
			src.icon_state = initial(icon_state)
			usr << "You button up your coat."
			src.is_toggled = 1
		else
			src.icon_state += "_open"
			usr << "You unbutton your coat."
			src.is_toggled = 2
		usr.update_inv_wear_suit()

/obj/item/clothing/suit/labcoat/cmo
	name = "chief medical officer's labcoat"
	desc = "Bluer than the standard model."
	icon_state = "labcoat_cmo"
	item_state = "labcoat_cmo"

/obj/item/clothing/suit/labcoat/mad
	name = "\improper The Mad's labcoat"
	desc = "It makes you look capable of konking someone on the noggin and shooting them into space."
	icon_state = "labgreen"
	item_state = "labgreen"

/obj/item/clothing/suit/labcoat/genetics
	name = "geneticist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a blue stripe on the shoulder."
	icon_state = "labcoat_gen"

/obj/item/clothing/suit/labcoat/chemist
	name = "chemist labcoat"
	desc = "A suit that protects against minor chemical spills. Has an orange stripe on the shoulder."
	icon_state = "labcoat_chem"

/obj/item/clothing/suit/labcoat/virologist
	name = "virologist labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has a green stripe on the shoulder."
	icon_state = "labcoat_vir"

/obj/item/clothing/suit/labcoat/emt
	name = "first-responder jacket"
	desc = "A basic medical jacket with reflective strips that designate emergency medical personnel."
	icon_state = "labcoat_emt"

/obj/item/clothing/suit/labcoat/science
	name = "scientist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a purple stripe on the shoulder."
	icon_state = "labcoat_tox"

/obj/item/clothing/suit/labcoat/red
	name = "red labcoat"
	desc = "A pretty red labcoat."
	icon_state = "red_labcoat"

/obj/item/clothing/suit/labcoat/purple
	name = "purple labcoat"
	desc = "A pretty purple labcoat."
	icon_state = "purple_labcoat"

/obj/item/clothing/suit/labcoat/orange
	name = "orange labcoat"
	desc = "A pretty orange labcoat."
	icon_state = "orange_labcoat"

/obj/item/clothing/suit/labcoat/green
	name = "green labcoat"
	desc = "A pretty green labcoat."
	icon_state = "green_labcoat"

/obj/item/clothing/suit/labcoat/blue
	name = "blue labcoat"
	desc = "A pretty blue labcoat."
	icon_state = "blue_labcoat"

/obj/item/clothing/suit/labcoat/yellow
	name = "yellow labcoat"
	desc = "A pretty yellow labcoat."
	icon_state = "yellow_labcoat"

/obj/item/clothing/suit/labcoat/coat
	name = "winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatwinter"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|ARMS|HEAD
	has_hood = 1
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS | HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/weapon/dnainjector,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper,/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/device/flashlight/seclite,/obj/item/weapon/lighter,/obj/item/weapon/lighter/zippo,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/clothing/mask/cigarette,/obj/item/weapon/reagent_containers/food/drinks/flask)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/suit/labcoat/coat/jacket
	name = "bomber jacket"
	desc = "Aviators not included."
	icon_state = "jacket"
	can_toggle = null

/obj/item/clothing/suit/labcoat/coat/jacket/leather
	name = "leather jacket"
	desc = "Pompadour not included."
	icon_state = "leatherjacket"

/obj/item/clothing/suit/labcoat/coat/jacket/varsity
	name = "varsity jacket"
	desc = "Smells like high school."
	icon_state = "varsity_red"

/obj/item/clothing/suit/labcoat/coat/jacket/varsity/blue
	icon_state = "varsity_blue"

/obj/item/clothing/suit/labcoat/coat/captain
	name = "captain's winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatcaptain"

/obj/item/clothing/suit/labcoat/coat/cargo
	name = "cargo winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatcargo"

/obj/item/clothing/suit/labcoat/coat/engineer
	name = "engineering winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatengineer"

/obj/item/clothing/suit/labcoat/coat/atmos
	name = "atmos winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatatmos"

/obj/item/clothing/suit/labcoat/coat/hydro
	name = "hydroponics winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coathydro"

/obj/item/clothing/suit/labcoat/coat/medical
	name = "medical winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatmedical"

/obj/item/clothing/suit/labcoat/coat/medical/emt
	name = "first-responder winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatemt"

/obj/item/clothing/suit/labcoat/coat/miner
	name = "mining winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatminer"

/obj/item/clothing/suit/labcoat/coat/science
	name = "science winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatscience"

/obj/item/clothing/suit/labcoat/coat/security
	name = "security winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatsecurity"
