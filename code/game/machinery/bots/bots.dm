// AI (i.e. game AI, not the AI player) controlled bots

/obj/machinery/bot
	icon = 'icons/obj/aibots.dmi'
	layer = MOB_LAYER
	luminosity = 3
	use_power = 0
	var/obj/item/weapon/card/id/botcard			// the ID card that the bot "holds"
	var/list/prev_access = list()
	var/on = 1
	var/health = 0 //do not forget to set health for your bot!
	var/maxhealth = 0
	var/fire_dam_coeff = 1.0
	var/brute_dam_coeff = 1.0
	var/open = 0//Maint panel
	var/locked = 1
	var/hacked = 0 //Used to differentiate between being hacked by silicons and emagged by humans.
	var/list/call_path = list() //Path calculated by the AI and given to the bot to follow.
	var/list/path = new() //Every bot has this, so it is best to put it here.
	var/list/patrol_path = list() //The path a bot has while on patrol.
	var/pathset = 0
	var/mode = 0 //Standardizes the vars that indicate the bot is busy with its function.
	var/tries = 0 //Number of times the bot tried and failed to move.
	var/remote_disabled = 0 //If enabled, the AI cannot *Remotely* control a bot. It can still control it through cameras.
	var/mob/living/silicon/ai/calling_ai = null //Links a bot to the AI calling it.
	//var/emagged = 0 //Urist: Moving that var to the general /bot tree as it's used by most bots
	var/auto_patrol = 0// set to make bot automatically patrol
	var/turf/patrol_target	// this is turf to navigate to (location of beacon)
	var/new_destination		// pending new destination (waiting for beacon response)
	var/destination			// destination description tag
	var/next_destination	// the next destination in the patrol route

	var/blockcount = 0		//number of times retried a blocked path
	var/awaiting_beacon	= 0	// count of pticks awaiting a beacon response

	var/nearest_beacon			// the nearest beacon's tag
	var/turf/nearest_beacon_loc	// the nearest beacon's location

	var/beacon_freq = 1445		// navigation beacon frequency
	var/control_freq = 1447		// bot control frequency

	var/bot_filter 				// The radio filter the bot uses to identify itself on the network.

	var/bot_type = 0 //The type of bot it is, for radio control.
	#define SEC_BOT				1	// Secutritrons (Beepsky) and ED-209s
	#define MULE_BOT			2	// MULEbots
	#define FLOOR_BOT			3	// Floorbots
	#define CLEAN_BOT			4	// Cleanbots
	#define MED_BOT				5	// Medibots

	//Mode defines
	#define BOT_IDLE 			0	// idle
	#define BOT_HUNT 			1	// found target, hunting
	#define BOT_PREP_ARREST 	2	// at target, preparing to arrest
	#define BOT_ARREST			3	// arresting target
	#define BOT_START_PATROL	4	// start patrol
	#define BOT_PATROL			5	// patrolling
	#define BOT_SUMMON			6	// summoned by PDA
	#define BOT_CLEANING 		7	// cleaning (cleanbots)
	#define BOT_REPAIRING		8	// repairing hull breaches (floorbots)
	#define BOT_WORKING			9	// for clean/floor bots, when moving.
	#define BOT_HEALING			10	// healing people (medbots)
	#define BOT_RESPONDING		11	// responding to a call from the AI
	#define BOT_LOADING			12	// loading/unloading
	#define BOT_DELIVER			13	// moving to deliver
	#define BOT_GO_HOME			14	// returning to home
	#define BOT_BLOCKED			15	// blocked
	#define BOT_NAV				16	// computing navigation
	#define BOT_WAIT_FOR_NAV	17	// waiting for nav computation
	#define BOT_NO_ROUTE		18	// no destination beacon found (or no route)
	var/list/mode_name = list("In Pursuit","Preparing to Arrest","Arresting","Beginning Patrol","Patrolling","Summoned by PDA", \
	"Cleaning", "Repairing", "Working","Healing","Responding","Loading/Unloading","Navigating to Delivery Location","Navigating to Home", \
	"Waiting for clear path","Calculating navigation path","Pinging beacon network","Unable to reach destination")
	//This holds text for what the bot is mode doing, reported on the AI's bot control interface.


/obj/machinery/bot/proc/turn_on()
	if(stat)	return 0
	on = 1
	SetLuminosity(initial(luminosity))
	return 1

/obj/machinery/bot/proc/turn_off()
	on = 0
	SetLuminosity(0)
	call_reset() //Resets an AI's call, should it exist.

/obj/machinery/bot/New()
	..()
	botcard = new /obj/item/weapon/card/id(src)

