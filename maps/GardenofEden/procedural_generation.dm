#define WALL_CHAR 1
#define FLOOR_CHAR 2
#define CELL_ALIVE(VAL) (VAL == cell_live_value)
#define KILL_CELL(CELL, NEXT_MAP) NEXT_MAP[CELL] = cell_dead_value;
#define REVIVE_CELL(CELL, NEXT_MAP) NEXT_MAP[CELL] = cell_live_value;
#define TRANSLATE_COORD(X,Y) ((((Y) - 1) * limit_x) + (X))

/datum/procgenerator
	var/startx=1
	var/starty=1
	var/limit_x=150
	var/limit_y=150
	var/z=1
	var/normal_prob=15
	var/Floor=/turf/simulated/floor/asteroid
	var/Wall=/turf/simulated/mineral
	var/list/map=list()
	var/initial_wall_cell=55
	var/iterations=5
	var/cell_live_value = WALL_CHAR
	var/cell_dead_value = FLOOR_CHAR
	var/cell_threshold = 12

/datum/procgenerator/New(sx,sy,lx,ly,_z)
	startx=sx
	starty=sy
	limit_x=lx
	limit_y=ly
	z=_z
	set_map_size()
	seed_map()
	automata_generate_map()
	generate()
	//world.log<<"Started generation"

/datum/procgenerator/proc/automata_generate_map()
	for(var/iter = 1 to iterations)
		var/list/next_map[limit_x*limit_y]
		var/count
		var/is_not_border_left
		var/is_not_border_right
		var/ilim_u
		var/ilim_d
		var/bottom_lim = ((limit_y - 1) * limit_x)

		if (!islist(map))
			set_map_size()

		for (var/i in 1 to (limit_x * limit_y))
			count = 0

			is_not_border_left = i != 1 && ((i - 1) % limit_x)
			is_not_border_right = i % limit_x

			if (CELL_ALIVE(map[i])) // Center row.
				++count
			if (is_not_border_left && CELL_ALIVE(map[i - 1]))
				++count
			if (is_not_border_right && CELL_ALIVE(map[i + 1]))
				++count

			if (i > limit_x) // top row
				ilim_u = i - limit_x
				if (CELL_ALIVE(map[ilim_u]))
					++count
				if (is_not_border_left && CELL_ALIVE(map[ilim_u - 1]))
					++count
				if (is_not_border_right && CELL_ALIVE(map[ilim_u + 1]))
					++count

			if (i <= bottom_lim) // bottom row
				ilim_d = i + limit_x
				if (CELL_ALIVE(map[ilim_d]))
					++count
				if (is_not_border_left && CELL_ALIVE(map[ilim_d - 1]))
					++count
				if (is_not_border_right && CELL_ALIVE(map[ilim_d + 1]))
					++count

			if(count >= cell_threshold)
				REVIVE_CELL(i, next_map)
			else	// Nope. Can't be alive. Kill it.
				KILL_CELL(i, next_map)

			//CHECK_TICK

		map = next_map

/datum/procgenerator/proc/generate()
	var/new_path
	var/tmp_cell
	for(var/turf/T in block(locate(startx, starty, z), locate(limit_x, limit_y, z)))
		tmp_cell = TRANSLATE_COORD(T.x, T.y)

		switch (map[tmp_cell])
			if(WALL_CHAR)
				new_path = Wall
			if(FLOOR_CHAR)
				new_path = Floor

		if (!new_path)
			continue
		T.ChangeTurf(new_path)

/datum/procgenerator/proc/set_map_size()
	map = list()
	map.len = limit_x * limit_y

/datum/procgenerator/proc/seed_map()
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(prob(initial_wall_cell))
				map[current_cell] = WALL_CHAR
			else
				map[current_cell] = FLOOR_CHAR
/datum/procgenerator/proc/get_map_cell(var/x,var/y)
	if(!map)
		set_map_size()
	. = ((y-1)*limit_x)+x
	if((. < 1) || (. > map.len))
		return null