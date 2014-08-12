/mob/living/carbon/verb/give()
	set category = "IC"
	set name = "Give"
	set src in view(1)
	if(src.stat == 2 || usr.stat == 2 || src.client == null)
		return
	if(src == usr)
		usr << "<span class='warning'>I feel stupider, suddenly.</span>"
		return
	var/obj/item/I
	if(!usr.hand && usr.r_hand == null)
		usr << "<span class='warning'>You don't have anything in your right hand to give to [src.name]</span>"
		return
	if(usr.hand && usr.l_hand == null)
		usr << "<span class='warning'>You don't have anything in your left hand to give to [src.name]</span>"
		return
	if(usr.hand)
		I = usr.l_hand
	else if(!usr.hand)
		I = usr.r_hand
	if(!I)
		return
	if(src.r_hand == null || src.l_hand == null)
		switch(alert(src,"[usr] wants to give you \a [I]?",,"Yes","No"))
			if("Yes")
				if(!I)
					return
				if(!Adjacent(usr))
					usr << "<span class='warning'>You need to stay in reaching distance while giving an object.</span>"
					src << "<span class='warning'>[usr.name] moved too far away.</span>"
					return
				if((usr.hand && usr.l_hand != I) || (!usr.hand && usr.r_hand != I))
					usr << "<span class='warning'>You need to keep the item in your active hand.</span>"
					src << "<span class='warning'>[usr.name] seem to have given up on giving \the [I.name] to you.</span>"
					return
				if(src.r_hand != null && src.l_hand != null)
					src << "<span class='warning'>Your hands are full.</span>"
					usr << "<span class='warning'>Their hands are full.</span>"
					return
				else
					var/obj/item/organ/limb/affecting = getlimb(/obj/item/organ/limb/r_arm)

					if(src.r_hand == null && affecting.state != ORGAN_REMOVED)
						r_hand = I
						usr.drop_item()
					else	
						affecting = getlimb(/obj/item/organ/limb/l_arm)
						if(l_hand == null && affecting.state != ORGAN_REMOVED)
							l_hand = I
							usr.drop_item()
						else
							src << "<span class='warning'>Your [affecting.getDisplayName()] is missing, so [usr.name] gave up!</span>"
							usr << "<span class='warning'>Their [affecting.getDisplayName()] is missing!</span>"
							return

				I.loc = src
				I.layer = 20
				I.add_fingerprint(src)
				src.update_inv_hands()
				usr.update_inv_hands()
				src.visible_message("<span class='notice'>[usr.name] handed \the [I.name] to [src.name].</span>")
			if("No")
				src.visible_message("<span class='warning'>[usr.name] tried to hand [I.name] to [src.name] but [src.name] didn't want it.</span>")
	else
		usr << "<span class='warning'>[src.name]'s hands are full.</span>"