/obj/machinery/bot/proc/add_to_beacons(bot_filter) //Master filter control for bots. Must be placed in the bot's local New() to support map spawned bots.
	if(radio_controller)
		radio_controller.add_object(src, beacon_freq, filter = RADIO_NAVBEACONS)
	if(bot_filter)
		radio_controller.add_object(src, control_freq, filter = bot_filter)



/obj/machinery/bot/proc/explode()
	qdel(src)

/obj/machinery/bot/proc/healthcheck()
	if (src.health <= 0)
		src.explode()

/obj/machinery/bot/proc/Emag(mob/user as mob)
	if(locked)
		locked = 0
		emagged = 1
		user << "<span class='warning'>You bypass [src]'s controls.</span>"
	if(!locked && open)
		emagged = 2
		remote_disabled = 1 //Manually emagging the bot locks out the AI.

/obj/machinery/bot/examine()
	set src in view()
	..()
	if (src.health < maxhealth)
		if (src.health > maxhealth/3)
			usr << "<span class='warning'>[src]'s parts look loose.</span>"
		else
			usr << "<span class='danger'>[src]'s parts look very loose!</span>"
	return

/obj/machinery/bot/attack_alien(var/mob/living/carbon/alien/user as mob)
	src.health -= rand(15,30)*brute_dam_coeff
	src.visible_message("\red <B>[user] has slashed [src]!</B>")
	playsound(src.loc, 'sound/weapons/slice.ogg', 25, 1, -1)
	if(prob(10))
		new /obj/effect/decal/cleanable/oil(src.loc)
	healthcheck()


/obj/machinery/bot/attack_animal(var/mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0)	return
	src.health -= M.melee_damage_upper
	src.visible_message("\red <B>[M] has [M.attacktext] [src]!</B>")
	add_logs(M, src, "attacked", admin=0)
	if(prob(10))
		new /obj/effect/decal/cleanable/oil(src.loc)
	healthcheck()




/obj/machinery/bot/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/screwdriver))
		if(!locked)
			open = !open
			user << "<span class='notice'>Maintenance panel is now [src.open ? "opened" : "closed"].</span>"
	else if(istype(W, /obj/item/weapon/weldingtool))
		if(health < maxhealth)
			if(open)
				health = min(maxhealth, health+10)
				user.visible_message("\red [user] repairs [src]!","\blue You repair [src]!")
			else
				user << "<span class='notice'>Unable to repair with the maintenance panel closed.</span>"
		else
			user << "<span class='notice'>[src] does not need a repair.</span>"
	else if (istype(W, /obj/item/weapon/card/emag) && emagged < 2)
		Emag(user)
	else
		if(hasvar(W,"force") && hasvar(W,"damtype"))
			switch(W.damtype)
				if("fire")
					src.health -= W.force * fire_dam_coeff
				if("brute")
					src.health -= W.force * brute_dam_coeff
			..()
			healthcheck()
		else
			..()

