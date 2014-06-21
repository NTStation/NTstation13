/obj/item/stack/ziptie
	name = "zipties"
	singular_name = "ziptie"
	desc = "A plastic ziptie designed to be disposable and convenient."
	icon = 'icons/obj/items.dmi'
	amount = 5
	max_amount = 5
	w_class = 2
	throw_speed = 3
	throw_range = 7
	var/breakouttime = 300 //Deciseconds = 60s = 1 minute

/obj/item/weapon/handcuffs/attack(mob/living/carbon/C, mob/user)
	if(CLUMSY in user.mutations && prob(50))
		user << "<span class='warning'>Uh... how do those things work?!</span>"
		if(!C.handcuffed)
			user.drop_item()
			loc = C
			C.handcuffed = src
			C.update_inv_handcuffed(0)
			return

	if(!C.handcuffed)
		C.visible_message("<span class='danger'>[user] is trying to restrain [C] with a ziptie!</span>", \
							"<span class='userdanger'>[user] is trying to restrain [C] with a ziptie!</span>")

		playsound(loc, 'sound/weapons/cablecuff.ogg', 30, 1, -2)

		var/turf/user_loc = user.loc
		var/turf/C_loc = C.loc
		if(do_after(user, 30))
			if(!C || C.handcuffed)
				return
			if(user_loc == user.loc && C_loc == C.loc)
				user.drop_item()
				loc = C
				C.handcuffed = src
				C.update_inv_handcuffed(0)
			feedback_add_details("ziptie","C")

			add_logs(user, C, "ziptied")

/obj/item/stack/ziptie/cyborg/attack(mob/living/carbon/C, mob/user)
	if(isrobot(user))
		if(!C.handcuffed)
			playsound(loc, 'sound/weapons/cablecuff.ogg', 30, 1, -2)
			C.visible_message("<span class='danger'>[user] is trying to put handcuffs on [C]!</span>", \
								"<span class='userdanger'>[user] is trying to put handcuffs on [C]!</span>")
			if(do_mob(user, C, 30))
				if(C.handcuffed)
					return
				C.handcuffed = new /obj/item/stack/ziptie(C)
				C.update_inv_handcuffed(0)
		else
			C.visible_message("<span class='danger'>[user] tries to remove [C]'s zipties.</span>", \
							"<span class='notice'>[user] tries to remove [C]'s zipties.</span>")
			if(do_mob(user, C, 30))
				if(!C.handcuffed)
					return
				C.unEquip(C.handcuffed)