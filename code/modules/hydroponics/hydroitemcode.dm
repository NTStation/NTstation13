/* Hydroponic Item Procs and Stuff
 * Contains:
 * Sunflowers Novaflowers Nettle Deathnettle Corncob
 */

//Sun/Novaflower
/obj/item/weapon/grown/sunflower/attack(mob/M as mob, mob/user as mob)
	M << "<font color='green'><b> [user] smacks you with a sunflower!</font><font color='yellow'><b>FLOWER POWER<b></font>"
	user << "<font color='green'> Your sunflower's </font><font color='yellow'><b>FLOWER POWER</b></font><font color='green'> strikes [M]</font>"

/obj/item/weapon/grown/novaflower/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(!..()) return
	if(istype(M, /mob/living))
		M << "\red You are heated by the warmth of the of the [name]!"
		M.bodytemperature += potency/2 * TEMPERATURE_DAMAGE_COEFFICIENT

/obj/item/weapon/grown/novaflower/afterattack(atom/A as mob|obj, mob/user as mob,proximity)
	if(!proximity) return
	if(endurance > 0)
		endurance -= rand(1,(endurance/3)+1)
	else
		usr << "All the petals have fallen off the [name] from violent whacking."
		usr.unEquip(src)
		qdel(src)

/obj/item/weapon/grown/novaflower/pickup(mob/living/carbon/human/user as mob)
	if(!user.gloves)
		user << "\red The [name] burns your bare hand!"
		user.adjustFireLoss(rand(1,5))

//Nettle
/obj/item/weapon/grown/nettle/pickup(mob/living/carbon/human/user as mob)
	if(!user.gloves)
		user << "\red The nettle burns your bare hand!"
		if(istype(user, /mob/living/carbon/human))
			var/organ = ((user.hand ? "l_":"r_") + "arm")
			var/obj/item/organ/limb/affecting = user.get_organ(organ)
			if(affecting.take_damage(0,force))
				user.update_damage_overlays(0)
		else
			user.take_organ_damage(0,force)

/obj/item/weapon/grown/nettle/afterattack(atom/A as mob|obj, mob/user as mob,proximity)
	if(!proximity) return
	if(force > 0)
		force -= rand(1,(force/3)+1) // When you whack someone with it, leaves fall off
	else
		usr << "All the leaves have fallen off the nettle from violent whacking."
		usr.unEquip(src)
		qdel(src)

/obj/item/weapon/grown/nettle/changePotency(newValue) //-QualityVan
	..()
	force = round((5+potency/5), 1)

//Deathnettle
/obj/item/weapon/grown/deathnettle/pickup(mob/living/carbon/human/user as mob)
	if(!user.gloves)
		if(istype(user, /mob/living/carbon/human))
			var/organ = ((user.hand ? "l_":"r_") + "arm")
			var/obj/item/organ/limb/affecting = user.get_organ(organ)
			if(affecting.take_damage(0,force))
				user.update_damage_overlays(0)
		else
			user.take_organ_damage(0,force)
		if(prob(50))
			user.Paralyse(5)
			user << "\red You are stunned by the Deathnettle when you try picking it up!"

/obj/item/weapon/grown/deathnettle/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(!..()) return
	if(istype(M, /mob/living))
		M << "\red You are stunned by the powerful acid of the Deathnettle!"
		add_logs(user, M, "attacked", object="[src.name]")

		M.eye_blurry += force/7
		if(prob(20))
			M.Paralyse(force/6)
			M.Weaken(force/15)
		M.drop_item()

/obj/item/weapon/grown/deathnettle/afterattack(atom/A as mob|obj, mob/user as mob,proximity)
	if(!proximity) return
	if (force > 0)
		force -= rand(1,(force/3)+1) // When you whack someone with it, leaves fall off

	else
		usr << "All the leaves have fallen off the deathnettle from violent whacking."
		usr.unEquip(src)
		qdel(src)

/obj/item/weapon/grown/deathnettle/changePotency(newValue) //-QualityVan
	..()
	force = round((5+potency/2.5), 1)


//Corncob
/obj/item/weapon/grown/corncob/attackby(obj/item/weapon/grown/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/circular_saw) || istype(W, /obj/item/weapon/hatchet) || istype(W, /obj/item/weapon/kitchen/utensil/knife))
		user << "<span class='notice'>You use [W] to fashion a pipe out of the corn cob!</span>"
		new /obj/item/clothing/mask/cigarette/pipe/cobpipe (user.loc)
		usr.unEquip(src)
		qdel(src)
		return

