/obj/item/weapon/powerarmor/weapon
	proc/pattack(var/atom/A, var/mob/living/carbon/user)
		return 0

/obj/item/weapon/powerarmor/weapon/meele

/obj/item/weapon/powerarmor/weapon/ranged
	proc/load(var/obj/item/I, var/mob/user)
		return 0

	proc/chamber_shot()
		return null

	proc/fire_proj(var/atom/A, var/mob/living/carbon/user, var/obj/item/projectile/in_chamber)
		var/turf/curloc = get_turf(user)
		var/turf/targloc = get_turf(A)
		if (!istype(targloc) || !istype(curloc))
			return 0
		if(!in_chamber)	return 0

		in_chamber.firer = user
		in_chamber.def_zone = user.zone_sel.selecting
		if(targloc == curloc)
			user.bullet_act(in_chamber)
			del(in_chamber)
			return

		user.visible_message("<span class='warning'>[user] fires [src]!</span>", \
		"<span class='warning'>You fire [src]!</span>", \
		"You hear a [istype(in_chamber, /obj/item/projectile/beam) ? "laser blast" : "gunshot"]!")

		in_chamber.original = A
		in_chamber.loc = get_turf(user)
		in_chamber.starting = get_turf(user)
		//in_chamber.shot_from = src
		user.next_move = world.time + 4
		in_chamber.current = curloc
		in_chamber.yo = targloc.y - curloc.y
		in_chamber.xo = targloc.x - curloc.x

		spawn()
			if(in_chamber)
				in_chamber.process()
		sleep(1)
		in_chamber = null
		return 1

// MEELE
/obj/item/weapon/powerarmor/weapon/meele/multiplier
	name = "punch repeater"
	desc = "Repeats your hand's movements with a set of servos."

	pattack(var/atom/A, var/mob/living/carbon/user)
		if(ismob(A) && parent.use_power(60))
			A.attack_hand(user)
			A.attack_hand(user)
			A.attack_hand(user)
			return 1
		return 0

/obj/item/weapon/powerarmor/weapon/meele/pneumatic
	name = "pneumatic amplifier"
	desc = "Smashing skulls never was so fun!"
	icon = 'icons/obj/module.dmi'
	icon_state = "pneumatics"

	pattack(var/atom/A, var/mob/living/carbon/user)
		if(ismob(A) && parent.use_power(250))
			var/mob/living/M = A
			M.Stun(8)
			M.adjustBruteLoss(10)
			M.attack_hand(user)
			var/throwdir = get_dir(user,M)
			M.throw_at(get_edge_target_turf(M, throwdir),5,1)
			return 1
		return 0


// RANGED
/obj/item/weapon/powerarmor/weapon/ranged/energy
	name = "mounted proto-kinetic accelerator"
	var/proj_type = /obj/item/ammo_casing/energy/kinetic
	var/shot_cost = 200

	pattack(var/atom/A, var/mob/living/carbon/user)
		if(fire_proj(A, user, chamber_shot()))
			return 1
		return 0

	chamber_shot()
		if(parent.use_power(shot_cost))
			return new proj_type(src)
		return ..()

/obj/item/weapon/powerarmor/weapon/ranged/proj
	name = "mounted Bulldog"
	icon_state = "bulldog"
	var/shot_cost = 60

	var/obj/item/weapon/gun/projectile/automatic/powersuit/gun
	var/guntype = /obj/item/weapon/gun/projectile/automatic/powersuit

	pattack(var/atom/A, var/mob/living/carbon/user)
		if(parent.use_power(shot_cost))
			gun.afterattack(A, user, 0, "")

	load(var/obj/item/I, var/mob/user)
		if(!gun.magazine && istype(I, gun.mag_type))
			return gun.attackby(I, user)

	New()
		..()
		gun = new guntype(src)
		button = new(null, src, "Drop")

	Stat()
		..()
		if(!istype(parent))	return
		statpanel("Power Armor", gun.name + ":", "")
		if(gun.magazine)
			statpanel("Power Armor", "\[[gun.get_ammo()] / [gun.magazine.max_ammo]\]", button)
		else
			statpanel("Power Armor", "\[RELOAD\]", "")

	stat_button(var/name)
		if(name == "Drop")
			gun.drop_mag()

/obj/item/weapon/gun/projectile/automatic/powersuit
	name = "\improper Bulldog shotgun"
	mag_type = /obj/item/ammo_box/magazine/m12g
	fire_sound = 'sound/weapons/Gunshot.ogg'
	trigger_guard = 0
	clumsy_check = 0

	var/obj/item/weapon/powerarmor/weapon/ranged/proj/holder

	New(var/atom/A)
		..()
		holder = A


	chamber_round()
		..()

		if(magazine && !magazine.ammo_count())
			drop_mag()

	proc/drop_mag()
		if(magazine)
			magazine.loc = get_turf(src.loc)
			magazine.update_icon()
			magazine = null


/obj/item/weapon/powerarmor/weapon/ranged/proj/l6
	name = "mounted L6 SAW"
	icon_state = "l6"
	w_class = 5
	shot_cost = 25

	guntype = /obj/item/weapon/gun/projectile/automatic/powersuit/l6

/obj/item/weapon/gun/projectile/automatic/powersuit/l6
	name = "L6 SAW"
	mag_type = /obj/item/ammo_box/magazine/m762
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'