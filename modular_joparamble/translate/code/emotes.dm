/* EMOTE DATUMS */
/datum/emote/living
	mob_type_allowed_typecache = /mob/living
	mob_type_blacklist_typecache = list(/mob/living/simple_animal/slime, /mob/living/brain)

/datum/emote/living/blush
	key = "blush"
	key_third_person = "краснеет"
	message = "краснеет."


/datum/emote/living/pray
	key = "pray"
	key_third_person = "молится"
	message = "молится."
	restraint_check = FALSE
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_pray()
	set name = "Молится"
	set category = "Emotes"

	emote("pray", intentional = TRUE)

/datum/emote/living/pray/run_emote(mob/user, params, type_override, intentional)
	if(isliving(user))
		var/mob/living/L = user
		var/area/C = get_area(user)
		var/msg = input("Какова будет ваша молитва?:", "Prayer") as text|null
		if(msg)
			L.whisper(msg)
			L.roguepray(msg)
//			for(var/obj/structure/fluff/psycross/P in view(7, get_turf(L)) ) // We'll reenable this later when the patron statues are more fleshed out.
//				if(P.obj_broken)
//					continue
//				P.check_prayer(L,msg)
//				break
			if(istype(C, /area/rogue/underworld))
				L.check_prayer_underworld(L,msg)
				return
			L.check_prayer(L,msg)
			for(var/mob/living/LICKMYBALLS in hearers(2,src))
				LICKMYBALLS.succumb_timer = world.time

/mob/living/proc/check_prayer(mob/living/L,message)
	if(!L || !message)
		return FALSE
	var/message2recognize = sanitize_hear_message(message)
	var/mob/living/carbon/human/M = L
	if(length(message2recognize) > 15)
		if(L.has_flaw(/datum/charflaw/addiction/godfearing))
			L.sate_addiction()
		if(L.mob_timers[MT_PSYPRAY])
			if(world.time < L.mob_timers[MT_PSYPRAY] + 1 MINUTES)
				L.mob_timers[MT_PSYPRAY] = world.time
				return FALSE
		else
			L.mob_timers[MT_PSYPRAY] = world.time
		if(!findtext(message2recognize, "[M.patron]"))
			return FALSE
		else
			L.playsound_local(L, 'sound/misc/notice (2).ogg', 100, FALSE)
			L.add_stress(/datum/stressevent/psyprayer)
			return TRUE
	else
		to_chat(L, span_danger("Моя молитва была маловата..."))

/mob/living/proc/check_prayer_underworld(mob/living/L,message)
	if(!L || !message)
		return FALSE
	var/list/bannedwords = list("cock","dick","fuck","shit","pussy","ass","cuck","fucker","fucked","cunt","asshole")
	var/message2recognize = sanitize_hear_message(message)
	var/mob/living/carbon/spirit/M = L
	for(var/T in bannedwords)
		var/list/turfs = list()
		if(findtext(message2recognize, T))
			for(var/turf/U in /area/rogue/underworld)
				if(U.density)
					continue
				turfs.Add(U)

			var/turf/pickedturf = safepick(turfs)
			if(!pickedturf)
				return
			to_chat(L, "<font color='yellow'>НАГЛЫЙ НЕГОДЯЙ, ТВОЯ СМЕРТЬ ЗАСЛУЖЕНА.</font>")
			L.forceMove(pickedturf)
			return FALSE
	if(length(message2recognize) > 15)
		if(findtext(message2recognize, "[M.patron]"))
			L.playsound_local(L, 'sound/misc/notice (2).ogg', 100, FALSE)
			to_chat(L, "<font color='yellow'>[M.patron], услышал твою молитву, но не может ни чем помочь...</font>")
			/*var/obj/item/underworld/coin/C = new
			L.put_in_active_hand(C)*/
			return TRUE
		else
			return TRUE
	else
		to_chat(L, span_danger("Моя молитва была маловата..."))

/datum/emote/living/meditate
	key = "meditate"
	key_third_person = "медитирует"
	message = "медитирует."
	restraint_check = FALSE
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_meditate()
	set name = "Медитировать"
	set category = "Emotes"

	emote("meditate", intentional = TRUE)

/datum/emote/living/meditate/run_emote(mob/user, params, type_override, intentional)
	if(isliving(user))
		if(!COOLDOWN_FINISHED(user, schizohelp_cooldown))
			to_chat(user, span_warning("Мне надо отдохнуть перед тем как начать медитацию снова."))
			return
		var/msg = input("Say your meditation:", "Voices in your head") as text|null
		if(msg)
			user.schizohelp(msg)

/datum/emote/living/bow
	key = "bow"
	key_third_person = "кланяется"
	message = "кланяется."
	message_param = "кланяется %t."
	restraint_check = TRUE
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_bow()
	set name = "Кланяться"
	set category = "Emotes"

	emote("bow", intentional = TRUE)

/datum/emote/living/burp
	key = "burp"
	key_third_person = "рыгает"
	message = "рыгает."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_burp()
	set name = "Отрыжка"
	set category = "Noises"

	emote("burp", intentional = TRUE)

