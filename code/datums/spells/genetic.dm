/obj/effect/proc_holder/spell/targeted/genetic
	name = "Genetic"
	desc = "This spell inflicts a set of mutations and disabilities upon the target."

	var/disabilities = 0 //bits
	var/list/mutations = list() //mutation strings
	var/duration = 100 //deciseconds
	/*
		Disabilities
			1st bit - ?
			2nd bit - ?
			3rd bit - ?
			4th bit - ?
			5th bit - ?
			6th bit - ?
	*/

/obj/effect/proc_holder/spell/targeted/genetic/cast(list/targets)
	for(var/mob/living/target in targets)
		for(var/OE_ADD in mutations)
			target.add_organic_effect(OE_ADD)

		target.disabilities |= disabilities
		target.update_mutations()	//update target's mutation overlays
		
		if(duration == -1) // Permanent effect, for badminous spells
			return  	   // (Honkius the Great approves!)
		
		spawn(duration)
			for(var/OE_REM in mutations)
				target.remove_organic_effect(OE_REM)
			target.disabilities &= ~disabilities
			target.update_mutations()

	return
