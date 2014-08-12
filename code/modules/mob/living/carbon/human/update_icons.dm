	///////////////////////
	//UPDATE_ICONS SYSTEM//
	///////////////////////
/* Keep these comments up-to-date if you -insist- on hurting my code-baby ;_;
This system allows you to update individual mob-overlays, without regenerating them all each time.
When we generate overlays we generate the standing version and then rotate the mob as necessary..

As of the time of writing there are 20 layers within this list. Please try to keep this from increasing. //21 Total, Keeping things simple
	var/overlays_standing[20]		//For the standing stance

Most of the time we only wish to update one overlay:
	e.g. - we dropped the fireaxe out of our left hand and need to remove its icon from our mob
	e.g.2 - our hair colour has changed, so we need to update our hair icons on our mob
In these cases, instead of updating every overlay using the old behaviour (regenerate_icons), we instead call
the appropriate update_X proc.
	e.g. - update_inv_hands()
	e.g.2 - update_hair()

Note: Recent changes by aranclanos+carn:
	update_icons() no longer needs to be called.
	the system is easier to use. update_icons() should not be called unless you absolutely -know- you need it.
	IN ALL OTHER CASES it's better to just call the specific update_X procs.

All of this means that this code is more maintainable, faster and still fairly easy to use.

There are several things that need to be remembered:
>	Whenever we do something that should cause an overlay to update (which doesn't use standard procs
	( i.e. you do something like l_hand = /obj/item/something new(src), rather than using the helper procs)
	You will need to call the relevant update_inv_* proc

	All of these are named after the variable they update from. They are defined at the mob/ level like
	update_clothing was, so you won't cause undefined proc runtimes with usr.update_inv_wear_id() if the usr is a
	slime etc. Instead, it'll just return without doing any work. So no harm in calling it for slimes and such.


>	There are also these special cases:
		update_mutations()			//handles updating your appearance for certain mutations.  e.g TK head-glows
		update_damage_overlays()	//handles damage overlays for brute/burn damage

		update_body()				//Handles sprite-accessories that didn't really fit elsewhere (underwear, undershirts, socks, lips, eyes)


		update_hair()				//Handles updating your hair overlay (used to be update_face, but mouth and
									eyes were merged into update_body())

		update_body_parts()			//Handles human body parts and augments + mutations using the human icon cache system

>	I repurposed an old unused variable which was in the code called (coincidentally) var/update_icon
	It can be used as another method of triggering regenerate_icons(). It's basically a flag that when set to non-zero
	will call regenerate_icons() at the next life() call and then reset itself to 0.
	The idea behind it is icons are regenerated only once, even if multiple events requested it.
	//NOTE: fairly unused, maybe this could be removed?

If you have any questions/constructive-comments/bugs-to-report
Please contact me on #coderbus IRC. ~Carnie x
//Carn can sometimes be hard to reach now. However IRC is still your best bet for getting help.
*/

//Human Overlays Indexes/////////
#define BODYPARTS_LAYER			21		//Limbs
#define BODY_LAYER				20		//underwear, undershirts, socks, eyes, lips(makeup)
#define MUTATIONS_LAYER			19		//Tk headglows etc.
#define DAMAGE_LAYER			18		//damage indicators (cuts and burns)
#define UNIFORM_LAYER			17
#define ID_LAYER				16
#define SHOES_LAYER				15
#define GLOVES_LAYER			14
#define EARS_LAYER				13
#define SUIT_LAYER				12
#define BELT_LAYER				11		//Possible make this an overlay of somethign required to wear a belt?
#define SUIT_STORE_LAYER		10
#define BACK_LAYER				9
#define HAIR_LAYER				8		//Seperate layer so head items can overlay Hair and Hair underlay head items
#define GLASSES_LAYER			7		//Seperate layer to head so Eye wear is below helmets, but above hair
#define FACEMASK_LAYER			6
#define HEAD_LAYER				5
#define HANDCUFF_LAYER			4
#define LEGCUFF_LAYER			3
#define HANDS_LAYER				2
#define FIRE_LAYER				1		//If you're on fire
#define TOTAL_LAYERS			21		//KEEP THIS UP-TO-DATE OR SHIT WILL BREAK ;_;
//////////////////////////////////
/mob/living/carbon/human
	var/list/overlays_standing[TOTAL_LAYERS]