/datum/emote/living/burp/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт сдавленный звук."

/datum/emote/living/choke
	key = "choke"
	key_third_person = "давится"
	message = "давиться!"
	emote_type = EMOTE_AUDIBLE
	ignore_silent = TRUE

/mob/living/carbon/human/verb/emote_choke()
	set name = "Подавиться"
	set category = "Noises"

	emote("choke", intentional = TRUE)

/datum/emote/living/cross
	key = "crossarms"
	key_third_person = "скрещивает руки"
	message = "скрещивает руки."
	restraint_check = TRUE
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_crossarms()
	set name = "Скрестить руки"
	set category = "Emotes"

	emote("crossarms", intentional = TRUE)

/datum/emote/living/collapse
	key = "collapse"
	key_third_person = "падает в обморок"
	message = "падает в обморок."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/collapse/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.Unconscious(40)

/datum/emote/living/whisper
	key = "whisper"
	key_third_person = "шепчет"
	message = "шепчет."
	message_mime = "что-то шепчет."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/aggro
	key = "aggro"
	key_third_person = "aggro"
	message = ""
	nomsg = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/cough
	key = "cough"
	key_third_person = "кашляет"
	message = "кашляет."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_cough()
	set name = "Кашель"
	set category = "Noises"

	emote("cough", intentional = TRUE)

/datum/emote/living/cough/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт сдавленный звук."

/datum/emote/living/clearthroat
	key = "clearthroat"
	key_third_person = "откашливается"
	message = "откашлевается."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_clearthroat()
	set name = "Откашляться"
	set category = "Noises"

	emote("clearthroat", intentional = TRUE)

/datum/emote/living/clearthroat/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт сдавленный звук."

/datum/emote/living/dance
	key = "dance"
	key_third_person = "танцует"
	message = "танцует."
	restraint_check = TRUE
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_dance()
	set name = "Танцевать"
	set category = "Emotes"

	emote("dance", intentional = TRUE)

/datum/emote/living/deathgasp
	key = ""
	key_third_person = ""
	message = "издаёт свой последних вздох..."
	message_robot = "shudders violently for a moment before falling still, its eyes slowly darkening."
	message_AI = "screeches, its screen flickering as its systems slowly halt."
	message_alien = "lets out a waning guttural screech, and collapses onto the floor..."
	message_larva = "lets out a sickly hiss of air and falls limply to the floor..."
	message_monkey = "lets out a faint chimper as it collapses and stops moving..."
	message_simple =  "falls limp."
	stat_allowed = UNCONSCIOUS

/datum/emote/living/deathgasp/run_emote(mob/user, params, type_override, intentional)
	var/mob/living/simple_animal/S = user
	if(istype(S) && S.deathmessage)
		message_simple = S.deathmessage
	. = ..()
	message_simple = initial(message_simple)
	if(. && user.deathsound)
		if(isliving(user))
			var/mob/living/L = user
			if(!L.can_speak_vocal() || L.oxyloss >= 50)
				return //stop the sound if oxyloss too high/cant speak
		playsound(user, user.deathsound, 200, TRUE, TRUE)

/datum/emote/living/drool
	key = "drool"
	key_third_person = "пускает слюни"
	message = "пускает слюни."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_drool()
	set name = "Пускать слюни"
	set category = "Emotes"

	emote("drool", intentional = TRUE)

/datum/emote/living/faint
	key = "faint"
	key_third_person = "падает в обморок"
	message = "падает в обморок."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_faint()
	set name = "Обморок"
	set category = "Emotes"

	emote("faint", intentional = TRUE)

/datum/emote/living/faint/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/L = user
		if(L.get_complex_pain() > (L.STAEND * 9))
			L.setDir(2)
			L.SetUnconscious(200)
		else
			L.Knockdown(10)

/datum/emote/living/flap
	key = "flap"
	key_third_person = "махает крыльями"
	message = "махает крыльями."
	restraint_check = TRUE
	var/wing_time = 20

/datum/emote/living/carbon/human/flap/can_run_emote(mob/user, status_check = TRUE , intentional)
	return FALSE

/datum/emote/living/flap/aflap
	key = "aflap"
	key_third_person = "aflaps"
	message = "агрессивно махает крыльями!"
	restraint_check = TRUE
	wing_time = 10

/datum/emote/living/carbon/human/aflap/can_run_emote(mob/user, status_check = TRUE , intentional)
	return FALSE

/datum/emote/living/frown
	key = "frown"
	key_third_person = "хмурится"
	message = "хмурится."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_frown()
	set name = "Хмуриться"
	set category = "Emotes"

	emote("frown", intentional = TRUE)

/datum/emote/living/gag
	key = "gag"
	key_third_person = "давится"
	message = "давится."
	emote_type = EMOTE_AUDIBLE
	ignore_silent = TRUE

/mob/living/carbon/human/verb/emote_gag()
	set name = "Подавиться"
	set category = "Noises"

	emote("gag", intentional = TRUE)

