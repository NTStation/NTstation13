
//Not to be confused with /obj/item/weapon/reagent_containers/food/drinks/bottle

/obj/item/weapon/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30)
	flags = OPENCONTAINER
	volume = 30

	New()
		..()
		if(!icon_state)
			icon_state = "bottle[rand(1,20)]"

/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline
	name = "inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"

	New()
		..()
		reagents.add_reagent("inaprovaline", 30)

/obj/item/weapon/reagent_containers/glass/bottle/toxin
	name = "toxin bottle"
	desc = "A small bottle of toxins. Do not drink, it is poisonous."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle12"

	New()
		..()
		reagents.add_reagent("toxin", 30)

/obj/item/weapon/reagent_containers/glass/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle of cyanide. Bitter almonds?"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle12"

	New()
		..()
		reagents.add_reagent("cyanide", 30)

/obj/item/weapon/reagent_containers/glass/bottle/stoxin
	name = "sleep-toxin bottle"
	desc = "A small bottle of sleep toxins. Just the fumes make you sleepy."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle20"

	New()
		..()
		reagents.add_reagent("stoxin", 30)

/obj/item/weapon/reagent_containers/glass/bottle/chloralhydrate
	name = "Chloral Hydrate Bottle"
	desc = "A small bottle of Choral Hydrate. Mickey's Favorite!"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle20"

	New()
		..()
		reagents.add_reagent("chloralhydrate", 15)		//Intentionally low since it is so strong. Still enough to knock someone out.

/obj/item/weapon/reagent_containers/glass/bottle/antitoxin
	name = "anti-toxin bottle"
	desc = "A small bottle of Anti-toxins. Counters poisons, and repairs damage, a wonder drug."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"

	New()
		..()
		reagents.add_reagent("anti_toxin", 30)

/obj/item/weapon/reagent_containers/glass/bottle/mutagen
	name = "unstable mutagen bottle"
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle20"

	New()
		..()
		reagents.add_reagent("mutagen", 30)

/obj/item/weapon/reagent_containers/glass/bottle/plasma
	name = "liquid plasma bottle"
	desc = "A small bottle of liquid plasma. Extremely toxic and reacts with micro-organisms inside blood."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle8"

	New()
		..()
		reagents.add_reagent("plasma", 30)


/obj/item/weapon/reagent_containers/glass/bottle/synaptizine
	name = "synaptizine bottle"
	desc = "A small bottle of synaptizine."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle20"

	New()
		..()
		reagents.add_reagent("synaptizine", 30)

/obj/item/weapon/reagent_containers/glass/bottle/ammonia
	name = "ammonia bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle20"

	New()
		..()
		reagents.add_reagent("ammonia", 30)

/obj/item/weapon/reagent_containers/glass/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"

	New()
		..()
		reagents.add_reagent("diethylamine", 30)

