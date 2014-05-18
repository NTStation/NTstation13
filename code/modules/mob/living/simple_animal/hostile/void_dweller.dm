
/mob/living/simple_animal/hostile/void_dweller
	name = "void dweller"
	desc = "A twisted, malevolent creature, cloaked in a tattered robe."
	icon_state = "void_dweller"
	icon_living = "void_dweller"
	speak_chance = 0
	turns_per_move = 5
	response_help = "thinks better of touching"
	response_disarm = "cautiously shoves"
	response_harm = "hits"
	speed = 0
	maxHealth = 40
	health = 40

	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "throws tendrils at"
	attack_sound = 'sound/hallucinations/growl1.ogg'

	//Space carp aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	factions = list("void")

/mob/living/simple_animal/hostile/void_dweller/Process_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for void dwellers!	//original comments do not steal

/mob/living/simple_animal/hostile/void_dweller/FindTarget()
	. = ..()
	if(.)
		emote("is drawn towards \the [.]")
		playsound(src.loc, 'sound/hallucinations/veryfar_noise.ogg', 50, 1)

/mob/living/simple_animal/hostile/void_dweller/Die()
	playsound(src.loc, 'sound/hallucinations/wail.ogg', 50, 1)
	emote("wails, collapsing in on itself until nothing remains..")
	del(src)