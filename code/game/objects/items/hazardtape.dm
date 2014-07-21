#define MAX_TAPE_RANGE 3
//The max length of a line of hazard tape by tile range, this is

//Define all tape types in hazardtape.dm
/obj/item/taperoll
	name = "tape roll"
	icon = 'icons/obj/hazardtape.dmi'
	icon_state = "rollstart"
	w_class = 2.0
	var/turf/start
	var/turf/end
	var/tape_type = /obj/item/tape
	var/icon_base

/obj/item/tape
	name = "tape"
	icon = 'icons/obj/hazardtape.dmi'
	anchored = 1
	density = 1
	var/icon_base

/obj/item/taperoll/security
	name = "secruity tape roll"
	desc = "A roll of security hazard tape used to block crime scenes from non-security staff. It can be placed in segments along hallways or on airlocks to restrict access."
	icon_state = "security_start"
	tape_type = /obj/item/tape/security
	icon_base = "security"

/obj/item/tape/security
	name = "security tape"
	desc = "A length of security hazard tape. It reads: SECURITY LINE | DO NOT CROSS."
	req_access = list(access_security)
	icon_base = "security"

/obj/item/taperoll/engineering
	name = "engineering tape roll"
	desc = "A roll of engineering hazard tape used to block hazardous areas from non-engineering staff. It can be placed in segments along hallways or on airlocks to restrict access."
	icon_state = "engineering_start"
	tape_type = /obj/item/tape/engineering
	icon_base = "engineering"

/obj/item/tape/engineering
	name = "engineering tape"
	desc = "A length of engineering hazard tape. It reads: HAZARD AHEAD | DO NOT CROSS."
	req_one_access = list(access_engine,access_atmospherics)
	icon_base = "engineering"

/obj/item/taperoll/attack_self(var/mob/user)
	if(icon_state == "[icon_base]_start")
		start = get_turf(src)
		usr << "<span class='notice'>You place the first end of the [src].</span>"
		icon_state = "[icon_base]_stop"
	else
		icon_state = "[icon_base]_start"
		end = get_turf(src)
		if(start.y != end.y && start.x != end.x || start.z != end.z)
			usr << "<span class='warning'>[src] can only be laid horizontally or vertically.</span>"
			return
		if(get_dist(start,end) >= MAX_TAPE_RANGE)
			usr << "<span class='warning'>Your tape segment is too long! It must be [MAX_TAPE_RANGE] tiles long or shorter!</span>"
			return

		var/turf/cur = start
		var/dir
		if (start.x == end.x)
			var/d = end.y-start.y
			if(d) d = d/abs(d)
			end = get_turf(locate(end.x,end.y+d,end.z))
			dir = "v"
		else
			var/d = end.x-start.x
			if(d) d = d/abs(d)
			end = get_turf(locate(end.x+d,end.y,end.z))
			dir = "h"

		var/can_place = 1
		while (cur!=end && can_place)
			if(cur.density == 1)
				can_place = 0
			else if (istype(cur, /turf/space))
				can_place = 0
			else
				for(var/obj/O in cur)
					if(!istype(O, /obj/item/tape) && O.density)
						can_place = 0
						break
			cur = get_step_towards(cur,end)
		if (!can_place)
			usr << "<span class='warning'>You can't run \the [src] through that!</span>"
			return

		cur = start
		var/tapetest = 0
		while (cur!=end)
			for(var/obj/item/tape/Ptest in cur)
				if(Ptest.icon_state == "[Ptest.icon_base]_[dir]")
					tapetest = 1
			if(tapetest != 1)
				var/obj/item/tape/P = new tape_type(cur)
				P.icon_state = "[P.icon_base]_[dir]"
			cur = get_step_towards(cur,end)
			
		usr << "<span class='notice'>You finish placing the [src].</span>"	

/obj/item/taperoll/afterattack(var/atom/A, var/mob/user)
	if (istype(A, /obj/machinery/door/airlock))
		if(!user.Adjacent(A))
			user << "<span class='notice'>You're too far away from \the [A]!</span>"
			return
		var/turf/T = get_turf(A)
		var/obj/item/tape/P = new tape_type(T.x,T.y,T.z)
		P.loc = locate(T.x,T.y,T.z)
		P.icon_state = "[src.icon_base]_door"
		P.layer = 3.2
		usr << "<span class='notice'>You finish placing the [src].</span>"

/obj/item/tape/Bumped(var/mob/M)
	if(src.allowed(M))
		var/turf/T = get_turf(src)
		M.loc = T

/obj/item/tape/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!density) return 1
	if(air_group || (height==0)) return 1

	if ((mover.flags & 2 || istype(mover, /obj/effect/meteor) || mover.throwing == 1) )
		return 1
	else
		return 0

/obj/item/tape/attackby(var/obj/item/weapon/W, var/mob/user)
	breaktape(W, user)

/obj/item/tape/attack_hand(mob/user as mob)
	if (user.a_intent == "help" && src.allowed(user))
		user.show_viewers("<span class='notice'>[user] lifts [src], allowing passage.</span>")
		src.density = 0
		spawn(200)
			src.density = 1
	else
		breaktape(null, user)

/obj/item/tape/attack_paw(var/mob/user)
	breaktape(/obj/item/weapon/wirecutters,user)

/obj/item/tape/proc/breaktape(var/obj/item/weapon/W, var/mob/user)
	if(user.a_intent == "help" && ((!is_sharp(W) && src.allowed(user))))
		user << "You can't break the [src] with that!"
		return
	user.show_viewers("<span class='warning'>[user] breaks the [src]!</span>")

	var/dir[2]
	var/icon_dir = src.icon_state
	if(icon_dir == "[src.icon_base]_h")
		dir[1] = EAST
		dir[2] = WEST
	if(icon_dir == "[src.icon_base]_v")
		dir[1] = NORTH
		dir[2] = SOUTH

	for(var/i=1;i<3;i++)
		var/N = 0
		var/turf/cur = get_step(src,dir[i])
		while(N != 1)
			N = 1
			for (var/obj/item/tape/P in cur)
				if(P.icon_state == icon_dir)
					N = 0
					del(P)
			cur = get_step(cur,dir[i])

	del(src)
	return

#undef MAX_TAPE_RANGE
