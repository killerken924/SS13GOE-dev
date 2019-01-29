/var/list/moving_advanced_shuttles=list()
/var/list/warming_up_advanced_shuttles=list()
PROCESSING_SUBSYSTEM_DEF(newshuttlesystem)
	name = "newshuttlesystem"
	init_order = INIT_ORDER_CAVES
	flags = SS_NO_INIT
	priority = SS_PRIORITY_MACHINERY//SS_PRIORITY_AIR
	//var/change_by=0.1
	//wait = 1
/datum/controller/subsystem/processing/newshuttlesystem/fire()
	if(moving_advanced_shuttles&&moving_advanced_shuttles.len)
		for(var/datum/advancedshuttle/S in moving_advanced_shuttles)
			if(S.moving)
				if(S.Can_Drop())
					S.Drop_From_Warp()
	//Handle warm up
	if(warming_up_advanced_shuttles&&warming_up_advanced_shuttles.len)
		for(var/datum/advancedshuttle/S in warming_up_advanced_shuttles)
			if(S.warming_up)
				if(world.time>S.start_warm_up_time+S.warm_up_time)//if warmed up
					S.Warm_Up()
