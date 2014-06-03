//This only assumes that the mob has a body and face with at least one mouth.
//Things like airguitar can be done without arms, and the flap thing makes so little sense it's a keeper.
//Intended to be called by a higher up emote proc if the requested emote isn't in the custom emotes.

/mob/living/emote(var/act,var/m_type=1,var/message = null)
	var/param = null

	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	switch(act)//Hello, how would you like to order? Alphabetically!
		if ("aflap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps its wings ANGRILY!"
				m_type = 2

		if ("blush")
			message = "<B>[src]</B> blushes."
			m_type = 1

		if ("bow")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null
				if (param)
					message = "<B>[src]</B> bows to [param]."
				else
					message = "<B>[src]</B> bows."
			m_type = 1

		if ("burp")
			message = "<B>[src]</B> burps."
			m_type = 2

		if ("choke")
			message = "<B>[src]</B> chokes!"
			m_type = 2

		if ("chuckle")
			message = "<B>[src]</B> chuckles."
			m_type = 2

		if ("collapse")
			Paralyse(2)
			message = "<B>[src]</B> collapses!"
			m_type = 2

		if ("cough")
			message = "<B>[src]</B> coughs!"
			m_type = 2

		if ("dance")
			if (!src.restrained())
				message = "<B>[src]</B> dances around happily."
				m_type = 1

		if ("deathgasp")
			message = "<B>[src]</B> seizes up and falls limp, its eyes dead and lifeless..."
			m_type = 1

		if ("drool")
			message = "<B>[src]</B> drools."
			m_type = 1

		if ("faint")
			message = "<B>[src]</B> faints."
			if(src.sleeping)
				return //Can't faint while asleep
			src.sleeping += 10 //Short-short nap
			m_type = 1

		if ("flap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps its wings."
				m_type = 2

		if ("flipoff")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null
				if (param)
					message = "<B>[src]</B> flips the bird at [param]!"
				else
					message = "<B>[src]</B> flips the bird."
			m_type = 1

		if ("frown")
			message = "<B>[src]</B> frowns."
			m_type = 1

		if ("gasp")
			message = "<B>[src]</B> gasps!"
			m_type = 2

		if ("giggle")
			message = "<B>[src]</B> giggles."
			m_type = 2

		if ("glare")
			var/M = null
			if (param)
				for (var/mob/A in view(1, src))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null
			if (param)
				message = "<B>[src]</B> glares at [param]."
			else
				message = "<B>[src]</B> glares."

		if ("grin")
			message = "<B>[src]</B> grins."
			m_type = 1

		if ("jump")
			message = "<B>[src]</B> jumps!"
			m_type = 1

		if ("laugh")
			message = "<B>[src]</B> laughs."
			m_type = 2

		if ("look")
			var/M = null
			if (param)
				for (var/mob/A in view(1, src))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null
			if (param)
				message = "<B>[src]</B> looks at [param]."
			else
				message = "<B>[src]</B> looks."
			m_type = 1

		if ("me")
			if (src.client)
				if(client.prefs.muted & MUTE_IC)
					src << "You cannot send IC messages (muted)."
					return
				if (src.client.handle_spam_prevention(message,MUTE_IC))
					return
			if (stat)
				return
			if(!(message))
				return
			else
				message = "<B>[src]</B> [message]"

		if ("nod")
			message = "<B>[src]</B> nods."
			m_type = 1

		if ("point")
			if (!src.restrained())
				var/mob/M = null
				if (param)
					for (var/atom/A as mob|obj|turf|area in view(1, src))
						if (param == A.name)
							M = A
							break
				if (!M)
					message = "<B>[src]</B> points."
				else
					M.point()
				if (M)
					message = "<B>[src]</B> points to [M]."
				else
			m_type = 1
		
		if ("pout")
			message = "<B>[src]</B> pouts."
			m_type = 1

		if ("rude")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null
				if (param)
					message = "<B>[src]</B> makes a rude gesture at [param]!"
				else
					message = "<B>[src]</B> makes a rude gesture."
			m_type = 1

		if ("scream")
			message = "<B>[src]</B> screams!"
			m_type = 2

		if ("shake")
			message = "<B>[src]</B> shakes its head."
			m_type = 1

		if ("sigh")
			message = "<B>[src]</B> sighs."
			m_type = 2

		if ("sit")
			message = "<B>[src]</B> sits down."
			m_type = 1

		if ("smile")
			message = "<B>[src]</B> smiles."
			m_type = 1
		
		if ("smirk")
			message = "<B>[src]</B> smirks."
			m_type = 1

		if ("snap")
			message = "<B>[src]</B> snaps their fingers."
			m_type = 2

		if ("sneeze")
			message = "<B>[src]</B> sneezes."
			m_type = 2

		if ("sniff")
			message = "<B>[src]</B> sniffs."
			m_type = 2

		if ("snore")
			message = "<B>[src]</B> snores."
			m_type = 2

		if ("snort")
			message = "<B>[src]</B> snorts."
			m_type = 2

		if ("spit")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null
				if (param)
					message = "<B>[src]</B> spits at [param]."
				else
					message = "<B>[src]</B> spits on the ground."
			m_type = 1

		if ("stare")
			var/M = null
			if (param)
				for (var/mob/A in view(1, src))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null
			if (param)
				message = "<B>[src]</B> stares at [param]."
			else
				message = "<B>[src]</B> stares."

		if ("sulk")
			message = "<B>[src]</B> sulks down sadly."
			m_type = 1

		if ("sway")
			message = "<B>[src]</B> sways around dizzily."
			m_type = 1

		if ("tap")
			message = "<B>[src]</B> taps their foot impatiently."
			m_type = 1

		if ("thumbsdown")
			message = "<B>[src]</B> gives a thumbs down."
			m_type = 1
		
		if ("thumbsup")
			message = "<B>[src]</B> gives a thumbs up!"
			m_type = 1

		if ("tremble")
			message = "<B>[src]</B> trembles in fear!"
			m_type = 1

		if ("twitch")
			message = "<B>[src]</B> twitches violently."
			m_type = 1

		if ("twitch_s")
			message = "<B>[src]</B> twitches."
			m_type = 1

		if ("wave")
			message = "<B>[src]</B> waves."
			m_type = 1

		if ("whimper")
			message = "<B>[src]</B> whimpers."
			m_type = 2
			
		if ("whistle")
			message = "<B>[src]</B> whistles."
			m_type = 2

		if ("whistle2")
			message = "<B>[src]</B> whistles a tune."
			m_type = 2

		if ("yawn")
			message = "<B>[src]</B> yawns."
			m_type = 2

		if ("help")
			src << "Help for emotes. You can use these emotes with say \"*emote\":\n\naflap, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough, dance, deathgasp, drool, flap, flipoff, frown, gasp, giggle, glare-(none)/mob, grin, jump, laugh, look, me, nod, point-atom, pout, rude, scream, shake, sit, sigh, smile, smirk, snap, sneeze, sniff, snore, snort, spit, stare-(none)/mob, sulk, sway, tap, thumbsup, thumbsdown, tremble, twitch, twitch_s, wave, whimper, whistle, whistle2 yawn"

		else
			src << "<span class='notice'> Unusable emote '[act]'. Say *help for a list.</span>"





	if (message)
		log_emote("[name]/[key] : [message]")

 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		for(var/mob/M in dead_mob_list)
			if(!M.client || istype(M, /mob/new_player))
				continue //skip monkeys, leavers and new players
			if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTSIGHT) && !(M in viewers(src,null)))
				M.show_message(message)


		if (m_type & 1)
			for (var/mob/O in viewers(src, null))
				O.show_message(message, m_type)
		else if (m_type & 2)
			for (var/mob/O in hearers(src.loc, null))
				O.show_message(message, m_type)
