/obj/machinery/bot/secbot
	name = "\improper Securitron"
	desc = "A little security robot.  He looks less than thrilled."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "secbot0"
	layer = 5.0
	density = 0
	anchored = 0
	health = 25
	maxhealth = 25
	fire_dam_coeff = 0.7
	brute_dam_coeff = 0.5
//	weight = 1.0E7
	req_one_access = list(access_security, access_forensics_lockers)
	var/mob/living/carbon/target
	var/oldtarget_name
	var/threatlevel = 0
	var/target_lastloc //Loc of target when arrested.
	var/last_found //There's a delay
	var/frustration = 0
//	var/emagged = 0 //Emagged Secbots view everyone as a criminal
	var/idcheck = 0 //If false, all station IDs are authorized for weapons.
	var/check_records = 1 //Does it check security records?
	var/arrest_type = 0 //If true, don't handcuff
	var/mode = 0
	var/auto_patrol = 0		// set to make bot automatically patrol

	var/beacon_freq = 1445		// navigation beacon frequency
	var/control_freq = 1447		// bot control frequency

	//List of weapons that secbots will not arrest for
	var/safe_weapons = list(\
		/obj/item/weapon/gun/energy/laser/bluetag,\
		/obj/item/weapon/gun/energy/laser/redtag,\
		/obj/item/weapon/gun/energy/laser/practice)

	var/turf/patrol_target	// this is turf to navigate to (location of beacon)
	var/new_destination		// pending new destination (waiting for beacon response)
	var/destination			// destination description tag
	var/next_destination	// the next destination in the patrol route

	var/blockcount = 0		//number of times retried a blocked path
	var/awaiting_beacon	= 0	// count of pticks awaiting a beacon response

	var/nearest_beacon			// the nearest beacon's tag
	var/turf/nearest_beacon_loc	// the nearest beacon's location


/obj/machinery/bot/secbot/beepsky
	name = "Officer Beep O'sky"
	desc = "It's Officer Beep O'sky! Powered by a potato and a shot of whiskey."
	idcheck = 0
	auto_patrol = 1

/obj/item/weapon/secbot_assembly
	name = "helmet/signaler assembly"
	desc = "Some sort of bizarre assembly."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "helmet_signaler"
	item_state = "helmet"
	var/build_step = 0
	var/created_name = "Securitron" //To preserve the name if it's a unique securitron I guess



/obj/machinery/bot/secbot
	New()
		..()
		icon_state = "secbot[on]"
		spawn(3)
			var/datum/job/detective/J = new/datum/job/detective
			botcard.access = J.get_access()
			if(radio_controller)
				radio_controller.add_object(src, control_freq, filter = RADIO_SECBOT)
				radio_controller.add_object(src, beacon_freq, filter = RADIO_NAVBEACONS)


/obj/machinery/bot/secbot/turn_on()
	..()
	icon_state = "secbot[on]"
	updateUsrDialog()

/obj/machinery/bot/secbot/turn_off()
	..()
	target = null
	oldtarget_name = null
	anchored = 0
	mode = BOT_IDLE
	walk_to(src,0)
	icon_state = "secbot[on]"
	updateUsrDialog()

/obj/machinery/bot/secbot/attack_hand(mob/user as mob)
	. = ..()
	if(.)
		return
	usr.set_machine(src)
	interact(user)

