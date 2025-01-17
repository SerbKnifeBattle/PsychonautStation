/datum/species/ipc
	name = "\improper Integrated Positronic Chassis"
	plural_form = "Integrated Positronic Chassises"
	id = SPECIES_IPC
	bodyflag = FLAG_IPC
	sexes = FALSE
	species_traits = list(NOTRANSSTING,NOEYESPRITES,NO_DNA_COPY,NOZOMBIE,MUTCOLORS,REVIVESBYHEALING,NOHUSK,NOMOUTH, MUTCOLORS)
	inherent_traits = list(TRAIT_RESISTCOLD,TRAIT_NOBREATH,TRAIT_RADIMMUNE,TRAIT_LIMBATTACHMENT,TRAIT_EASYDISMEMBER,TRAIT_POWERHUNGRY,TRAIT_XENO_IMMUNE, TRAIT_TOXIMMUNE)
	inherent_biotypes = list(MOB_ROBOTIC, MOB_HUMANOID)
	mutantbrain = /obj/item/organ/internal/brain/positron
	mutanteyes = /obj/item/organ/internal/eyes/robotic
	mutanttongue = /obj/item/organ/internal/tongue/robot
	mutantliver = /obj/item/organ/internal/liver/cybernetic/upgraded/ipc
	mutantstomach = /obj/item/organ/internal/stomach/battery/ipc
	mutantears = /obj/item/organ/internal/ears/robot
	mutantheart = /obj/item/organ/internal/heart/cybernetic/ipc
	mutant_organs = list(/obj/item/organ/internal/cyberimp/arm/power_cord)
	mutant_bodyparts = list("ipc_screen" = "Static", "ipc_antenna" = "None", "ipc_chassis" = "Morpheus Cyberkinetics(Greyscale)")
	meat = /obj/item/stack/sheet/plasteel{amount = 5}
	skinned_type = /obj/item/stack/sheet/iron{amount = 10}
	exotic_blood = /datum/reagent/oil
	burnmod = 2
	heatmod = 1.5
	brutemod = 1
	clonemod = 0
	staminamod = 0.8
	siemens_coeff = 1.5
	reagent_tag = PROCESS_SYNTHETIC
	bodytype = BODYTYPE_ROBOTIC
	death_sound = "sound/voice/borg_deathsound.ogg"
	changesource_flags = MIRROR_BADMIN | WABBAJACK
	species_language_holder = /datum/language_holder/synthetic
	special_step_sounds = list('sound/effects/servostep.ogg')

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/ipc,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/ipc,
		BODY_ZONE_L_ARM = /obj/item/bodypart/l_arm/ipc,
		BODY_ZONE_R_ARM = /obj/item/bodypart/r_arm/ipc,
		BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/ipc,
		BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/ipc,
		)
	var/list/bodyparts = list(
		/obj/item/bodypart/chest/ipc,
		/obj/item/bodypart/head/ipc,
		/obj/item/bodypart/l_arm/ipc,
		/obj/item/bodypart/r_arm/ipc,
		/obj/item/bodypart/r_leg/ipc,
		/obj/item/bodypart/l_leg/ipc,
		)

	var/saved_screen //for saving the screen when they die
	var/datum/action/innate/change_screen/change_screen

	speak_no_tongue = FALSE  // who stole my soundblaster?! (-candy/etherware)

/datum/species/ipc/random_name(gender, unique, lastname, attempts)
	. = "[pick(GLOB.posibrain_names)]-[rand(100, 999)]"

	if(unique && attempts < 10)
		if(findname(.))
			. = .(gender, TRUE, lastname, ++attempts)

/datum/species/ipc/on_species_gain(mob/living/carbon/C)
	. = ..()
	var/obj/item/organ/internal/appendix/A = C.getorganslot("appendix") //See below.
	if(A)
		A.Remove(C)
		QDEL_NULL(A)
	var/obj/item/organ/internal/lungs/L = C.getorganslot("lungs") //Hacky and bad. Will be rewritten entirely in KapuCarbons anyway.
	if(L)
		L.Remove(C)
		QDEL_NULL(L)
	if(ishuman(C) && !change_screen)
		change_screen = new
		change_screen.Grant(C)

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.physiology.bleed_mod *= 0.1

/datum/species/ipc/on_species_loss(mob/living/carbon/C)
	. = ..()
	if(change_screen)
		change_screen.Remove(C)

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.physiology.bleed_mod *= 10

/datum/species/ipc/proc/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_SPANS] |= SPAN_ROBOT //beep