/datum/emote/living/gasp
	key = "gasp"
	key_third_person = "задыхается"
	message = "задыхается!"
	emote_type = EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS

/mob/living/carbon/human/verb/emote_gasp()
	set name = "Задыхаться"
	set category = "Noises"

	emote("gasp", intentional = TRUE)

/datum/emote/living/gasp/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт сдавленный звук."

/datum/emote/living/breathgasp
	key = "breathgasp"
	key_third_person = "breathgasps"
	message = "задыхается от нехватки воздуха!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/giggle
	key = "giggle"
	key_third_person = "хихикает"
	message = "хихикает."
	message_mime = "беззвучно хихикает!"
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_giggle()
	set name = "Хихикать"
	set category = "Noises"

	emote("giggle", intentional = TRUE)

/datum/emote/living/giggle/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "беззвучно хихикает."

/datum/emote/living/chuckle
	key = "chuckle"
	key_third_person = "посмеивается"
	message = "посмеивается."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_chuckle()
	set name = "Посмеиваться"
	set category = "Noises"

	emote("chuckle", intentional = TRUE)

/datum/emote/living/chuckle/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "беззвучно хихикает."

/datum/emote/living/glare
	key = "glare"
	key_third_person = "пялится"
	message = "пялится."
	message_param = "пялится на %t."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_glare()
	set name = "Пялиться"
	set category = "Emotes"

	emote("glare", intentional = TRUE)

/datum/emote/living/grin
	key = "grin"
	key_third_person = "ухмыляется"
	message = "ухмыляется."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_grin()
	set name = "Ухмельнуться"
	set category = "Emotes"

	emote("grin", intentional = TRUE)

/datum/emote/living/groan
	key = "groan"
	key_third_person = "стонет"
	message = "стонет."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_groan()
	set name = "Стонать"
	set category = "Noises"

	emote("groan", intentional = TRUE)

/datum/emote/living/groan/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт сдавленный стон."
/*
/datum/emote/living/grimace
	key = "grimace"
	key_third_person = "корчит рожу"
	message = "корчит рожу."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_grimace()
	set name = "Скорчить рожу"
	set category = "Emotes"

	emote("grimace", intentional = TRUE)
*/
/datum/emote/living/jump
	key = "jump"
	key_third_person = "прыгает"
	message = "прыгает!"
	restraint_check = TRUE

/datum/emote/living/leap
	key = "leap"
	key_third_person = "совершает прыжок"
	message = "совершает прыжок!"
	restraint_check = TRUE
	only_forced_audio = TRUE

/datum/emote/living/kiss
	key = "kiss"
	key_third_person = "целует"
	message = "посылает поцелуй."
	message_param = "целует %t."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_kiss()
	set name = "Целовать"
	set category = "Emotes"

	emote("kiss", intentional = TRUE, targetted = TRUE)

/datum/emote/living/kiss/adjacentaction(mob/user, mob/target)
	. = ..()
	message_param = initial(message_param) // re
	if(!user || !target)
		return
	if(ishuman(user) && ishuman(target))
		var/mob/living/carbon/human/H = user
		var/do_change
		if(target.loc == user.loc)
			do_change = TRUE
		if(!do_change)
			if(H.pulling == target)
				do_change = TRUE
		if(do_change)
			if(H.zone_selected == BODY_ZONE_PRECISE_MOUTH)
				message_param = "глубоко целует %t."
			else if(H.zone_selected == BODY_ZONE_PRECISE_EARS)
				message_param = "целует ушко %t."
				var/mob/living/carbon/human/E = target
				if(iself(E) || ishalfelf(E))
					if(!E.cmode)
						to_chat(target, span_love("Это щекотно..."))
			else if(H.zone_selected == BODY_ZONE_PRECISE_R_EYE || H.zone_selected == BODY_ZONE_PRECISE_L_EYE)
				message_param = "целует %t в бровь."
			else
				message_param = "целует %t в [parse_zone(H.zone_selected)]."
	playsound(target.loc, pick('sound/vo/kiss (1).ogg','sound/vo/kiss (2).ogg'), 100, FALSE, -1)


/datum/emote/living/spit
	key = "spit"
	key_third_person = "плюёт"
	message = "плюёт на землю."
	message_param = "плюёт в %t."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_spit()
	set name = "Плевать"
	set category = "Emotes"

	emote("spit", intentional = TRUE, targetted = TRUE)


/datum/emote/living/spit/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param) // reset
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mouth)
			if(H.mouth.spitoutmouth)
				H.visible_message(span_warning("[H] плюёт в [H.mouth]."))
				H.dropItemToGround(H.mouth, silent = FALSE)
			return
	..()

/datum/emote/living/spit/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(user.gender == MALE)
		playsound(target.loc, pick('sound/vo/male/gen/spit.ogg'), 100, FALSE, -1)
	else
		playsound(target.loc, pick('sound/vo/female/gen/spit.ogg'), 100, FALSE, -1)


/datum/emote/living/hug
	key = "hug"
	key_third_person = "обнимает"
	message = ""
	message_param = "обнимает %t."
	emote_type = EMOTE_VISIBLE
	restraint_check = TRUE

