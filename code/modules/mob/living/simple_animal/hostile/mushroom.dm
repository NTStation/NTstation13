/mob/living/simple_animal/hostile/mushroom
	name = "walking mushroom"
	desc = "It's a massive mushroom... with legs?"
	icon_state = "mushroom_color"
	icon_living = "mushroom_color"
	icon_dead = "mushroom_dead"
	speak_chance = 0
	turns_per_move = 1
	maxHealth = 10
	health = 10
	meat_type = list(/obj/item/weapon/reagent_containers/food/snacks/hugemushroomslice)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "whacks"
	harm_intent_damage = 5
	melee_damage_lower = 1
	melee_damage_upper = 1
	attack_same = 2
	attacktext = "chomps"
	factions = list("mushroom")
	environment_smash = 0
	stat_attack = 2
	mouse_opacity = 1
	speed = 1
	ventcrawler = 2
	minbodytemp = 270 //Some adjustments so the freezing ability will actually damage other mushrooms.
	attack_sound = 'sound/weapons/bite.ogg'
	var/powerlevel = 0 //Tracks our general strength level gained from eating other shrooms
	var/bruised = 0 //If someone tries to cheat the system by attacking a shroom to lower its health, punish them so that it wont award levels to shrooms that eat it
	var/recovery_cooldown = 0 //So you can't repeatedly revive it during a fight
	var/faint_ticker = 0 //If we hit three, another mushroom's gonna eat us
	var/image/cap_living = null //Where we store our cap icons so we dont generate them constantly to update our icon
	var/image/cap_dead = null
	var/limit_maxhealth = 400 //This is the maximum amount of health a walking mushroom can gain.
	var/limit_damage_lower = 45 //hardcap for lower damage cap a walking mushroom can gain
	var/limit_damage_upper = 45 //hardcap for upper damage cap a walking mushroom can gain
	var/list/mushbility = list("stun" = 0, "smash" = 0, "fastheal" = 0, "freeze" = 0, "bluespace" = 0, "spaceproof" = 0, "evolve" = 0, "rampage" = 0,) //learned abilities are stored here

/mob/living/simple_animal/hostile/mushroom/examine()
	..()
	if(health >= maxHealth)
		usr << "<span class='info'>It looks healthy.</span>"
	else
		usr << "<span class='info'>It looks like it's been roughed up.</span>"

/mob/living/simple_animal/hostile/mushroom/Life()
	..()
	if(!stat)//Mushrooms slowly regenerate if conscious, for people who want to save them from being eaten
		health = min(health+2, maxHealth)
		if(mushbility["fastheal"] == 1)
			health = min(health+1, maxHealth)

/mob/living/simple_animal/hostile/mushroom/New()//Makes every shroom a little unique
	melee_damage_lower += rand(4,5)
	melee_damage_upper += rand(4,5)
	maxHealth += rand(30,50)
	move_to_delay = rand(3,11)
	var/cap_color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
	cap_living = image('icons/mob/animal.dmi',icon_state = "mushroom_cap")
	cap_dead = image('icons/mob/animal.dmi',icon_state = "mushroom_cap_dead")
	cap_living.color = cap_color
	cap_dead.color = cap_color
	UpdateMushroomCap()
	health = maxHealth
	..()

/mob/living/simple_animal/hostile/mushroom/adjustBruteLoss(var/damage)//Possibility to flee from a fight just to make it more visually interesting
	if(!retreat_distance && prob(33))
		retreat_distance = 5
		spawn(30)
			retreat_distance = null
	..()

/mob/living/simple_animal/hostile/mushroom/attack_animal(var/mob/living/L)
	if(istype(L, /mob/living/simple_animal/hostile/mushroom) && stat == DEAD)
		var/mob/living/simple_animal/hostile/mushroom/M = L
		if(faint_ticker < 2)
			M.visible_message("<span class='notice'>[M] chews a bit on [src].</span>")
			faint_ticker++
			return
		M.visible_message("<span class='notice'>[M] devours [src]!</span>")
		var/level_gain = (powerlevel - M.powerlevel)
		if(!bruised && !M.ckey && M.powerlevel <= 20)//Player shrooms can't level up to become robust gods.
			if(level_gain == 0)//So we still gain a level if two mushrooms were the same level
				level_gain = 1
			else if (level_gain < 0) //So the winning mushroom is higher level... it still can level up, but at a lower chance.
				if(prob(round(100 / ((M.powerlevel - powerlevel)/2)))) //chance for levelup decreases for every level the losing shroom is below us
					level_gain = 1
				else
					level_gain = 0 //Make sure that we don't get negative levelups from being too overleveled!
			M.LevelUp(level_gain)
		M.health = M.maxHealth
		qdel(src)
		return
	..()



/mob/living/simple_animal/hostile/mushroom/revive()
	..()
	UpdateMushroomCap()
	icon_state = icon_living