/obj/machinery/bot/bullet_act(var/obj/item/projectile/Proj)
	if((Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		health -= Proj.damage
		..()
		healthcheck()
	return

/obj/machinery/bot/blob_act()
	src.health -= rand(20,40)*fire_dam_coeff
	healthcheck()
	return

/obj/machinery/bot/ex_act(severity)
	switch(severity)
		if(1.0)
			src.explode()
			return
		if(2.0)
			src.health -= rand(5,10)*fire_dam_coeff
			src.health -= rand(10,20)*brute_dam_coeff
			healthcheck()
			return
		if(3.0)
			if (prob(50))
				src.health -= rand(1,5)*fire_dam_coeff
				src.health -= rand(1,5)*brute_dam_coeff
				healthcheck()
				return
	return

/obj/machinery/bot/emp_act(severity)
	var/was_on = on
	stat |= EMPED
	var/obj/effect/overlay/pulse2 = new/obj/effect/overlay ( src.loc )
	pulse2.icon = 'icons/effects/effects.dmi'
	pulse2.icon_state = "empdisable"
	pulse2.name = "emp sparks"
	pulse2.anchored = 1
	pulse2.dir = pick(cardinal)

	spawn(10)
		pulse2.delete()
	if (on)
		turn_off()
	spawn(severity*300)
		stat &= ~EMPED
		if (was_on)
			turn_on()

/obj/machinery/bot/proc/hack(mob/user)
	var/hack
	if(issilicon(user))
		hack += "[emagged ? "Software compromised! Unit may exhibit dangerous or erratic behavior." : "Unit operating normally. Release safety lock?"]<BR>"
		hack += "Harm Prevention Safety System: <A href='?src=\ref[src];operation=hack'>[emagged ? "DANGER" : "Engaged"]</A><BR>"
	return hack

/obj/machinery/bot/attack_ai(mob/user as mob)
	src.attack_hand(user)

/obj/machinery/bot/proc/speak(var/message)
	if((!src.on) || (!message))
		return
	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>[src]</span> beeps, \"[message]\"</span>",2)
	return

/obj/machinery/bot/proc/check_bot_access()
	if(mode != BOT_SUMMON && mode != BOT_RESPONDING)
		botcard.access = prev_access

/obj/machinery/bot/proc/set_path() //Contains all the non-unique settings for prepairing a bot to be controlled by the AI.
	pathset = 1
	mode = BOT_RESPONDING
	tries = 0

/obj/machinery/bot/proc/move_to_call()
	if(call_path && call_path.len && tries < 6)
		step_towards(src, call_path[1])

		if(loc == call_path[1])//Remove turfs from the path list if the bot moved there.
			tries = 0
			call_path -= call_path[1]
		else //Could not move because of an obstruction.
			tries++
	else
		if(calling_ai)
			calling_ai << "[tries ? "<span class='danger'>[src] failed to reach waypoint.</span>" : "<span class='notice'>[src] successfully arrived to waypoint.</span>"]"
		call_reset()

obj/machinery/bot/proc/call_reset()

	calling_ai = null
	call_path = null
	path = new()
	patrol_path = new()
	pathset = 0
	botcard.access = prev_access
	tries = 0
	mode = BOT_IDLE
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Experimental patrol code!
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/obj/machinery/bot/proc/bot_patrol()
	patrol_step()
	spawn(5)
		if(mode == BOT_PATROL)
			patrol_step()
	return

obj/machinery/bot/proc/start_patrol()

	if(tries >= 5) //Bot is trapped, so stop trying to patrol.
		auto_patrol = 0
		tries = 0
		speak("Unable to start patrol.")

		return

	if(!auto_patrol) //A bot not set to patrol should not be patrolling.
		mode = BOT_IDLE
		return

	if(patrol_path && patrol_path.len > 0 && patrol_target)	// have a valid path, so just resume
		mode = BOT_PATROL
		return

	else if(patrol_target)		// has patrol target already
		spawn(0)
			calc_path()		// so just find a route to it
			if(patrol_path.len == 0)
				patrol_target = 0
				return
			mode = BOT_PATROL
	else					// no patrol target, so need a new one
		find_patrol_target()
		speak("Engaging patrol mode.")
		tries++
	return

obj/machinery/bot/proc/bot_summon()
		// summoned to PDA
	patrol_step()
	spawn(4)
		if(mode == BOT_SUMMON)
			patrol_step()
			sleep(4)
			patrol_step()
	return
// perform a single patrol step

/obj/machinery/bot/proc/patrol_step()

	if(loc == patrol_target)		// reached target


		at_patrol_target()
		return

	else if(patrol_path.len > 0 && patrol_target)		// valid path
		var/turf/next = patrol_path[1]
		if(next == loc)
			patrol_path -= next
			return


		if(istype( next, /turf/simulated))

			var/moved = step_towards(src, next)	// attempt to move
			if(moved)	// successful move
				blockcount = 0
				patrol_path -= loc

			else		// failed to move
				blockcount++

				if(blockcount > 5)	// attempt 5 times before recomputing
					// find new path excluding blocked turf

					spawn(2)
						calc_path(next)
						if(patrol_path.len == 0)
							find_patrol_target()
						else
							blockcount = 0
							tries = 0

					return

				return

		else	// not a valid turf
			mode = BOT_IDLE
			return

	else if(mode == BOT_SUMMON && patrol_target) //Try to find the user again.
		calc_path()
		tries++

	else	// no path, so calculate new one
		mode = BOT_START_PATROL

	return

// finds a new patrol target
/obj/machinery/bot/proc/find_patrol_target()
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
/obj/machinery/bot/proc/find_nearest_beacon()
	nearest_beacon = null
	new_destination = "__nearest__"
	post_signal(beacon_freq, "findbeacon", "patrol")
	awaiting_beacon = 1
	spawn(10)
		awaiting_beacon = 0
		if(nearest_beacon)
			set_destination(nearest_beacon)
			tries = 0
		else
			auto_patrol = 0
			mode = BOT_IDLE
			speak("Disengaging patrol mode.")
			send_status()


/obj/machinery/bot/proc/at_patrol_target()
	if(mode == BOT_SUMMON)
		botcard.access = prev_access
		mode = BOT_IDLE

	find_patrol_target()
	return


// sets the current destination
// signals all beacons matching the patrol code
// beacons will return a signal giving their locations
/obj/machinery/bot/proc/set_destination(var/new_dest)
	new_destination = new_dest
	post_signal(beacon_freq, "findbeacon", "patrol")
	awaiting_beacon = 1


// receive a radio signal
// used for beacon reception

/obj/machinery/bot/receive_signal(datum/signal/signal)
	//log_admin("DEBUG \[[// world.timeofday]\]: /obj/machinery/bot/receive_signal([signal.debug_print()])")
	if(!on)
		return
/*
	if(!signal.data["beacon"])

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
				call_reset() //Override the AI.
				auto_patrol = 0
				return

			if("go")
				call_reset()
				auto_patrol = 1
				return

			if("summon")
				var/list/user_access = signal.data["useraccess"]
				patrol_target = signal.data["target"]	//Location of the user
				if(user_access.len != 0)
					botcard.access = user_access	//Adds the user's access, if any.
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
/obj/machinery/bot/proc/post_signal(var/freq, var/key, var/value)
	post_signal_multiple(freq, list("[key]" = value) )

// send a radio signal with multiple data key/values
/obj/machinery/bot/proc/post_signal_multiple(var/freq, var/list/keyval)
	var/datum/radio_frequency/frequency = radio_controller.return_frequency(freq)

	if(!frequency) return

	var/datum/signal/signal = new()
	signal.source = src
	signal.transmission_method = 1
//	for(var/key in keyval)
//		signal.data[key] = keyval[key]
	signal.data = keyval
//	world << "sent [key],[keyval[key]] on [freq]"
	if(signal.data["findbeacon"])
		frequency.post_signal(src, signal, filter = RADIO_NAVBEACONS)
	else if(signal.data["type"] == bot_type)
		frequency.post_signal(src, signal, filter = bot_filter)
	else
		frequency.post_signal(src, signal)

// signals bot status etc. to controller
/obj/machinery/bot/proc/send_status()
	var/list/kv = list(
	"type" = src.bot_type,
	"name" = src.name,
	"loca" = src.loc.loc,	// area
	"mode" = src.mode
	)
	post_signal_multiple(control_freq, kv)



// calculates a path to the current destination
// given an optional turf to avoid
/obj/machinery/bot/proc/calc_path(var/turf/avoid = null)
	check_bot_access()
	patrol_path = AStar(loc, patrol_target, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance_cardinal, 0, 120, id=botcard, exclude=avoid)
	if(!patrol_path)
		patrol_path = list()



/******************************************************************/
// Navigation procs
// Used for A-star pathfinding


// Returns the surrounding cardinal turfs with open links
// Including through doors openable with the ID
/turf/proc/CardinalTurfsWithAccess(var/obj/item/weapon/card/id/ID)
	var/L[] = new()

	//	for(var/turf/simulated/t in oview(src,1))

	for(var/d in cardinal)
		var/turf/simulated/T = get_step(src, d)
		if(istype(T) && !T.density)
			if(!LinkBlockedWithAccess(src, T, ID))
				L.Add(T)
	return L


// Returns true if a link between A and B is blocked
// Movement through doors allowed if ID has access
/proc/LinkBlockedWithAccess(turf/A, turf/B, obj/item/weapon/card/id/ID)

	if(A == null || B == null) return 1
	var/adir = get_dir(A,B)
	var/rdir = get_dir(B,A)
	if((adir & (NORTH|SOUTH)) && (adir & (EAST|WEST)))	//	diagonal
		var/iStep = get_step(A,adir&(NORTH|SOUTH))
		if(!LinkBlockedWithAccess(A,iStep, ID) && !LinkBlockedWithAccess(iStep,B,ID))
			return 0

		var/pStep = get_step(A,adir&(EAST|WEST))
		if(!LinkBlockedWithAccess(A,pStep,ID) && !LinkBlockedWithAccess(pStep,B,ID))
			return 0
		return 1

	if(DirBlockedWithAccess(A,adir, ID))
		return 1

	if(DirBlockedWithAccess(B,rdir, ID))
		return 1

	for(var/obj/O in B)
		if(O.density && !istype(O, /obj/machinery/door) && !(O.flags & ON_BORDER))
			return 1

	return 0

// Returns true if direction is blocked from loc
// Checks doors against access with given ID
/proc/DirBlockedWithAccess(turf/loc,var/dir,var/obj/item/weapon/card/id/ID)
	for(var/obj/structure/window/D in loc)
		if(!D.density)			continue
		if(D.dir == SOUTHWEST)	return 1
		if(D.dir == dir)		return 1

	for(var/obj/machinery/door/D in loc)
		if(!D.density)			continue
		if(istype(D, /obj/machinery/door/window))
			if( dir & D.dir )	return !D.check_access(ID)

			//if((dir & SOUTH) && (D.dir & (EAST|WEST)))		return !D.check_access(ID)
			//if((dir & EAST ) && (D.dir & (NORTH|SOUTH)))	return !D.check_access(ID)
		else return !D.check_access(ID)	// it's a real, air blocking door
	return 0
