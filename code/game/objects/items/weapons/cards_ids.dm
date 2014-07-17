/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/weapon/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = 1.0

	var/list/files = list(  )

/obj/item/weapon/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"

/obj/item/weapon/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = "Object"
	set src in usr

	if (t)
		src.name = text("data disk- '[]'", t)
	else
		src.name = "data disk"
	src.add_fingerprint(usr)
	return

/obj/item/weapon/card/data/clown
	name = "\proper the coordinates to clown planet"
	icon_state = "data"
	item_state = "card-id"
	layer = 3
	level = 2
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	function = "teleporter"
	data = "Clown Land"

/*
 * ID CARDS
 */
/obj/item/weapon/card/emag
	name = "cryptographic sequencer"
	desc = "It's a card with a magnetic strip attached to some circuitry."
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = "magnets=2;syndicate=2"

/obj/item/weapon/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station."
	icon_state = "id"
	item_state = "card-id"
	slot_flags = SLOT_ID
	var/mining_points = 0		//For redeeming at mining equipment lockers
	var/list/access = list()
	var/registered_name = null	//The name registered_name on the card
	var/assignment = null

/obj/item/weapon/card/id/attack_self(mob/user)
	user.visible_message("[user] shows \his [src]: \icon[src] [name]: assignment: [assignment]")

/obj/item/weapon/card/id/examine()
	..()
	usr << "The current assignment on the card is [assignment]."
	if(mining_points)
		usr << "There's [mining_points] mining equipment redemption points loaded onto this card."

/obj/item/weapon/card/id/GetAccess()
	return access

/obj/item/weapon/card/id/GetID()
	return src

/*
Usage:
update_label()
	Sets the id name to whatever registered_name and assignment is

update_label("John Doe", "Clowny")
	Properly formats the name and occupation and sets the id name to the arguments
*/
/obj/item/weapon/card/id/proc/update_label(var/newname, var/newjob)
	if(newname || newjob)
		name = text("[][]",
			(!newname)	? "identification card"	: "[newname]'s ID Card",
			(!newjob)		? ""										: " ([newjob])"
		)
		return

	name = text("[][]",
		(!registered_name)	? "identification card"	: "[registered_name]'s ID Card",
		(!assignment)				? ""										: " ([assignment])"
	)

/obj/item/weapon/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

/obj/item/weapon/card/id/silver
	desc = "A silver card which shows honour and dedication."
	icon_state = "silver"
	item_state = "silver_id"

/obj/item/weapon/card/id/gold
	desc = "A golden card which shows power and might."
	icon_state = "gold"
	item_state = "gold_id"

/obj/item/weapon/card/id/syndicate
	name = "agent card"
	access = list(access_maint_tunnels, access_syndicate)
	origin_tech = "syndicate=3"