/mob/living/carbon/human/verb/emote_hug()
	set name = "Обнять"
	set category = "Emotes"

	emote("hug", intentional = TRUE, targetted = TRUE)

/datum/emote/living/hug/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.add_stress(/datum/stressevent/hug)

/datum/emote/living/holdbreath
	key = "hold"
	key_third_person = "задержать воздух"
	message = "начинает задерживать дыхание."
	stat_allowed = SOFT_CRIT

/mob/living/carbon/human/verb/emote_hold()
	set name = "Задержать дыхание"
	set category = "Emotes"

	emote("hold", intentional = TRUE)

/datum/emote/living/holdbreath/can_run_emote(mob/living/user, status_check = TRUE, intentional)
	. = ..()
	if(. && intentional && !HAS_TRAIT(user, TRAIT_HOLDBREATH) && !HAS_TRAIT(user, TRAIT_PARALYSIS))
		to_chat(user, span_warning("Я не настолько отчаянный, чтобы сделать это."))
		return FALSE

/datum/emote/living/holdbreath/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		if(HAS_TRAIT(user, TRAIT_HOLDBREATH))
			REMOVE_TRAIT(user, TRAIT_HOLDBREATH, "[type]")
		else
			ADD_TRAIT(user, TRAIT_HOLDBREATH, "[type]")

/datum/emote/living/holdbreath/select_message_type(mob/user, intentional)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_HOLDBREATH))
		. = "перестает задерживать дыхание."

/datum/emote/living/slap
	key = "slap"
	key_third_person = "шлёпает"
	message = ""
	message_param = "бьет %t по лицу."
	emote_type = EMOTE_VISIBLE
	restraint_check = TRUE


/datum/emote/living/slap/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param) // reset
	// RATWOOD MODULAR START
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.zone_selected == BODY_ZONE_PRECISE_GROIN)
			message_param = "шлепает %t по заднице!"
	// RATWOOD MODULAR END
	..()

/mob/living/carbon/human/verb/emote_slap()
	set name = "Шлёпать"
	set category = "Emotes"

	emote("slap", intentional = TRUE, targetted = TRUE)

/datum/emote/living/slap/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.flash_fullscreen("redflash3")
		H.AdjustSleeping(-50)
		playsound(target.loc, 'sound/foley/slap.ogg', 100, TRUE, -1)

/datum/emote/living/pinch
	key = "pinch"
	key_third_person = "щипает"
	message = ""
	message_param = "щипает %t."
	emote_type = EMOTE_VISIBLE
	restraint_check = TRUE

/datum/emote/living/pinch/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.flash_fullscreen("redflash1")

/mob/living/carbon/human/verb/emote_pinch()
	set name = "Щипать"
	set category = "Emotes"

	emote("pinch", intentional = TRUE, targetted = TRUE)



/datum/emote/living/laugh
	key = "laugh"
	key_third_person = "смеётся"
	message = "смеётся."
	message_mime = "беззвучно смеётся!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/laugh/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		return !C.silent

/mob/living/carbon/human/verb/emote_laugh()
	set name = "Смеяться"
	set category = "Noises"

	emote("laugh", intentional = TRUE)

/datum/emote/living/laugh/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "беззвучно смеётся."

/datum/emote/living/look
	key = "look"
	key_third_person = "смотрит"
	message = "смотрит."
	message_param = "смотрит на %t."

/datum/emote/living/nod
	key = "nod"
	key_third_person = "кивает"
	message = "кивает."
	message_param = "кивает %t."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_nod()
	set name = "Кивать"
	set category = "Emotes"

	emote("nod", intentional = TRUE)

/datum/emote/living/point
	key = "point"
	key_third_person = "указывает"
	message = "указывает."
	message_param = "показывает на %t."
	restraint_check = TRUE

/datum/emote/living/point/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param) // reset
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.get_num_arms() == 0)
			if(H.get_num_legs() != 0)
				message_param = "пытается указать на %t ногой, <span class='danger'>падая</span> в процессе!"
				H.Paralyze(20)
			else
				message_param = "<span class='danger'>ударяется [user.p_their()] головой об пол</span>, пытаясь двигаться в сторону %t."
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5)
	..()

/datum/emote/living/pout
	key = "pout"
	key_third_person = "дует"
	message = "дует."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/scream
	key = "scream"
	key_third_person = "кричит"
	message = "кричит!"
	message_mime = "издает крик!"
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_scream()
	set name = "Кричать"
	set category = "Noises"

	emote("scream", intentional = TRUE)

/datum/emote/living/scream/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт беззвучный крик!"
		if(intentional)
			if(!C.rogfat_add(10))
				to_chat(C, span_warning("Я пытаюсь кричать, но мой голос подводит меня."))
				. = FALSE

/datum/emote/living/scream/painscream
	key = "painscream"
	message = "кричит от боли!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE

/datum/emote/living/scream/painscream/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.has_flaw(/datum/charflaw/addiction/masochist))
			H.sate_addiction()

