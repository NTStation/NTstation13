

///////////////////
// Dismemberment //
///////////////////

//handle the removal of limbs

/obj/item/organ/limb/proc/dismember(var/obj/item/I, var/removal_type, var/overide)
	var/obj/item/organ/limb/affecting = src

	if(affecting.state == ORGAN_REMOVED)
		return

	var/mob/living/carbon/human/owner = affecting.owner

	var/dismember_chance = 0 //Chance to fall off, tends to be the Item's force
	var/succesful = 0 //Did they lose the limb?

	if(!overide)
		switch(removal_type)
			if(EXPLOSION_DISMEMBERMENT)
				dismember_chance = 45
			if(GUN_DISMEMBERMENT)
				dismember_chance = 30
			if(MELEE_DISMEMBERMENT)
				if(I)
					dismember_chance = I.force
			else
				world << "<span class='notice'> Error, Invalid removal_type in dismemberment call: [removal_type]</span>"
				return
	else
		dismember_chance = overide //So you can specify an overide chance to dismember, for Unique weapons / Non weapon dismemberment


	if(I)
		if((affecting.brute_dam + I.force) >= (affecting.max_damage / 2) && affecting.state != ORGAN_REMOVED)
			succesful++

	else
		if((affecting.brute_dam) >= (affecting.max_damage / 2) && affecting.state != ORGAN_REMOVED)
			succesful++

	if(succesful)
		if(prob(dismember_chance))
			var/turf/T = get_turf(owner)
			var/dismember_msg = "<span class='danger'><B>[owner]'s [affecting.getDisplayName()] has been violently dismembered!</B></span>"

			switch(affecting.body_part)
				if(HEAD)
					return
				if(CHEST)
					for(var/obj/item/organ/O in owner.internal_organs)
						if(istype(O,/obj/item/organ/brain))
							continue
						owner.internal_organs -= O
						O.loc = T

					dismember_msg = "<span class='danger'><B>[owner]'s internal organs have spilled onto the floor!</B></span>"

				if(ARM_RIGHT || ARM_LEFT)
					handle_arm_removal()
				if(LEG_RIGHT || LEG_LEFT)
					handle_leg_removal()

			owner.apply_damage(30, "brute","[affecting]")

			affecting.state = ORGAN_REMOVED

			affecting.drop_limb(owner)

			affecting.brutestate = 0

			affecting.burnstate = 0

			owner.visible_message(dismember_msg)

			owner.drop_r_hand() //Removes any items they may be carrying in their now non existant arms
			owner.drop_l_hand()
		owner.regenerate_icons()  //Redraw the mob and all it's clothing
		owner.update_canmove()


