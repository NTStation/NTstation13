/obj/item/clothing/gloves/powered
	name = "powered gloves"
	icon_state = "powered"
	desc = "A pair of armored and wired gloves."
	item_state = "bgloves"
	armor = list(melee = 40, bullet = 30, laser = 20,energy = 15, bomb = 25, bio = 10, rad = 10)

	heat_protection = HANDS
	cold_protection = HANDS

	proc/get_armor(var/checkconnection = 1)
		var/mob/living/carbon/human/H = loc
		if(!istype(H))
			return null
		if(istype(H.wear_suit, /obj/item/clothing/suit/powered))
			var/obj/item/clothing/suit/powered/suit = H.wear_suit
			if(suit.gloves == src || !checkconnection)
				return suit
		return null

	proc/is_armor_on()
		var/obj/item/clothing/suit/powered/suit = get_armor()
		if(!istype(suit)) return 0
		return suit.active

	Touch(A, proximity, var/mob/living/carbon/user)
		var/obj/item/clothing/suit/powered/parmor = get_armor()

		if(!user)		return 0
		if(!parmor)		return 0

		if(user.a_intent == "harm" && is_armor_on())
			if(proximity)
				if(parmor.meele)
					return parmor.meele.pattack(A, user)
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
		/*
		else if(istype(A, /obj/machinery/power/apc) && user.a_intent == "grab" && proximity)
			place charging code here
		*/
		return 0