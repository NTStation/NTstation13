/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/
/proc/init_sprite_accessory_subtypes(prototype, list/L, list/male, list/female)
	if(!istype(L))		L = list()
	if(!istype(male))	male = list()
	if(!istype(female))	female = list()

	for(var/path in typesof(prototype))
		if(path == prototype)	continue
		var/datum/sprite_accessory/D = new path()

		if(D.icon_state)	L[D.name] = D
		else				L += D.name

		switch(D.gender)
			if(MALE)	male += D.name
			if(FEMALE)	female += D.name
			else
				male += D.name
				female += D.name
	return L

/datum/sprite_accessory
	var/icon			//the icon file the accessory is located in
	var/icon_state		//the icon_state of the accessory
	var/name			//the preview name of the accessory
	var/gender = NEUTER	//Determines if the accessory will be skipped or included in random hair generations

//////////////////////
// Hair Definitions //
//////////////////////
/datum/sprite_accessory/hair
	icon = 'icons/mob/human_face.dmi'	  // default icon for all hairs

	short
		name = "Short Hair"	  // try to capatilize the names please~
		icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you

	shorthair2
		name = "Short Hair 2"
		icon_state = "hair_shorthair2"

	cut
		name = "Cut Hair"
		icon_state = "hair_c"

	long
		name = "Shoulder-length Hair"
		icon_state = "hair_b"

	longer
		name = "Long Hair"
		icon_state = "hair_vlong"

	long_over_eye
		name = "Over-eye Long"
		icon_state = "hair_longovereye"

	short_over_eye
		name = "Over-eye Short"
		icon_state = "hair_shortovereye"

	longest
		name = "Very Long Hair"
		icon_state = "hair_longest"

	longest2
		name = "Very Long Over Eye"
		icon_state = "hair_longest2"

	longfringe
		name = "Long Fringe"
		icon_state = "hair_longfringe"

	longestalt
		name = "Longer Fringe"
		icon_state = "hair_vlongfringe"

	gentle
		name = "Gentle"
		icon_state = "hair_gentle"

	halfbang
		name = "Half-banged Hair"
		icon_state = "hair_halfbang"

	halfbangalt
		name = "Half-banged Hair Alt"
		icon_state = "hair_halfbang_alt"

	ponytail1
		name = "Ponytail 1"
		icon_state = "hair_ponytail"

	ponytail2
		name = "Ponytail 2"
		icon_state = "hair_pa"

	ponytail3
		name = "Ponytail 3"
		icon_state = "hair_ponytail3"

	ponytail4
		name = "Ponytail 4"
		icon_state = "hair_ponytail4"

	side_tail
		name = "Side Pony"
		icon_state = "hair_sidetail"

	side_tail2
		name = "Side Pony 2"
		icon_state = "hair_sidetail2"

	side_tail3
		name = "Side Pony 3"
		icon_state = "hair_stail"

	oneshoulder
		name = "One Shoulder"
		icon_state = "hair_oneshoulder"

	tressshoulder
		name = "Tress Shoulder"
		icon_state = "hair_tressshoulder"

	parted
		name = "Parted"
		icon_state = "hair_parted"

	pompadour
		name = "Pompadour"
		icon_state = "hair_pompadour"

	quiff
		name = "Quiff"
		icon_state = "hair_quiff"

	bedhead
		name = "Bedhead"
		icon_state = "hair_bedhead"

	bedhead2
		name = "Bedhead 2"
		icon_state = "hair_bedheadv2"

	bedhead3
		name = "Bedhead 3"
		icon_state = "hair_bedheadv3"

	messy
		name = "Messy"
		icon_state = "hair_messy"

	beehive
		name = "Beehive"
		icon_state = "hair_beehive"

	beehive2
		name = "Beehive 2"
		icon_state = "hair_beehivev2"

	bobcurl
		name = "Bobcurl"
		icon_state = "hair_bobcurl"

	bob
		name = "Bob"
		icon_state = "hair_bobcut"

	bowl
		name = "Bowl"
		icon_state = "hair_bowlcut"

	buzz
		name = "Buzzcut"
		icon_state = "hair_buzzcut"

	crew
		name = "Crewcut"
		icon_state = "hair_crewcut"

	combover
		name = "Combover"
		icon_state = "hair_combover"

	devillock
		name = "Devil Lock"
		icon_state = "hair_devilock"

	dreadlocks
		name = "Dreadlocks"
		icon_state = "hair_dreads"

	curls
		name = "Curls"
		icon_state = "hair_curls"

	afro
		name = "Afro"
		icon_state = "hair_afro"

	afro2
		name = "Afro 2"
		icon_state = "hair_afro2"

	afro_large
		name = "Big Afro"
		icon_state = "hair_bigafro"

	sargeant
		name = "Flat Top"
		icon_state = "hair_sargeant"

	emo
		name = "Emo"
		icon_state = "hair_emo"

	longemo
		name = "Long Emo"
		icon_state = "hair_longemo"

	fag
		name = "Flow Hair"
		icon_state = "hair_f"

	feather
		name = "Feather"
		icon_state = "hair_feather"

	hitop
		name = "Hitop"
		icon_state = "hair_hitop"

	mohawk
		name = "Mohawk"
		icon_state = "hair_d"

	reversemohawk
		name = "Reverse Mohawk"
		icon_state = "hair_reversemohawk"

	jensen
		name = "Adam Jensen Hair"
		icon_state = "hair_jensen"

	gelled
		name = "Gelled Back"
		icon_state = "hair_gelled"

	spiky
		name = "Spiky"
		icon_state = "hair_spikey"

	protagonist
		name = "Slightly long"
		icon_state = "hair_protagonist"

	kusangi
		name = "Kusanagi Hair"
		icon_state = "hair_kusanagi"

	kagami
		name = "Pigtails"
		icon_state = "hair_kagami"

	himecut
		name = "Hime Cut"
		icon_state = "hair_himecut"

	himeup
		name = "Hime Updo"
		icon_state = "hair_himeup"

	antenna
		name = "Ahoge"
		icon_state = "hair_antenna"

	pigtail
		name = "Pig tails"
		icon_state = "hair_pigtails"

	front_braid
		name = "Braided front"
		icon_state = "hair_braidfront"

	lowbraid
		name = "Low Braid"
		icon_state = "hair_hbraid"

	not_floorlength_braid
		name = "High Braid"
		icon_state = "hair_braid2"

	braid
		name = "Floorlength Braid"
		icon_state = "hair_braid"

	shortbraid
		name = "Short Floorlength Braid"
		icon_state = "hair_shortbraid"

	odango
		name = "Odango"
		icon_state = "hair_odango"

	ombre
		name = "Ombre"
		icon_state = "hair_ombre"

	updo
		name = "Updo"
		icon_state = "hair_updo"

	skinhead
		name = "Skinhead"
		icon_state = "hair_skinhead"

	longbangs
		name = "Long Bangs"
		icon_state = "hair_lbangs"

	balding
		name = "Balding Hair"
		icon_state = "hair_e"

	bald
		name = "Bald"
		icon_state = null

	parted
		name = "Side Part"
		icon_state = "hair_part"

	braided
		name = "Braided"
		icon_state = "hair_braided"

	bun
		name = "Bun Head"
		icon_state = "hair_bun"

	braidtail
		name = "Braided Tail"
		icon_state = "hair_braidtail"

	familyman
		name = "Family Man"
		icon_state = "hair_thefamilyman"

	drillruru
		name = "Drillruru"
		icon_state = "hair_drillruru"

	dandypomp
		name = "Dandy Pompadour"
		icon_state = "hair_dandypompadour"

	poofy
		name = "Poofy"
		icon_state = "hair_poofy"

	crono
		name = "Chrono"
		icon_state = "hair_toriyama1"

	vegeta
		name = "Vegeta Hair"
		icon_state = "hair_toriyama2"

	cia
		name = "CIA"
		icon_state = "hair_cia"

	mulder
		name = "Mulder"
		icon_state = "hair_mulder"

	scully
		name = "Scully"
		icon_state = "hair_scully"

	nitori
		name = "Nitori"
		icon_state = "hair_nitori"

	joestar
		name = "Joestar"
		icon_state = "hair_joestar"

	edgeworth
		name = "Edgeworth"
		icon_state = "hair_edgeworth"

	objection
		name = "Wright"
		icon_state = "hair_objection!"

	dubsman
		name = "Dubsman"
		icon_state = "hair_dubsman"

	blackswordsman
		name = "Black Swordsman"
		icon_state = "hair_blackswordsman"

	mentalist
		name = "Mentalist"
		icon_state = "hair_mentalist"

	fujisaki
		name = "Fujisaki"
		icon_state = "hair_fujisaki"

	schierke
		name = "Schierke"
		icon_state = "hair_schierke"

	akari
		name = "Akari"
		icon_state = "hair_akari"

	fujiyabashi
		name = "Fujiyabashi"
		icon_state = "hair_fujiyabashi"

	nia
		name = "Nia"
		icon_state = "hair_nia"

	shinobu
		name = "Shinobu"
		icon_state = "hair_shinobu"

	ramona
		name = "Ramona"
		icon_state = "hair_ramona"

	megaeyebrows
		name = "Mega Eyebrows"
		icon_state = "hair_megaeyebrow"

