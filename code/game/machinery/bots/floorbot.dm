//Floorbot assemblies
/obj/item/weapon/toolbox_tiles
	desc = "It's a toolbox with tiles sticking out the top"
	name = "tiles and toolbox"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "toolbox_tiles"
	force = 3.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 5
	w_class = 3.0
	var/created_name = "Floorbot"

/obj/item/weapon/toolbox_tiles_sensor
	desc = "It's a toolbox with tiles sticking out the top and a sensor attached"
	name = "tiles, toolbox and sensor arrangement"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "toolbox_tiles_sensor"
	force = 3.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 5
	w_class = 3.0
	var/created_name = "Floorbot"

//Floorbot
/obj/machinery/bot/floorbot
	name = "\improper Floorbot"
	desc = "A little floor repairing robot, he looks so excited!"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "floorbot0"
	layer = 5.0
	density = 0
	anchored = 0
	health = 25
	maxhealth = 25
	//weight = 1.0E7
	var/amount = 10
	var/improvefloors = 0
	var/eattiles = 0
	var/maketiles = 0
	var/turf/target
	var/turf/oldtarget
	var/oldloc = null
	req_access = list(access_construction)
	var/targetdirection


/obj/machinery/bot/floorbot/New()
	..()
	updateicon()

/obj/machinery/bot/floorbot/turn_on()
	. = ..()
	updateicon()
	updateUsrDialog()

/obj/machinery/bot/floorbot/turn_off()
	..()
	target = null
	oldtarget = null
	oldloc = null
	updateicon()
	path = new()
	updateUsrDialog()

/obj/machinery/bot/floorbot/attack_hand(mob/user as mob)
	. = ..()
	if (.)
		return
	usr.set_machine(src)
	interact(user)

/obj/machinery/bot/floorbot/interact(mob/user as mob)
	var/dat
	dat += hack(user)
	dat += "<TT><B>Automatic Station Floor Repairer v1.0</B></TT><BR><BR>"
	dat += "Status: <A href='?src=\ref[src];operation=start'>[on ? "On" : "Off"]</A><BR>"
	dat += "Maintenance panel panel is [open ? "opened" : "closed"]<BR>"
	dat += "Tiles left: [amount]<BR>"
	dat += "Behvaiour controls are [locked ? "locked" : "unlocked"]<BR>"
	if(!locked || issilicon(user))
		dat += "Improves floors: <A href='?src=\ref[src];operation=improve'>[improvefloors ? "Yes" : "No"]</A><BR>"
		dat += "Finds tiles: <A href='?src=\ref[src];operation=tiles'>[eattiles ? "Yes" : "No"]</A><BR>"
		dat += "Make singles pieces of metal into tiles when empty: <A href='?src=\ref[src];operation=make'>[maketiles ? "Yes" : "No"]</A><BR>"
		var/bmode
		if (targetdirection)
			bmode = dir2text(targetdirection)
		else
			bmode = "Disabled"
		dat += "<BR><BR>Bridge Mode : <A href='?src=\ref[src];operation=bridgemode'>[bmode]</A><BR>"

	user << browse("<HEAD><TITLE>Repairbot v1.0 controls</TITLE></HEAD>[dat]", "window=autorepair")
	onclose(user, "autorepair")
	return


/obj/machinery/bot/floorbot/attackby(var/obj/item/W , mob/user as mob)
	if(istype(W, /obj/item/stack/tile/plasteel))
		var/obj/item/stack/tile/plasteel/T = W
		if(amount >= 50)
			return
		var/loaded = min(50-amount, T.amount)
		T.use(loaded)
		amount += loaded
		user << "<span class='notice'>You load [loaded] tiles into the floorbot. He now contains [amount] tiles.</span>"
		updateicon()
	else if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))
		if(allowed(usr) && !open && !emagged)
			locked = !locked
			user << "<span class='notice'>You [locked ? "lock" : "unlock"] the [src] behaviour controls.</span>"
		else
			if(emagged)
				user << "<span class='warning'>ERROR</span>"
			if(open)
				user << "<span class='warning'>Please close the access panel before locking it.</span>"
			else
				user << "<span class='warning'>Access denied.</span>"
		updateUsrDialog()
	else
		..()

/obj/machinery/bot/floorbot/Emag(mob/user as mob)
	..()
	if(open && !locked)
		if(user) user << "<span class='notice'>The [src] buzzes and beeps.</span>"

