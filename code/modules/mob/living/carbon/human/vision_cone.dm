#define OPPOSITE_DIR(D) turn(D, 180)
/mob/living/var/list/Hidden_Mobs=list()
/mob/living/var/list/Hidden_Objs=list()
/mob/living/var/list/Hidden_Images=list()

/mob/living/proc/Clear_Vision()
	if(src.client)
		for(var/image/I in Hidden_Images)
			I.override=0
			src.client.images-=I
			Hidden_Images-=I
		for(var/mob/M in Hidden_Mobs)
			Hidden_Mobs-=M
/proc/cone(atom/center = usr, dir = NORTH, list/list = oview(center))
	for(var/atom/O in list) if(!O.InCone(center, dir)) list -= O
	return list

/mob/living/carbon/human/proc/Handle_Real_Vision()
	if(src.client)
		Clear_Vision()
		Handle_Vision_Cone()
		if(resting||sleeping||stat==UNCONSCIOUS)
			return
		for(var/mob/M in cone(src, OPPOSITE_DIR(src.dir), view(10, src)))
			var/image/I= image("split", M)
			Hidden_Images+=I
			Hidden_Mobs+=M
			I.override=1
			src.client.images+=I
		return

/atom/proc/InCone(atom/center = usr, dir = NORTH)
	if(get_dist(center, src) == 0 || src == center) return 0
	var/d = get_dir(center, src)

	if(!d || d == dir) return 1
	if(dir & (dir-1))
		return (d & ~dir) ? 0 : 1
	if(!(d & dir)) return 0
	var/dx = abs(x - center.x)
	var/dy = abs(y - center.y)
	if(dx == dy) return 1
	if(dy > dx)
		return (dir & (NORTH|SOUTH)) ? 1 : 0
	return (dir & (EAST|WEST)) ? 1 : 0

/mob/living/InCone(mob/center = usr, dir = NORTH)
	. = ..()
	for(var/obj/item/grab/G in center)//TG doesn't have the grab item. But if you're porting it and you do then uncomment this.
		if(src == G.victim)
			return 0
		else
			return
/mob/dead/InCone(mob/center = usr, dir = NORTH)
	return
/mob/living/carbon/human/proc/Handle_Vision_Cone()
	if(istype(src,/mob/living/carbon/human/dummy/mannequin))
		return 1
	fov_icon.dir=src.dir
	if(resting||sleeping||stat==UNCONSCIOUS||client.eye != client.mob)
		fov_icon.alpha=0
		return
	else
		fov_icon.alpha=255

