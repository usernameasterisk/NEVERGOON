GLOBAL_LIST_EMPTY(outlawed_players)
GLOBAL_LIST_EMPTY(lord_decrees)
GLOBAL_LIST_INIT(laws_of_the_land, initialize_laws_of_the_land())

/proc/initialize_laws_of_the_land()
	var/list/laws = strings("laws_of_the_land.json","lawsets")
	var/list/lawsets_weighted = list()
	for(var/lawset_name as anything in laws)
		var/list/lawset = laws[lawset_name]
		lawsets_weighted[lawset_name] = lawset["weight"]
	var/chosen_lawset = pickweight(lawsets_weighted)
	return laws[chosen_lawset]["laws"]

/obj/structure/roguemachine/titan
	name = "Трон"
	desc = "Тот, кто носит корону, владеет ключом к этому сидалищу. Если все остальное не поможет, кричите \"Помощь!\""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = ""
	density = FALSE
	blade_dulling = DULLING_BASH
	integrity_failure = 0.5
	max_integrity = 0
	flags_1 = HEAR_1
	anchored = TRUE
	var/mode = 0


/obj/structure/roguemachine/titan/obj_break(damage_flag)
	..()
	cut_overlays()
	set_light(0)
	return

/obj/structure/roguemachine/titan/Destroy()
	set_light(0)
	..()

/obj/structure/roguemachine/titan/Initialize()
	. = ..()
	icon_state = null
	set_light(5)

