/obj/structure/closet/wardrobe
	name = "wardrobe"
	desc = "It's a storage closet for standard-issue Nanotrasen attire."
	icon_state = "blue"
	icon_closed = "blue"

/obj/structure/closet/wardrobe/New()
	new /obj/item/clothing/under/color/blue(src)
	new /obj/item/clothing/under/color/blue(src)
	new /obj/item/clothing/under/color/blue(src)
	new /obj/item/clothing/mask/bandana/blue(src)
	new /obj/item/clothing/mask/bandana/blue(src)
	new /obj/item/clothing/mask/bandana/blue(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	return


/obj/structure/closet/wardrobe/red
	name = "security wardrobe"
	icon_state = "red"
	icon_closed = "red"

/obj/structure/closet/wardrobe/red/New()
	new /obj/item/weapon/storage/backpack/security(src)
	new /obj/item/weapon/storage/backpack/security(src)
	new /obj/item/weapon/storage/backpack/satchel_sec(src)
	new /obj/item/weapon/storage/backpack/satchel_sec(src)
	new /obj/item/clothing/mask/bandana/red(src)
	new /obj/item/clothing/mask/bandana/red(src)
	new /obj/item/clothing/mask/bandana/red(src)
	if(prob(30))
		new /obj/item/clothing/suit/armor/vest/jacket(src)
	if(prob(30))
		new /obj/item/clothing/suit/armor/vest/jacket(src)
	if(prob(30))
		new /obj/item/clothing/under/camo(src)
	if(prob(30))
		new /obj/item/clothing/under/camo(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	return

/obj/structure/closet/wardrobe/hos
	name = "\proper head of security's wardrobe"
	icon_state = "red"
	icon_closed = "red"

/obj/structure/closet/wardrobe/hos/New()
	new /obj/item/clothing/suit/labcoat/coat/security(src)
	new /obj/item/clothing/under/camo(src)
	new /obj/item/clothing/suit/armor/vest/jacket(src)
	new /obj/item/clothing/under/hosformalfem(src)
	new /obj/item/clothing/under/hosformalmale(src)
	new /obj/item/clothing/under/rank/head_of_security/jensen(src)
	return

/obj/structure/closet/wardrobe/pink
	name = "pink wardrobe"
	icon_state = "pink"
	icon_closed = "pink"

/obj/structure/closet/wardrobe/pink/New()
	new /obj/item/clothing/under/lightpink(src)
	new /obj/item/clothing/under/lightpink(src)
	new /obj/item/clothing/under/lightpink(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	return

/obj/structure/closet/wardrobe/black
	name = "black wardrobe"
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/black/New()
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	if(prob(30))
		new /obj/item/clothing/suit/labcoat/coat/jacket/leather(src)
	if(prob(40))
		new /obj/item/clothing/mask/bandana/skull(src)
	else
		new /obj/item/clothing/mask/bandana/black(src)
	if(prob(40))
		new /obj/item/clothing/mask/bandana/skull(src)
	else
		new /obj/item/clothing/mask/bandana/black(src)
	if(prob(40))
		new /obj/item/clothing/mask/bandana/skull(src)
	else
		new /obj/item/clothing/mask/bandana/black(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/head/soft/black(src)
	return


/obj/structure/closet/wardrobe/chaplain_black
	name = "chapel wardrobe"
	desc = "It's a storage unit for Nanotrasen-approved religious attire."
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/chaplain_black/New()
	new /obj/item/clothing/under/rank/chaplain(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/suit/nun(src)
	new /obj/item/clothing/head/nun_hood(src)
	new /obj/item/clothing/suit/chaplain_hoodie(src)
	new /obj/item/clothing/head/chaplain_hood(src)
	new /obj/item/clothing/suit/holidaypriest(src)
	new /obj/item/weapon/storage/backpack/cultpack (src)
	new /obj/item/weapon/storage/fancy/candle_box(src)
	new /obj/item/weapon/storage/fancy/candle_box(src)
	return


/obj/structure/closet/wardrobe/green
	name = "green wardrobe"
	icon_state = "green"
	icon_closed = "green"

/obj/structure/closet/wardrobe/green/New()
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/mask/bandana/green(src)
	new /obj/item/clothing/mask/bandana/green(src)
	new /obj/item/clothing/mask/bandana/green(src)
	new /obj/item/clothing/under/color/lightgreen(src)
	new /obj/item/clothing/under/color/lightgreen(src)
	new /obj/item/clothing/under/color/lightgreen(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	return


/obj/structure/closet/wardrobe/orange
	name = "prison wardrobe"
	desc = "It's a storage unit for Nanotrasen-regulation prisoner attire."
	icon_state = "orange"
	icon_closed = "orange"

/obj/structure/closet/wardrobe/orange/New()
	new /obj/item/clothing/under/color/prison(src)
	new /obj/item/clothing/under/color/prison(src)
	new /obj/item/clothing/under/color/prison(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	return


/obj/structure/closet/wardrobe/yellow
	name = "yellow wardrobe"
	icon_state = "yellow"
	icon_closed = "yeloww"

/obj/structure/closet/wardrobe/yellow/New()
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	return


/obj/structure/closet/wardrobe/atmospherics_yellow
	name = "atmospherics wardrobe"
	icon_state = "atmos"
	icon_closed = "atmos"

/obj/structure/closet/wardrobe/atmospherics_yellow/New()
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/suit/labcoat/coat/atmos(src)
	new /obj/item/clothing/suit/labcoat/coat/atmos(src)
	new /obj/item/taperoll/engineering(src)
	new /obj/item/taperoll/engineering(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	return



/obj/structure/closet/wardrobe/engineering_yellow
	name = "engineering wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/engineering_yellow/New()
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	return


/obj/structure/closet/wardrobe/white
	name = "white wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/white/New()
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	return


/obj/structure/closet/wardrobe/pjs
	name = "pajama wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/pjs/New()
	new /obj/item/clothing/under/pj/red(src)
	new /obj/item/clothing/under/pj/red(src)
	new /obj/item/clothing/under/pj/blue(src)
	new /obj/item/clothing/under/pj/blue(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	return


/obj/structure/closet/wardrobe/toxins_white
	name = "toxins wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/toxins_white/New()
	new /obj/item/weapon/storage/backpack/satchel_tox(src)
	new /obj/item/weapon/storage/backpack/satchel_tox(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/suit/labcoat(src)
	new /obj/item/clothing/suit/labcoat(src)
	new /obj/item/clothing/suit/labcoat(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	return


/obj/structure/closet/wardrobe/robotics_black
	name = "robotics wardrobe"
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/robotics_black/New()
	new /obj/item/weapon/storage/backpack/satchel_robo(src)
	new /obj/item/weapon/storage/backpack/satchel_robo(src)
	new /obj/item/clothing/suit/labcoat(src)
	new /obj/item/clothing/suit/labcoat(src)
	new /obj/item/clothing/under/rank/roboticist(src)
	new /obj/item/clothing/under/rank/roboticist(src)
	if(prob(40))
		new /obj/item/clothing/mask/bandana/skull(src)
	else
		new /obj/item/clothing/mask/bandana/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/head/soft/black(src)
	return


/obj/structure/closet/wardrobe/chemistry_white
	name = "chemistry wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/chemistry_white/New()
	if(prob(40))
		new /obj/item/weapon/storage/backpack/satchel_chem(src)
	if(prob(40))
		new /obj/item/weapon/storage/backpack/satchel_chem(src)
	new /obj/item/clothing/suit/labcoat/chemist(src)
	new /obj/item/clothing/suit/labcoat/chemist(src)
	new /obj/item/clothing/under/rank/chemist(src)
	new /obj/item/clothing/under/rank/chemist(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	return


/obj/structure/closet/wardrobe/genetics_white
	name = "genetics wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/genetics_white/New()
	if(prob(40))
		new /obj/item/weapon/storage/backpack/satchel_gen(src)
	if(prob(40))
		new /obj/item/weapon/storage/backpack/satchel_gen(src)
	new /obj/item/clothing/suit/labcoat/genetics(src)
	new /obj/item/clothing/suit/labcoat/genetics(src)
	new /obj/item/clothing/under/rank/geneticist(src)
	new /obj/item/clothing/under/rank/geneticist(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	return


/obj/structure/closet/wardrobe/virology_white
	name = "virology wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/virology_white/New()
	if(prob(40))
		new /obj/item/weapon/storage/backpack/satchel_vir(src)
	if(prob(40))
		new /obj/item/weapon/storage/backpack/satchel_vir(src)
	new /obj/item/clothing/suit/labcoat/virologist(src)
	new /obj/item/clothing/suit/labcoat/virologist(src)
	new /obj/item/clothing/under/rank/virologist(src)
	new /obj/item/clothing/under/rank/virologist(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	return


/obj/structure/closet/wardrobe/grey
	name = "grey wardrobe"
	icon_state = "grey"
	icon_closed = "grey"

/obj/structure/closet/wardrobe/grey/New()
	if(prob(40))
		new /obj/item/clothing/suit/labcoat/coat(src)
	if(prob(40))
		new /obj/item/clothing/suit/labcoat/coat(src)
	if(prob(40))
		new /obj/item/clothing/suit/labcoat/coat(src)
	if(prob(40))
		new /obj/item/clothing/shoes/boots(src)
	if(prob(40))
		new /obj/item/clothing/shoes/boots(src)
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/head/beanie(src)
	new /obj/item/clothing/head/beanie(src)
	new /obj/item/clothing/head/beanie(src)
	new /obj/item/clothing/head/soft/grey(src)
	new /obj/item/clothing/head/soft/grey(src)
	new /obj/item/clothing/head/soft/grey(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	if(prob(40))
		new /obj/item/clothing/under/assistantformal(src)
	if(prob(40))
		new /obj/item/clothing/under/color/brownoveralls(src)
	return

/obj/structure/closet/wardrobe/mixed
	name = "mixed wardrobe"
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/wardrobe/mixed/New()
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/under/color/blue(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/lightpink(src)
	if(prob(40))
		new /obj/item/clothing/under/color/lightred(src)
	if(prob(40))
		new /obj/item/clothing/under/color/darkred(src)
	if(prob(40))
		new /obj/item/clothing/under/color/darkblue(src)
	new /obj/item/clothing/under/lightpink(src)
	if(prob(40))
		new /obj/item/clothing/under/color/lightgreen(src)
	if(prob(40))
		new /obj/item/clothing/under/color/yellowgreen(src)
	if(prob(40))
		new /obj/item/clothing/under/color/lightbrown(src)
	new /obj/item/clothing/under/color/brown(src)
	if(prob(40))
		new /obj/item/clothing/under/color/lightpurple(src)
	new /obj/item/clothing/under/color/purple(src)
	new /obj/item/clothing/under/color/aqua(src)
	if(prob(40))
		new /obj/item/clothing/under/color/lightblue(src)
	switch(pick("purple", "yellow", "brown"))
		if ("purple")
			new /obj/item/clothing/shoes/sneakers/purple(src)
		if ("yellow")
			new /obj/item/clothing/shoes/sneakers/yellow(src)
		if ("brown")
			new /obj/item/clothing/shoes/sneakers/brown(src)
	switch(pick("blue", "green", "red"))
		if ("blue")
			new /obj/item/clothing/shoes/sneakers/blue(src)
		if ("green")
			new /obj/item/clothing/shoes/sneakers/green(src)
		if ("red")
			new /obj/item/clothing/shoes/sneakers/red(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	return

/obj/structure/closet/wardrobe/casual
	name = "casual wardrobe"
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/wardrobe/casual/New()
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/mask/bandana/blue(src)
	new /obj/item/clothing/mask/bandana/blue(src)
	if(prob(40))
		new /obj/item/clothing/mask/bandana/red(src)
	new /obj/item/clothing/mask/bandana/green(src)
	new /obj/item/clothing/mask/bandana/green(src)
	new /obj/item/clothing/suit/labcoat/coat/jacket(src)
	new /obj/item/clothing/suit/labcoat/coat/jacket(src)
	new /obj/item/clothing/suit/labcoat/coat/jacket(src)
	switch(pick("red", "blue"))
		if ("red")
			new /obj/item/clothing/suit/labcoat/coat/jacket/varsity(src)
		if ("blue")
			new /obj/item/clothing/suit/labcoat/coat/jacket/varsity/blue(src)
	switch(pick("red", "blue"))
		if ("red")
			new /obj/item/clothing/suit/labcoat/coat/jacket/varsity(src)
		if ("blue")
			new /obj/item/clothing/suit/labcoat/coat/jacket/varsity/blue(src)
	switch(pick("red", "blue"))
		if ("red")
			new /obj/item/clothing/suit/labcoat/coat/jacket/varsity(src)
		if ("blue")
			new /obj/item/clothing/suit/labcoat/coat/jacket/varsity/blue(src)
	if(prob(40))
		new /obj/item/clothing/under/camo(src)
	if(prob(40))
		new /obj/item/clothing/under/trackpants(src)
	new /obj/item/clothing/under/khaki(src)
	new /obj/item/clothing/under/jeans(src)
	new /obj/item/clothing/under/jeans(src)
	switch(pick("purple", "yellow", "brown"))
		if ("purple")
			new /obj/item/clothing/shoes/sneakers/purple(src)
		if ("yellow")
			new /obj/item/clothing/shoes/sneakers/yellow(src)
		if ("brown")
			new /obj/item/clothing/shoes/sneakers/brown(src)
	switch(pick("blue", "green", "red"))
		if ("blue")
			new /obj/item/clothing/shoes/sneakers/blue(src)
		if ("green")
			new /obj/item/clothing/shoes/sneakers/green(src)
		if ("red")
			new /obj/item/clothing/shoes/sneakers/red(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	if(prob(40))
		new /obj/item/clothing/under/redoveralls(src)
	return

/obj/structure/closet/wardrobe/medical
	name = "medical wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/medical/New()
	new /obj/item/clothing/under/rank/nursesuit (src)
	new /obj/item/clothing/under/rank/nursesuit (src)
	new /obj/item/clothing/head/nursehat(src)
	new /obj/item/clothing/head/nursehat(src)
	new /obj/item/clothing/suit/labcoat/emt(src)
	new /obj/item/clothing/suit/labcoat/emt(src)
	new /obj/item/clothing/suit/labcoat/coat/medical/emt(src)
	new /obj/item/clothing/suit/labcoat/coat/medical/emt(src)
	new /obj/item/clothing/shoes/steeltoe(src)
	new /obj/item/clothing/shoes/steeltoe(src)
	new /obj/item/clothing/suit/labcoat(src)
	new /obj/item/clothing/suit/labcoat(src)
	switch(pick("blue", "green", "purple"))
		if ("blue")
			new /obj/item/clothing/under/rank/medical/blue(src)
		if ("green")
			new /obj/item/clothing/under/rank/medical/green(src)
		if ("purple")
			new /obj/item/clothing/under/rank/medical/purple(src)
	switch(pick("blue", "green", "purple"))
		if ("blue")
			new /obj/item/clothing/under/rank/medical/blue(src)
		if ("green")
			new /obj/item/clothing/under/rank/medical/green(src)
		if ("purple")
			new /obj/item/clothing/under/rank/medical/purple(src)
	switch(pick("blue", "green", "purple"))
		if ("blue")
			new /obj/item/clothing/under/rank/medical/blue(src)
		if ("green")
			new /obj/item/clothing/under/rank/medical/green(src)
		if ("purple")
			new /obj/item/clothing/under/rank/medical/purple(src)
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