/obj/machinery/bot/secbot/interact(mob/user as mob)
	var/dat
	dat += hack(user)
	dat += text({"
<TT><B>Automatic Security Unit v1.3</B></TT><BR><BR>
Status: []<BR>
Behaviour controls are [locked ? "locked" : "unlocked"]<BR>
Maintenance panel panel is [open ? "opened" : "closed"]"},

"<A href='?src=\ref[src];power=1'>[on ? "On" : "Off"]</A>" )

	if(!locked || issilicon(user))
		dat += text({"<BR>
Check for Weapon Authorization: []<BR>
Check Security Records: []<BR>
Operating Mode: []<BR>
Auto Patrol: []"},

"<A href='?src=\ref[src];operation=idcheck'>[idcheck ? "Yes" : "No"]</A>",
"<A href='?src=\ref[src];operation=ignorerec'>[check_records ? "Yes" : "No"]</A>",
"<A href='?src=\ref[src];operation=switchmode'>[arrest_type ? "Detain" : "Arrest"]</A>",
"<A href='?src=\ref[src];operation=patrol'>[auto_patrol ? "On" : "Off"]</A>" )


	user << browse("<HEAD><TITLE>Securitron v1.3 controls</TITLE></HEAD>[dat]", "window=autosec")
	onclose(user, "autosec")
	return

/obj/machinery/bot/secbot/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	if((href_list["power"]) && (allowed(usr)))
		if (on && !emagged)
			turn_off()
		else
			turn_on()
		return

	switch(href_list["operation"])
		if("idcheck")
			idcheck = !idcheck
			updateUsrDialog()
		if("ignorerec")
			check_records = !check_records
			updateUsrDialog()
		if("switchmode")
			arrest_type = !arrest_type
			updateUsrDialog()
		if("patrol")
			auto_patrol = !auto_patrol
			mode = BOT_IDLE
			updateUsrDialog()
		if("hack")
			if(!emagged)
				emagged = 2
				hacked = 1
				usr << "<span class='warning'>You overload [src]'s target identification system.</span>"
			else if(!hacked)
				usr << "<span class='userdanger'>[src] refuses to accept your authority!</span>"
			else
				emagged = 0
				hacked = 0
				usr << "<span class='notice'>You reboot [src] and restore the target identification.</span>"
			updateUsrDialog()

/obj/machinery/bot/secbot/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))
		if(allowed(user) && !open && !emagged)
			locked = !locked
			user << "Controls are now [locked ? "locked." : "unlocked."]"
		else
			if(emagged)
				user << "<span class='warning'>ERROR</span>"
			if(open)
				user << "\red Please close the access panel before locking it."
			else
				user << "\red Access denied."
	else
		..()
		if(!istype(W, /obj/item/weapon/screwdriver) && !istype(W, /obj/item/weapon/weldingtool) && (W.force) && (!target)) // Added check for welding tool to fix #2432. Welding tool behavior is handled in superclass.
			target = user
			mode = BOT_HUNT

/obj/machinery/bot/secbot/Emag(mob/user as mob)
	..()
	if(open && !locked)
		if(user) user << "\red You short out [src]'s target assessment circuits."
		spawn(0)
			for(var/mob/O in hearers(src, null))
				O.show_message("\red <B>[src] buzzes oddly!</B>", 1)
		target = null
		if(user) oldtarget_name = user.name
		last_found = world.time
		anchored = 0
		emagged = 2
		on = 1
		icon_state = "secbot[on]"
		mode = BOT_IDLE