/obj/structure/roguemachine/titan/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	if(speaker == src)
		return
	if(speaker.loc != loc)
		return
	if(obj_broken)
		return
	if(!ishuman(speaker))
		return
	var/mob/living/carbon/human/H = speaker
	var/nocrown
	if(!istype(H.head, /obj/item/clothing/head/roguetown/crown/serpcrown))
		nocrown = TRUE
	var/notlord
	if(SSticker.rulermob != H)
		notlord = TRUE
	var/message2recognize = sanitize_hear_message(original_message)

	if(mode)
		if(findtext(message2recognize, "неважно"))
			mode = 0
			return
	if(findtext(message2recognize, "призвать корону")) //This must never fail, thus place it before all other modestuffs.
		if(!SSroguemachine.crown)
			new /obj/item/clothing/head/roguetown/crown/serpcrown(src.loc)
			say("Корона призвана!")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		if(SSroguemachine.crown)
			var/obj/item/clothing/head/roguetown/crown/serpcrown/I = SSroguemachine.crown
			if(!I)
				I = new /obj/item/clothing/head/roguetown/crown/serpcrown(src.loc)
			if(I && !ismob(I.loc))//You MUST MUST MUST keep the Crown on a person to prevent it from being summoned (magical interference)
				I.anti_stall()
				I = new /obj/item/clothing/head/roguetown/crown/serpcrown(src.loc)
				say("Корона призвана!")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				return 
			if(ishuman(I.loc))
				var/mob/living/carbon/human/HC = I.loc
				if(HC.stat != DEAD)
					if(I in HC.held_items)
						say("[HC.real_name] держит корону!")
						playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
						return
					if(H.head == I)
						say("[HC.real_name] носит корону!")
						playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
						return
				else
					HC.dropItemToGround(I, TRUE) //If you're dead, forcedrop it, then move it.
			I.forceMove(src.loc)
			say("Корона призвана!")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	switch(mode)
		if(0)
			if(findtext(message2recognize, "помощь"))
				say("Ваши команды: Издать указ, Сделать объявление, Установить налог, Объявить преступника, Призвать корону, Создать закон, Убрать закон, Отменить законы, Неважно")
				playsound(src, 'sound/misc/machinelong.ogg', 100, FALSE, -1)
			if(findtext(message2recognize, "сделать объявление"))
				if(nocrown)
					say("Вам нужна корона.")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(!SScommunications.can_announce(H))
					say("Я должен собраться с силами!")
					return
				say("Говори, и они будут слушать.")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				mode = 1
				return
			if(findtext(message2recognize, "издать указ"))
				if(!SScommunications.can_announce(H))
					say("Я должен собраться с силами!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(notlord || nocrown)
					say("Ты не мой хозяин!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("Скажите, и они подчинятся.")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				mode = 2
				return
			if(findtext(message2recognize, "создать закон"))
				if(!SScommunications.can_announce(H))
					say("Я должен собраться с силами!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(notlord || nocrown)
					say("Ты не мой хозяин!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("Скажите, и они подчинятся.")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				mode = 4
				return
			if(findtext(message2recognize, "убрать закон"))
				if(!SScommunications.can_announce(H))
					say("Я должен собраться с силами!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(notlord || nocrown)
					say("Ты не мой хозяин!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				var/message_clean = replacetext(message2recognize, "убрать закон", "")
				var/law_index = text2num(message_clean) || 0
				if(!law_index || !GLOB.laws_of_the_land[law_index])
					say("Такого закона не существует!")
					return
				say("Этого закона больше не будет!")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				remove_law(law_index)
				return
			if(findtext(message2recognize, "отменить законы"))
				if(!SScommunications.can_announce(H))
					say("Я должен собраться с силами!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(notlord || nocrown)
					say("Ты не мой хозяин!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("Все законы ликвидированы!")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				purge_laws()
				return
			if(findtext(message2recognize, "объявить преступника"))
				if(notlord || nocrown)
					say("Ты не мой хозяин!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("Кого следует объявить вне закона?")
				playsound(src, 'sound/misc/machinequestion.ogg', 100, FALSE, -1)
				mode = 3
				return
			if(findtext(message2recognize, "установить налог"))
				if(notlord || nocrown)
					say("Ты не мой хозяин!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("Новый налоговый процент должен составлять...")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				give_tax_popup(H)
				return
		if(1)
			make_announcement(H, raw_message)
			mode = 0
		if(2)
			make_decree(H, raw_message)
			mode = 0
		if(3)
			declare_outlaw(H, original_message)
			mode = 0
		if(4)
			if(!SScommunications.can_announce(speaker))
				return
			make_law(raw_message)
			mode = 0

/obj/structure/roguemachine/titan/proc/give_tax_popup(mob/living/carbon/human/user)
	if(!Adjacent(user))
		return
	var/newtax = input(user, "Каков будет процент налога? (1-99)", src, SStreasury.tax_value*100) as null|num
	if(newtax)
		if(!Adjacent(user))
			return
		if(findtext(num2text(newtax), "."))
			return
		newtax = CLAMP(newtax, 1, 99)
		SStreasury.tax_value = newtax / 100
		priority_announce("Новый налог в Рокхилле будет составлять [newtax]%.", "Милорд Постановляет", pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain")


/obj/structure/roguemachine/titan/proc/make_announcement(mob/living/user, raw_message)
	if(!SScommunications.can_announce(user))
		return
	try_make_rebel_decree(user)

	SScommunications.make_announcement(user, FALSE, raw_message)

/obj/structure/roguemachine/titan/proc/try_make_rebel_decree(mob/living/user)
	var/datum/antagonist/prebel/P = user.mind?.has_antag_datum(/datum/antagonist/prebel)
	if(!P)
		return
	var/datum/game_mode/chaosmode/C = SSticker.mode
	if(!istype(C))
		return
	if(!P.rev_team)
		return
	if(P.rev_team.members.len < 3)
		to_chat(user, span_warning("Мне нужно больше людей на моей стороне, чтобы объявить о победе."))
		return
	var/obj/structure/roguethrone/throne = GLOB.king_throne
	if(throne == null)
		return
	if(throne.rebel_leader_sit_time < REBEL_THRONE_TIME)
		to_chat(user, span_warning("Мне нужно поудобнее устроиться на троне, прежде чем я объявлю о победе."))
		return
	for(var/datum/objective/prebel/obj in user.mind.get_all_objectives())
		obj.completed = TRUE
	if(!C.headrebdecree)
		user.mind.adjust_triumphs(1)
	C.headrebdecree = TRUE

/obj/structure/roguemachine/titan/proc/make_decree(mob/living/user, raw_message)
	if(!SScommunications.can_announce(user))
		return

	GLOB.lord_decrees += raw_message
	try_make_rebel_decree(user)

	SScommunications.make_announcement(user, TRUE, raw_message)

/obj/structure/roguemachine/titan/proc/declare_outlaw(mob/living/user, raw_message)
	if(!SScommunications.can_announce(user))
		return
	if(user.job)
		if(!istype(SSjob.GetJob(user.job), /datum/job/roguetown/lord))
			return
	else
		return
	return make_outlaw(raw_message)

/proc/make_outlaw(raw_message, silent = FALSE)
	if(raw_message in GLOB.outlawed_players)
		GLOB.outlawed_players -= raw_message
		if(!silent)
			priority_announce("[raw_message] больше не находится вне закона в землях Рокхилла.", "Король издал указ", 'sound/misc/royal_decree.ogg', "Captain")
		return FALSE
	var/found = FALSE
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.real_name == raw_message)
			found = TRUE
	if(!found)
		return FALSE
	GLOB.outlawed_players += raw_message
	if(!silent)
		priority_announce("[raw_message] объявлен вне закона и должна быть схвачен или убит.", "Король издал указ", 'sound/misc/royal_decree2.ogg', "Captain")
	return TRUE

/proc/make_law(raw_message)
	GLOB.laws_of_the_land += raw_message
	priority_announce("[length(GLOB.laws_of_the_land)]. [raw_message]", "ОБЪЯВЛЕН ЗАКОН", pick('sound/misc/new_law.ogg', 'sound/misc/new_law2.ogg'), "Captain")

/proc/remove_law(law_index)
	if(!GLOB.laws_of_the_land[law_index])
		return
	var/law_text = GLOB.laws_of_the_land[law_index]
	GLOB.laws_of_the_land -= law_text
	priority_announce("[law_index]. [law_text]", "Отмена закона", pick('sound/misc/new_law.ogg', 'sound/misc/new_law2.ogg'), "Captain")

/proc/purge_laws()
	GLOB.laws_of_the_land = list()
	priority_announce("Все законы Рокхилла были отменены!", "ЗАКОНЫ БЫЛИ ОЧИЩЕНЫ", 'sound/misc/lawspurged.ogg', "Captain")