/mob/living/carbon/human/proc/apply_overlay(cache_index)
	var/image/I = overlays_standing[cache_index]
	if(I)
		overlays += I

/mob/living/carbon/human/proc/remove_overlay(cache_index)
	if(overlays_standing[cache_index])
		overlays -= overlays_standing[cache_index]
		overlays_standing[cache_index] = null

//UPDATES OVERLAYS FROM OVERLAYS_STANDING
//TODO: Remove all instances where this proc is called. It used to be the fastest way to swap between standing/lying.
/mob/living/carbon/human/update_icons()

	update_hud()		//TODO: remove the need for this

	if(overlays.len != overlays_standing.len)
		overlays.Cut()

		for(var/thing in overlays_standing)
			if(thing)	overlays += thing

	update_transform()


//DAMAGE OVERLAYS
//constructs damage icon for each organ from mask * damage field and saves it in our overlays_ lists
/mob/living/carbon/human/update_damage_overlays()
	remove_overlay(DAMAGE_LAYER)

	var/image/standing	= image("icon"='icons/mob/dam_human.dmi', "icon_state"="blank", "layer"=-DAMAGE_LAYER)
	overlays_standing[DAMAGE_LAYER]	= standing

	for(var/obj/item/organ/limb/O in organs)
		if(O.state == ORGAN_REMOVED)
			continue
		if(O.brutestate)
			standing.overlays	+= "[O.dam_icon]_[O.brutestate]0"	//we're adding dam_icons of the base image as overlays
		if(O.burnstate)
			standing.overlays	+= "[O.dam_icon]_0[O.burnstate]"

	apply_overlay(DAMAGE_LAYER)


//HAIR OVERLAY
/mob/living/carbon/human/proc/update_hair()
	//Reset our hair
	remove_overlay(HAIR_LAYER)
	var/obj/item/organ/limb/head/HEAD_ORGAN = get_organ("head")

	//mutants don't have hair. masks and helmets can obscure our hair too.
	if( has_organic_effect(/datum/organic_effect/husk) || (dna && dna.mutantrace) || (head && (head.flags & BLOCKHAIR)) || (wear_mask && (wear_mask.flags & BLOCKHAIR)) )
		return

	if( (wear_suit) && (wear_suit.flags & BLOCKHAIR) && (!wear_suit.has_hood) )
		return

	if(HEAD_ORGAN.status == ORGAN_ROBOTIC || HEAD_ORGAN.state == ORGAN_REMOVED)
		return

	//base icons
	var/datum/sprite_accessory/S
	var/list/standing	= list()

//beardz

	if(facial_hair_style)
		S = facial_hair_styles_list[facial_hair_style]
		if(S)
			var/image/img_facial_s = image("icon" = S.icon, "icon_state" = "[S.icon_state]_s", "layer" = -HAIR_LAYER)

			var/new_color = "#" + facial_hair_color
			img_facial_s.color = new_color

			standing	+= img_facial_s

	//Applies the debrained overlay if there is no brain
	if(!getorgan(/obj/item/organ/brain) && HEAD_ORGAN.state == ORGAN_FINE)
		standing	+= image("icon"='icons/mob/human_face.dmi', "icon_state" = "debrained_s", "layer" = -HAIR_LAYER)

	if((wear_suit) && (wear_suit.has_hood) && (wear_suit.is_toggled == 2))
		if(standing.len)
			overlays_standing[HAIR_LAYER]    = standing
		apply_overlay(HAIR_LAYER)
		return
//hairz
	else if(hair_style)
		S = hair_styles_list[hair_style]
		if(S)
			var/image/img_hair_s = image("icon" = S.icon, "icon_state" = "[S.icon_state]_s", "layer" = -HAIR_LAYER)

			var/new_color = "#" + hair_color
			img_hair_s.color = new_color

			standing	+= img_hair_s

	if(standing.len)
		overlays_standing[HAIR_LAYER]	= standing

	apply_overlay(HAIR_LAYER)


