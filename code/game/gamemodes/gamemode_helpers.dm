
/*
procs designed to work out the current gamemode.
Added to remove MOST (All hopefully) colons in Gamemode code by
making typecasting of the gamemode easier - RemieRichards
*/


proc/game_is_malf_mode(var/ticker_mode)
	if(istype(ticker_mode,/datum/game_mode/malfunction))
		return 1
	return 0

proc/game_is_cult_mode(var/ticker_mode)
	if(istype(ticker_mode,/datum/game_mode/cult))
		return 1
	return 0

proc/game_is_extended_mode(var/ticker_mode) //if you need this... what are you doing?
	if(istype(ticker_mode,/datum/game_mode/extended))
		return 1
	return 0

proc/game_is_meteor_mode(var/ticker_mode)
	if(istype(ticker_mode,/datum/game_mode/meteor))
		return 1
	return 0

proc/game_is_blob_mode(var/ticker_mode)
	if(istype(ticker_mode,/datum/game_mode/blob))
		return 1
	return 0

proc/game_is_nuclear_mode(var/ticker_mode)
	if(istype(ticker_mode,/datum/game_mode/nuclear))
		return 1
	return 0

proc/game_is_rev_mode(var/ticker_mode)
	if(istype(ticker_mode,/datum/game_mode/revolution))
		return 1
	return 0

proc/game_is_sandbox_mode(var/ticker_mode)
	if(istype(ticker_mode,/datum/game_mode/sandbox))
		return 1
	return 0

proc/game_is_traitor_mode(var/ticker_mode)
	if(istype(ticker_mode,/datum/game_mode/traitor))
		return 1
	return 0

proc/game_is_doubleagents_mode(var/ticker_mode)
	if(istype(ticker_mode,/datum/game_mode/traitor/double_agents))
		return 1
	return 0

proc/game_is_wizard_mode(var/ticker_mode)
	if(istype(ticker_mode,/datum/game_mode/wizard))
		return 1
	return 0


