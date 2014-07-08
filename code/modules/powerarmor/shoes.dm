/obj/item/clothing/shoes/powered
	name = "powered boots"
	icon_state = "steeltoe"
	desc = "Not for rookies."
	item_state = "steeltoe"
	armor = list(melee = 40, bullet = 30, laser = 20,energy = 15, bomb = 25, bio = 10, rad = 10)

	heat_protection = FEET
	cold_protection = FEET

/obj/item/clothing/shoes/powered/proc/get_armor(var/checkconnection = 1)
	var/mob/living/carbon/human/H = loc
	if(!istype(H))
		return null
	if(istype(H.wear_suit, /obj/item/clothing/suit/powered))
		var/obj/item/clothing/suit/powered/suit = H.wear_suit
		if(suit.shoes == src || !checkconnection)
			return suit
	return null

/obj/item/clothing/shoes/powered/proc/is_armor_on()
	var/obj/item/clothing/suit/powered/suit = get_armor()
	if(!istype(suit)) return 0
	return suit.active

/obj/item/clothing/shoes/powered/negates_gravity()
	return flags & NOSLIP