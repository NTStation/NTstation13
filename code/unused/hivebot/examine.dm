/mob/living/silicon/hivebot/examine()
	set src in oview()

	usr << "<span class="notice">*---------*</span>"
	usr << text("<span class="notice">This is \icon[src] <B>[src.name]</B>!</span>")
	if (src.stat == 2)
		usr << text("<span class='alert'> [src.name] is powered-down.</span>")
	if (src.getBruteLoss())
		if (src.getBruteLoss() < 75)
			usr << text("<span class='alert'> [src.name] looks slightly dented</span>")
		else
			usr << text("<span class='alert'> <B>[src.name] looks severely dented!</B></span>")
	if (src.getFireLoss())
		if (src.getFireLoss() < 75)
			usr << text("<span class='alert'> [src.name] looks slightly burnt!</span>")
		else
			usr << text("<span class='alert'> <B>[src.name] looks severely burnt!</B></span>")
	if (src.stat == 1)
		usr << text("<span class='alert'> [src.name] doesn't seem to be responding.</span>")
	return