/mob/living/carbon/human/update_mutations()
	remove_overlay(MUTATIONS_LAYER)

	var/list/standing	= list()

	if(has_organic_effect(/datum/organic_effect/cold_res))
		standing	+= image("icon"='icons/effects/genetics.dmi', "icon_state"="fire_s", "layer"=-MUTATIONS_LAYER)
	if(has_organic_effect(/datum/organic_effect/tk))
		standing	+= image("icon"='icons/effects/genetics.dmi', "icon_state"="telekinesishead_s", "layer"=-MUTATIONS_LAYER)
	if(has_organic_effect(/datum/organic_effect/laser))
		standing	+= image("icon"='icons/effects/genetics.dmi', "icon_state"="lasereyes_s", "layer"=-MUTATIONS_LAYER)
	if(standing.len)
		overlays_standing[MUTATIONS_LAYER]	= standing

	apply_overlay(MUTATIONS_LAYER)


/mob/living/carbon/human/proc/update_body()
	remove_overlay(BODY_LAYER)

	var/list/standing	= list()
	var/obj/item/organ/limb/head/HEAD_ORGAN = get_organ("head")

	//Mouth	(lipstick!)

	if(HEAD_ORGAN.state == ORGAN_FINE)
		if(lip_style)
			standing	+= image("icon"='icons/mob/human_face.dmi', "icon_state"="lips_[lip_style]_s", "layer" = -BODY_LAYER)

	//Eyes
	if(HEAD_ORGAN.state == ORGAN_FINE)
		if(!dna || dna.mutantrace != "skeleton")
			var/image/img_eyes_s = image("icon" = 'icons/mob/human_face.dmi', "icon_state" = "eyes_s", "layer" = -BODY_LAYER)

			var/new_color = "#" + eye_color

			img_eyes_s.color = new_color

			standing	+= img_eyes_s

	//Underwear
	if(underwear)
		var/datum/sprite_accessory/underwear/U = underwear_all[underwear]
		if(U)
			standing	+= image("icon"=U.icon, "icon_state"="[U.icon_state]_s", "layer"=-BODY_LAYER)


	if(undershirt)
		var/datum/sprite_accessory/undershirt/U2 = undershirt_list[undershirt]
		if(U2)
			standing	+= image("icon"=U2.icon, "icon_state"="[U2.icon_state]_s", "layer"=-BODY_LAYER)


	if(socks)
		if(get_num_limbs_of_state(LEG_RIGHT,ORGAN_FINE) >= 2)
			var/datum/sprite_accessory/socks/U3 = socks_list[socks]
			if(U3)
				standing	+= image("icon"=U3.icon, "icon_state"="[U3.icon_state]_s", "layer"=-BODY_LAYER)

	if(standing.len)
		overlays_standing[BODY_LAYER]	= standing

	apply_overlay(BODY_LAYER)


/mob/living/carbon/human/proc/update_body_parts()
	icon_state = ""
	base_icon_state = ""

	//CHECK FOR UPDATE
	var/oldkey = icon_render_key
	generate_icon_render_key()

	if(oldkey == icon_render_key)
		human_icon_debug_text(1)
		return


	remove_overlay(BODYPARTS_LAYER)

	//LOAD ICONS
	if(human_icon_cache[icon_render_key])

		human_icon_debug_text(2)

		load_from_cache()

		update_damage_overlays()
		update_inv_gloves()
		update_hair()

		return

	//GENERATE ICONS
	var/list/new_limbs = list()

	for(var/obj/item/organ/limb/L in organs)
		var/image/temp = generate_icon(L)
		if(temp)
			new_limbs += temp

	if(new_limbs.len)
		overlays_standing[BODYPARTS_LAYER] = new_limbs
		human_icon_cache[icon_render_key] = new_limbs

		human_icon_debug_text(3)

	apply_overlay(BODYPARTS_LAYER)

	update_damage_overlays()
	update_inv_gloves()
	update_hair()


/mob/living/carbon/human/update_fire()

	remove_overlay(FIRE_LAYER)
	if(on_fire)
		overlays_standing[FIRE_LAYER] = image("icon"='icons/mob/OnFire.dmi', "icon_state"="Standing", "layer"=-FIRE_LAYER)

	apply_overlay(FIRE_LAYER)


