/mob/living/proc/run_armor_check(def_zone = null, attack_flag = "melee", absorb_text = null, soften_text = null)
	var/armor = getarmor(def_zone, attack_flag)
	if(armor >= 100)
		if(absorb_text)
			src << "<span class='userdanger'>[absorb_text]</span>"
		else
			src << "<span class='userdanger'>Your armor absorbs the blow!</span>"
	else if(armor > 0)
		if(soften_text)
			src << "<span class='userdanger'>[soften_text]</span>"
		else
			src << "<span class='userdanger'>Your armor softens the blow!</span>"
	return armor


/mob/living/proc/getarmor(var/def_zone, var/type)
	return 0

/mob/living/bullet_act(obj/item/projectile/P, def_zone, var/has_limbs)
	if(P.silenced)
		playsound(loc, P.hitsound, 5, 1, -1)
		src << "<span class='userdanger'>You've been shot by \a [P][has_limbs ? " in the [parse_zone(def_zone)]!" : "!"]</span>"
	else
		if(P.hitsound)
			var/volume = P.vol_by_damage()
			playsound(loc, P.hitsound, volume, 1, -1)
		visible_message("<span class='danger'>[src] is hit by \a [P][has_limbs ? " in the [parse_zone(def_zone)]!" : "!"]</span>", \
						"<span class='userdanger'>[src] is hit by \a [P][has_limbs ? " in the [parse_zone(def_zone)]!" : "!"]</span>")	//X has fired Y is now given by the guns so you cant tell who shot you if you could not see the shooter
	var/armor = run_armor_check(def_zone, P.flag)
	if(!P.nodamage)
		apply_damage(P.damage, P.damage_type, def_zone, armor)
	return P.on_hit(src, armor, def_zone)

proc/vol_by_throwforce_and_or_w_class(var/obj/item/I)
		if(!I)
				return 0
		if(I.throwforce && I.w_class)
				return Clamp((I.throwforce + I.w_class) * 5, 30, 100)// Add the item's throwforce to its weight class and multiply by 5, then clamp the value between 30 and 100
		else if(I.w_class)
				return Clamp(I.w_class * 8, 20, 100) // Multiply the item's weight class by 8, then clamp the value between 20 and 100
		else
				return 0

/mob/living/hitby(atom/movable/AM)//Standardization and logging -Sieve
	if(istype(AM, /obj/item))
		var/obj/item/I = AM
		var/zone = ran_zone("chest", 65)
		var/dtype = BRUTE
		var/volume = vol_by_throwforce_and_or_w_class(I)
		if(istype(I,/obj/item/weapon))
			var/obj/item/weapon/W = I
			dtype = W.damtype

			if (W.throwforce > 0)
				if (W.throwhitsound)
					playsound(loc, W.throwhitsound, volume, 1, -1)
				else if(W.hitsound)
					playsound(loc, W.hitsound, volume, 1, -1)
				else if(!W.throwhitsound)
					playsound(loc, 'sound/weapons/genhit.ogg',volume, 1, -1)

		else if(!I.throwhitsound && I.throwforce > 0)
			playsound(loc, 'sound/weapons/genhit.ogg', volume, 1, -1)
		if(!I.throwforce).
			playsound(loc, 'sound/weapons/throwtap.ogg', 1, volume, -1)

		visible_message("<span class='danger'>[src] has been hit by [I].</span>", \
						"<span class='userdanger'>[src] has been hit by [I].</span>")
		var/armor = run_armor_check(zone, "melee", "Your armor has protected your [parse_zone(zone)].", "Your armor has softened hit to your [parse_zone(zone)].")
		apply_damage(I.throwforce, dtype, zone, armor, I)
		if(!I.fingerprintslast)
			return
		var/client/assailant = directory[ckey(I.fingerprintslast)]
		if(assailant && assailant.mob && istype(assailant.mob,/mob))
			var/mob/M = assailant.mob
			add_logs(M, src, "hit", object="[I]")

//Mobs on Fire
/mob/living/proc/IgniteMob()
	if(fire_stacks > 0 && !on_fire)
		on_fire = 1
		src.AddLuminosity(3)
		update_fire()

/mob/living/proc/ExtinguishMob()
	if(on_fire)
		on_fire = 0
		fire_stacks = 0
		src.AddLuminosity(-3)
		update_fire()

/mob/living/proc/update_fire()
	return

/mob/living/proc/adjust_fire_stacks(add_fire_stacks) //Adjusting the amount of fire_stacks we have on person
    fire_stacks = Clamp(fire_stacks + add_fire_stacks, min = -20, max = 20)

/mob/living/proc/handle_fire()
	if(fire_stacks < 0)
		fire_stacks++ //If we've doused ourselves in water to avoid fire, dry off slowly
		fire_stacks = min(0, fire_stacks)//So we dry ourselves back to default, nonflammable.
	if(!on_fire)
		return 1
	var/datum/gas_mixture/G = loc.return_air() // Check if we're standing in an oxygenless environment
	if(G.oxygen < 1)
		ExtinguishMob() //If there's no oxygen in the tile we're on, put out the fire
		return
	var/turf/location = get_turf(src)
	location.hotspot_expose(700, 50, 1)

/mob/living/fire_act()
	adjust_fire_stacks(0.5)
	IgniteMob()

//Mobs on Fire end