/obj/item/weapon/reagent_containers/glass/bottle/flu_virion
	name = "Flu virion culture bottle"
	desc = "A small bottle. Contains H13N1 flu virion culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/advance/flu(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/epiglottis_virion
	name = "Epiglottis virion culture bottle"
	desc = "A small bottle. Contains Epiglottis virion culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/advance/voice_change(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/liver_enhance_virion
	name = "Liver enhancement virion culture bottle"
	desc = "A small bottle. Contains liver enhancement virion culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/advance/heal(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/hullucigen_virion
	name = "Hullucigen virion culture bottle"
	desc = "A small bottle. Contains hullucigen virion culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/advance/hullucigen(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/pierrot_throat
	name = "Pierrot's Throat culture bottle"
	desc = "A small bottle. Contains H0NI<42 virion culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/pierrot_throat(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/cold
	name = "Rhinovirus culture bottle"
	desc = "A small bottle. Contains XY-rhinovirus culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/advance/F = new /datum/disease/advance/cold(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/random
	name = "Random culture bottle"
	desc = "A small bottle. Contains a random disease."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/advance/F = new(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/retrovirus
	name = "Retrovirus culture bottle"
	desc = "A small bottle. Contains a retrovirus culture in a synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/dna_retrovirus(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)


/obj/item/weapon/reagent_containers/glass/bottle/gbs
	name = "GBS culture bottle"
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS+ culture in synthblood medium."//Or simply - General BullShit
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	amount_per_transfer_from_this = 5

	New()
		..()
		var/datum/disease/F = new /datum/disease/gbs
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/fake_gbs
	name = "GBS culture bottle"
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS- culture in synthblood medium."//Or simply - General BullShit
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/fake_gbs(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)
/*
/obj/item/weapon/reagent_containers/glass/bottle/rhumba_beat
	name = "Rhumba Beat culture bottle"
	desc = "A small bottle. Contains The Rhumba Beat culture in synthblood medium."//Or simply - General BullShit
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	amount_per_transfer_from_this = 5

	New()
		..()
		var/datum/disease/F = new /datum/disease/rhumba_beat
		var/list/data = list("virus"= F)
		R.add_reagent("blood", 20, data)
*/

/obj/item/weapon/reagent_containers/glass/bottle/brainrot
	name = "Brainrot culture bottle"
	desc = "A small bottle. Contains Cryptococcus Cosmosis culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/brainrot(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/magnitis
	name = "Magnitis culture bottle"
	desc = "A small bottle. Contains a small dosage of Fukkos Miracos."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/magnitis(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)


/obj/item/weapon/reagent_containers/glass/bottle/wizarditis
	name = "Wizarditis culture bottle"
	desc = "A small bottle. Contains a sample of Rincewindus Vulgaris."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/wizarditis(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/pacid
	name = "Polytrinic Acid Bottle"
	desc = "A small bottle. Contains a small amount of Polytrinic Acid"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"
	New()
		..()
		reagents.add_reagent("pacid", 30)

/obj/item/weapon/reagent_containers/glass/bottle/adminordrazine
	name = "Adminordrazine Bottle"
	desc = "A small bottle. Contains the liquid essence of the gods."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"
	New()
		..()
		reagents.add_reagent("adminordrazine", 30)

/obj/item/weapon/reagent_containers/glass/bottle/capsaicin
	name = "Capsaicin Bottle"
	desc = "A small bottle. Contains hot sauce."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		reagents.add_reagent("capsaicin", 30)

/obj/item/weapon/reagent_containers/glass/bottle/frostoil
	name = "Frost Oil Bottle"
	desc = "A small bottle. Contains cold sauce."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"
	New()
		..()
		reagents.add_reagent("frostoil", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle_syndicate"

/obj/item/weapon/reagent_containers/glass/bottle/syndie/chiyanine
	name = "chiyanine bottle"
	desc = "A delayed poison that will cause severe poisoning several minutes after consumption."
	New()
		..()
		reagents.add_reagent("chiyanine", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/mizarudol
	name = "mizarudol bottle"
	desc = "A poison that is known to degrade vision."
	New()
		..()
		reagents.add_reagent("mizarudol", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/iwazarudol
	name = "iwazarudol bottle"
	desc = "A muting poison. It takes a while to start working."
	New()
		..()
		reagents.add_reagent("iwazarudol", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/maizine
	name = "maizine bottle"
	desc = "A very slow acting poison. It does not kill very fast but even small doses may be lethal if left untreated."
	New()
		..()
		reagents.add_reagent("maizine", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/ehuadol
	name = "ehuadol bottle"
	desc = "A very complex and dangerous poison."
	New()
		..()
		reagents.add_reagent("ehuadol", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/impedrezene
	name = "impedrezene bottle"
	desc = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	New()
		..()
		reagents.add_reagent("impedrezene", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/beepskysmash
	name = "beepsky smash bottle"
	desc = "Stuns the victim. Considered a drink by nanotrasen."
	New()
		..()
		reagents.add_reagent("beepskysmash", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/frostoil
	name = "frost oil bottle"
	desc = "A special oil that noticably chills the body. Extraced from Icepeppers."
	New()
		..()
		reagents.add_reagent("frostoil", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/fangshenine
	name = "fangshenine bottle"
	desc = "Irridiates the victim."
	New()
		..()
		reagents.add_reagent("fangshenine", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/amatoxin
	name = "amatoxin bottle"
	desc = "A powerful poison derived from certain species of mushroom."
	New()
		..()
		reagents.add_reagent("amatoxin", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/hunzine
	name = "hunzine bottle"
	desc = "A poison targeting various parts of the body. Known to cause toxic damage to tissue, damage to the brain and severe confusion."
	New()
		..()
		reagents.add_reagent("hunzine", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/chloralhydrate
	name = "chloral hydrate bottle"
	desc = "A powerful sedative."
	New()
		..()
		reagents.add_reagent("chloralhydrate", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/neurotoxin
	name = "neurotoxin bottle"
	desc = "Weakens the victim. Considered a drink by nanotrasen."
	New()
		..()
		reagents.add_reagent("neurotoxin", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/mutagen
	name = "unstable mutagen bottle"
	desc = "Might cause unpredictable mutations."
	New()
		..()
		reagents.add_reagent("mutagen", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/plasma
	name = "plasma bottle"
	desc = "Plasma in its liquid form."
	New()
		..()
		reagents.add_reagent("plasma", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/lexorin
	name = "lexorin bottle"
	desc = "Lexorin temporarily stops respiration. Causes tissue damage."
	New()
		..()
		reagents.add_reagent("lexorin", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/blazeoil
	name = "blaze oil bottle"
	desc = "Causes spontanous combustion when ingested."
	New()
		..()
		reagents.add_reagent("blazeoil", 30)

/obj/item/weapon/reagent_containers/glass/bottle/syndie/slimejelly
	name = "slime jelly bottle"
	desc = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence."
	New()
		..()
		reagents.add_reagent("slimejelly", 30)