/obj/machinery/bot/floorbot/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	switch(href_list["operation"])
		if("start")
			if (on && !emagged)
				turn_off()
			else
				turn_on()
		if("improve")
			improvefloors = !improvefloors
			updateUsrDialog()
		if("tiles")
			eattiles = !eattiles
			updateUsrDialog()
		if("make")
			maketiles = !maketiles
			updateUsrDialog()
		if("hack")
			if(!emagged)
				emagged = 2
				hacked = 1
				usr << "<span class='warning'>You corrupt [src]'s construction protocols.</span>"
			else if(!hacked)
				usr << "<span class='userdanger'>[src] is not responding to reset commands!</span>"
			else
				emagged = 0
				hacked = 0
				usr << "<span class='notice'>You detect errors in [src] and reset its programming.</span>"
			updateUsrDialog()
		if("bridgemode")
			switch(targetdirection)
				if(null)
					targetdirection = 1
				if(1)
					targetdirection = 2
				if(2)
					targetdirection = 4
				if(4)
					targetdirection = 8
				if(8)
					targetdirection = null
				else
					targetdirection = null
			updateUsrDialog()

/obj/machinery/bot/floorbot/process()
	set background = BACKGROUND_ENABLED

	if(!on)
		return
	if(busy == BOT_REPAIRING)
		return
	if(call_path)
		if(!pathset)
			target = null
			oldtarget = null
			oldloc = null
			set_path()
		else
			move_to_call(path)
			sleep(5)
			move_to_call(path)
		return

	var/list/floorbottargets = list()
	if(amount <= 0 && ((target == null) || !target))
		if(eattiles)
			for(var/obj/item/stack/tile/plasteel/T in view(7, src))
				if(T != oldtarget && !(target in floorbottargets))
					oldtarget = T
					target = T
					break
		if(target == null || !target)
			if(maketiles)
				if(target == null || !target)
					for(var/obj/item/stack/sheet/metal/M in view(7, src))
						if(!(M in floorbottargets) && M != oldtarget && M.amount == 1 && !(istype(M.loc, /turf/simulated/wall)))
							oldtarget = M
							target = M
							break
		else
			return
	if(prob(5))
		visible_message("[src] makes an excited booping beeping sound!")

	if((!target || target == null) && emagged < 2)
		if(targetdirection != null)
			/*
			for (var/turf/space/D in view(7,src))
				if(!(D in floorbottargets) && D != oldtarget)			// Added for bridging mode
					if(get_dir(src, D) == targetdirection)
						oldtarget = D
						target = D
						break
			*/
			var/turf/T = get_step(src, targetdirection)
			if(istype(T, /turf/space))
				oldtarget = T
				target = T
		if(!target || target == null)
			for (var/turf/space/D in view(7,src))
				if(!(D in floorbottargets) && D != oldtarget && (D.loc.name != "Space"))
					oldtarget = D
					target = D
					break
		if((!target || target == null ) && improvefloors)
			for (var/turf/simulated/floor/F in view(7,src))
				if(!(F in floorbottargets) && F != oldtarget && F.icon_state == "Floor1" && !(istype(F, /turf/simulated/floor/plating)))
					oldtarget = F
					target = F
					break
		if((!target || target == null) && eattiles)
			for(var/obj/item/stack/tile/plasteel/T in view(7, src))
				if(!(T in floorbottargets) && T != oldtarget)
					oldtarget = T
					target = T
					break

	if((!target || target == null) && emagged == 2)
		if(!target || target == null)
			for (var/turf/simulated/floor/D in view(7,src))
				if(!(D in floorbottargets) && D != oldtarget && D.floor_tile)
					oldtarget = D
					target = D
					break

	if(!target || target == null)
		if(loc != oldloc)
			oldtarget = null
		return

	if(target && (target != null) && path.len == 0)
		spawn(0)
			if(!istype(target, /turf/))
				var/turf/TL = get_turf(target)
				path = AStar(loc, TL, /turf/proc/AdjacentTurfsSpace, /turf/proc/Distance, 0, 30)
			else
				path = AStar(loc, target, /turf/proc/AdjacentTurfsSpace, /turf/proc/Distance, 0, 30)
			if(!path)
				path = list()
			if(path.len == 0)
				oldtarget = target
				target = null
		return
	if(path.len > 0 && target && (target != null))
		step_to(src, path[1])
		path -= path[1]
	else if(path.len == 1)
		step_to(src, target)
		path = new()

	if(loc == target || loc == target.loc)
		if(istype(target, /obj/item/stack/tile/plasteel))
			eattile(target)
		else if(istype(target, /obj/item/stack/sheet/metal))
			maketile(target)
		else if(istype(target, /turf/) && emagged < 2)
			repair(target)
		else if(emagged == 2 && istype(target,/turf/simulated/floor))
			var/turf/simulated/floor/F = target
			anchored = 1
			busy = BOT_REPAIRING
			if(prob(90))
				F.break_tile_to_plating()
			else
				F.ReplaceWithLattice()
			visible_message("\red [src] makes an excited booping sound.")
			spawn(50)
				amount ++
				anchored = 0
				busy = 0
				target = null
		path = new()
		return

	oldloc = loc


