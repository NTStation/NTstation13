
///////////////////////
//  ORGANIC EFFECTS  //
///////////////////////

//Simple datums designed to run code on a mob they are attached to
//or be used as a label for other code to check against
//Replaces old Mutations.

/datum/organic_effect
	var/effect_name = "Base"
	var/effect_desc = "Base Effect, Report to a coder if you see this"
	var/mob/living/carbon/owner //Owner of the effect
	var/happens_once = 0 //if this effect should fire and delete itself after
	var/auto_start = 0 //if this effect trigger()s on it's New()

/datum/organic_effect/New()
	..()
	if(auto_start)
		trigger()

/datum/organic_effect/proc/check_owner()
	if(owner)
		return 1
	return 0

/datum/organic_effect/proc/effect()
	return

/datum/organic_effect/proc/remove()
	if(owner)
		owner.organic_effects -= src
	qdel(src)

/datum/organic_effect/proc/trigger() //This is the proc other code should run 90% of the time.
	if(!check_owner())
		return
	effect()
	if(happens_once)
		remove()

////////////////
//  EXAMPLES: //
////////////////

//MAX HEALTH UP

//Note: This is not actually a good idea, I'm pretty sure all the UI code checks 200 as the max HP :S

/datum/organic_effect/max_health_up
	effect_name = "Bigger Heart"
	effect_desc = "Boosts a living being's Maximum health!"
	happens_once = 1
	auto_start = 1
	var/health_up = 20

/datum/organic_effect/max_health_up/effect()
	owner.maxHealth += health_up
	owner.health = owner.maxHealth

/datum/organic_effect/max_health_up/HP40
	health_up = 40