//Bluespace Tomatoes
/obj/item/weapon/reagent_containers/food/snacks/grown/bluespacetomato/throw_impact(atom/hit_atom)
	..()
	var/mob/M = usr
	var/outer_teleport_radius = potency/10 //Plant potency determines radius of teleport.
	var/inner_teleport_radius = potency/15
	var/list/turfs = new/list()
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	if(inner_teleport_radius < 1) //Wasn't potent enough, it just splats.
		new/obj/effect/decal/cleanable/oil(src.loc)
		src.visible_message("<span class='notice'>The [src.name] has been squashed.</span>","<span class='moderate'>You hear a smack.</span>")
		usr.unEquip(src)
		qdel(src)
		return
	for(var/turf/T in orange(M,outer_teleport_radius))
		if(T in orange(M,inner_teleport_radius)) continue
		if(istype(T,/turf/space)) continue
		if(T.density) continue
		if(T.x>world.maxx-outer_teleport_radius || T.x<outer_teleport_radius)	continue
		if(T.y>world.maxy-outer_teleport_radius || T.y<outer_teleport_radius)	continue
		turfs += T
	if(!turfs.len)
		var/list/turfs_to_pick_from = list()
		for(var/turf/T in orange(M,outer_teleport_radius))
			if(!(T in orange(M,inner_teleport_radius)))
				turfs_to_pick_from += T
		turfs += pick(/turf in turfs_to_pick_from)
	var/turf/picked = pick(turfs)
	if(!isturf(picked)) return
	switch(rand(1,2))//Decides randomly to teleport the thrower or the throwee.
		if(1) // Teleports the person who threw the tomato.
			s.set_up(3, 1, M)
			s.start()
			new/obj/effect/decal/cleanable/molten_item(M.loc) //Leaves a pile of goo behind for dramatic effect.
			M.loc = picked //
			sleep(1)
			s.set_up(3, 1, M)
			s.start() //Two set of sparks, one before the teleport and one after.
		if(2) //Teleports mob the tomato hit instead.
			for(var/mob/A in get_turf(hit_atom))//For the mobs in the tile that was hit...
				s.set_up(3, 1, A)
				s.start()
				new/obj/effect/decal/cleanable/molten_item(A.loc) //Leave a pile of goo behind for dramatic effect...
				A.loc = picked//And teleport them to the chosen location.
				sleep(1)
				s.set_up(3, 1, A)
				s.start()
	new/obj/effect/decal/cleanable/oil(src.loc)
	src.visible_message("<span class='notice'>The [src.name] has been squashed, causing a distortion in space-time.</span>","<span class='moderate'>You hear a splat and a crackle.</span>")
	qdel(src)
	return

//singulo potato
/obj/item/weapon/reagent_containers/food/snacks/grown/singulopotato/attack_self(mob/user as mob)
	user.visible_message("<span class='warning'>[user] crushes a singularity potato!</span>")
	var/vortexpower = max(3, round(potency/14, 1)) // this limits the range to 7 at max potency.
	var/turf/pull = user.loc
	playsound(user, 'sound/weapons/marauder.ogg', 50, 1)
	for(var/atom/X in orange(vortexpower,pull))
		if(istype(X, /atom/movable))
			if(X == user) continue
			if((X) &&(!X:anchored) && (!istype(X,/mob/living/carbon/human)))
				step_towards(X,pull)
				step_towards(X,pull)
				step_towards(X,pull)
			else if(istype(X,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = X
				if(istype(H.shoes,/obj/item/clothing/shoes/magboots))
					var/obj/item/clothing/shoes/magboots/M = H.shoes
					if(M.magpulse)
						continue
				H.apply_effect(min(3, vortexpower), WEAKEN, 0)
				step_towards(H,pull)
				step_towards(H,pull)
				step_towards(H,pull)
	log_game("[key_name(user)] used a singularity potato.")
	qdel(src)
	return

//spiderplant
/obj/item/weapon/grown/spiderpod/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/kitchenknife) || istype(W, /obj/item/weapon/butch))
		var/spidermeatamount = max(1, round(potency/25, 1))
		var/turf/L = user.loc
		for (var/i=1 to spidermeatamount)
			var/obj/item/weapon/reagent_containers/food/snacks/spidermeat/newspidermeat = new(L)
			src.reagents.trans_to (newspidermeat, round(src.reagents.total_volume/spidermeatamount, 1)) //move all reagents from the pod to the meat but split it between the meatslabs
			user << "<span class='notice'>You cut the spiderpod into [spidermeatamount] spidermeat slabs.</span>"
		qdel(src)
		return

/obj/item/weapon/grown/spiderpod/attack_self(mob/user as mob)
	user.visible_message("<span class='warning'>[user] pries open a spiderpod!</span>")
	if(prob(max(5, round(potency/1.6, 1))))
		user << "<span class='notice'>You pry open the spiderpod and release the spiderling.</span>"
		var/turf/L = user.loc
		var/obj/effect/spider/spiderling/S = new(L)
		switch (pickweight(list("regular" = 50, "hunter" = 35, "nurse" = 15)))
			if ("regular")
				S.grow_as = /mob/living/simple_animal/hostile/giant_spider
			if ("hunter")
				S.grow_as = /mob/living/simple_animal/hostile/giant_spider/hunter
			if ("nurse")
				S.grow_as = /mob/living/simple_animal/hostile/giant_spider/nurse
		log_game("[key_name(user)] spawned a spiderling with a spiderpod.")
	else
		user << "<span class='notice'>You pry open the spiderpod but it is empty.</span>"
		log_game("[key_name(user)] attempted to spawn a spiderling with a spiderpod.")
	qdel(src)
	return