/////////////////////////////
// Facial Hair Definitions //
/////////////////////////////
/datum/sprite_accessory/facial_hair
	icon = 'icons/mob/human_face.dmi'

	shaved
		name = "Shaved"
		icon_state = null
		gender = NEUTER

	watson
		name = "Watson Mustache"
		icon_state = "facial_watson"

	hogan
		name = "Hulk Hogan Mustache"
		icon_state = "facial_hogan" //-Neek

	vandyke
		name = "Van Dyke Mustache"
		icon_state = "facial_vandyke"

	chaplin
		name = "Square Mustache"
		icon_state = "facial_chaplin"

	selleck
		name = "Selleck Mustache"
		icon_state = "facial_selleck"

	neckbeard
		name = "Neckbeard"
		icon_state = "facial_neckbeard"

	fullbeard
		name = "Full Beard"
		icon_state = "facial_fullbeard"

	longbeard
		name = "Long Beard"
		icon_state = "facial_longbeard"

	vlongbeard
		name = "Very Long Beard"
		icon_state = "facial_wise"

	elvis
		name = "Elvis Sideburns"
		icon_state = "facial_elvis"

	abe
		name = "Abraham Lincoln Beard"
		icon_state = "facial_abe"

	chinstrap
		name = "Chinstrap"
		icon_state = "facial_chin"

	hip
		name = "Hipster Beard"
		icon_state = "facial_hip"

	gt
		name = "Goatee"
		icon_state = "facial_gt"

	jensen
		name = "Adam Jensen Beard"
		icon_state = "facial_jensen"

	dwarf
		name = "Dwarf Beard"
		icon_state = "facial_dwarf"

	fiveoclock
		name = "Five o Clock Shadow"
		icon_state = "facial_fiveoclock"

	fu
		name = "Fu Manchu"
		icon_state = "facial_fumanchu"

