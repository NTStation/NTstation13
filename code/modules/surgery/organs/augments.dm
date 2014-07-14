/////AUGMENTATION\\\\\
//See code/modules/surgery/organs/organ.dm for the parent "limb"


/obj/item/augment
	name = "cyberlimb"
	desc = "You should never be seeing this!"
	icon = 'icons/mob/augments.dmi'
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

