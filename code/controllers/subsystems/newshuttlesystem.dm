/*var/list/moving_newshuttles=list()
PROCESSING_SUBSYSTEM_DEF(newshuttlesystem)
	name = "newshuttlesystem"
	init_order = INIT_ORDER_CAVES
	flags = SS_NO_INIT
	priority = SS_PRIORITY_MACHINERY//SS_PRIORITY_AIR
	//var/change_by=0.1
	//wait = 1
/datum/controller/subsystem/processing/newshuttlesystem/fire()
	if(moving_newshuttles&&moving_newshuttles.len)
		for(var/datum/newshuttle/S in moving_newshuttles)
			if(!S.moving&&S.location!=S.intermission)
				moving_newshuttles-=S
			if(S.moving)
				if(S.Can_Drop())
					S.Move_to_Destination()	*/