///////////////////////////
// Underwear Definitions //
///////////////////////////
/datum/sprite_accessory/underwear
	icon = 'icons/mob/underwear.dmi'

	nude
		name = "Nude"
		icon_state = null
		gender = NEUTER

	male_white
		name = "Mens White"
		icon_state = "male_white"
		gender = MALE

	male_grey
		name = "Mens Grey"
		icon_state = "male_grey"
		gender = MALE

	male_green
		name = "Mens Green"
		icon_state = "male_green"
		gender = MALE

	male_blue
		name = "Mens Blue"
		icon_state = "male_blue"
		gender = MALE

	male_black
		name = "Mens Black"
		icon_state = "male_black"
		gender = MALE

	male_mankini
		name = "Mankini"
		icon_state = "male_mankini"
		gender = MALE

	male_hearts
		name = "Mens Hearts Boxer"
		icon_state = "male_hearts"
		gender = MALE

	male_blackalt
		name = "Mens Black Boxer"
		icon_state = "male_blackalt"
		gender = MALE

	male_greyalt
		name = "Mens Grey Boxer"
		icon_state = "male_greyalt"
		gender = MALE

	male_stripe
		name = "Mens Striped Boxer"
		icon_state = "male_stripe"
		gender = MALE

	male_kinky
		name = "Mens Kinky"
		icon_state = "male_kinky"
		gender = MALE

	male_red
		name = "Mens Red"
		icon_state = "male_red"
		gender = MALE

	female_red
		name = "Ladies Red"
		icon_state = "female_red"
		gender = FEMALE

	female_white
		name = "Ladies White"
		icon_state = "female_white"
		gender = FEMALE

	female_yellow
		name = "Ladies Yellow"
		icon_state = "female_yellow"
		gender = FEMALE

	female_blue
		name = "Ladies Blue"
		icon_state = "female_blue"
		gender = FEMALE

	female_black
		name = "Ladies Black"
		icon_state = "female_black"
		gender = FEMALE

	female_thong
		name = "Ladies Thong"
		icon_state = "female_thong"
		gender = FEMALE

	female_babydoll
		name = "Babydoll"
		icon_state = "female_babydoll"
		gender = FEMALE

	female_babyblue
		name = "Ladies Baby-Blue"
		icon_state = "female_babyblue"
		gender = FEMALE

	female_green
		name = "Ladies Green"
		icon_state = "female_green"
		gender = FEMALE

	female_pink
		name = "Ladies Pink"
		icon_state = "female_pink"
		gender = FEMALE

	female_kinky
		name = "Ladies Kinky"
		icon_state = "female_kinky"
		gender = FEMALE

	female_tankini
		name = "Tankini"
		icon_state = "female_tankini"
		gender = FEMALE

