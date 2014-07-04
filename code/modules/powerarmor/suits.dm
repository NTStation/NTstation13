/obj/item/clothing/suit/powered/full
	helmrequired = 1

/obj/item/clothing/suit/powered/full/New()
	atmoseal = new /obj/item/weapon/powerarmor/atmoseal/optional/standart(src)
	atmoseal.add_to(src)
	..()


/obj/item/clothing/suit/powered/syndie
	shoesrequired = 1

/obj/item/clothing/suit/powered/syndie/New()
	..()
	var/obj/item/weapon/powerarmor/C = new /obj/item/weapon/powerarmor/servos(src)
	C.add_to(src)
	subsystems.Add(C)

	reactive = new /obj/item/weapon/powerarmor/reactive/centcomm(src)
	reactive.add_to(src)

	C = new /obj/item/weapon/powerarmor/medinj(src)
	C.add_to(src)
	subsystems.Add(C)

	meele = new /obj/item/weapon/powerarmor/weapon/meele/pneumatic(src)
	meele.add_to(src)

	ranged_r = new /obj/item/weapon/powerarmor/weapon/ranged/proj/l6(src)
	ranged_r.add_to(src)

	ranged_l = new /obj/item/weapon/powerarmor/weapon/ranged/proj(src)
	ranged_l.add_to(src)
	var/obj/item/weapon/powerarmor/weapon/ranged/proj/P = ranged_l
	var/obj/item/weapon/gun/projectile/automatic/powersuit/gun = P.gun
	del(gun.chambered)
	gun.magazine = new /obj/item/ammo_box/magazine/m12g/dragon(gun)
	gun.process_chamber()

/obj/item/clothing/suit/powered/syndie/supercell/New()
	..()
	powercell = new /obj/item/weapon/stock_parts/cell/super(src)

/*
// HEV
/obj/item/clothing/suit/powered/spawnable/hev
	name = "HEV"
	icon_state = "HEVsuit"


// BATMAN
/obj/item/clothing/suit/powered/spawnable/full/batman
	name = "batsuit"
	icon_state = "batmansuit"

/obj/item/clothing/head/powered/spawnable/batman
	name = "batmask"
	icon_state = "batmanmask"
	brightness_on = 0
*/


/obj/item/clothing/head/powered/stealth
	icon_state = "rig0-stealth"
	item_color = "stealth"

/obj/item/clothing/suit/powered/full/stealth
	icon_state = "stealth"




/obj/item/clothing/head/powered/dark
	icon_state = "rig0-dark"
	item_color = "dark"

/obj/item/clothing/suit/powered/full/dark
	icon_state = "dark"



/obj/item/clothing/head/powered/mining
	icon_state = "rig0-engicold"
	item_color = "engicold"
	armor = list(melee = 5, bullet = 5, laser = 5, energy = 5, bomb = 5, bio = 10, rad = 15)

/obj/item/clothing/suit/powered/full/mining
	icon_state = "cryo-engineering"
	shoesrequired = 1
	slowdown = 7
	armor = list(melee = 5, bullet = 5, laser = 5, energy = 5, bomb = 5, bio = 10, rad = 15)

/obj/item/clothing/suit/powered/full/mining/New()
	..()
	var/obj/item/weapon/powerarmor/C = new /obj/item/weapon/powerarmor/servos/cheap(src)
	C.add_to(src)
	subsystems.Add(C)

	reactive = new /obj/item/weapon/powerarmor/reactive/standard(src)
	reactive.add_to(src)