/obj/machinery/bot/floorbot/proc/repair(var/turf/target)
	if(istype(target, /turf/space/))
		if(target.loc.name == "Space")
			return
	else if(!istype(target, /turf/simulated/floor))
		return
	if(amount <= 0)
		return
	anchored = 1
	icon_state = "floorbot-c"
	if(istype(target, /turf/space/))
		visible_message("\red [src] begins to repair the hole")
		var/obj/item/stack/tile/plasteel/T = new /obj/item/stack/tile/plasteel
		busy = BOT_REPAIRING
		spawn(50)
			T.build(loc)
			busy = 0
			amount -= 1
			updateicon()
			anchored = 0
			target = null
	else
		visible_message("\red [src] begins to improve the floor.")
		busy = BOT_REPAIRING
		spawn(50)
			loc.icon_state = "floor"
			busy = 0
			amount -= 1
			updateicon()
			anchored = 0
			target = null

/obj/machinery/bot/floorbot/proc/eattile(var/obj/item/stack/tile/plasteel/T)
	if(!istype(T, /obj/item/stack/tile/plasteel))
		return
	visible_message("\red [src] begins to collect tiles.")
	busy = BOT_REPAIRING
	spawn(20)
		if(isnull(T))
			target = null
			busy = 0
			return
		if(amount + T.amount > 50)
			var/i = 50 - amount
			amount += i
			T.amount -= i
		else
			amount += T.amount
			qdel(T)
		updateicon()
		target = null
		busy = 0

/obj/machinery/bot/floorbot/proc/maketile(var/obj/item/stack/sheet/metal/M)
	if(!istype(M, /obj/item/stack/sheet/metal))
		return
	if(M.amount > 1)
		return
	visible_message("\red [src] begins to create tiles.")
	busy = BOT_REPAIRING
	spawn(20)
		if(isnull(M))
			target = null
			busy = 0
			return
		var/obj/item/stack/tile/plasteel/T = new /obj/item/stack/tile/plasteel
		T.amount = 4
		T.loc = M.loc
		qdel(M)
		target = null
		busy = 0

/obj/machinery/bot/floorbot/proc/updateicon()
	if(amount > 0)
		icon_state = "floorbot[on]"
	else
		icon_state = "floorbot[on]e"

/obj/machinery/bot/floorbot/explode()
	on = 0
	visible_message("\red <B>[src] blows apart!</B>", 1)
	var/turf/Tsec = get_turf(src)

	var/obj/item/weapon/storage/toolbox/mechanical/N = new /obj/item/weapon/storage/toolbox/mechanical(Tsec)
	N.contents = list()

	new /obj/item/device/assembly/prox_sensor(Tsec)

	if (prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	while (amount)//Dumps the tiles into the appropriate sized stacks
		if(amount >= 16)
			var/obj/item/stack/tile/plasteel/T = new (Tsec)
			T.amount = 16
			amount -= 16
		else
			var/obj/item/stack/tile/plasteel/T = new (Tsec)
			T.amount = amount
			amount = 0

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return


/obj/item/weapon/storage/toolbox/mechanical/attackby(var/obj/item/stack/tile/plasteel/T, mob/user as mob)
	if(!istype(T, /obj/item/stack/tile/plasteel))
		..()
		return
	if(contents.len >= 1)
		user << "<span class='notice'>They wont fit in as there is already stuff inside.</span>"
		return
	if(user.s_active)
		user.s_active.close(user)
	qdel(T)
	var/obj/item/weapon/toolbox_tiles/B = new /obj/item/weapon/toolbox_tiles
	user.put_in_hands(B)
	user << "<span class='notice'>You add the tiles into the empty toolbox. They protrude from the top.</span>"
	user.unEquip(src, 1)
	qdel(src)

/obj/item/weapon/toolbox_tiles/attackby(var/obj/item/W, mob/user as mob)
	..()
	if(isprox(W))
		qdel(W)
		var/obj/item/weapon/toolbox_tiles_sensor/B = new /obj/item/weapon/toolbox_tiles_sensor()
		B.created_name = created_name
		user.put_in_hands(B)
		user << "<span class='notice'>You add the sensor to the toolbox and tiles!</span>"
		user.unEquip(src, 1)
		qdel(src)

	else if (istype(W, /obj/item/weapon/pen))
		var/t = copytext(stripped_input(user, "Enter new robot name", name, created_name),1,MAX_NAME_LEN)
		if (!t)
			return
		if (!in_range(src, usr) && loc != usr)
			return

		created_name = t

/obj/item/weapon/toolbox_tiles_sensor/attackby(var/obj/item/W, mob/user as mob)
	..()
	if(istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm))
		qdel(W)
		var/turf/T = get_turf(user.loc)
		var/obj/machinery/bot/floorbot/A = new /obj/machinery/bot/floorbot(T)
		A.name = created_name
		user << "<span class='notice'>You add the robot arm to the odd looking toolbox assembly! Boop beep!</span>"
		user.unEquip(src, 1)
		qdel(src)
	else if (istype(W, /obj/item/weapon/pen))
		var/t = stripped_input(user, "Enter new robot name", name, created_name)

		if (!t)
			return
		if (!in_range(src, usr) && loc != usr)
			return

		created_name = t