/obj/item/weapon/card/id/syndicate/afterattack(obj/item/I, mob/user, proximity)
	if(!proximity)	return
	if(istype(I, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/idcard = I
		access |= idcard.access
		if(isliving(user) && user.mind)
			if(user.mind.special_role)
				user << "<span class='notice'>The card's microscanners activate as you pass it over the ID, copying its access.</span>"


/obj/item/weapon/card/id/syndicate/attack_self(mob/user)
	if(!src.registered_name)
		//Stop giving the players unsanitized unputs! You are giving ways for players to intentionally crash clients! -Nodrak
		var t = copytext(sanitize(input(user, "What name would you like to put on this card?", "Agent card name", ishuman(user) ? user.real_name : user.name)),1,26)
		if(!t || t == "Unknown" || t == "floor" || t == "wall" || t == "r-wall") //Same as mob/new_player/prefrences.dm
			alert("Invalid name.")
			return
		registered_name = t

		var u = copytext(sanitize(input(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels other than maintenance.", "Agent card job assignment", "Assistant")),1,MAX_MESSAGE_LEN)
		if(!u)
			alert("Invalid assignment.")
			registered_name = ""
			return
		src.assignment = u
		update_label()
		user << "\blue You successfully forge the ID card."
	else
		..()

/obj/item/weapon/card/id/syndicate/nuke //same deal, just with different icon
	name = "syndicate ID card"
	desc = "A syndicate ID.  This one has the same features as the agent ID, just with a new paint job."
	icon_state = "syndicate"
	assignment = "Syndicate Agent"

/obj/item/weapon/card/id/syndicate/nuke/command
	name = "syndicate leader's ID card"
	desc = "A golden version of the syndicate ID.  This, like all other syndicate IDs, work just like agent IDs."
	icon_state = "syndicate-command"
	assignment = "Syndicate Leader"

/obj/item/weapon/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = "gold"
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"
	New()
		var/datum/job/captain/J = new/datum/job/captain
		access = J.get_access()
		..()

//Centcom

/obj/item/weapon/card/id/centcom
	name = "\improper Centcom ID"
	desc = "An ID given to guests of Central Command. This ID is painted white, as only real members of Centcom get 'real' platinum IDs."
	icon_state = "centcom"
	registered_name = "Central Command"
	assignment = "Guest"
	New()
		access = get_centcom_access("Guest")
		..()

/obj/item/weapon/card/id/centcom/employee
	name = "\improper Centcom ID"
	desc = "An ID given to general employees of Central Command.  It's platinum plated."
	assignment = "Employee"
	New()
		access = get_centcom_access("Employee")

/obj/item/weapon/card/id/centcom/thunder
	name = "\improper Thunderdome Overseer's ID"
	desc = "This ID has access to the bowels of the Thunderdome, a place where anything can happen. It's platinum plated."
	icon_state = "centcom-thunder"
	assignment = "Thunderdome Overseer"
	New()
		access = get_centcom_access("Thunderdome Overseer")

/obj/item/weapon/card/id/centcom/specops
	name = "\improper Special Operations ID"
	desc = "An ID that belongs to those who serve in Central Command's Special Operations, Deathsquad or otherwise. It's platinum plated."
	icon_state = "centcom-specops"
	assignment = "Spec Ops"
	New()
		access = get_centcom_access("Spec Ops")

/obj/item/weapon/card/id/centcom/medsci
	name = "\improper Centcom MedSci ID"
	desc = "Scientists and Medical Doctors share the same department at Centcom. It's platinum plated."
	icon_state = "centcom-medsci"
	assignment = "Med-Sci"
	New()
		access = get_centcom_access("Med-Sci")

/obj/item/weapon/card/id/centcom/engi
	name = "\improper Centcom Engineer"
	desc = "An ID that belongs to an engineer of Central Command.  You wonder if they're any more competent then the station engineers. It's platinum plated."
	icon_state = "centcom-engi"
	assignment = "Engineer"
	New()
		access = get_centcom_access("Engineer")

/obj/item/weapon/card/id/centcom/agent
	name = "\improper Centcom Secret ID"
	desc = "Company policy forbids thinking about this card."
	icon_state = "centcom-agent"
	assignment = "Agent"
	New()
		access = get_centcom_access("Agent")

/obj/item/weapon/card/id/centcom/vice
	name = "\improper Centcom Vice-Admiral's ID"
	desc = "This ID belongs to the Admiral's right-hand man. It's platinum plated, with a silver stripe in the middle."
	icon_state = "centcom-vice"
	assignment = "Vice-Admiral"
	New()
		access = get_all_centcom_access()

/obj/item/weapon/card/id/centcom/admiral
	name = "\improper Centcom Admiral's ID"
	desc = "Centcom's version of the Captain's ID. It's platinum plated, with a gold stripe in the middle."
	icon_state = "centcom-admiral"
	assignment = "Admiral"
	New()
		access = get_all_centcom_access()

/obj/item/weapon/card/id/prisoner
	name = "prisoner ID card"
	desc = "You are a number, you are not a free man."
	icon_state = "orange"
	item_state = "orange-id"
	assignment = "Prisoner"
	registered_name = "Scum"
	var/goal = 0	//How far from freedom?
	var/points = 0

/obj/item/weapon/card/id/prisoner/attack_self(mob/user)
	usr << "You have accumulated [points] out of the [goal] points you need for freedom."

/obj/item/weapon/card/id/prisoner/one
	name = "prisoner card #13-001"
	registered_name = "Prisoner #13-001"

/obj/item/weapon/card/id/prisoner/two
	name = "prisoner card #13-002"
	registered_name = "Prisoner #13-002"

/obj/item/weapon/card/id/prisoner/three
	name = "prisoner card #13-003"
	registered_name = "Prisoner #13-003"

/obj/item/weapon/card/id/prisoner/four
	name = "prisoner card #13-004"
	registered_name = "Prisoner #13-004"

/obj/item/weapon/card/id/prisoner/five
	name = "prisoner card #13-005"
	registered_name = "Prisoner #13-005"

/obj/item/weapon/card/id/prisoner/six
	name = "prisoner card #13-006"
	registered_name = "Prisoner #13-006"

/obj/item/weapon/card/id/prisoner/seven
	name = "prisoner card #13-007"
	registered_name = "Prisoner #13-007"

/obj/item/weapon/card/id/assistant
	name = "assistant employment card"
	desc = "Imprinted with the Assistant Lifelong Enslavement Contract."
	var/registered = FALSE

/obj/item/weapon/card/id/assistant/attackby(obj/item/I, mob/user)
	if(!registered)
		var/obj/item/weapon/card/id/idcard = I.GetID()
		if(idcard)
			desc = "Assistant to [idcard.registered_name]."

			var/datum/job/job = null
			for(var/datum/job/J in job_master.occupations)
				if(J.title == idcard.assignment)
					job = J
					break
			if(job &&!istype(idcard,/obj/item/weapon/card/id/syndicate))
				access |= job.assistant_access
			registered = TRUE
			user << "<span class='notice'>You register the assistant as a part of your department.</span>"

/obj/item/weapon/card/id/assistant/attack_self(mob/user)	//copypasta but not worth proc imo
	user.visible_message("[user] shows \his [src]: \icon[src] [name]: assignment: [registered ? desc : assignment]")

/obj/item/weapon/card/id/assistant/proc/ResetRegistration()
	src.registered = FALSE
	src.desc = "Imprinted with the Assistant Lifelong Enslavement Contract."
	var/datum/job/assdatum = job_master.GetJob("Assistant")
	src.access = assdatum.get_access()