/obj/machinery/bot/secbot/process()
	set background = BACKGROUND_ENABLED

	if(!on)
		return
	if(call_path)
		if(!pathset)
			set_path()
			target = null
			oldtarget_name = null
			anchored = 0
			mode = BOT_IDLE
			walk_to(src,0)
		else
			move_to_call()
			sleep(5)
			move_to_call()
		return

	switch(mode)

		if(BOT_IDLE)		// idle

			walk_to(src,0)
			look_for_perp()	// see if any criminals are in range
			if(!mode && auto_patrol)	// still idle, and set to patrol
				mode = BOT_START_PATROL	// switch to patrol mode

		if(BOT_HUNT)		// hunting for perp

			// if can't reach perp for long enough, go idle
			if(frustration >= 8)
		//		for(var/mob/O in hearers(src, null))
		//			O << "<span class='game say'><span class='name'>[src]</span> beeps, \"Backup requested! Suspect has evaded arrest.\""
				target = null
				last_found = world.time
				frustration = 0
				mode = 0
				walk_to(src,0)

			if(target)		// make sure target exists
				if(Adjacent(target) && isturf(target.loc))				// if right next to perp
					playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
					icon_state = "secbot-c"
					spawn(2)
						icon_state = "secbot[on]"
					var/mob/living/carbon/M = target
					var/maxstuns = 4
					if(istype(M, /mob/living/carbon/human))
						if(M.stuttering < 10 && (!(HULK in M.mutations)))
							M.stuttering = 10
						M.Stun(10)
						M.Weaken(10)
					else
						M.Weaken(10)
						M.stuttering = 10
						M.Stun(10)
					maxstuns--
					if(maxstuns <= 0)
						target = null
					visible_message("\red <B>[target] has been stunned by [src]!</B>")

					mode = BOT_PREP_ARREST
					anchored = 1
					target_lastloc = M.loc
					return

				else								// not next to perp
					var/turf/olddist = get_dist(src, target)
					walk_to(src, target,1,4)
					if((get_dist(src, target)) >= (olddist))
						frustration++
					else
						frustration = 0

		if(BOT_PREP_ARREST)		// preparing to arrest target

			// see if he got away
			if((get_dist(src, target) > 1) || ((target:loc != target_lastloc) && target:weakened < 2))
				anchored = 0
				mode = BOT_HUNT
				return

			if(iscarbon(target) && target.canBeHandcuffed())
				if(!target.handcuffed && !arrest_type)
					playsound(loc, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
					mode = BOT_ARREST
					visible_message("\red <B>[src] is trying to put handcuffs on [target]!</B>")

					spawn(60)
						if(get_dist(src, target) <= 1)
							if(target.handcuffed)
								return

							if(istype(target,/mob/living/carbon))
								target.handcuffed = new /obj/item/weapon/handcuffs(target)
								target.update_inv_handcuffed(0)	//update the handcuffs overlay

							mode = BOT_IDLE
							target = null
							anchored = 0
							last_found = world.time
							frustration = 0

							playsound(loc, pick('sound/voice/bgod.ogg', 'sound/voice/biamthelaw.ogg', 'sound/voice/bsecureday.ogg', 'sound/voice/bradio.ogg', 'sound/voice/binsult.ogg', 'sound/voice/bcreep.ogg'), 50, 0)
		//					var/arrest_message = pick("Have a secure day!","I AM THE LAW.", "God made tomorrow for the crooks we don't catch today.","You can't outrun a radio.")
		//					speak(arrest_message)
			else
				mode = BOT_IDLE
				target = null
				anchored = 0
				last_found = world.time
				frustration = 0

		if(BOT_ARREST)		// arresting

			if(!target || target.handcuffed)
				anchored = 0
				mode = BOT_IDLE
				return


		if(BOT_START_PATROL)	// start a patrol

			if(path.len > 0 && patrol_target)	// have a valid path, so just resume
				mode = BOT_PATROL
				return

			else if(patrol_target)		// has patrol target already
				spawn(0)
					calc_path()		// so just find a route to it
					if(path.len == 0)
						patrol_target = 0
						return
					mode = BOT_PATROL


			else					// no patrol target, so need a new one
				find_patrol_target()
				speak("Engaging patrol mode.")


		if(BOT_PATROL)		// patrol mode

			patrol_step()
			spawn(5)
				if(mode == BOT_PATROL)
					patrol_step()

		if(BOT_SUMMON)		// summoned to PDA
			patrol_step()
			spawn(4)
				if(mode == BOT_SUMMON)
					patrol_step()
					sleep(4)
					patrol_step()
	busy = mode
	return


// perform a single patrol step

/obj/machinery/bot/secbot/proc/patrol_step()

	if(loc == patrol_target)		// reached target
		at_patrol_target()
		return

	else if(path.len > 0 && patrol_target)		// valid path

		var/turf/next = path[1]
		if(next == loc)
			path -= next
			return


		if(istype( next, /turf/simulated))

			var/moved = step_towards(src, next)	// attempt to move
			if(moved)	// successful move
				blockcount = 0
				path -= loc

				look_for_perp()
			else		// failed to move

				blockcount++

				if(blockcount > 5)	// attempt 5 times before recomputing
					// find new path excluding blocked turf

					spawn(2)
						calc_path(next)
						if(path.len == 0)
							find_patrol_target()
						else
							blockcount = 0

					return

				return

		else	// not a valid turf
			mode = BOT_IDLE
			return

	else	// no path, so calculate new one
		mode = BOT_START_PATROL


// finds a new patrol target
/obj/machinery/bot/secbot/proc/find_patrol_target()
	send_status()
	if(awaiting_beacon)			// awaiting beacon response
		awaiting_beacon++
		if(awaiting_beacon > 5)	// wait 5 secs for beacon response
			find_nearest_beacon()	// then go to nearest instead
		return

	if(next_destination)
		set_destination(next_destination)
	else
		find_nearest_beacon()
	return


// finds the nearest beacon to self
// signals all beacons matching the patrol code
/obj/machinery/bot/secbot/proc/find_nearest_beacon()
	nearest_beacon = null
	new_destination = "__nearest__"
	post_signal(beacon_freq, "findbeacon", "patrol")
	awaiting_beacon = 1
	spawn(10)
		awaiting_beacon = 0
		if(nearest_beacon)
			set_destination(nearest_beacon)
		else
			auto_patrol = 0
			mode = BOT_IDLE
			speak("Disengaging patrol mode.")
			send_status()


/obj/machinery/bot/secbot/proc/at_patrol_target()
	find_patrol_target()
	return


// sets the current destination
// signals all beacons matching the patrol code
// beacons will return a signal giving their locations
/obj/machinery/bot/secbot/proc/set_destination(var/new_dest)
	new_destination = new_dest
	post_signal(beacon_freq, "findbeacon", "patrol")
	awaiting_beacon = 1


// receive a radio signal
// used for beacon reception

/obj/machinery/bot/secbot/receive_signal(datum/signal/signal)
	//log_admin("DEBUG \[[world.timeofday]\]: /obj/machinery/bot/secbot/receive_signal([signal.debug_print()])")
	if(!on)
		return

	/*
	world << "rec signal: [signal.source]"
	for(var/x in signal.data)
		world << "* [x] = [signal.data[x]]"
	*/

	var/recv = signal.data["command"]
	// process all-bot input
	if(recv=="bot_status")
		send_status()

	// check to see if we are the commanded bot
	if(signal.data["active"] == src)
	// process control input
		switch(recv)
			if("stop")
				mode = BOT_IDLE
				auto_patrol = 0
				return

			if("go")
				mode = BOT_IDLE
				auto_patrol = 1
				return

			if("summon")
				patrol_target = signal.data["target"]
				next_destination = destination
				destination = null
				awaiting_beacon = 0
				mode = BOT_SUMMON
				calc_path()
				speak("Responding.")

				return



	// receive response from beacon
	recv = signal.data["beacon"]
	var/valid = signal.data["patrol"]
	if(!recv || !valid)
		return

	if(recv == new_destination)	// if the recvd beacon location matches the set destination
								// the we will navigate there
		destination = new_destination
		patrol_target = signal.source.loc
		next_destination = signal.data["next_patrol"]
		awaiting_beacon = 0

	// if looking for nearest beacon
	else if(new_destination == "__nearest__")
		var/dist = get_dist(src,signal.source.loc)
		if(nearest_beacon)

			// note we ignore the beacon we are located at
			if(dist>1 && dist<get_dist(src,nearest_beacon_loc))
				nearest_beacon = recv
				nearest_beacon_loc = signal.source.loc
				return
			else
				return
		else if(dist > 1)
			nearest_beacon = recv
			nearest_beacon_loc = signal.source.loc
	return


// send a radio signal with a single data key/value pair
/obj/machinery/bot/secbot/proc/post_signal(var/freq, var/key, var/value)
	post_signal_multiple(freq, list("[key]" = value) )

// send a radio signal with multiple data key/values
/obj/machinery/bot/secbot/proc/post_signal_multiple(var/freq, var/list/keyval)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(freq)

	if(!frequency) return

	var/datum/signal/signal = new()
	signal.source = src
	signal.transmission_method = 1
	//for(var/key in keyval)
	//	signal.data[key] = keyval[key]
	signal.data = keyval
		//world << "sent [key],[keyval[key]] on [freq]"
	if(signal.data["findbeacon"])
		frequency.post_signal(src, signal, filter = RADIO_NAVBEACONS)
	else if(signal.data["type"] == "secbot")
		frequency.post_signal(src, signal, filter = RADIO_SECBOT)
	else
		frequency.post_signal(src, signal)

// signals bot status etc. to controller
/obj/machinery/bot/secbot/proc/send_status()
	var/list/kv = list(
	"type" = "secbot",
	"name" = name,
	"loca" = loc.loc,	// area
	"mode" = mode
	)
	post_signal_multiple(control_freq, kv)



// calculates a path to the current destination
// given an optional turf to avoid
/obj/machinery/bot/secbot/proc/calc_path(var/turf/avoid = null)
	path = AStar(loc, patrol_target, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance_cardinal, 0, 120, id=botcard, exclude=avoid)
	if(!path)
		path = list()


// look for a criminal in view of the bot

/obj/machinery/bot/secbot/proc/look_for_perp()
	anchored = 0
	for (var/mob/living/carbon/C in view(7,src)) //Let's find us a criminal
		if((C.stat) || (C.handcuffed))
			continue

		if((C.name == oldtarget_name) && (world.time < last_found + 100))
			continue

		if(istype(C, /mob/living/carbon))
			threatlevel = assess_perp(C)

		if(!threatlevel)
			continue

		else if(threatlevel >= 4)
			target = C
			oldtarget_name = C.name
			speak("Level [threatlevel] infraction alert!")
			playsound(loc, pick('sound/voice/bcriminal.ogg', 'sound/voice/bjustice.ogg', 'sound/voice/bfreeze.ogg'), 50, 0)
			visible_message("<b>[src]</b> points at [C.name]!")
			mode = BOT_HUNT
			spawn(0)
				process()	// ensure bot quickly responds to a perp
			break
		else
			continue


//If the security records say to arrest them, arrest them
//Or if they have weapons and aren't security, arrest them.
/obj/machinery/bot/secbot/proc/assess_perp(mob/living/carbon/perp as mob)
	var/threatcount = 0

	if(emagged == 2) return 10 //Everyone is a criminal!

	if(idcheck && !allowed(perp))

		if(check_for_weapons(perp.l_hand))
			threatcount += 4
		if(check_for_weapons(perp.r_hand))
			threatcount += 4

	if(istype(perp, /mob/living/carbon/human))
		var/mob/living/carbon/human/humanperp = perp

		if(idcheck && !allowed(perp))
			if(check_for_weapons(humanperp.belt))
				threatcount += 2

		if(istype(humanperp.head, /obj/item/clothing/head/wizard) || istype(humanperp.head, /obj/item/clothing/head/helmet/space/rig/wizard))
			threatcount += 2

		if(humanperp.dna && humanperp.dna.mutantrace && humanperp.dna.mutantrace != "none")
			threatcount += 2

		//Agent cards lower threatlevel.
		if(humanperp.wear_id && istype(humanperp.wear_id.GetID(), /obj/item/weapon/card/id/syndicate))
			threatcount -= 2

		if(check_records)	//check if they are set to *Arrest* on records
			var/perpname = humanperp.get_face_name(humanperp.get_id_name())
			var/datum/data/record/R = find_record("name", perpname, data_core.security)
			if(R && (R.fields["criminal"] == "*Arrest*"))
				threatcount += 4
	else
		threatcount += 2

	return threatcount

/obj/machinery/bot/secbot/proc/check_for_weapons(var/obj/item/slot_item)
	if(istype(slot_item, /obj/item/weapon/gun) || istype(slot_item, /obj/item/weapon/melee))
		if(!(slot_item.type in safe_weapons))
			return 1
	return 0

/obj/machinery/bot/secbot/Bump(M as mob|obj) //Leave no door unopened!
	if((istype(M, /obj/machinery/door)) && (!isnull(botcard)))
		var/obj/machinery/door/D = M
		if(!istype(D, /obj/machinery/door/firedoor) && D.check_access(botcard))
			D.open()
			frustration = 0
	else if((istype(M, /mob/living/)) && (!anchored))
		loc = M:loc
		frustration = 0
	return

/* terrible
/obj/machinery/bot/secbot/Bumped(atom/movable/M as mob|obj)
	spawn(0)
		if(M)
			var/turf/T = get_turf(src)
			M:loc = T
*/

/obj/machinery/bot/secbot/explode()

	walk_to(src,0)
	visible_message("\red <B>[src] blows apart!</B>", 1)
	var/turf/Tsec = get_turf(src)

	var/obj/item/weapon/secbot_assembly/Sa = new /obj/item/weapon/secbot_assembly(Tsec)
	Sa.build_step = 1
	Sa.overlays += "hs_hole"
	Sa.created_name = name
	new /obj/item/device/assembly/prox_sensor(Tsec)
	new /obj/item/weapon/melee/baton(Tsec)

	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/oil(loc)
	qdel(src)

/obj/machinery/bot/secbot/attack_alien(var/mob/living/carbon/alien/user as mob)
	..()
	if(!isalien(target))
		target = user
		mode = BOT_HUNT

//Secbot Construction

/obj/item/clothing/head/helmet/attackby(var/obj/item/device/assembly/signaler/S, mob/user as mob)
	..()
	if(!issignaler(S))
		..()
		return

	if(type != /obj/item/clothing/head/helmet) //Eh, but we don't want people making secbots out of space helmets.
		return

	if(S.secured)
		qdel(S)
		var/obj/item/weapon/secbot_assembly/A = new /obj/item/weapon/secbot_assembly
		user.put_in_hands(A)
		user << "<span class='notice'>You add the signaler to the helmet.</span>"
		user.unEquip(src, 1)
		qdel(src)
	else
		return

/obj/item/weapon/secbot_assembly/attackby(obj/item/I, mob/user)
	..()
	if(istype(I, /obj/item/weapon/weldingtool))
		if(!build_step)
			var/obj/item/weapon/weldingtool/WT = I
			if(WT.remove_fuel(0, user))
				build_step++
				overlays += "hs_hole"
				user << "<span class='notice'>You weld a hole in [src]!</span>"
		else if(build_step == 1)
			var/obj/item/weapon/weldingtool/WT = I
			if(WT.remove_fuel(0, user))
				build_step--
				overlays -= "hs_hole"
				user << "<span class='notice'>You weld the hole in [src] shut!</span>"

	else if(isprox(I) && (build_step == 1))
		user.drop_item()
		build_step++
		user << "<span class='notice'>You add the prox sensor to [src]!</span>"
		overlays += "hs_eye"
		name = "helmet/signaler/prox sensor assembly"
		qdel(I)

	else if(((istype(I, /obj/item/robot_parts/l_arm)) || (istype(I, /obj/item/robot_parts/r_arm))) && (build_step == 2))
		user.drop_item()
		build_step++
		user << "<span class='notice'>You add the robot arm to [src]!</span>"
		name = "helmet/signaler/prox sensor/robot arm assembly"
		overlays += "hs_arm"
		qdel(I)

	else if((istype(I, /obj/item/weapon/melee/baton)) && (build_step >= 3))
		user.drop_item()
		build_step++
		user << "<span class='notice'>You complete the Securitron! Beep boop.</span>"
		var/obj/machinery/bot/secbot/S = new /obj/machinery/bot/secbot
		S.loc = get_turf(src)
		S.name = created_name
		qdel(I)
		qdel(src)

	else if(istype(I, /obj/item/weapon/pen))
		var/t = copytext(stripped_input(user, "Enter new robot name", name, created_name),1,MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t

	else if(istype(I, /obj/item/weapon/screwdriver))
		if(!build_step)
			new /obj/item/device/assembly/signaler(get_turf(src))
			new /obj/item/clothing/head/helmet(get_turf(src))
			user << "<span class='notice'>You disconnect the signaler from the helmet.</span>"
			qdel(src)

		else if(build_step == 2)
			overlays -= "hs_eye"
			new /obj/item/device/assembly/prox_sensor(get_turf(src))
			user << "<span class='notice'>You detach the proximity sensor from [src].</span>"
			build_step--

		else if(build_step == 3)
			overlays -= "hs_arm"
			new /obj/item/robot_parts/l_arm(get_turf(src))
			user << "<span class='notice'>You remove the robot arm from [src].</span>"
			build_step--