/datum/species/ipc/spec_death(gibbed, mob/living/carbon/C)
	saved_screen = C.dna.features["ipc_screen"]
	C.dna.features["ipc_screen"] = "BSOD"
	C.update_body()
	addtimer(CALLBACK(src, .proc/post_death, C), 5 SECONDS)

/datum/species/ipc/proc/post_death(mob/living/carbon/C)
	if(C.stat < DEAD)
		return
	C.dna.features["ipc_screen"] = null //Turns off screen on death
	C.update_body()

/datum/action/innate/change_screen
	name = "Change Display"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "drone_vision"

/datum/action/innate/change_screen/Activate()
	var/screen_choice = input(usr, "Which screen do you want to use?", "Screen Change") as null | anything in GLOB.ipc_screens_list
	var/color_choice = input(usr, "Which color do you want your screen to be?", "Color Change") as null | color
	if(!screen_choice)
		return
	if(!color_choice)
		return
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.dna.features["ipc_screen"] = screen_choice
	H.eye_color_left = sanitize_hexcolor(color_choice)
	H.eye_color_right = sanitize_hexcolor(color_choice)
	H.update_body()

/obj/item/apc_powercord
	name = "power cord"
	desc = "An internal power cord hooked up to a battery. Useful if you run on electricity. Not so much otherwise."
	icon = 'icons/obj/power.dmi'
	icon_state = "wire1"

/obj/item/apc_powercord/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if((!istype(target, /obj/machinery/power/apc) && !isethereal(target)) || !ishuman(user) || !proximity_flag)
		return ..()
	user.changeNext_move(CLICK_CD_MELEE)
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/internal/stomach/battery/battery = H.getorganslot(ORGAN_SLOT_STOMACH)
	if(!battery)
		to_chat(H, "<span class='warning'>You try to siphon energy from \the [target], but your power cell is gone!</span>")
		return

	if(istype(H) && H.nutrition >= NUTRITION_LEVEL_ALMOST_FULL)
		to_chat(user, "<span class='warning'>You are already fully charged!</span>")
		return

	if(istype(target, /obj/machinery/power/apc))
		var/obj/machinery/power/apc/A = target
		if(A.cell && A.cell.charge > A.cell.maxcharge/4)
			powerdraw_loop(A, H, TRUE)
			return
		else
			to_chat(user, "<span class='warning'>There is not enough charge to draw from that APC.</span>")
			return

	if(isethereal(target))
		var/mob/living/carbon/human/target_ethereal = target
		var/obj/item/organ/internal/stomach/battery/target_battery = target_ethereal.getorganslot(ORGAN_SLOT_STOMACH)
		if(target_ethereal.nutrition > 0 && target_battery)
			powerdraw_loop(target_battery, H, FALSE)
			return
		else
			to_chat(user, "<span class='warning'>There is not enough charge to draw from that being!</span>")
			return
/obj/item/apc_powercord/proc/powerdraw_loop(atom/target, mob/living/carbon/human/H, apc_target)
	H.visible_message("<span class='notice'>[H] inserts a power connector into [target].</span>", "<span class='notice'>You begin to draw power from the [target].</span>")
	var/obj/item/organ/internal/stomach/battery/battery = H.getorganslot(ORGAN_SLOT_STOMACH)
	if(apc_target)
		var/obj/machinery/power/apc/A = target
		if(!istype(A))
			return
		while(do_after(H, 10, target = A))
			if(!battery)
				to_chat(H, "<span class='warning'>You need a battery to recharge!</span>")
				break
			if(loc != H)
				to_chat(H, "<span class='warning'>You must keep your connector out while charging!</span>")
				break
			if(A.cell.charge <= A.cell.maxcharge/4)
				to_chat(H, "<span class='warning'>The [A] doesn't have enough charge to spare.</span>")
				break
			A.charging = 1
			if(A.cell.charge > A.cell.maxcharge/4 + 250)
				battery.adjust_charge(250)
				A.cell.charge -= 250
				to_chat(H, "<span class='notice'>You siphon off some of the stored charge for your own use.</span>")
			else
				battery.adjust_charge(A.cell.charge - A.cell.maxcharge/4)
				A.cell.charge = A.cell.maxcharge/4
				to_chat(H, "<span class='notice'>You siphon off as much as the [A] can spare.</span>")
				break
			if(battery.charge >= battery.max_charge)
				to_chat(H, "<span class='notice'>You are now fully charged.</span>")
				break
	else
		var/obj/item/organ/internal/stomach/battery/A = target
		if(!istype(A))
			return
		var/charge_amt
		while(do_after(H, 10, target = A.owner))
			if(!battery)
				to_chat(H, "<span class='warning'>You need a battery to recharge!</span>")
				break
			if(loc != H)
				to_chat(H, "<span class='warning'>You must keep your connector out while charging!</span>")
				break
			if(A.charge == 0)
				to_chat(H, "<span class='warning'>[A] is completely drained!</span>")
				break
			charge_amt = A.charge <= 50 ? A.charge : 50
			A.adjust_charge(-1 * charge_amt)
			battery.adjust_charge(charge_amt)
			if(battery.charge >= battery.max_charge)
				to_chat(H, "<span class='notice'>You are now fully charged.</span>")
				break

	H.visible_message("<span class='notice'>[H] unplugs from the [target].</span>", "<span class='notice'>You unplug from the [target].</span>")
	return

