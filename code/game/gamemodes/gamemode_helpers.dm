
/*
Proc designed to work out the Gamemode, helps prevent colons - RemieRichards

Parameters/Arguments key:
- changeling
- AI malfunction
- nuclear emergency
- wizard
- traitor
- double agents
- sandbox
- extended
- blob
- meteor
- cult
- revolution
*/

proc/gamemode_is(var/mode_name)
	if(mode_name == ticker.mode.name)
		return 1
	return 0


