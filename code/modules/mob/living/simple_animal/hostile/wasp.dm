
/mob/living/simple_animal/hostile/wasp
	name = "space wasp"
	desc = "HOLY SHIT, GET IT AWAY!"
	icon_state = "wasp"
	icon_living = "wasp"
	icon_dead = "wasp_dead"
	icon_gib = "wasp_dead"
	speak_chance = 0
	turns_per_move = 5
	meat_type = list()
	response_help = "pets"
	response_disarm = "quickly pushes"
	response_harm = "swats"
	speed = 1
	maxHealth = 30
	health = 30

	harm_intent_damage = 8
	melee_damage_lower = 8
	melee_damage_upper = 12
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'


	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	factions = list("insects")

/mob/living/simple_animal/hostile/wasp/Process_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space wasp!	//original comment stolen

/mob/living/simple_animal/hostile/wasp/FindTarget()
	. = ..()
	if(.)
		emote("angrily buzzez at [.]")

/mob/living/simple_animal/hostile/wasp/AttackingTarget()
	. =..()
	var/mob/living/carbon/L = .
	if(istype(L))
		if(prob(22))
			L.visible_message("<span class='danger'>\the [src] stings \the [L]!</span>")
			L.reagents.add_reagent("toxin", 3)
			L.reagents.add_reagent("cryptobiolin", 3)