/obj/item/organ/limb/proc/handle_arm_removal()
	if(!owner || !ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner

	if(H.handcuffed)
		H.handcuffed.loc = get_turf(owner)
		H.handcuffed = null
		H.update_inv_handcuffed(0)

/obj/item/organ/limb/proc/handle_leg_removal()
	if(!owner || ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner

	if(H.legcuffed)
		H.legcuffed.loc = get_turf(owner)
		H.legcuffed = null
		H.update_inv_legcuffed(0)


//////////////////
// Augmentation //
//////////////////

//Augment a limb using an Augment

/mob/living/carbon/human/proc/augmentation(var/obj/item/organ/limb/affecting, var/mob/user, var/obj/item/I)
	if(affecting.state == ORGAN_REMOVED)
		var/obj/item/augment/AUG = I

		if(affecting.body_part == AUG.limb_part)
			affecting.change_organ(ORGAN_ROBOTIC)

			var/who = "[src]'s"
			if(user == src)
				who = "their"

			visible_message("<span class='notice'>[user] has attached [who] new limb!</span>")

			if(affecting.body_part == CHEST)
				for(var/datum/disease/D in viruses)
					D.cure(1)

		else
			user << "<span class='notice'>[AUG.name] doesn't go there!</span>"
			return

		user.drop_item()
		qdel(AUG)
		regenerate_icons()
		update_canmove()
		user.attack_log += "\[[time_stamp()]\]<font color ='red'> Augmented [src.name]'s ([src.ckey])'s [parse_zone(user.zone_sel.selecting)] </font>"
		src.attack_log += "\[[time_stamp()]\]<font color='orange'> [parse_zone(user.zone_sel.selecting)] Augmented by [user.name] ([user.ckey])</font"


/////////////////
// Limb status //
/////////////////

//Obtain the number of limbs of limb_type that are limb_state
//symmetry_type deals with requests for example, all arms

/mob/living/carbon/human/proc/get_num_limbs_of_state(var/limb_type,var/limb_state)
	var/limb_num = 0
	var/symmetry_type

	for(var/obj/item/organ/limb/affecting in organs)
		switch(limb_type)
			if(ARM_LEFT)
				symmetry_type = ARM_RIGHT
			if(ARM_RIGHT)
				symmetry_type = ARM_LEFT
			if(LEG_LEFT)
				symmetry_type = LEG_RIGHT
			if(LEG_RIGHT)
				symmetry_type = LEG_LEFT

		if(affecting.body_part == limb_type || affecting.body_part == symmetry_type)
			if(affecting.state == limb_state)
				limb_num++

	return limb_num


////////////////////////
// Change organ procs //
////////////////////////

//Easily change an organ to a different type

/mob/living/carbon/human/proc/change_all_organs(var/type)
	for(var/obj/item/organ/O in organs)
		O.change_organ(type)


/obj/item/organ/proc/change_organ(var/type)
	status = type
	state = ORGAN_FINE

	if(istype(src, /obj/item/organ/limb))
		var/obj/item/organ/limb/L = src
		L.burn_dam = 0
		L.brute_dam = 0
		L.brutestate = 0
		L.burnstate = 0
		if(L.owner)
			var/mob/living/carbon/human/H = L.owner
			H.updatehealth()
			H.regenerate_icons()



/////////////////
// Dummy limbs //
/////////////////

//Produces a dummy copy of the limb on the ground, for Asthetics
//Only handles limbs that visually remove

/obj/item/organ/limb/proc/drop_limb(var/location)
	var/obj/item/organ/limb/L
	var/obj/item/augment/A
	var/turf/T

	if(location)
		T = get_turf(location)
	else
		T = get_turf(src)

	if(status == ORGAN_ORGANIC)
		switch(body_part)
			if(ARM_RIGHT)
				L = new /obj/item/organ/limb/r_arm (T)
			if(ARM_LEFT)
				L = new /obj/item/organ/limb/l_arm (T)
			if(LEG_RIGHT)
				L = new /obj/item/organ/limb/r_leg (T)
			if(LEG_LEFT)
				L = new /obj/item/organ/limb/l_leg (T)

	else if(status == ORGAN_ROBOTIC)
		switch(body_part)
			if(ARM_RIGHT)
				A = new /obj/item/augment/r_arm (T)
			if(ARM_LEFT)
				A = new /obj/item/augment/l_arm (T)
			if(LEG_RIGHT)
				A = new /obj/item/augment/r_leg (T)
			if(LEG_LEFT)
				A = new /obj/item/augment/l_leg (T)

	var/direction = pick(cardinal)
	if(L)
		L.name = L.getDisplayName()
		step(L,direction)
	if(A)
		step(A,direction)

///////////////////////
// Has_active_hand() //
///////////////////////

//checks that the current active hand exists

/mob/proc/has_active_hand()
	return 1

/mob/living/carbon/human/has_active_hand()
	if(!ishuman(src))
		return
	var/obj/item/organ/limb/L
	if(hand)
		L = get_organ("l_arm")
	else
		L = get_organ("r_arm")
	if(L)
		if(L.state == ORGAN_REMOVED)
			return 0
		return 1

