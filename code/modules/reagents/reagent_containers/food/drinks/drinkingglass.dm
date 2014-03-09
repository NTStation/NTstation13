/obj/item/weapon/reagent_containers/food/drinks/drinkingglass
	name = "glass"
	desc = "Your standard drinking glass. Stores 50 of any reagent."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "glass"
	amount_per_transfer_from_this = 10
	volume = 50

	on_reagent_change()
		update_icon()

	examine()
		set src in view()
		..()
		if(!(usr in view(2)) && usr != loc)
			return
		if(reagents && reagents.reagent_list.len)
			usr << "It contains:"
			for(var/datum/reagent/R in reagents.reagent_list)
				usr << "[R.volume] units of [R.name]"

	update_icon()
		overlays.Cut()

		if(reagents.total_volume)
			var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

			var/percent = round((reagents.total_volume / volume) * 100)
			switch(percent)
				if(0 to 9)		filling.icon_state = "[icon_state]-10"
				if(10 to 24) 	filling.icon_state = "[icon_state]10"
				if(25 to 49)	filling.icon_state = "[icon_state]25"
				if(50 to 74)	filling.icon_state = "[icon_state]50"
				if(75 to 79)	filling.icon_state = "[icon_state]75"
				if(80 to 90)	filling.icon_state = "[icon_state]80"
				if(91 to INFINITY)	filling.icon_state = "[icon_state]100"

			filling.icon += mix_color_from_reagents(reagents.reagent_list)
			overlays += filling

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/shot
	name = "shot glass"
	desc = "A Shot Glass. For when the Shotgun isn't enough of a shot. Stores 10 of any reagent."
	icon_state = "shotglass"
	volume = 10

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/wine
	name = "wine glass"
	desc = "A Wine Glass. Presumably for the fabulously wealthy. Stores 30 of any reagent."
	icon_state = "wineglass"
	amount_per_transfer_from_this = 3	//hon hon hon
	volume = 30

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug
	name = "mug glass"
	desc = "A Glass Mug. Where's a beer keg when you need it? Stores 70 of any reagent."
	icon_state = "mugglass"
	volume = 70

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/bottle
	name = "glass bottle"
	desc = "A Glass Bottle. Good for Cola and Booze. Stores 100 of any reagent."
	icon_state = "bottleglass"
	volume = 100

// for /obj/machinery/vending/sovietsoda
/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/soda
	New()
		..()
		reagents.add_reagent("sodawater", 50)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/cola
	New()
		..()
		reagents.add_reagent("cola", 50)
		on_reagent_change()

//Booze for the Boozegod!
/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/bottle/beer
	name = "NanoBeer"
	desc = "A moderately drukening booze. Brewed by the best NanoTrasen bartenders."
	New()
		..()
		reagents.add_reagent("beer", 100)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/bottle/ale
	name = "Magm-Ale"
	desc = "A light booze, kept chilled."
	New()
		..()
		reagents.add_reagent("ale", 100)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/bottle/kahlua
	name = "Honkish Honking Kahlua"
	desc = "The coffee liqeur of the Clowns. Extremely good, if extremely bitter. And possibly angry."
	New()
		..()
		reagents.add_reagent("kahlua", 100)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/bottle/vodka
	name = "Ukraine 2023 Vodka"
	desc = "An old bottle from post-WWIII Ukraine. Or not, the label says brewed in 2043."
	New()
		..()
		reagents.add_reagent("vodka", 100)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/bottle/whiskey
	name = "Big Jacko's Australian Whiskey"
	desc = "It's the Hardest Drink for the Hardest Cunt of them all."
	New()
		..()
		reagents.add_reagent("whiskey", 100)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/bottle/gin
	name = "Lil' Jacko's Australian Gin"
	desc = "It's the Hardest Drink for the Smallest Cunt of them all."
	New()
		..()
		reagents.add_reagent("gin", 100)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/bottle/rum
	name = "Pun Pun's Jungle Rumma"
	desc = "Brewed by the craziest and most war torn monkey in the solar system, this rum is bananas!"
	New()
		..()
		reagents.add_reagent("rum", 100)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/bottle/wine
	name = "Captain BeardBeard's Vintage 2013 Wine"
	desc = "It's winning, not whining."
	New()
		..()
		reagents.add_reagent("wine", 100)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/bottle/cognac
	name = "MasterBrew Cognac"
	desc = "Probably drank by rich texans."
	New()
		..()
		reagents.add_reagent("cognac", 100)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/bottle/vermouth
	name = "Rhode Island Vermouth"
	desc = "Why the smallest state in the GPDUSA would brew Vermouth, we'll never know. Nontheless it's damned good."
	New()
		..()
		reagents.add_reagent("vermouth", 100)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/bottle/tequilla
	name = "Cuban Tequilla"
	desc = "Gurenteed to leave a trail of fire in your throat and explode out the rear."
	New()
		..()
		reagents.add_reagent("tequilla", 100)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/bottle/patron
	name = "Patronic Patron"
	desc = "A Favorite at Nightclubs throughout the solar system, though we're not sure where it comes from."
	New()
		..()
		reagents.add_reagent("patron", 100)
		on_reagent_change()

//THE MILLIONS OF COCKTAILS. FUCK. WHY WOULD YOU ADD SO MUCH BOOZE?
/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/mead
	New()
		..()
		reagents.add_reagent("mead", 70)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/screwdriver
	New()
		..()
		reagents.add_reagent("screwdrivercocktail", 50)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/wine/gintonic
	New()
		..()
		reagents.add_reagent("gintonic", 30)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/b52
	New()
		..()
		reagents.add_reagent("b52", 50)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/atomicbomb
	New()
		..()
		reagents.add_reagent("atomicbomb", 50)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/shot/whiterussian
	New()
		..()
		reagents.add_reagent("whiterussian", 10)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/shot/blackrussian
	New()
		..()
		reagents.add_reagent("blackrussian", 10)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/shot/whiskeycola
	New()
		..()
		reagents.add_reagent("whiskeycola", 10)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/wine/margarita
	New()
		..()
		reagents.add_reagent("margarita", 30)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/manlydorf
	New()
		..()
		reagents.add_reagent("manlydorf", 70)
		on_reagent_change()