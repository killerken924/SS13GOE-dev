proc/get_job_by_title(var/j)
	if(j)
		var/datum/job/job = job_master.occupations_by_title[j]
		return job