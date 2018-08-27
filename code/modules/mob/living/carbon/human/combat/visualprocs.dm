#define PERPENDICULAR_DIR(D) turn(D, 90)
#define NEGPERPENDICULAR_DIR(D) turn(D, -90)
/proc/is_A_behind_B(atom/A,atom/B)//If A is behind B
	var/Bdir=B.dir
	switch(Bdir)
		if(NORTH)//if B is looking north
			if(A.y<B.y)//if A is more south than B, and B is looking north.
				return TRUE
		if(SOUTH)//if B is looking south
			if(A.y>B.y)//if A is more north than B, and B is looking south.
				return TRUE
		if(EAST)//if B is looking east
			if(A.x<B.x)//if A is more west than B, and B is looking east.
				return TRUE
		if(WEST)//if B is looking west
			if(A.x>B.x)//if A is more east than B, and B is looking west.
				return TRUE
	return FALSE

/proc/is_A_perpendicular_to_B(atom/A,atom/B)//If A is looking at B and B is looking perpendicular to A
	var/Bdir=B.dir
	if(Bdir==PERPENDICULAR_DIR(get_dir(A,B))||Bdir==NEGPERPENDICULAR_DIR(get_dir(A,B)))
		return TRUE
	return FALSE

