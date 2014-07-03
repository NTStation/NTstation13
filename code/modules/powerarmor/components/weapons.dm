/obj/item/weapon/powerarmor/weapon
	proc/pattack(var/atom/A, var/mob/living/carbon/user)
		return 0

	drop()
		..()
		if(src == parent.meele)
			parent.meele = null
		if(src == parent.ranged_l)
			parent.ranged_l = null
		if(src == parent.ranged_r)
			parent.ranged_r = null


// MEELE
/obj/item/weapon/powerarmor/weapon/meele/multiplier
	name = "punch repeater"
	desc = "Repeats your hand's movements with a set of servos."

	pattack(var/atom/A, var/mob/living/carbon/user)
		if(ismob(A) && parent.use_power(120))
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
/obj/item/weapon/powerarmor/weapon/ranged
	var/obj/item/weapon/gun/gun
	var/guntype
	var/gun_name = "gun"
	var/shot_cost = 100
	var/fire_sound = 'sound/weapons/Gunshot.ogg'

	proc/load()
		return 0

/obj/item/weapon/powerarmor/weapon/ranged/energy
	name = "mounted proto-kinetic accelerator"
	icon_state = ""
	shot_cost = 200
	var/list/ammo_type = list(/obj/item/ammo_casing/energy/kinetic)

	pattack(var/atom/A, var/mob/living/carbon/user)
		gun.afterattack(A, user, 0, "")


/obj/item/weapon/gun/energy/powersuit
	var/obj/item/weapon/powerarmor/weapon/ranged/energy/holder


	New(var/atom/A)
		..()
		holder = A
		fire_sound = holder.fire_sound
		name = holder.gun_name
		ammo_type = holder.ammo_type


	newshot()
		if (!ammo_type || !holder.parent)	return
		var/obj/item/ammo_casing/energy/shot = ammo_type[select]
		if (!holder.parent.use_power(holder.shot_cost))	return
		chambered = shot
		chambered.newshot()
		return

/obj/item/weapon/powerarmor/weapon/ranged/proj
	name = "mounted Bulldog"
	icon_state = "bulldog"
	shot_cost = 60
	gun_name = "\improper Bulldog shotgun"

	var/mag_type = /obj/item/ammo_box/magazine/m762

	pattack(var/atom/A, var/mob/living/carbon/user)
		if(parent.use_power(shot_cost))
			gun.afterattack(A, user, 0, "")

	load(var/obj/item/I, var/mob/user)
		var/obj/item/weapon/gun/projectile/automatic/powersuit/proj_gun = gun
		if(!proj_gun.magazine && istype(I, mag_type))
			var/obj/item/ammo_box/magazine/magazine = I
			if(magazine.ammo_count())
				return gun.attackby(magazine, user)

	New()
		..()
		gun = new /obj/item/weapon/gun/projectile/automatic/powersuit(src)
		button = new(null, src, "Drop")

	Stat()
		..()
		if(!istype(parent))	return
		var/obj/item/weapon/gun/projectile/automatic/powersuit/proj_gun = gun
		statpanel("Power Armor", gun.name + ":", "")
		if(proj_gun.magazine)
			statpanel("Power Armor", "\[[proj_gun.get_ammo()] / [proj_gun.magazine.max_ammo]\]", button)
		else
			statpanel("Power Armor", "\[RELOAD\]", "")

	stat_button(var/name)
		var/obj/item/weapon/gun/projectile/automatic/powersuit/proj_gun = gun
		if(name == "Drop")
			proj_gun.drop_mag()

/obj/item/weapon/gun/projectile/automatic/powersuit
	name = "powersuit gun"
	trigger_guard = 0
	clumsy_check = 0
	var/obj/item/weapon/powerarmor/weapon/ranged/proj/holder


	New(var/atom/A)
		holder = A
		mag_type = holder.mag_type
		fire_sound = holder.fire_sound
		name = holder.gun_name
		..()

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
	gun_name = "L6 SAW"
	mag_type = /obj/item/ammo_box/magazine/m762
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'