/mob/living/simple_animal/hostile/mushroom/Die()
	visible_message("<span class='notice'>[src] fainted.</span>")
	UpdateMushroomCap()
	..()
	if(mushbility["rampage"] == 1) //rampaging mushrooms explode into a fireblast when they die.
		explosion(get_turf(src.loc),-1,-1,0, flame_range = 4)
		explosion(get_turf(src.loc),-1,-1,-1, flame_range = 5)
		qdel(src)
		return


mob/living/simple_animal/hostile/mushroom/proc/rampage()
	src.visible_message("<span class='warning'>The [src.name] looks a bit annoyed...</span>")
	spawn(120)
		attack_same = 1
		stat_attack = 0
		src.visible_message("<span class='danger'>The [src.name] lets out a roar!</span>")

/mob/living/simple_animal/hostile/mushroom/proc/UpdateMushroomCap()
	overlays.Cut()
	if(mushbility["evolve"] == 0)
		if(health == 0)
			overlays += cap_dead
		else
			overlays += cap_living

/mob/living/simple_animal/hostile/mushroom/proc/Recover()
	visible_message("<span class='notice'>[src] slowly begins to recover.</span>")
	health = 5
	faint_ticker = 0
	icon_state = icon_living
	UpdateMushroomCap()
	recovery_cooldown = 1
	spawn(300)
		recovery_cooldown = 0

/mob/living/simple_animal/hostile/mushroom/proc/LevelUp(var/level_gain)
	if(level_gain > 0)
		src.visible_message("<span class='notice'>The [src.name] grows a bit stronger!</span>")
		powerlevel += level_gain
		if(prob(50))
			melee_damage_lower = min(limit_damage_lower, melee_damage_lower + (level_gain * rand(2,4)))
		else
			melee_damage_upper = min(limit_damage_upper, melee_damage_upper + (level_gain * rand(2,4)))
		maxHealth = min(limit_maxhealth, maxHealth + (level_gain * rand(2,5)))
	//PUT ALL THE ABILITIES HERE


	if(powerlevel >= 3 && mushbility["stun"] == 0)
		mushbility["stun"] = 1
		src.visible_message("<span class='notice'>The [src.name] has learned a stunning attack!</span>")

	if(powerlevel >= 7 && mushbility["evolve"] == 0)
		mushbility["evolve"] = 1
		icon_state = "mushroom_evolved_color"
		icon_living = "mushroom_evolved_color"
		icon_dead = "mushroom_evolved_dead"
		UpdateMushroomCap()
		melee_damage_lower = min(limit_damage_lower, melee_damage_lower + rand(5,7))
		melee_damage_upper = min(limit_damage_upper, melee_damage_upper + rand(5,7))
		maxHealth = min(limit_maxhealth, maxHealth + rand(15,22))
		src.visible_message("<span class='notice'>The [src.name] sheds its cap to become even better at fighting!</span>")
		move_to_delay = max(3, (move_to_delay - 3))

	if(powerlevel >= 5 && mushbility["fastheal"] == 0)
		mushbility["fastheal"] = 1
		move_to_delay = max(3, (move_to_delay - 3))
		src.visible_message("<span class='notice'>The [src.name] seems to move faster now!</span>")

	if(powerlevel >= 3 && mushbility["spaceproof"] == 0)
		if(prob(5))
			mushbility["spaceproof"] = 1
			min_oxy = 0
			max_oxy = 0
			min_tox = 0
			max_tox = 0
			min_co2 = 0
			max_co2 = 0
			min_n2 = 0
			max_n2 = 0
			minbodytemp = 0
			src.visible_message("<span class='notice'>The [src.name] has become spaceproof!</span>")

	if(powerlevel >= 5 && mushbility["bluespace"] == 0) //You can learn this from both bluespace tomatoes and random levelups!
		if(prob(1))
			mushbility["bluespace"] = 1
			src.visible_message("<span class='notice'>The [src.name] has mastered bluespace teleportion!</span>")

	health = maxHealth //They'll always heal, even if they don't gain a level, in case you want to keep this shroom around instead of harvesting it

/mob/living/simple_animal/hostile/mushroom/proc/Bruise()
	if(!bruised && !stat)
		src.visible_message("<span class='notice'>The [src.name] was bruised!</span>")
		bruised = 1

