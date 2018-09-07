
SUBSYSTEM_DEF(procedural)
	name = "procedural"
	init_order = INIT_ORDER_CAVES
	flags = SS_NO_FIRE
	var/startx=1//101
	var/starty=1//128
	var/endx=255//197
	var/endy=255//198
	var/z=3//1

/datum/controller/subsystem/procedural/Initialize()
	//var/turf/start=locate(startx,starty,z)
	//var/turf/end=locate(endx,endy,z)
	start_generate_mines()//generate_mines(start,end)
	..()
/datum/controller/subsystem/procedural/proc/start_generate_mines()
	new/datum/procgenerator(startx,starty,endx,endy,z)
