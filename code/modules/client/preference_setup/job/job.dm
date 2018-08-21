/datum/preferences
	var/job_high = null
	var/list/job_medium
	var/list/job_low
	var/alternate_option

/datum/category_item/player_setup_item/jobs
	name = "Jobs"
	sort_order = 1

/datum/category_item/player_setup_item/jobs/New()
	..()
	listchecks()

/datum/category_item/player_setup_item/jobs/load_character(var/savefile/S)
	from_file(S["job_high"],			pref.job_high)
	from_file(S["job_medium"],			pref.job_medium)
	from_file(S["job_low"],				pref.job_low)
	listchecks()
/datum/category_item/player_setup_item/jobs/save_character(var/savefile/S)

	to_file(S["job_high"],				pref.job_high)
	to_file(S["job_medium"],			pref.job_medium)
	to_file(S["job_low"],
					pref.job_low)
	listchecks()
/datum/category_item/player_setup_item/jobs/proc/listchecks()
	if(!islist(pref.job_low))
		pref.job_low=list()
	if(!islist(pref.job_medium))
		pref.job_medium=list()
/datum/category_item/player_setup_item/jobs/proc/get_job_prio(var/datum/job/job)
	if(pref.job_high==job.title)
		return "High"
	if(pref.job_medium.Find(job.title))
		return "Med"
	if(pref.job_low.Find(job.title))
		return "Low"
	return "None"

/datum/category_item/player_setup_item/jobs/proc/Remove_job_Med(var/datum/job/job)
	if(pref.job_medium.Find(job.title))
		pref.job_medium-=job.title

/datum/category_item/player_setup_item/jobs/proc/Remove_job_Low(var/datum/job/job)
	if(pref.job_low.Find(job.title))
		pref.job_low-=job.title

/datum/category_item/player_setup_item/jobs/proc/Add_job_Med(var/datum/job/job)
	if(pref.job_medium.Find(job.title))
		return
	pref.job_medium+=job.title

/datum/category_item/player_setup_item/jobs/proc/Add_job_Low(var/datum/job/job)
	if(pref.job_low.Find(job.title))
		return
	pref.job_low+=job.title

/datum/category_item/player_setup_item/jobs/content(mob/user)
	if(!job_master)
		return
	. = list()
	. += "<tt><center>"
	for(var/datum/job/job in job_master.occupations)
		. += "<b>[job.title]:</b></a>"
		. += "<a href='?src=\ref[src];[job.title]=1'><b>[get_job_prio(job)]</b></a><br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/jobs/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/jbpriority
	for(var/datum/job/job in job_master.occupations)
		if(href_list["[job.title]"])
			jbpriority=get_job_prio(job)
			switch(jbpriority)
				if("High")
					pref.job_high=null
					Remove_job_Med(job)
					Remove_job_Low(job)
				if("Med")
					Remove_job_Med(job)
					Remove_job_Low(job)
					pref.job_high=job.title
				if("Low")
					Remove_job_Med(job)
					Remove_job_Low(job)
					Add_job_Med(job)
				if("None")
					Remove_job_Med(job)
					Remove_job_Low(job)
					Add_job_Low(job)
	return TOPIC_REFRESH_UPDATE_PREVIEW

/datum/preferences/proc/CorrectLevel(var/datum/job/job, var/level)
	if(!job || !level)	return 0
	switch(level)
		if(1)
			return job_high == job.title
		if(2)
			return !!(job.title in job_medium)
		if(3)
			return !!(job.title in job_low)
	return 0