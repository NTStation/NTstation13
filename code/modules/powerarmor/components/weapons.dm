/obj/item/weapon/powerarmor/weapon/proc/pattack(var/atom/A, var/mob/living/carbon/user)
	return 0


// melee
/obj/item/weapon/powerarmor/weapon/melee/multiplier
	name = "punch repeater"
	desc = "Repeats your hand's movements with a set of servos."
	origin_tech = "combat=2;materials=1;programming=1;engineering=1"

/obj/item/weapon/powerarmor/weapon/melee/multiplier/pattack(var/atom/A, var/mob/living/carbon/user)
	if(ismob(A) && parent.use_power(80))
		A.attack_hand(user)
		A.attack_hand(user)
		A.attack_hand(user)
		return 1
	return 0


/obj/item/weapon/powerarmor/weapon/melee/pneumatic
	name = "pneumatic amplifier"
	desc = "Smashing skulls never was so fun!"
	icon = 'icons/obj/module.dmi'
	icon_state = "pneumatics"
	origin_tech = "combat=3;materials=2;engineering=1"

/obj/item/weapon/powerarmor/weapon/melee/pneumatic/pattack(var/atom/A, var/mob/living/carbon/user)
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



// ENERGY
/obj/item/weapon/powerarmor/weapon/ranged/energy
	name = "mounted laser gun"
	desc = ""
	icon_state = "kineticgun"
	shot_cost = 250
	gun_name = "laser gun"
	origin_tech = "combat=2;magnets=2;materials=2"

	var/list/ammo_type = list(/obj/item/ammo_casing/energy/laser)


/obj/item/weapon/powerarmor/weapon/ranged/energy/New()
	..()
	gun = new /obj/item/weapon/gun/energy/powersuit(src)


/obj/item/weapon/powerarmor/weapon/ranged/energy/pattack(var/atom/A, var/mob/living/carbon/user)
	return gun.afterattack(A, user, 0, "")


/obj/item/weapon/gun/energy/powersuit
	name = "powersuit gun"
	var/obj/item/weapon/powerarmor/weapon/ranged/energy/holder


/obj/item/weapon/gun/energy/powersuit/New(var/atom/A)
	holder = A
	fire_sound = holder.fire_sound
	name = holder.gun_name
	ammo_type = holder.ammo_type
	..()

/obj/item/weapon/gun/energy/powersuit/newshot()
	if (!ammo_type || !holder.parent)	return
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	if (!holder.parent.use_power(holder.shot_cost))	return
	chambered = shot
	chambered.newshot()
	return


/obj/item/weapon/powerarmor/weapon/ranged/energy/kinetic
	name = "mounted proto-kinetic accelerator"
	desc = "According to Nanotrasen accounting, this is mining equipment used for crushing rocks. It's not very powerful unless used in a low pressure environment."
	icon_state = "kineticgun"
	shot_cost = 180
	gun_name = "rapid proto-kinetic accelerator"
	origin_tech = "combat=2;magnets=2;materials=2"
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic)

// PROJECTILE
/obj/item/weapon/powerarmor/weapon/ranged/proj
	name = "mounted Bulldog"
	desc = "A mag-fed semi-automatic shotgun for combat in narrow corridors. Compatible only with specialized magazines."
	icon_state = "bulldog"
	origin_tech = "combat=5;materials=4;syndicate=6"
	shot_cost = 60
	gun_name = "\improper Bulldog shotgun"

	var/mag_type = /obj/item/ammo_box/magazine/m12g


/obj/item/weapon/powerarmor/weapon/ranged/proj/pattack(var/atom/A, var/mob/living/carbon/user)
	var/obj/item/weapon/gun/projectile/automatic/powersuit/proj_gun = gun
	if(proj_gun.get_ammo() && parent.use_power(shot_cost))
		return proj_gun.afterattack(A, user, 0, "")

/obj/item/weapon/powerarmor/weapon/ranged/proj/load(var/obj/item/I, var/mob/user)
	var/obj/item/weapon/gun/projectile/automatic/powersuit/proj_gun = gun
	if(!proj_gun.magazine && istype(I, mag_type))
		var/obj/item/ammo_box/magazine/magazine = I
		if(magazine.ammo_count())
			var/tenp = gun.attackby(magazine, user)
			return tenp

/obj/item/weapon/powerarmor/weapon/ranged/proj/New()
	..()
	gun = new /obj/item/weapon/gun/projectile/automatic/powersuit(src)
	button = new(null, src, "Drop")

/obj/item/weapon/powerarmor/weapon/ranged/proj/Stat()
	..()
	if(!istype(parent))	return
	var/obj/item/weapon/gun/projectile/automatic/powersuit/proj_gun = gun
	statpanel("Power Armor", gun.name + ":", "")
	if(proj_gun.magazine)
		statpanel("Power Armor", "\[[proj_gun.get_ammo()] / [proj_gun.magazine.max_ammo]\]", button)
	else
		statpanel("Power Armor", "\[RELOAD\]", "")

/obj/item/weapon/powerarmor/weapon/ranged/proj/attack_self()
	var/obj/item/weapon/gun/projectile/automatic/powersuit/proj_gun = gun
	proj_gun.drop_mag()

/obj/item/weapon/powerarmor/weapon/ranged/proj/stat_button(var/name)
	var/obj/item/weapon/gun/projectile/automatic/powersuit/proj_gun = gun
	if(name == "Drop")
		proj_gun.drop_mag()


/obj/item/weapon/gun/projectile/automatic/powersuit
	name = "powersuit gun"
	trigger_guard = 0
	clumsy_check = 0
	var/obj/item/weapon/powerarmor/weapon/ranged/proj/holder


/obj/item/weapon/gun/projectile/automatic/powersuit/New(var/atom/A)
	holder = A
	mag_type = holder.mag_type
	fire_sound = holder.fire_sound
	name = holder.gun_name
	..()

/obj/item/weapon/gun/projectile/automatic/powersuit/chamber_round()
	..()
	if(magazine && !magazine.ammo_count())
		drop_mag()

/obj/item/weapon/gun/projectile/automatic/powersuit/proc/drop_mag()
	if(magazine)
		magazine.loc = get_turf(src.loc)
		magazine.update_icon()
		magazine = null




/obj/item/weapon/powerarmor/weapon/ranged/proj/l6
	name = "mounted L6 SAW"
	desc = "A heavily modified light machine gun with a tactical plasteel frame resting on a rather traditionally-made ballistic weapon. Has 'Aussec Armoury - 2531' engraved on the reciever, as well as '7.62x51mm'."
	icon_state = "l6"
	origin_tech = "combat=5;materials=1;syndicate=2"
	w_class = 5

	shot_cost = 25
	gun_name = "L6 SAW"
	mag_type = /obj/item/ammo_box/magazine/m762
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'