/* --------------------------------------- */
//For legacy support.
/mob/living/carbon/human/regenerate_icons()
	..()
	if(notransform)		return
	update_body()
	update_body_parts()
	update_hair()
	update_mutations()
	update_inv_w_uniform()
	update_inv_wear_id()
	update_inv_gloves()
	update_inv_glasses()
	update_inv_ears()
	update_inv_shoes()
	update_inv_s_store()
	update_inv_wear_mask()
	update_inv_head()
	update_inv_belt()
	update_inv_back()
	update_inv_wear_suit()
	update_inv_hands()
	update_inv_handcuffed()
	update_inv_legcuffed()
	update_inv_pockets()
	update_fire()
	update_transform()
	//Hud Stuff
	update_hud()

/* --------------------------------------- */
//vvvvvv UPDATE_INV PROCS vvvvvv

/mob/living/carbon/human/update_inv_w_uniform()
	remove_overlay(UNIFORM_LAYER)

	if(istype(w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = w_uniform
		if(client && hud_used && hud_used.hud_shown)
			if(hud_used.inventory_shown)			//if the inventory is open ...
				w_uniform.screen_loc = ui_iclothing //...draw the item in the inventory screen
			client.screen += w_uniform				//Either way, add the item to the HUD

		var/t_color = w_uniform.item_color
		if(!t_color)		t_color = icon_state

		var/image/standing	= U.get_onmob_icon("uniform", -UNIFORM_LAYER)
		overlays_standing[UNIFORM_LAYER]	= standing

		var/G = (gender == FEMALE) ? "f" : "m"
		if(G == "f" && U.fitted == 1 && !U.item_state_icon)
			var/index = "[t_color]_s"
			var/icon/female_uniform_icon = female_uniform_icons[index]
			if(!female_uniform_icon ) 	//Create standing/laying icons if they don't exist
				generate_uniform(index,t_color)
			standing	= image("icon"=female_uniform_icons["[t_color]_s"], "layer"=-UNIFORM_LAYER)
			standing.color = w_uniform.color
			standing.alpha = w_uniform.alpha
			overlays_standing[UNIFORM_LAYER]	= standing

		if(w_uniform.blood_DNA)
			standing.overlays	+= image("icon"='icons/effects/blood.dmi', "icon_state"="uniformblood")

		if(U.hastie)
			var/tie_color = U.hastie.item_color
			if(!tie_color) tie_color = U.hastie.icon_state
			var/image/tie = image("icon"='icons/mob/ties.dmi', "icon_state"="[tie_color]")
			tie.color = U.hastie.color
			tie.alpha = U.hastie.alpha

			standing.overlays	+= tie
	else
		// Automatically drop anything in store / id / belt if you're not wearing a uniform.	//CHECK IF NECESARRY
		for(var/obj/item/thing in list(r_store, l_store, wear_id, belt))						//
			unEquip(thing)

	apply_overlay(UNIFORM_LAYER)


/mob/living/carbon/human/update_inv_wear_id()
	remove_overlay(ID_LAYER)
	if(wear_id)
		if(client && hud_used && hud_used.hud_shown)
			wear_id.screen_loc = ui_id	//TODO
			client.screen += wear_id

		overlays_standing[ID_LAYER]	= image("icon"='icons/mob/mob.dmi', "icon_state"="id", "layer"=-ID_LAYER)

	apply_overlay(ID_LAYER)


/mob/living/carbon/human/update_inv_gloves()
	remove_overlay(GLOVES_LAYER)
	if(gloves)
		if(client && hud_used && hud_used.hud_shown)
			if(hud_used.inventory_shown)			//if the inventory is open ...
				gloves.screen_loc = ui_gloves		//...draw the item in the inventory screen
			client.screen += gloves					//Either way, add the item to the HUD

		if(get_num_limbs_of_state(ARM_RIGHT,ORGAN_FINE) >= 2)//if it's less than 2, don't bother rendering
			var/image/standing = gloves.get_onmob_icon("hands", -GLOVES_LAYER)
			overlays_standing[GLOVES_LAYER]	= standing

			if(gloves.blood_DNA)
				standing.overlays	+= image("icon"='icons/effects/blood.dmi', "icon_state"="bloodyhands")

		else
			unEquip(gloves)

	else
		if(blood_DNA && get_num_limbs_of_state(ARM_RIGHT,ORGAN_FINE) >= 2)
			overlays_standing[GLOVES_LAYER]	= image("icon"='icons/effects/blood.dmi', "icon_state"="bloodyhands")

	apply_overlay(GLOVES_LAYER)



/mob/living/carbon/human/update_inv_glasses()
	remove_overlay(GLASSES_LAYER)

	if(glasses)
		if(client && hud_used && hud_used.hud_shown)
			if(hud_used.inventory_shown)			//if the inventory is open ...
				glasses.screen_loc = ui_glasses		//...draw the item in the inventory screen
			client.screen += glasses				//Either way, add the item to the HUD

		overlays_standing[GLASSES_LAYER]	= glasses.get_onmob_icon("eyes", -GLASSES_LAYER)

	apply_overlay(GLASSES_LAYER)


/mob/living/carbon/human/update_inv_ears()
	remove_overlay(EARS_LAYER)

	if(ears)
		if(client && hud_used && hud_used.hud_shown)
			if(hud_used.inventory_shown)			//if the inventory is open ...
				ears.screen_loc = ui_ears			//...draw the item in the inventory screen
			client.screen += ears					//Either way, add the item to the HUD

		overlays_standing[EARS_LAYER] = ears.get_onmob_icon("ears", -EARS_LAYER)

	apply_overlay(EARS_LAYER)


/mob/living/carbon/human/update_inv_shoes()
	remove_overlay(SHOES_LAYER)

	if(shoes)
		if(client && hud_used && hud_used.hud_shown)
			if(hud_used.inventory_shown)			//if the inventory is open ...
				shoes.screen_loc = ui_shoes			//...draw the item in the inventory screen
			client.screen += shoes					//Either way, add the item to the HUD

		if(get_num_limbs_of_state(LEG_RIGHT,ORGAN_FINE) == 2)
			var/image/standing = shoes.get_onmob_icon("shoes", -SHOES_LAYER)
			overlays_standing[SHOES_LAYER] = standing

			if(shoes.blood_DNA)
				standing.overlays	+= image("icon"='icons/effects/blood.dmi', "icon_state"="shoeblood")
		else
			unEquip(shoes)

	apply_overlay(SHOES_LAYER)


/mob/living/carbon/human/update_inv_s_store()
	remove_overlay(SUIT_STORE_LAYER)

	if(s_store)
		if(client && hud_used && hud_used.hud_shown)
			s_store.screen_loc = ui_sstore1		//TODO
			client.screen += s_store

		overlays_standing[SUIT_STORE_LAYER]	= s_store.get_onmob_icon("s_store", -SUIT_STORE_LAYER)

	apply_overlay(SUIT_STORE_LAYER)



/mob/living/carbon/human/update_inv_head()
	remove_overlay(HEAD_LAYER)

	if(head)
		if(client && hud_used && hud_used.hud_shown)
			if(hud_used.inventory_shown)				//if the inventory is open ...
				head.screen_loc = ui_head		//TODO	//...draw the item in the inventory screen
			client.screen += head						//Either way, add the item to the HUD

		var/image/standing = head.get_onmob_icon("head", -HEAD_LAYER)
		overlays_standing[HEAD_LAYER] = standing

		if(head.blood_DNA)
			standing.overlays	+= image("icon"='icons/effects/blood.dmi', "icon_state"="helmetblood")

	apply_overlay(HEAD_LAYER)


/mob/living/carbon/human/update_inv_belt()
	remove_overlay(BELT_LAYER)

	if(belt)
		if(client && hud_used && hud_used.hud_shown)
			belt.screen_loc = ui_belt
			client.screen += belt

		overlays_standing[BELT_LAYER]	= belt.get_onmob_icon("belt", -BELT_LAYER)

	apply_overlay(BELT_LAYER)



/mob/living/carbon/human/update_inv_wear_suit()
	remove_overlay(SUIT_LAYER)

	if(get_num_limbs_of_state(ARM_RIGHT,ORGAN_REMOVED) >= 2 && get_num_limbs_of_state(LEG_RIGHT,ORGAN_REMOVED) >= 2)
		if(wear_suit)
			unEquip(wear_suit)
		return

	if(istype(wear_suit, /obj/item/clothing/suit))
		if(client && hud_used && hud_used.hud_shown)
			if(hud_used.inventory_shown)					//if the inventory is open ...
				wear_suit.screen_loc = ui_oclothing	//TODO	//...draw the item in the inventory screen
			client.screen += wear_suit						//Either way, add the item to the HUD

		var/image/standing = wear_suit.get_onmob_icon("suit", -SUIT_LAYER)
		overlays_standing[SUIT_LAYER] = standing

		if(istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
			unEquip(handcuffed)
			drop_l_hand()
			drop_r_hand()

		if(wear_suit.blood_DNA)
			var/obj/item/clothing/suit/S = wear_suit
			standing.overlays	+= image("icon"='icons/effects/blood.dmi', "icon_state"="[S.blood_overlay_type]blood")

	src.update_hair()
	apply_overlay(SUIT_LAYER)


/mob/living/carbon/human/update_inv_pockets()
	if(l_store)
		if(client && hud_used && hud_used.hud_shown)
			l_store.screen_loc = ui_storage1	//TODO
			client.screen += l_store
	if(r_store)
		if(client && hud_used && hud_used.hud_shown)
			r_store.screen_loc = ui_storage2	//TODO
			client.screen += r_store


/mob/living/carbon/human/update_inv_wear_mask()
	remove_overlay(FACEMASK_LAYER)

	if(istype(wear_mask, /obj/item/clothing/mask))
		if(client && hud_used && hud_used.hud_shown)
			if(hud_used.inventory_shown)				//if the inventory is open ...
				wear_mask.screen_loc = ui_mask	//TODO	//...draw the item in the inventory screen
			client.screen += wear_mask					//Either way, add the item to the HUD

		var/image/standing = wear_mask.get_onmob_icon("mask", -FACEMASK_LAYER)
		overlays_standing[FACEMASK_LAYER] = standing

		if(wear_mask.blood_DNA && !istype(wear_mask, /obj/item/clothing/mask/cigarette))
			standing.overlays	+= image("icon"='icons/effects/blood.dmi', "icon_state"="maskblood")


	apply_overlay(FACEMASK_LAYER)



/mob/living/carbon/human/update_inv_back()
	remove_overlay(BACK_LAYER)

	if(get_num_limbs_of_state(ARM_RIGHT,ORGAN_REMOVED) >= 2)
		if(back)
			unEquip(back)
		return

	if(back)
		if(client && hud_used && hud_used.hud_shown)
			back.screen_loc = ui_back	//TODO
			client.screen += back

		overlays_standing[BACK_LAYER]	= back.get_onmob_icon("back", -BACK_LAYER)

	apply_overlay(BACK_LAYER)



/mob/living/carbon/human/update_hud()	//TODO: do away with this if possible
	if(client)
		client.screen |= contents
		if(hud_used)
			hud_used.hidden_inventory_update() 	//Updates the screenloc of the items on the 'other' inventory bar


/mob/living/carbon/human/update_inv_handcuffed()
	remove_overlay(HANDCUFF_LAYER)

	if(handcuffed)
		drop_r_hand()
		drop_l_hand()
		stop_pulling()	//TODO: should be handled elsewhere
		if(hud_used)	//hud handcuff icons
			var/obj/screen/inventory/R = hud_used.adding[3]
			var/obj/screen/inventory/L = hud_used.adding[4]
			R.overlays += image("icon"='icons/mob/screen_gen.dmi', "icon_state"="markus")
			L.overlays += image("icon"='icons/mob/screen_gen.dmi', "icon_state"="gabrielle")

		overlays_standing[HANDCUFF_LAYER]	= image("icon"='icons/mob/mob.dmi', "icon_state"="handcuff1", "layer"=-HANDCUFF_LAYER)
	else
		if(hud_used)
			var/obj/screen/inventory/R = hud_used.adding[3]
			var/obj/screen/inventory/L = hud_used.adding[4]
			R.overlays = null
			L.overlays = null

	apply_overlay(HANDCUFF_LAYER)


/mob/living/carbon/human/update_inv_legcuffed()
	remove_overlay(LEGCUFF_LAYER)

	if(legcuffed)
		overlays_standing[LEGCUFF_LAYER]	= image("icon"='icons/mob/mob.dmi', "icon_state"="legcuff1", "layer"=-LEGCUFF_LAYER)

	apply_overlay(LEGCUFF_LAYER)


/mob/living/carbon/human/update_inv_hands()
	var/list/H_hands_overlays = list()

	remove_overlay(HANDS_LAYER)

	if(handcuffed)
		drop_l_hand()
		drop_r_hand()
		return
	if(l_hand)
		if(client)
			l_hand.screen_loc = ui_lhand
			client.screen += l_hand

		H_hands_overlays += l_hand.get_onmob_icon("l_hand", -HANDS_LAYER)

	if(r_hand)
		if(client)
			r_hand.screen_loc = ui_rhand
			client.screen += r_hand

		H_hands_overlays += r_hand.get_onmob_icon("r_hand", -HANDS_LAYER)

	if(H_hands_overlays.len)
		overlays_standing[HANDS_LAYER] = H_hands_overlays

	apply_overlay(HANDS_LAYER)



///////////////////////
// Human icon cache! //
// By Remie Richards //
///////////////////////

/*
	Called from update_body_parts() these procs handle the human icon cache the human icon cache uses a human mob's
	icon_render_key to either load an icon matching the key	or create one and add it to the cache.
	at present icon_render_key stores the following:
	- skin_tone
	- mutant_type (a local variable to these procs which simplifies mutantraces for the procs)
	- gender
	- limbs (these are stored as the limb's name, and whether it is REMOVED, ORGANIC or ROBOTIC)
	These procs do NOT extend to hair or sprite accesories or clothing as that would reduce the number of "matches" in the cache
	effectively negating the entire existance of the cache

	The cache essentially causes human icon operations involving limbs to get faster as a round progresses
	this progress is lost at the start of the next round

	The cache's original inspiration is based on the estimated cost of generating human overlays of limbs, the cache means
	that a new icon is only created where needed.
*/


var/global/list/human_icon_cache = list()


/mob/living/carbon/human
	var/icon_render_key = ""


///////////////////////
// get_mutant_type() //
///////////////////////
//simplifies dna.mutantraces and non mutantraces and husks and hulks into one var

/mob/living/carbon/human/proc/get_mutant_type()
	var/mutant_type = null
	var/race = dna ? dna.mutantrace : null

	if(!has_organic_effect(/datum/organic_effect/husk) && !has_organic_effect(/datum/organic_effect/hulk))
		if(race)
			if(race == "adamantine")
				mutant_type = "golem"
			else
				mutant_type = race
		else
			mutant_type = "normal"

	else
		if(has_organic_effect(/datum/organic_effect/husk))
			mutant_type = "husk"
		else if(has_organic_effect(/datum/organic_effect/hulk))
			mutant_type = "hulk"

	if(mutant_type)
		return mutant_type


////////////////////////////////
// generate_icon_render_key() //
////////////////////////////////
//produces a key based on a human's state

/mob/living/carbon/human/proc/generate_icon_render_key()
	var/mutant_type = get_mutant_type()

	icon_render_key = "" //Reset render_key

	if(mutant_type == "normal")
		icon_render_key += "|[skin_tone]" //Skin tone

	else
		icon_render_key += "|[mutant_type]" //Mutantrace/Normal human

	icon_render_key += "|[gender]" //Gender

	for(var/obj/item/organ/limb/L in organs) //Limb status
		if(L.state == ORGAN_REMOVED)
			icon_render_key += "|[L.name]=removed"
		else
			if(L.status == ORGAN_ORGANIC)
				icon_render_key += "|[L.name]=organic"
			else
				icon_render_key += "|[L.name]=robotic"

	icon_render_key += "|" //Make it look neat on the end



///////////////////////
// load_from_cache() //
///////////////////////
//change the human's icon to the one matching it's key

/mob/living/carbon/human/proc/load_from_cache()
	if(human_icon_cache[icon_render_key])
		remove_overlay(BODYPARTS_LAYER)
		overlays_standing[BODYPARTS_LAYER] = human_icon_cache[icon_render_key]
		apply_overlay(BODYPARTS_LAYER)


/////////////////////
// generate_icon() //
/////////////////////
//builds an icon of the limb

/mob/living/carbon/human/proc/generate_icon(var/obj/item/organ/limb/affecting)
	var/image/I
	var/icon_gender = (gender == FEMALE) ? "f" : "m"

	var/icon/human_parts = 'icons/mob/human_parts.dmi'
	var/icon/augment_parts = 'icons/mob/augments.dmi'

	var/mutant_type = get_mutant_type()


	if(affecting.state == ORGAN_REMOVED && affecting.visibly_dismembers)
		return 0

	if(affecting.body_part == HEAD || affecting.body_part == CHEST) //these have gender and use it in their icons
		if(affecting.status == ORGAN_ORGANIC) //Heads bypass this due to the icon
			if(mutant_type != "normal")//Skin tone is irrelevant in Mutant races
				if(stat == DEAD)
					if(mutant_type == "plant")
						I						= image("icon"=human_parts, "icon_state"="[mutant_type]_[affecting.name]_[icon_gender]_dead_s", "layer"=-BODYPARTS_LAYER)


					else if(mutant_type == "husk")
						I						= image("icon"=human_parts, "icon_state"="[mutant_type]_[affecting.name]_s","layer"=-BODYPARTS_LAYER)

				else
					I							= image("icon"=human_parts, "icon_state"="[mutant_type]_[affecting.name]_[icon_gender]_s","layer"=-BODYPARTS_LAYER)


			if(mutant_type == "normal") //Skin tone IS Relevant in "Normal" race humans
				I								= image("icon"=human_parts,"icon_state"="[skin_tone]_[affecting.name]_[icon_gender]_s","layer"=-BODYPARTS_LAYER)

		else if(affecting.status == ORGAN_ROBOTIC)
			I									= image("icon"=augment_parts,"icon_state"="[affecting.name]_[icon_gender]_s","layer"=-BODYPARTS_LAYER)

	else
		if(affecting.status == ORGAN_ORGANIC)
			if(mutant_type != "normal")
				if(stat == DEAD)
					if(mutant_type == "plant")
						I					= image("icon"=human_parts, "icon_state"="[mutant_type]_[affecting.name]_dead_s", "layer"=-BODYPARTS_LAYER)
					else
						I					= image("icon"=human_parts,"icon_state"="[mutant_type]_[affecting.name]_s", "layer"=-BODYPARTS_LAYER)
				else
					I						= image("icon"=human_parts,"icon_state"="[mutant_type]_[affecting.name]_s", "layer"=-BODYPARTS_LAYER)
			else if(mutant_type == "normal")
				I							= image("icon"=human_parts,"icon_state"="[skin_tone]_[affecting.name]_s", "layer"=-BODYPARTS_LAYER)
		else if(affecting.status == ORGAN_ROBOTIC)
			I								= image("icon"=augment_parts,"icon_state"="[affecting.name]_s","layer"=-BODYPARTS_LAYER)

	if(I)
		return I
	return 0

////////////////////////////////////
// update_body_parts() debug text //
////////////////////////////////////
//when the world is in debug mode (Debug = 1) update_body_parts() prints it's work as it goes along

/mob/living/carbon/human/proc/human_icon_debug_text(var/mode)
	if(!Debug2) //Yes Debug2 is the var
		return

	message_admins("Human mob: [name]")

	switch(mode)
		if(1)
			message_admins("No icon update was needed!")
		if(2)
			message_admins("An icon was retrieved from the icon cache!")
		if(3)
			message_admins("A new list of images were created and cached!")

	message_admins("Icon Render Key is ")
	message_admins("[icon_render_key]")


//Human Overlays Indexes/////////
#undef BODYPARTS_LAYER
#undef BODY_LAYER
#undef MUTATIONS_LAYER
#undef DAMAGE_LAYER
#undef UNIFORM_LAYER
#undef ID_LAYER
#undef SHOES_LAYER
#undef GLOVES_LAYER
#undef EARS_LAYER
#undef SUIT_LAYER
#undef GLASSES_LAYER
#undef FACEMASK_LAYER
#undef BELT_LAYER
#undef SUIT_STORE_LAYER
#undef BACK_LAYER
//#undef HAIR_LAYER //Keeping these defined, for easy Head dismemberment
//#undef HEAD_LAYER
#undef HANDCUFF_LAYER
#undef LEGCUFF_LAYER
#undef HANDS_LAYER
#undef FIRE_LAYER
#undef TOTAL_LAYERS
