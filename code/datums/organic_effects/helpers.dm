
///////////////////////////
// HELPER PROCS FOR MOBS //
///////////////////////////

//PATH is a typepath of an organic_effect or a #define of a typepath

/mob/proc/has_organic_effect(var/PATH)

	for(var/datum/organic_effect/OE in organic_effects)
		if(istype(OE,PATH))
			return 1
	return 0

/mob/proc/get_organic_effect(var/PATH)
	if(!ispath(PATH))
		return null
	if(!has_organic_effect(PATH))
		return null
	for(var/datum/organic_effect/OE_CHECK in organic_effects)
		if(istype(OE_CHECK, PATH))
			return OE_CHECK

/mob/proc/remove_organic_effect(var/PATH)
	var/datum/organic_effect/REMOVE = get_organic_effect(PATH)
	if(REMOVE)
		REMOVE.remove()

/mob/proc/add_organic_effect(var/PATH)
	if(!ispath(PATH))
		return
	var/datum/organic_effect/OE = new PATH
	organic_effects += OE
	OE.owner = src



