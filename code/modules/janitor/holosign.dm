/obj/item/weapon/janitor/holosign_creator
	name = "\improper Holographic Sign Creator"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "signmaker"
	item_state = "electronic"
	desc = "A holographic sign creator that displays a Janitorial Sign."
	flags = CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	origin_tech = "programming=3"
/obj/item/weapon/janitor/holosign_creator/attack_self(mob/user as mob)
	..()
	user << "You create a holographic sign with the device."
	new /obj/item/weapon/janitor/caution/holograph(get_turf(user))
	return
/obj/item/weapon/janitor/caution // Old lame signs
	desc = "Caution! Wet Floor!"
	name = "wet floor sign"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "caution"
	force = 1.0
	throwforce = 3.0
	throw_speed = 2
	throw_range = 5
	w_class = 2.0
	attack_verb = list("warned", "cautioned", "smashed")

/obj/item/weapon/janitor/caution/cone
	desc = "This cone is trying to warn you of something!"
	name = "warning cone"
	icon_state = "cone"

/obj/item/weapon/janitor/caution/holograph
	desc = "The words flicker as if they mean nothing."
	name = "wet floor sign"
	icon_state = "holosign"
	anchored = 1

/obj/item/weapon/janitor/caution/holograph/attackby(obj/item/I, mob/user)
	..()
	if(istype(I, /obj/item/weapon/janitor/holosign_creator))
		user << "You use [I] to destroy [src]."
		del(src)