/datum/emote/living/scream/agony
	key = "agony"
	message = "кричит в агонии!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE

/datum/emote/living/screan/agony/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.has_flaw(/datum/charflaw/addiction/masochist))
			H.sate_addiction()

/datum/emote/living/scream/firescream
	key = "firescream"
	nomsg = TRUE
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE

/datum/emote/living/scream/firescream/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.has_flaw(/datum/charflaw/addiction/masochist))
			H.sate_addiction()

/datum/emote/living/aggro
	key = "aggro"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

/datum/emote/living/idle
	key = "idle"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

/datum/emote/living/death
	key = "death"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	stat_allowed = UNCONSCIOUS
	mob_type_ignore_stat_typecache = list(/mob/living)

/datum/emote/living/pain
	key = "pain"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

/datum/emote/living/pain/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.has_flaw(/datum/charflaw/addiction/masochist))
			H.sate_addiction()

/datum/emote/living/drown
	key = "drown"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	ignore_silent = TRUE

/datum/emote/living/paincrit
	key = "paincrit"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

/datum/emote/living/embed
	key = "embed"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

/datum/emote/living/painmoan
	key = "painmoan"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

/datum/emote/living/groin
	key = "groin"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

/datum/emote/living/fatigue
	key = "fatigue"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

/datum/emote/living/jump
	key = "jump"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

/datum/emote/living/haltyell
	key = "haltyell"
	message = "shouts a halt!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE

/datum/emote/living/conqrah
	key = "conqrah"
	message = "торжествующе кричит!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE 

/datum/emote/living/rage
	key = "rage"
	message = "кричит в ярости!"
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_rage()
	set name = "Ярость"
	set category = "Noises"

	emote("rage", intentional = TRUE)

/datum/emote/living/attnwhistle
	key = "attnwhistle"
	message = "свистит, чтобы привлечь внимание!"
	emote_type = EMOTE_AUDIBLE



/mob/living/carbon/human/verb/emote_attnwhistle()
	set name = "Свистеть во внимании"
	set category = "Noises"

	emote("attnwhistle", intentional = TRUE)

/datum/emote/living/attnwhistle/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт сдавленный звук."


/datum/emote/living/clap
	key = "clap"
	key_third_person = "хлопает"
	message = "хлопает."
	muzzle_ignore = TRUE
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE
	vary = TRUE


/mob/living/carbon/human/verb/emote_clap()
	set name = "Хлопать руками"
	set category = "Noises"

	emote("clap", intentional = TRUE)


/datum/emote/living/carbon/clap/get_sound(mob/living/user)
	if(ishuman(user))
		if(!user.get_bodypart(BODY_ZONE_L_ARM) || !user.get_bodypart(BODY_ZONE_R_ARM))
			return
		else
			return "clap"



/datum/emote/living/choke
	key = "choke"
	key_third_person = "задыхается"
	message = "задыхается!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/scowl
	key = "scowl"
	key_third_person = "хмурится"
	message = "хмурится."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/shakehead
	key = "shakehead"
	key_third_person = "вертит головой"
	message = "вертит головой."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_shakehead()
	set name = "Вертеть головой"
	set category = "Emotes"

	emote("shakehead", intentional = TRUE)


/datum/emote/living/shiver
	key = "shiver"
	key_third_person = "дрожит"
	message = "дрожит."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_shiver()
	set name = "Дрожать"
	set category = "Emotes"

	emote("shiver", intentional = TRUE)


/datum/emote/living/sigh
	key = "sigh"
	key_third_person = "вздыхает"
	message = "вздыхает."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_sigh()
	set name = "Вздыхать"
	set category = "Noises"

	emote("sigh", intentional = TRUE)

/datum/emote/living/sigh/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "беззвучно вздыхает."

/datum/emote/living/whistle
	key = "whistle"
	key_third_person = "свистит"
	message = "свистит."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_whistle()
	set name = "Свистеть"
	set category = "Noises"

	emote("whistle", intentional = TRUE)

/datum/emote/living/whistle/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт сдавленный звук."

/datum/emote/living/hmm
	key = "hmm"
	key_third_person = "хмыкает"
	message = "хмыкает."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_hmm()
	set name = "Хмыкнуть"
	set category = "Noises"

	emote("hmm", intentional = TRUE)

/datum/emote/living/hmm/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт беззвучный хмык."

/datum/emote/living/huh
	key = "huh"
	key_third_person = "издаёт вопросительный звук"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE

/mob/living/carbon/human/verb/emote_huh()
	set name = "Хах?"
	set category = "Noises"

	emote("huh", intentional = TRUE)

/datum/emote/living/huh/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт сдавленный звук."

/datum/emote/living/hum
	key = "hum"
	key_third_person = "мелодично гудит"
	message = "мелодично гудит."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_hum()
	set name = "Гудеть"
	set category = "Noises"

	emote("hum", intentional = TRUE)

/datum/emote/living/hum/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "сдавленно гудит."