////////////////////////////
// Undershirt Definitions //
////////////////////////////

/datum/sprite_accessory/undershirt
	icon = 'icons/mob/undershirt.dmi'

	nude
		name = "Nude"
		icon_state = null
		gender = NEUTER

	black_shirt
		name = "Black Shirt"
		icon_state = "bl_shirt"
		gender = NEUTER

	black_shirt2
		name = "Black Shirt 2"
		icon_state = "bl_shirt2"
		gender = NEUTER

	white_shirt
		name = "White Shirt"
		icon_state = "wt_shirt"
		gender = NEUTER

	white_shirt2
		name = "White Shirt 2"
		icon_state = "wt_shirt2"
		gender = NEUTER

	black_tank_top
		name = "Black Tank Top"
		icon_state = "bl_ttop"
		gender = NEUTER

	white_tank_top
		name = "White Tank Top"
		icon_state = "wt_ttop"
		gender = NEUTER

	atmos_tank
		name = "Atmos Tank Top"
		icon_state = "atmostank"
		gender = NEUTER

	botany_tank
		name = "Botany Tank Top"
		icon_state = "botanytank"
		gender = NEUTER

	engi_tank
		name = "Engineering Tank Top"
		icon_state = "engitank"
		gender = NEUTER

	sci_tank
		name = "Science Tank Top"
		icon_state = "scitank"
		gender = NEUTER

	mine_tank
		name = "Mining Tank Top"
		icon_state = "minetank"
		gender = NEUTER

	jani_tank
		name = "Janitorial Tank Top"
		icon_state = "janitank"
		gender = NEUTER

	med_tank
		name = "Medical Tank Top"
		icon_state = "medtank"
		gender = NEUTER

	robo_tank
		name = "Robotics Tank Top"
		icon_state = "robotank"
		gender = NEUTER

	sec_tank
		name = "Security Tank Top"
		icon_state = "sectank"
		gender = NEUTER

	rainbow_tank
		name = "Rainbow Tank Top"
		icon_state = "rainbowtank"
		gender = NEUTER

	happy_tank
		name = "Happy Tank Top"
		icon_state = "happytank"
		gender = NEUTER

	neutral_tank
		name = "Neutral Tank Top"
		icon_state = "neutraltank"
		gender = NEUTER

	sad_tank
		name = "Sad Tank Top"
		icon_state = "sadtank"
		gender = NEUTER

	assistant_tank
		name = "Assistant Tank Top"
		icon_state = "assistanttank"
		gender = NEUTER

	dorf_tank
		name = "Dwarf Tank Top"
		icon_state = "dorftank"
		gender = NEUTER

	monkey_tank
		name = "Monkey Tank Top"
		icon_state = "monkeytank"
		gender = NEUTER

	praise_the_sun_tank
		name = "Praise The Sun Tank Top" //Looks a tad shit all capitalised
		icon_state = "praisethesuntank"
		gender = NEUTER

	treehugger_tank
		name = "Treehugger Tank Top"
		icon_state = "treehuggertank"
		gender = NEUTER

	skull_tank
		name = "Skull Tank Top"
		icon_state = "skull_ttop"
		gender = NEUTER

	rus_shirt
		name = "Telnyashka Shirt"
		icon_state = "rus_shirt"
		gender = NEUTER

	rus_tank
		name = "Telnyashka Tank Top"
		icon_state = "rus_ttop"
		gender = NEUTER

	ss13_shirt
		name = "Space Station 13 Shirt"
		icon_state = "ss13shirt"
		gender = NEUTER

	bleed_shirt
		name = "Wound Shirt"
		icon_state = "bleedshirt"
		gender = NEUTER

	ian_shirt
		name = "Corgi Shirt"
		icon_state = "ianshirt"
		gender = NEUTER

	wat_shirt
		name = "Question Shirt"
		icon_state = "watshirt"
		gender = NEUTER

	skull_shirt
		name = "Skull Shirt"
		icon_state = "skullshirt"
		gender = NEUTER

	commie_shirt
		name = "Question Shirt"
		icon_state = "watshirt"
		gender = NEUTER

	nano_shirt
		name = "Nanotrasen Shirt"
		icon_state = "skullshirt"
		gender = NEUTER

