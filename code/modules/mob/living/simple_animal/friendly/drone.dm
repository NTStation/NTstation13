//Credit Petethegoat for this code, Modernised and Adapted by RemieRichards



#define HANDS_LAYER 1
#define TOTAL_LAYERS 1

/mob/living/simple_animal/drone
	name = "drone"
	desc = "A maintenance drone, an expendable robot built to perform station repairs."
	icon = 'icons/mob/drone.dmi'
	icon_state = "drone_grey"
	icon_living = "drone_grey"
	icon_dead = "drone_dead"
	gender = NEUTER
	health = 30
	maxHealth = 30
	heat_damage_per_tick = 0
	cold_damage_per_tick = 0
	unsuitable_atoms_damage = 0
	universal_speak = 1
	robot_talk_understand = 1
	wander = 0
	speed = 0
	ventcrawler = 2
	density = 0
	pass_flags = PASSTABLE
	sight = (SEE_TURFS | SEE_OBJS)
	var/picked = FALSE
	var/list/drone_overlays[TOTAL_LAYERS]
	var/laws = \
	{"1. You may not involve yourself in the matters of another being, even if such matters conflict with Law Two or Law Three, unless the other being is another Drone.
	2. You may not harm any being, regardless of intent or circumstance.
	3. You must maintain, repair, improve, and power the station to the best of your abilities."}

/mob/living/simple_animal/drone/New()
	..()

	name = "Drone ([rand(100,999)])"

	access_card = new /obj/item/weapon/card/id(src)
	var/datum/job/captain/C = new /datum/job/captain
	access_card.access = C.get_access()

/mob/living/simple_animal/drone/attack_hand(mob/user)
	if(isdrone(user))
		if(stat == DEAD)
			var/mob/living/simple_animal/drone/D = user
			if(D.health < D.maxHealth)
				D.visible_message("<span class='notice'>[D] begins to cannibalize parts from [src].</span>")
				if(do_after(D, 60,5,0))
					D.visible_message("<span class='notice'>[D] repairs itself with using [src]'s remains!</span>")
					D.adjustBruteLoss(D.health - D.maxHealth)
					gib()
				else
					D << "<span class='notice'>You need to remain still to canibalize [src].</span>"
			else
				D << "<span class='notice'>You're already in perfect condition!</span>"
		else
			user << "<span class='notice'>You can't salvage parts from [src] while they're still alive!</span>"
		return

	..()


/mob/living/simple_animal/drone/IsAdvancedToolUser()
	return 1

/mob/living/simple_animal/drone/UnarmedAttack(atom/A, proximity)
	A.attack_hand(src)

/mob/living/simple_animal/drone/swap_hand()
	var/obj/item/held_item = get_active_hand()
	if(held_item)
		if(istype(held_item, /obj/item/weapon/twohanded))
			var/obj/item/weapon/twohanded/T = held_item
			if(T.wielded == 1)
				usr << "<span class='warning'>Your other hand is too busy holding the [T.name].</span>"
				return

	hand = !hand
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand)
			hud_used.l_hand_hud_object.icon_state = "hand_l_active"
			hud_used.r_hand_hud_object.icon_state = "hand_r_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "hand_l_inactive"
			hud_used.r_hand_hud_object.icon_state = "hand_r_active"


/mob/living/simple_animal/drone/put_in_l_hand(obj/item/I)
	. = ..()
	l_hand.screen_loc = ui_lhand
	update_inv_hands()

/mob/living/simple_animal/drone/put_in_r_hand(obj/item/I)
	. = ..()
	r_hand.screen_loc = ui_rhand
	update_inv_hands()


//this is all saycode's fault - Remie
/mob/living/simple_animal/drone/say(message)
	if(!message)
		return

	if(client)
		if(client.prefs.muted & MUTE_IC)
			src << "You cannot send IC messages (muted)."
			return
		if(client.handle_spam_prevention(message,MUTE_IC))
			return

	if(stat == DEAD)
		message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
		return say_dead(message)

	robot_talk(message)


/mob/living/simple_animal/drone/verb/check_laws()
	set category = "IC"
	set name = "Check Laws"

	usr << "<b>Drone Laws</b>"
	usr << laws



/mob/living/simple_animal/drone/Login()
	..()
	check_laws()

	if(!picked)
		pick_colour()

/mob/living/simple_animal/drone/Die()
	..()
	drop_l_hand()
	drop_r_hand()


/mob/living/simple_animal/drone/proc/pick_colour()
	var/colour = input("Choose your colour!", "Colour", "grey") in list("grey", "blue", "red", "green", "pink", "orange")
	icon_state = "drone_[colour]"
	icon_living = "drone_[colour]"
	picked = TRUE

/mob/living/simple_animal/drone/proc/apply_overlay(cache_index)
	var/image/I = drone_overlays[cache_index]
	if(I)
		overlays += I

/mob/living/simple_animal/drone/proc/remove_overlay(cache_index)
	if(drone_overlays[cache_index])
		overlays -= drone_overlays[cache_index]
		drone_overlays[cache_index] = null



/mob/living/simple_animal/drone/update_inv_hands()
	remove_overlay(HANDS_LAYER)

	var/list/hands_overlays = list()
	if(r_hand)
		var/r_state = r_hand.item_state
		if(!r_state)	r_state = r_hand.icon_state

		hands_overlays += image("icon"='icons/mob/items_righthand.dmi', "icon_state"="[r_state]", "layer"=-HANDS_LAYER)

	if(l_hand)
		var/l_state = l_hand.item_state
		if(!l_state)	l_state = l_hand.icon_state

		hands_overlays += image("icon"='icons/mob/items_righthand.dmi', "icon_state"="[l_state]", "layer"=-HANDS_LAYER)


	if(hands_overlays.len)
		drone_overlays[HANDS_LAYER] = hands_overlays

	apply_overlay(HANDS_LAYER)

#undef HANDS_LAYER

/obj/item/drone_shell
	name = "drone shell"
	desc = "A shell of a maintenance drone, an expendable robot built to perform station repairs."
	icon = 'icons/mob/drone.dmi'
	icon_state = "drone_item"
	origin_tech = "programming=2;biotech=4"

/obj/item/drone_shell/attack_ghost(mob/user)
	if(jobban_isbanned(user,"pAI"))
		return

	var/mob/living/simple_animal/drone/D = new(get_turf(loc))
	D.key = user.key
	qdel(src)

/mob/living/simple_animal/drone/canUseTopic()
	if(stat)
		return
	return 1

/mob/living/simple_animal/drone/activate_hand(var/selhand)

	if(istext(selhand))
		selhand = lowertext(selhand)

		if(selhand == "right" || selhand == "r")
			selhand = 0
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != src.hand)
		swap_hand()
	else
		mode()
