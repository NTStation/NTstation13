var/global/obj/effect/overlay/plmaster = null // atmospheric overlay for plasma
var/global/obj/effect/overlay/slmaster = null // atmospheric overlay for sleeping gas
var/admin_notice = "" // Admin notice that all clients see when joining the server


// nanomanager, the manager for Nano UIs
var/datum/nanomanager/nanomanager = new()

var/timezoneOffset = 0 // The difference betwen midnight (of the host computer) and 0 world.ticks.

	// For FTP requests. (i.e. downloading runtime logs.)
	// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
var/fileaccess_timer = 0


///////////////////
//  Bible Stuff  //
///////////////////

//Pretty bible names
var/global/list/biblenames =		list("Bible", "Quran", "Scrapbook", "Burning Bible", "Clown Bible", "Banana Bible", "Creeper Bible", "White Bible", "Holy Light", "The God Delusion", "Tome", "The King in Yellow", "Ithaqua", "Scientology", "Melted Bible", "Necronomicon")

//Bible iconstates
var/global/list/biblestates =		list("bible", "koran", "scrapbook", "burning", "honk1", "honk2", "creeper", "white", "holylight", "atheist", "tome", "kingyellow", "ithaqua", "scientology", "melted", "necronomicon")

//Bible itemstates
var/global/list/bibleitemstates =	list("bible", "koran", "scrapbook", "bible", "bible", "bible", "syringe_kit", "syringe_kit", "syringe_kit", "syringe_kit", "syringe_kit", "kingyellow", "ithaqua", "scientology", "melted", "necronomicon")

//Bible deity names, Stolen from Fiction and gathered from the Players
var/global/list/bibledeitynames = 	list("Space Jesus","Space Satan","Cthulu","Armok","Honk Mother","Gia","Beelzebub","Ymir","Zeus","Yog-Sothoth","Talos","Cuban Pete", \
"Chaos","Slaanesh","Death","Drilldoizer","Astaruas","Bringer of Deep fryer","Gwyn","Flying Spaghetti Monster","The Force","Great Corgi","Mr Rogers","Old man Henderson", \
"Galactus, Eater of Worlds","Gozer the Gozerian","Crom","The Q Continuum","Arceus","Eru Ilúvatar","Honk Father","Silencer", "Toolboxia","Bhaal","Comdomiom","God-king Boris")