///////////////////////
// Socks Definitions //
///////////////////////

/datum/sprite_accessory/socks
	icon = 'icons/mob/socks.dmi'

	none
		name = "None"
		icon_state = null
		gender = NEUTER

	white_norm
		name = "Normal White"
		icon_state = "white_norm"
		gender = NEUTER

	black_norm
		name = "Normal Black"
		icon_state = "black_norm"
		gender = NEUTER

	white_short
		name = "Short White"
		icon_state = "white_short"
		gender = NEUTER

	black_short
		name = "Short Black"
		icon_state = "black_short"
		gender = NEUTER

	white_knee
		name = "Knee-high White"
		icon_state = "white_knee"
		gender = NEUTER

	black_knee
		name = "Knee-high Black"
		icon_state = "black_knee"
		gender = NEUTER

	thin_knee
		name = "Knee-high Thin"
		icon_state = "thin_knee"
		gender = FEMALE

	striped_knee
		name = "Knee-high Striped"
		icon_state = "striped_knee"
		gender = NEUTER

	rainbow_knee
		name = "Knee-high Rainbow"
		icon_state = "rainbow_knee"
		gender = NEUTER

	white_thigh
		name = "Thigh-high White"
		icon_state = "white_thigh"
		gender = NEUTER

	black_thigh
		name = "Thigh-high Black"
		icon_state = "black_thigh"
		gender = NEUTER

	thin_thigh
		name = "Thigh-high Thin"
		icon_state = "thin_thigh"
		gender = FEMALE

	striped_thigh
		name = "Thigh-high Striped"
		icon_state = "striped_thigh"
		gender = NEUTER

	rainbow_thigh
		name = "Thigh-high Rainbow"
		icon_state = "rainbow_thigh"
		gender = NEUTER

	pantyhose
		name = "Pantyhose"
		icon_state = "pantyhose"
		gender = FEMALE
