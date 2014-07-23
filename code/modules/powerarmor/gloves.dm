/obj/item/clothing/gloves/powered
	name = "powered gloves"
	icon_state = "powered"
	desc = "A pair of armored and wired gloves."
	item_state = "bgloves"
	armor = list(melee = 40, bullet = 30, laser = 20,energy = 15, bomb = 25, bio = 10, rad = 10)

	heat_protection = HANDS
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT


/obj/item/clothing/gloves/powered/proc/get_armor(var/checkconnection = 1)
	var/mob/living/carbon/human/H = loc
	if(!istype(H))
		return null
	if(istype(H.wear_suit, /obj/item/clothing/suit/powered))
		var/obj/item/clothing/suit/powered/suit = H.wear_suit
		if(suit.gloves == src || !checkconnection)
			return suit
	return null

/obj/item/clothing/gloves/powered/proc/is_armor_on()
	var/obj/item/clothing/suit/powered/suit = get_armor()
	if(!istype(suit)) return 0
	return suit.active

/obj/item/clothing/gloves/powered/Touch(A, proximity, var/mob/living/carbon/user)
	var/obj/item/clothing/suit/powered/parmor = get_armor()

	if(!user)			return 0
	if(!parmor)			return 0
	if(!is_armor_on())	return 0

	if(user.a_intent == "harm")
		if(proximity)
			if(parmor.melee)
				return parmor.melee.pattack(A, user)
		else
			if(parmor.ranged_r && parmor.ranged_l)
				if(user.hand)
					return parmor.ranged_l.pattack(A, user)
				else
					return parmor.ranged_r.pattack(A, user)
			else
				if(parmor.ranged_l)
					return parmor.ranged_l.pattack(A, user)
				else if(parmor.ranged_r)
					return parmor.ranged_r.pattack(A, user)
	else
		for(var/obj/item/weapon/powerarmor/P in parmor.subsystems)
			if(P.user_click(A, proximity, user, user.a_intent))
				break


	/*
	else if(istype(A, /obj/machinery/power/apc) && user.a_intent == "grab" && proximity)
		place code for charging from apcs here
	*/
	return 0
