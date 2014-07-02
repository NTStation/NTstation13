/atom/proc/stat_button(var/name)
	return

/obj/effect/proc_holder/stat_button
	var/atom/parent

	New(var/loc, var/atom/parent, var/name)
		src.parent = parent
		src.name = name
		..()

	Click(object,location,control,params)
		var/mob/living/user = usr
		if(!istype(user))			return
		if(user.stat)				return

		parent.stat_button(name, params)