/datum/emote/living/smile
	key = "smile"
	key_third_person = "улыбается"
	message = "улыбается."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_smile()
	set name = "Улыбнуться"
	set category = "Emotes"

	emote("smile", intentional = TRUE)

/datum/emote/living/sneeze
	key = "sneeze"
	key_third_person = "чихает"
	message = "чихает."
	emote_type = EMOTE_AUDIBLE
/*
/mob/living/carbon/human/verb/emote_sneeze()
	set name = "Sneeze"
	set category = "Noises"

	emote("sneeze", intentional = TRUE)
*/
/datum/emote/living/sneeze/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "сдавленно чихает."

/datum/emote/living/shh
	key = "shh"
	key_third_person = "шикает"
	message = "шикает."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_shh()
	set name = "Шикнуть"
	set category = "Noises"

	emote("shh", intentional = TRUE)

/datum/emote/living/shh/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "сдавленно шикает."

/datum/emote/living/smug
	key = "smug"
	key_third_person = "лыбиться"
	message = "самодовольно лыбиться."

/datum/emote/living/sniff
	key = "sniff"
	key_third_person = "принюхивается"
	message = "принюхивается."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/snore
	key = "snore"
	key_third_person = "храпит"
	message = "храпит."
	message_mime = "сдавленно храпит."
	emote_type = EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS
	snd_range = -4

/datum/emote/living/stare
	key = "stare"
	key_third_person = "наблюдает"
	message = "наблюдает."
	message_param = "наблюдает за %t."

/datum/emote/living/strech
	key = "stretch"
	key_third_person = "разминает"
	message = "разминает руки."

/datum/emote/living/sulk
	key = "sulk"
	key_third_person = "тоскует"
	message = "тоскует."

/datum/emote/living/sway
	key = "sway"
	key_third_person = "покачивается"
	message = "покачивается на месте."

/datum/emote/living/tremble
	key = "tremble"
	key_third_person = "подрагивает"
	message = "дрожит от страха!"

/datum/emote/living/twitch
	key = "twitch"
	key_third_person = "дёргается"
	message = "сильно дергается."

/datum/emote/living/twitch_s
	key = "twitch_s"
	message = "дёргается."
	stat_allowed = UNCONSCIOUS
	mob_type_ignore_stat_typecache = list(/mob/living/carbon/human)

/datum/emote/living/wave
	key = "wave"
	key_third_person = "махает"
	message = "машет."

/datum/emote/living/whimper
	key = "whimper"
	key_third_person = "хнычет"
	message = "хнычет."
	message_mime = "выглядит обиженным."

/mob/living/carbon/human/verb/emote_whimper()
	set name = "Хныкать"
	set category = "Noises"

	emote("whimper", intentional = TRUE)

/datum/emote/living/whimper/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт беззвучное хныканье."

/datum/emote/living/wsmile
	key = "wsmile"
	key_third_person = "слабо улыбается"
	message = "слабо улыбается."

/mob/living/carbon/human/verb/wsmile()
	set name = "Слабо улыбаться"
	set category = "Emotes"

	emote("wsmile", intentional = TRUE)

/datum/emote/living/yawn
	key = "yawn"
	key_third_person = "зевает"
	message = "зевает."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_yawn()
	set name = "Зевать"
	set category = "Noises"

	emote("yawn", intentional = TRUE)

/datum/emote/living/yawn/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт сдавленный зевок."

/datum/emote/living/warcry
	key = "warcry"
	key_third_person = "выкрикивает вдохновляющий боевой клич"
	message = "выкрикивает вдохновляющий боевой клич!"
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_warcry()
	set name = "Боевой клич"
	set category = "Noises"

	emote("warcry", intentional = TRUE)

/datum/emote/living/warcry/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издает приглушенный крик!"

/datum/emote/living/custom
	key = "me"
	key_third_person = "custom"
#ifdef MATURESERVER
	message_param = "%t"
#endif
	//mute_time = 1 - RATWOOD CHANGE, I don't want spammers.
/datum/emote/living/custom/can_run_emote(mob/user, status_check, intentional)
	. = ..() && intentional

/datum/emote/living/custom/proc/check_invalid(mob/user, input)
	. = TRUE
	if(copytext(input,1,5) == "says")
		to_chat(user, span_danger("Invalid emote."))
	else if(copytext(input,1,9) == "exclaims")
		to_chat(user, span_danger("Invalid emote."))
	else if(copytext(input,1,6) == "yells")
		to_chat(user, span_danger("Invalid emote."))
	else if(copytext(input,1,5) == "asks")
		to_chat(user, span_danger("Invalid emote."))
	else
		. = FALSE

/datum/emote/living/custom/run_emote(mob/user, params, type_override = null, intentional = FALSE)
	if(!can_run_emote(user, TRUE, intentional))
		return FALSE
	else if(QDELETED(user))
		return FALSE
	else if(user.client && user.client.prefs.muted & MUTE_IC)
		to_chat(user, span_boldwarning("Я не могу писать что-то в IC (Замутили лоха)."))
		return FALSE
	else if(!params)
		var/custom_emote = copytext(sanitize(input("Что делает ваш персонаж?") as text|null), 1, MAX_MESSAGE_LEN)
		if(custom_emote && !check_invalid(user, custom_emote))
