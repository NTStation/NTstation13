/obj/effect/proc_holder/changeling/fleshmend
	name = "Fleshmend"
	desc = "Our flesh rapidly regenerates, healing our wounds and regrowing our limbs."
	helptext = "Heals a moderate amount of damage over a short period of time, regrows our limbs. Can be used while unconscious."
	chemical_cost = 30
	dna_cost = 1
	req_stat = UNCONSCIOUS

//Starts healing you every second for 10 seconds. Can be used whilst unconscious.
/obj/effect/proc_holder/changeling/fleshmend/sting_action(var/mob/living/user)
	user << "<span class='notice'>We begin to heal rapidly.</span>"

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		for(var/obj/item/organ/limb/L  in H.organs)
			if(L.state == ORGAN_REMOVED)
				L.state = ORGAN_FINE
				L.burn_dam = 0
				L.brute_dam = 0
				L.brutestate = 0
				L.burnstate = 0
				H.visible_message("<span class='danger'>[src] has regrown their [L.getDisplayName()]!</span>")

		H.regenerate_icons()
		H.update_canmove()


	spawn(0)
		for(var/i = 0, i<10,i++)
			user.adjustBruteLoss(-10)
			user.adjustOxyLoss(-10)
			user.adjustFireLoss(-10)
			sleep(10)

	feedback_add_details("changeling_powers","RR")
	return 1