/mob/living/simple_animal/hostile/mushroom/attackby(obj/item/I as obj, mob/user as mob)
	if(I.force)
		Bruise()

	if(istype(I, /obj/item/device/analyzer/plant_analyzer))
		var/msg
		msg = "<span class='info'>*---------*\n"
		msg += "Statistics of walking mushroom:\n"
		if(mushbility["evolve"] == 0) msg += "- Evolution Stage: <i>Basic</i>\n"
		else msg += "- Evolution Stage: <i>Advanced</i>\n"
		msg += "- Level: <i>[src.powerlevel]</i>\n"
		msg += "- Current Health: <i>[health]</i>\n"
		msg += "- Max Health: <i>[maxHealth]</i>\n"
		msg += "- Attack: <i>[melee_damage_lower] to [melee_damage_upper]</i>\n"
		msg += "*---------*\n"
		msg += "- Abilities:\n"
		if(mushbility["smash"] == 1)
			msg += "- *Environment Smasher*\n"
			msg += "- Allows mushroom to smash windows and tables.\n"
		if(mushbility["fastheal"] == 1)
			msg += "- *Fast Metabolism*\n"
			msg += "- Speeds up movement and regeneration rate.\n"
		if(mushbility["bluespace"] == 1)
			msg += "- *Bluespace Teleportation*\n"
			msg += "- Allows mushroom to teleport to sighted enemies.\n"
		if(mushbility["stun"] == 1)
			msg += "- *Stunning Chomp*\n"
			msg += "- Some of the mushroom bites become electrically charged.\n"
		if(mushbility["freeze"] == 1)
			msg += "- *Freezing Chomp*\n"
			msg += "- Mushroom bites lower the victims body temperature.\n"
		if(mushbility["spaceproof"] == 1)
			msg += "- *Space Survival*\n"
			msg += "- Allows the mushroom to survive and move freely in space.\n"
		msg += "*---------*</span>"
		user << msg
		return

	if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom))
		if(stat == DEAD && !recovery_cooldown)
			Recover()
			qdel(I)
		else
			user << "<span class='notice'>[src] won't eat it!</span>"
		return

	if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/grown/ghost_chilli))
		user << "<span class='notice'>You feed the [I] to the [src].</span>"
		if(!mushbility["rampage"] == 1 && !factions["lazarus"])
			mushbility["rampage"] = 1
			friends += user
			log_game("[key_name(user)] turned a walking mushroom hostile.")
			rampage()
		qdel(I)
		return

	//abilities gained through special items start here

	if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/grown/bluespacetomato))
		user << "<span class='notice'>You feed the [I] to [src].</span>"
		if(!mushbility["bluespace"] == 1)
			mushbility["bluespace"] = 1
			src.visible_message("<span class='notice'>The [src.name] has mastered bluespace teleportion!</span>")
		qdel(I)
		return

	if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/grown/icepepper))
		user << "<span class='notice'>You feed the [I] to [src].</span>"
		if(!mushbility["freeze"] == 1)
			mushbility["freeze"] = 1
			src.visible_message("<span class='notice'>The [src.name] gains a freezing bite!</span>")
		qdel(I)
		return

	if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/grown/soybeans))
		user << "<span class='notice'>You feed the [I] to [src].</span>"
		if(!mushbility["smash"] == 1)
			mushbility["smash"] = 1
			environment_smash = 1
			src.visible_message("<span class='notice'>The [src.name] looks strong enough to smash through walls and tables!</span>")
		qdel(I)
		return

	..()

/mob/living/simple_animal/hostile/mushroom/attack_hand(mob/living/carbon/human/M as mob)
	..()
	if(M.a_intent == "harm")
		Bruise()

/mob/living/simple_animal/hostile/mushroom/hitby(atom/movable/AM)
	..()
	if(istype(AM, /obj/item))
		var/obj/item/T = AM
		if(T.throwforce)
			Bruise()

/mob/living/simple_animal/hostile/mushroom/bullet_act()
	..()
	Bruise()

/mob/living/simple_animal/hostile/mushroom/harvest()
	var/counter
	for(counter=0, counter<=powerlevel, counter++)
		var/obj/item/weapon/reagent_containers/food/snacks/hugemushroomslice/S = new /obj/item/weapon/reagent_containers/food/snacks/hugemushroomslice(src.loc)
		S.reagents.add_reagent("mushroomhallucinogen", powerlevel)
		S.reagents.add_reagent("doctorsdelight", powerlevel)
		S.reagents.add_reagent("synaptizine", powerlevel)
	qdel(src)

/mob/living/simple_animal/hostile/mushroom/AttackingTarget()
	..()
	var/mob/living/L = target
	if(mushbility["freeze"] == 1) //this will still damage other mushrooms
		if(isliving(target))
			if(L.bodytemperature)
				if(L.bodytemperature > 261)
					L.bodytemperature -= 30
	if(mushbility["stun"] == 1)
		if(isliving(target))
			if(prob(25))
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				src.visible_message("<span class='danger'><b>The [src.name]</b> delivers a powerful electrical chomp to [L]!</span>")
				s.set_up(3, 1, L)
				s.start()
				if(istype(target, /mob/living/carbon))
					L.Weaken(1)
				else
					L.adjustFireLoss(10) //so it's not useless against unstunable mobs

/mob/living/simple_animal/hostile/mushroom/FindTarget()
	. = ..()
	if(. && mushbility["bluespace"] == 1)
		var/mob/living/L = .
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		src.visible_message("<span class='warning'>The <b>[src.name]</b> teleports!</span>")
		playsound(src, 'sound/effects/EMPulse.ogg', 50, 1)
		src.loc = L.loc
		s.set_up(3, 1, src)
		s.start()

/mob/living/simple_animal/hostile/mushroom/Process_Spacemove(var/check_drift = 0)
	if(mushbility["spaceproof"] == 1)
		return 1	//No drifting when they are spaceproof!