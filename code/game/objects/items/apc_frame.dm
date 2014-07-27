// FRAME
/obj/item/wall_frame
	name = "frame"
	flags = CONDUCT

/obj/item/wall_frame/proc/try_build(turf/on_wall)
	if (get_dist(on_wall,usr)>1)
		return
	var/ndir = get_dir(usr,on_wall)
	var/turf/loc = get_turf(usr)
	if (!(ndir in cardinal))
		return
	if (!istype(loc, /turf/simulated/floor))
		usr << "\red [src] cannot be placed on this spot."
		return
	var/area/A = loc.loc
	if (A.requires_power == 0 || istype(A, /area/space))
		usr << "\red [src] cannot be placed in this area."
		return
	if(gotwallitem(loc, ndir))
		usr << "\red There's already an item on this wall!"
		return

	return 1



// APC HULL
/obj/item/wall_frame/apc
	name = "\improper APC frame"
	desc = "Used for repairing or building APCs"
	icon = 'icons/obj/apc_repair.dmi'
	icon_state = "apc_frame"

/obj/item/wall_frame/apc/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/stack/sheet/metal( get_turf(src.loc), 2 )
		qdel(src)

/obj/item/wall_frame/apc/try_build(turf/on_wall)
	if(!..())
		return
	var/ndir = get_dir(usr,on_wall)
	var/turf/loc = get_turf(usr)
	var/area/A = loc.loc
	if (A.get_apc())
		usr << "\red This area already has APC."
		return //only one APC per area
	for(var/obj/machinery/power/terminal/T in loc)
		if (T.master)
			usr << "\red There is another network terminal here."
			return
		else
			var/obj/item/stack/cable_coil/C = new /obj/item/stack/cable_coil(loc)
			C.amount = 10
			usr << "You cut the cables and disassemble the unused power terminal."
			qdel(T)
	new /obj/machinery/power/apc(loc, ndir, 1)
	qdel(src)
