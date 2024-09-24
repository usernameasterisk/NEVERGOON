/datum/customizer/organ/penis/is_allowed(datum/preferences/prefs)
	return (prefs.gender == MALE)

/datum/customizer/organ/testicles/is_allowed(datum/preferences/prefs)
	return (prefs.gender == MALE)

/datum/customizer/organ/breasts/is_allowed(datum/preferences/prefs)
	return (prefs.gender == FEMALE)

/datum/customizer/organ/vagina/is_allowed(datum/preferences/prefs)
	return (prefs.gender == FEMALE)
