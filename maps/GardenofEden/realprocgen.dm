/datum/procgenerator
	var/startx=1
	var/starty=1
	var/limit_x=150
	var/limit_y=150
	var/z=1
	var/normal_prob=30
	var/Floor=/turf/simulated/floor/asteroid
	var/Wall=/turf/simulated/mineral
	var/list/map=list()
	var/amountneeded=3
/datum/procgenerator/New(sx,sy,lx,ly,_z)
	startx=sx
	starty=sy
	limit_x=lx
	limit_y=ly
	z=_z
	generate()
/datum/procgenerator/proc/generate()
	//step1
	for(var/turf/T in block(locate(startx,starty,z),locate(limit_x,limit_y,z)))
		if(prob(normal_prob))
			T.ChangeTurf(Floor)
		else
			T.ChangeTurf(Wall)
	for(var/turf/T in block(locate(startx,starty,z),locate(limit_x,limit_y,z)))
		if(istype(T,Wall))
			if(IsNear(T))
				T.ChangeTurf(Floor)
		else if(istype(T,Floor))
			if(!IsNear(T))
				T.ChangeTurf(Wall)


/datum/procgenerator/proc/IsNear(T)
	var/list/directions2search=list(NORTH,EAST,SOUTH,WEST,NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST)
	var/count=0
	if(istype(T,Wall))
		while(directions2search.len)
			if(!directions2search||!directions2search.len)
				break
			var/pickedir=pick(directions2search)
			var/turf/A=get_step(T,pickedir)
			if(istype(A,Floor))
				count++
			directions2search-=pickedir
		if(count>=3)
			return 1
		else
			return 0
	else if(istype(T,Floor))
		while(directions2search.len)
			if(!directions2search||!directions2search.len)
				break
			var/pickedir=pick(directions2search)
			var/turf/A=get_step(T,pickedir)
			if(istype(A,Floor))
				count++
			directions2search-=pickedir
		if(count==3||count==2)
			return 1
		else
			return 0
/*proc/IsNear(turf/T,type)
	var/list/directions2search=list(NORTH,EAST,SOUTH,WEST,NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST)
	var/count=0
	while(directions2search.len)
		if(!directions2search||!directions2search.len)
			break
		var/pickedir=pick(directions2search)
		var/turf/A=get_step(T,pickedir)
		if(istype(A,type))
			count++
		directions2search-=pickedir
	if(count==3||count==2)
		return 1 */


