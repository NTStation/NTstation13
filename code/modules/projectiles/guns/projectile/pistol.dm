/obj/item/weapon/gun/projectile/automatic/silenced
	name = "silenced pistol"
	desc = "A small, quiet,  easily concealable gun. Uses .45 rounds."
	icon_state = "silenced_pistol"
	w_class = 3.0
	silenced = 1
	origin_tech = "combat=2;materials=2;syndicate=8"
	mag_type = /obj/item/ammo_box/magazine/sm45
	fire_sound = 'sound/weapons/Gunshot_silenced.ogg'

/obj/item/weapon/gun/projectile/automatic/silenced/update_icon()
	..()
	icon_state = "[initial(icon_state)]"
	return


/obj/item/weapon/gun/projectile/automatic/deagle
	name = "desert eagle"
	desc = "A robust handgun that uses .50 AE ammo."
	icon_state = "deagle"
	force = 14
	mag_type = /obj/item/ammo_box/magazine/m50

/obj/item/weapon/gun/projectile/automatic/deagle/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"]"

/obj/item/weapon/gun/projectile/automatic/deagle/gold
	desc = "A gold plated gun folded over a million times by superior martian gunsmiths. Uses .50 AE ammo."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/weapon/gun/projectile/automatic/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .50 AE ammo."
	icon_state = "deaglecamo"
	item_state = "deagleg"



/obj/item/weapon/gun/projectile/automatic/gyropistol
	name = "gyrojet pistol"
	desc = "A bulky pistol designed to fire self propelled rounds"
	icon_state = "gyropistol"
	fire_sound = 'sound/effects/Explosion1.ogg'
	origin_tech = "combat=3"
	mag_type = /obj/item/ammo_box/magazine/m75

/obj/item/weapon/gun/projectile/automatic/gyropistol/process_chamber(var/eject_casing = 0, var/empty_chamber = 1)
	..()

/obj/item/weapon/gun/projectile/automatic/gyropistol/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	..()
	if(!chambered && !get_ammo() && !alarmed)
		playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
		update_icon()
		alarmed = 1
	return

/obj/item/weapon/gun/projectile/automatic/gyropistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "loaded" : ""]"
	return

/obj/item/weapon/gun/projectile/automatic/pistol
	name = "\improper Stechkin pistol"
	desc = "A small, easily concealable handgun. Uses 10mm ammo and has a threaded barrel for silencers."
	icon_state = "pistol"
	w_class = 2
	silenced = 0
	origin_tech = "combat=2;materials=2;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/m10mm

/obj/item/weapon/gun/projectile/automatic/pistol/attack_hand(mob/user as mob)
	if(loc == user)
		if(silenced)
			silencer_attack_hand(user)
	..()

/obj/item/weapon/gun/projectile/automatic/pistol/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/silencer))
		silencer_attackby(I,user)
	..()

/obj/item/weapon/gun/projectile/automatic/pistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][silenced ? "-silencer" : ""][chambered ? "" : "-e"]"
	return


/obj/item/weapon/gun/projectile/automatic/deagle/m1911
	name = "\improper M1911"
	desc = "An M1911 pistol. Uses .45 ammo."
	icon_state = "m1911"
	force = 13.0
	origin_tech = "combat=4;materials=4"
	mag_type = /obj/item/ammo_box/magazine/sm45

/obj/item/weapon/gun/projectile/automatic/deagle/glock
	name = "glock"
	desc = "A glock pistol. Uses 9mm ammo."
	icon_state = "glock"
	force = 10.0
	origin_tech = "combat=4;materials=3"
	mag_type = /obj/item/ammo_box/magazine/m9mm

/obj/item/glockbarrel
	name = "handgun barrel"
	desc = "One third of a low-caliber handgun."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "glock1"
	m_amt = 400000 // expensive, will need an autolathe upgrade to hold enough metal to produce the barrel. this way you need cooperation between 3 departments to finish even 1.

/obj/item/glockconstruction
	name = "handgun barrel and grip"
	desc = "Two thirds of a low-caliber handgun."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "glockstep1"
	var/construction = 0

/obj/item/glockconstruction/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/glockslide))
		user << "You attach the slide to the gun."
		construction = 1
		del(W)
		icon_state = "glockstep2"
		name = "unfinished handgun"
		desc = "An almost finished handgun."
		return
	if(istype(W,/obj/item/weapon/screwdriver))
		if(construction)
			user << "You finish the handgun."
			new /obj/item/weapon/gun/projectile/automatic/deagle/glock(user.loc)
			del(src)
			return

/obj/item/glockbarrel/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/glockgrip))
		user << "You attach the grip to the barrel."
		new /obj/item/glockconstruction(user.loc)
		del(W)
		del(src)
		return

/obj/item/glockgrip
	name = "handgun grip"
	desc = "One third of a low-caliber handgun."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "glock2"

/obj/item/glockslide
	name = "handgun slide"
	desc = "One third of a low-caliber handgun."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "glock3"

/obj/item/weapon/silencer
	name = "silencer"
	desc = "A universal syndicate small-arms silencer."
	icon = 'icons/obj/gun.dmi'
	icon_state = "silencer"
	w_class = 2
	var/oldsound = 0 //Stores the true sound the gun made before it was silenced