/*			var/type = input("Is this a visible or hearable emote?") as null|anything in list("Visible", "Hearable")
			switch(type)
				if("Visible")
					emote_type = EMOTE_VISIBLE
				if("Hearable")
					emote_type = EMOTE_AUDIBLE
				else
					alert("Unable to use this emote, must be either hearable or visible.")
					return*/
			message = custom_emote
			emote_type = EMOTE_VISIBLE
	else
		message = params
		if(type_override)
			emote_type = type_override
	. = ..()
	message = null
	emote_type = EMOTE_VISIBLE

/datum/emote/living/custom/replace_pronoun(mob/user, message)
	return message

/datum/emote/living/help
	key = "help"

/datum/emote/living/help/run_emote(mob/user, params, type_override, intentional)
/*	var/list/keys = list()
	var/list/message = list("Available emotes, you can use them with say \"*emote\": ")

	for(var/key in GLOB.emote_list)
		for(var/datum/emote/P in GLOB.emote_list[key])
			if(P.key in keys)
				continue
			if(P.can_run_emote(user, status_check = FALSE , intentional = TRUE))
				keys += P.key

	keys = sortList(keys)

	for(var/emote in keys)
		if(LAZYLEN(message) > 1)
			message += ", [emote]"
		else
			message += "[emote]"

	message += "."

	message = jointext(message, "")

	to_chat(user, message)*/

/datum/emote/beep
	key = "beep"
	key_third_person = "beeps"
	message = "beeps."
	message_param = "beeps at %t."
	sound = 'sound/blank.ogg'
	mob_type_allowed_typecache = list(/mob/living/brain, /mob/living/silicon)
/*
/datum/emote/living/circle
	key = "circle"
	key_third_person = "circles"
	restraint_check = TRUE

/datum/emote/living/circle/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	var/obj/item/circlegame/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, span_notice("I make a circle with your hand."))
	else
		qdel(N)
		to_chat(user, span_warning("I don't have any free hands to make a circle with."))

/datum/emote/living/slap
	key = "slap"
	key_third_person = "slaps"
	restraint_check = TRUE

/datum/emote/living/slap/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/obj/item/slapper/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, span_notice("I ready your slapping hand."))
	else
		to_chat(user, span_warning("You're incapable of slapping in your current state."))
*/

/datum/emote/living/shake
	key = "shake"
	key_third_person = "встряхивается"
	message = "встряхивается."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_shake()
	set name = "Встряхнуться"
	set category = "Emotes"

	emote("shake", intentional = TRUE)

/datum/emote/living/squint
	key = "squint"
	key_third_person = "прищуривается"
	message = "прищуривается."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_squint()
	set name = "Прищуриться"
	set category = "Emotes"

	emote("squint", intentional = TRUE)

/datum/emote/living/yip
	key = "yip"
	key_third_person = "йипает"
	message = "йипает."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_yip()
	set name = "Йип"
	set category = "Noises"

	emote("yip", intentional = TRUE)

/datum/emote/living/yip/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт сдавленный йип."

/datum/emote/living/yap
	key = "yap"
	key_third_person = "йапает"
	message = "йапает."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_yap()
	set name = "Йап"
	set category = "Noises"

	emote("yap", intentional = TRUE)

/datum/emote/living/yap/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт сдавленный йап."


/datum/emote/living/coyhowl
	key = "howl"
	key_third_person = "воет"
	message = "воет."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_coyhowl()
	set name = "Выть"
	set category = "Noises"

	emote("howl", intentional = TRUE)

/datum/emote/living/howl/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт сдавленный вой."


/datum/emote/living/snap
	key = "snap"
	key_third_person = "щёлкает"
	message = "щёлкает пальцами."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_snap()
	set name = "Щёлкать пальцами"
	set category = "Noises"

	emote("snap", intentional = TRUE)


/datum/emote/living/catrage
	key = "catrage"
	key_third_person = "неистовствует"
	message = "неистовствует."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_catrage()
	set name = "Кошачая ярость"
	set category = "Noises"

	emote("catrage", intentional = TRUE)


/datum/emote/living/bark
	key = "bark"
	key_third_person = "гавкает"
	message = "гавкает."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_bark()
	set name = "Гавкать"
	set category = "Noises"

	emote("bark", intentional = TRUE)

/datum/emote/living/bark/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт сдавленное гавканье."

/datum/emote/living/whine
	key = "whine"
	key_third_person = "скулить"
	message = "скулить."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_whine()
	set name = "Скулить"
	set category = "Noises"

	emote("whine", intentional = TRUE)

/datum/emote/living/whine/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издает приглушенный скулеж."
/datum/emote/living/cackle
	key = "cackle"
	key_third_person = "гогочет по собачьи"
	message = "гогочет по собачьи."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_cackle()
	set name = "Гоготать как собака"
	set category = "Noises"

	emote("cackle", intentional = TRUE)

