/////AUGMENTATION\\\\\
//See code/modules/surgery/organs/organ.dm for the parent "limb"


/obj/item/augment
	name = "cyberlimb"
	desc = "You should never be seeing this!"
	icon = 'icons/obj/surgery.dmi'
	origin_tech = "programming=2;biotech=3"
	var/limb_part = null
	var/list/construction_cost = list("metal"=250)
	var/construction_time = 75

/obj/item/augment/chest
	name = "robotic chest"
	desc = "A Robotic chest"
	icon_state = "chest_m_s"
	limb_part = CHEST
	construction_cost = list("metal"=350)

/obj/item/augment/head
	name = "robotic head"
	desc = "A Robotic head"
	icon_state = "head_m_s"
	limb_part = HEAD
	construction_cost = list("metal"=350)
	var/obj/item/organ/brain/brain

/obj/item/augment/l_arm
	name = "robotic left arm"
	desc = "A Robotic arm"
	icon_state = "l_arm_s"
	limb_part = ARM_LEFT

/obj/item/augment/l_leg
	name = "robotic left leg"
	desc = "A Robotic leg"
	icon_state = "l_leg_s"
	limb_part = LEG_LEFT

/obj/item/augment/r_arm
	name = "robotic right arm"
	desc = "A Robotic arm"
	icon_state = "r_arm_s"
	limb_part = ARM_RIGHT

/obj/item/augment/r_leg
	name = "robotic right leg"
	desc = "A Robotic leg"
	icon_state = "r_leg_s"
	limb_part = LEG_RIGHT


/obj/item/augment/head/attackby(var/obj/item/I,var/mob/M)
	if(istype(I,/obj/item/organ/brain))
		var/obj/item/organ/brain/B = I

		if(!B.brainmob || !B.brainmob.mind)
			M << "<span class='warning'>This brain is unresponsive.</span>"
			return

		M.unEquip(B)
		B.loc = src
		brain = B
		M << "<span class='notice'>You insert the brain into [src].</span>"


	if(istype(I, /obj/item/weapon/crowbar))

		if(!brain)
			return

		brain.loc = get_turf(src)
		contents -= brain
		brain = null

		M << "<span class='notice'>You pop the brain out of the [src].</span>"