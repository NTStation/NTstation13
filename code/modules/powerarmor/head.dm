/obj/item/clothing/head/powered
	name = "powered helmet"
	icon_state = "swat"
	desc = "Not for rookies."
	flags = HEADCOVERSEYES | BLOCKHAIR | HEADCOVERSMOUTH
	var/brightness_on = 6 //luminosity when on
	var/power = 5
	var/on = 0
	item_state = "swat"
	flash_protect = 2
	armor = list(melee = 40, bullet = 30, laser = 20,energy = 15, bomb = 25, bio = 10, rad = 10)
	var/obj/item/clothing/suit/powered/parent
	var/obj/effect/proc_holder/stat_button/button

	cold_protection = HEAD
	heat_protection = HEAD

	New()
		button = new(null, src, "Toggle")

/obj/item/clothing/head/powered/proc/get_armor(var/checkconnection = 0)
	if(istype(parent, /obj/item/clothing/suit/powered))
		if((parent.helm == src && parent.active) || !checkconnection)
			return parent
	return null

/obj/item/clothing/head/powered/proc/is_armor_on()
	var/obj/item/clothing/suit/powered/suit = get_armor()
	if(!istype(suit)) return 0
	return suit.active

/obj/item/clothing/head/powered/update_icon()
	icon_state = "rig[on]-[item_color]"
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_head()

/obj/item/clothing/head/powered/pickup(mob/user)
	if(on)
		user.SetLuminosity(user.luminosity + brightness_on)
		SetLuminosity(0)

/obj/item/clothing/head/powered/dropped(mob/user)
	if(on)
		on = 0
		user.SetLuminosity(user.luminosity - brightness_on)
		update_icon()

/obj/item/clothing/head/powered/Stat(var/stat = 0)
	..()
	if(!stat)			return
	if(!brightness_on)	return
	if(!istype(parent))	return
	if(!is_armor_on())	return
	statpanel("Power Armor", "Helmet lights:", "")
	statpanel("Power Armor", on ? "\[ON\]" :"\[OFF\]", button)

/obj/item/clothing/head/powered/stat_button(var/name)
	if(name == "Toggle")
		lightstoggle()

/obj/item/clothing/head/powered/proc/lightstoggle()
	var/mob/living/carbon/human/user = usr

	if(!istype(user))		return
	if(user.head != src)	return

	if(!get_armor())
		user << "\red This helmet can only couple with powered armor."
		return

	if(!isturf(user.loc))
		user << "You cannot turn the light on while in this [user.loc]" //To prevent some lighting anomalities.
		return

	if(!is_armor_on())
		user << "The suit must be powered!"
		return

	on = !on
	update_icon()

	if(on)	user.SetLuminosity(user.luminosity + brightness_on)
	else	user.SetLuminosity(user.luminosity - brightness_on)

/obj/item/clothing/head/powered/process()
	if(on && brightness_on)
		var/obj/item/clothing/suit/powered/armor = get_armor()
		armor.use_power(1)