/datum/emote/living/cackle/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издает сдавленный гогот."

/datum/emote/living/blink
	key = "blink"
	key_third_person = "моргает"
	message = "моргает."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_blink()
	set name = "Моргать"
	set category = "Noises"

	emote("blink", intentional = TRUE)


/datum/emote/living/meow
	key = "meow"
	key_third_person = "мяукает"
	message = "мяукает."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_meow()
	set name = "Мяукать"
	set category = "Noises"

	emote("meow", intentional = TRUE)

/datum/emote/living/meow/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak_vocal())
			message = "издаёт сдавленное мяуканье."

/datum/emote/living/hiss
	key = "hiss"
	key_third_person = "шипит"
	message = "шипит."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_hiss()
	set name = "Шипеть"
	set category = "Noises"

	emote("hiss", intentional = TRUE)

/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/human/cry
	key = "cry"
	key_third_person = "плачет"
	message = "плачет."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_cry()
	set name = "Плакать"
	set category = "Noises"

	emote("cry", intentional = TRUE)

/datum/emote/living/carbon/human/cry/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak())
			message = "издаёт сдавленный звук, сопровождающийся слёзами."


/datum/emote/living/carbon/human/sexmoanlight
	key = "sexmoanlight"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

/datum/emote/living/carbon/human/sexmoanlight/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak())
			message = "издаёт сдавленный звук."

/datum/emote/living/carbon/human/sexmoanhvy
	key = "sexmoanhvy"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

/datum/emote/living/carbon/human/sexmoanhvy/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak())
			message = "издаёт сдавленный звук."

/datum/emote/living/carbon/human/eyebrow
	key = "eyebrow"
	message = "поднимает бровь."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_eyebrow()
	set name = "Поднять бровь"
	set category = "Emotes"

	emote("eyebrow", intentional = TRUE)

/datum/emote/living/carbon/human/psst
	key = "psst"
	key_third_person = "пытается привлечь внимание"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE

/mob/living/carbon/human/verb/emote_psst()
	set name = "Привлечь внимание"
	set category = "Noises"

	emote("psst", intentional = TRUE)

/datum/emote/living/carbon/human/grumble
	key = "grumble"
	key_third_person = "ропщет"
	message = "ропщет."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_grumble()
	set name = "Ропотать"
	set category = "Noises"

	emote("grumble", intentional = TRUE)

/datum/emote/living/carbon/human/grumble/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak())
			message = "издает приглушенный ворчливый звук."

/datum/emote/living/carbon/human/handshake
	key = "handshake"
	message = "пожимает собственные руки."
	message_param = "пожимает руку %t."
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/handshake()
	set name = "Пожать руку"
	set category = "Emotes"

	emote("handshake", intentional = TRUE)

/datum/emote/living/carbon/human/mumble
	key = "mumble"
	key_third_person = "бормочет"
	message = "бормочет."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/mumble()
	set name = "Ворчать"
	set category = "Noises"

	emote("mumble", intentional = TRUE)

/datum/emote/living/carbon/human/pale
	key = "pale"
	message = "бледнеет на секунду."

/datum/emote/living/carbon/human/raise
	key = "raise"
	key_third_person = "поднимает руку"
	message = "поднимает руку."
	restraint_check = TRUE

/datum/emote/living/carbon/human/salute
	key = "salute"
	key_third_person = "исполняет воинское приветствие"
	message = "исполняет воинское приветствие."
	message_param = "исполняет воинское приветствие %t."
	restraint_check = TRUE

/mob/living/carbon/human/verb/salute()
	set name = "Салютовать"
	set category = "Emotes"

	emote("salute", intentional = TRUE)

/datum/emote/living/carbon/human/shrug
	key = "shrug"
	key_third_person = "пожимает плечами"
	message = "пожимает плечами."

/mob/living/carbon/human/verb/shrug()
	set name = "Пожать плечами"
	set category = "Emotes"

	emote("shrug", intentional = TRUE)

/datum/emote/living/carbon/human/wag
	key = "wag"
	key_third_person = "виляет хвостом"
	message = "виляет хвостом."

/datum/emote/living/carbon/human/wag/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.dna || !H.dna.species || !H.dna.species.can_wag_tail(H))
		return
	if(!H.dna.species.is_wagging_tail(H))
		H.dna.species.start_wagging_tail(H)
	else
		H.dna.species.stop_wagging_tail(H)

/datum/emote/living/carbon/human/wag/can_run_emote(mob/user, status_check = TRUE , intentional)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	return H.dna && H.dna.species && H.dna.species.can_wag_tail(user)

/datum/emote/living/carbon/human/wag/select_message_type(mob/user, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(!H.dna || !H.dna.species)
		return
	if(H.dna.species.is_wagging_tail(H))
		. = null

/datum/emote/living/carbon/human/wing
	key = "wing"
	key_third_person = "хлопает крыльями"
	message = "хлопает крыльями."

/mob/living/carbon/human/proc/OpenWings()
	return

/mob/living/carbon/human/proc/CloseWings()
	return
