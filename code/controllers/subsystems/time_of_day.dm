var/global/list/turfs = list()
var/global/list/outside_turfs = list()
var/time_of_day=8//24 hour time
var/time_of_day_change_by=0.1

PROCESSING_SUBSYSTEM_DEF(time_of_day)
	name = "time_of_day"
	init_order = INIT_ORDER_CAVES
	flags = SS_POST_FIRE_TIMING
	priority = SS_PRIORITY_MACHINERY//SS_PRIORITY_AIR
	var/change_by=0.1
	wait = 1

/datum/controller/subsystem/processing/time_of_day/Initialize()
	var/list/turfs2pickfrm=turfs.Copy()//outside
	for(var/turf/T in turfs2pickfrm)
		var/area/A=get_area(T)
		if(!A.outside)
			turfs2pickfrm-=T
	world.log<<"length=[turfs2pickfrm.len]"
	outside_turfs=turfs2pickfrm



/datum/controller/subsystem/processing/time_of_day/fire()
	time_of_day+=time_of_day_change_by/10
	if(time_of_day>=24)
		time_of_day=1
	var/turfs_len=outside_turfs.len
	#define DIVISOR 200
	for(var/v=1;v<turfs_len;v++)// in 1 to turfs_len)
		spawn ceil(v/DIVISOR) // 100,000 turfs = 50 seconds (when DIVISOR = 200)
			var/turf/T=outside_turfs[v]
			if(T.time_of_day_turf != time_of_day_num_2_word())
				T.adjust_lighting_overlay_to_daylight()

#define Early_Morning 1
#define Morning 6
#define Noon 12
#define AfterNoon 16
#define Evening 18
#define MidNight 24

/proc/time_of_day_num_2_word()
	switch(time_of_day)
		if(Early_Morning to Morning)
			return "Early Morning"
		if(Morning to Noon)
			return "Morning"
		if(Noon to AfterNoon)
			return "Afternoon"
		if(AfterNoon to Evening)
			return "Evening"
		if(Evening to MidNight)
			return "Night"
		if(MidNight to Early_Morning)
			return "Midnight"

#define BASIC_LIGHT_AMOUNT 0.05
#define MAX_LIGHT_AMOUNT 1.00
var/list/time_of_day2luminosity = list(
	"Early Morning" = BASIC_LIGHT_AMOUNT * 10,
	"Morning" = BASIC_LIGHT_AMOUNT * 15,
	"Afternoon" = BASIC_LIGHT_AMOUNT * 18,
	"Midday" = MAX_LIGHT_AMOUNT,
	"Evening" = BASIC_LIGHT_AMOUNT * 7,
	"Night" = BASIC_LIGHT_AMOUNT * 2,
	"Midnight" = BASIC_LIGHT_AMOUNT)
/turf
	var/time_of_day_turf

/turf/proc/adjust_lighting_overlay_to_daylight()
	var/area/A=get_area(src)
	if(!A.outside)
		outside_turfs-=src
		return

	var/changed = FALSE

	for (var/datum/lighting_corner/corner in corners)
		//world.log<<"time_of_day2luminosity(time_of_day_num_2_word())=[time_of_day2luminosity[time_of_day_num_2_word()]]"
		corner.TOD_lum_r = time_of_day2luminosity[time_of_day_num_2_word()]
		corner.TOD_lum_g = time_of_day2luminosity[time_of_day_num_2_word()]
		corner.TOD_lum_b = time_of_day2luminosity[time_of_day_num_2_word()]
		changed = TRUE
		corner.update_overlays()
	time_of_day_turf=time_of_day_num_2_word()
	if (changed)
		if (lighting_overlay)
			//world.log<<"updartlayover"
			lighting_overlay.update_overlay()
/area
	var/outside=0

/area/outside
	name="outisde"
	icon_state="outisde"
	base_turf = /turf/simulated/open
	outside=1

/datum/lighting_corner
	//
	var/TOD_lum_r = 0
	var/TOD_lum_g = 0
	var/TOD_lum_b = 0
	//

/mob/living/carbon/human/verb/chngtimeofday(A as num)
	if(A<=24||A>0)
		time_of_day=A
/mob/living/carbon/human/verb/chngtimeprogress(A as num)
	if(A)
		time_of_day_change_by=A

/datum/lighting_corner/proc/getLumR()
	return min(1.0, lum_r + (TOD_lum_r))
/datum/lighting_corner/proc/getLumG()
	return min(1.0, lum_g + (TOD_lum_g))
/datum/lighting_corner/proc/getLumB()
	return min(1.0, lum_b + (TOD_lum_b))