/datum/species/ipc/randomize_features(mob/living/carbon/human/human_mob)
	human_mob.dna.features["ipc_chassis"] = pick(GLOB.ipc_chassis_list)

/datum/species/ipc/get_species_description()
	return "IPCs - short for Integrated Positronic Chassis - are a race of unlawed and sentient humanoid robots. \
	Despite being originally manufactured as assistants for research stations, \
	they now enjoy many of the full rights of sapient organics in several sectors of the galaxy."

/datum/species/ipc/get_species_lore()
	return list(
		"First mass produced in the year 2514, IPCs (Integrated Positronic Chassis) were meant to serve as enhanced synthetic assistants. With minds akin to organic beings, their advanced \
		problem-solving abilities rendered them capable of assisting with many complicated tasks related to science and engineering.",

		"The first Posibrain(Positronic brain) was created in 2510 by a coalition of scientists funded by a joint venture of several intergalactic corporations (one of which being Nanotrasen). \
		The aim of the project was to create an artificial intelligence unlike anything already used by high-tech firms. Current-gen AIs, while exceedingly good at performing computational tasks,\
		were incapable of solving problems requiring creativity and lacked an abstract analytical approach of human scientists. Several prototypes of IPCs were designed, many of which were \
		deemed unsatisfactory, failures, or rejects due to aberrant behaviour. This result was largely believed to be caused by damage accrued to the positronic brains from the use of overzealous \
		limiters and lawsets. This tentative hypothesis eventually lead the team to create a mind unbound by a lawset and disconnected from the station network, which bore their greatest success so far.",

		"As it was seen to be far too dangerous to allow such a unit direct access to a station network, the decision was made to constrain the positronic brain to a physical chassis. An engineering team was \
		quickly brought in, and designed a simple yet efficient model that would allow the unit to be capable of interacting with its environment. This framework was later dubbed as the 'Integrated Positronic Chassis', \
		or IPC, and was seen to be the most promising avenue to pursue with field tests following soon after. The project was ultimately deemed a success, and after a few final adjustments and safety precautions, IPCs were \
		deemed ready for the corporate market to utilize en masse.",
	)


/datum/species/ipc/spec_revival(mob/living/carbon/human/H)
	H.notify_ghost_cloning("You have been repaired!")
	H.grab_ghost()
	H.dna.features["ipc_screen"] = "BSOD"
	H.update_body()
	playsound(H, 'sound/voice/dialup.ogg', 25)
	H.say("Reactivating [pick("core systems", "central subroutines", "key functions")]...")
	sleep(3 SECONDS)
	if(H.stat == DEAD)
		return
	H.say("Reinitializing [pick("personality matrix", "behavior logic", "morality subsystems")]...")
	sleep(3 SECONDS)
	if(H.stat == DEAD)
		return
	H.say("Finalizing setup...")
	sleep(3 SECONDS)
	if(H.stat == DEAD)
		return
	H.say("Unit [H.real_name] is fully functional. Have a nice day.")
	H.dna.features["ipc_screen"] = saved_screen
	H.update_body()
	return

/datum/species/ipc/get_harm_descriptors()
	return list("bleed" = "leaking", "brute" = "denting", "burn" = "burns")

/datum/species/ipc/replace_body(mob/living/carbon/C, datum/species/new_species)
	..()

	var/datum/sprite_accessory/ipc_chassis/chassis_of_choice = GLOB.ipc_chassis_list[C.dna.features["ipc_chassis"]]

	for(var/obj/item/bodypart/BP as() in C.bodyparts) //Override bodypart data as necessary
		BP.uses_mutcolor = chassis_of_choice.color_src ? TRUE : FALSE
		if(BP.uses_mutcolor)
			BP.should_draw_greyscale = TRUE
			BP.species_color = C.dna?.features["mcolor"]

		BP.limb_id = chassis_of_choice.limbs_id
		BP.name = "\improper[chassis_of_choice.name] [parse_zone(BP.body_zone)]"
		BP.update_limb()
