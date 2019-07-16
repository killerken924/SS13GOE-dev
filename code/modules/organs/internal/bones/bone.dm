/mob/living/carbon
	var/list/bones_by_name= list()
	var/list/bones= list()

/obj/item/organ/bone
	name="Bone"
	var/bone_tag
	var/broken = 0
	var/cracked = 0
	var/destroyed
	var/crack_dmg
	var/parent_bone
	var/child_bone
	var/list/bone_heiarchy=list()
	icon='icons/mob/bones.dmi'
	icon_state="test"


/obj/item/organ/bone/New(var/mob/living/carbon/C)
	..(C)
	generate_heiarchy()

/obj/item/organ/bone/proc/generate_heiarchy()
	bone_heiarchy=list()
	var/list/Bonelist=owner.bones-src
	if(parent_bone)
		for(var/obj/item/organ/bone/B1 in Bonelist)//Search bones in bonelist
			if(B1.bone_tag==parent_bone)//Find parent of src
				bone_heiarchy+=B1//add to heiarchy
				Bonelist-=B1//remove from temp bonelist
				continue//coninute next iteration
			if(bone_heiarchy&&bone_heiarchy.len)//see if heiarchy list exists
				for(var/obj/item/organ/bone/B2 in bone_heiarchy)//search for bones in new heiarchy list
					if(B2.parent_bone==B1.bone_tag)//see if bone in bonelist, is a parent bone of one in the heiarchy
						bone_heiarchy+=B1//add new bone to heiarchy
						Bonelist-=B1//remove fromlist
						continue
	return

/obj/item/organ/bone/proc/Functional()
	var/Function_Counter = 0//Higher than zero, it is not funciontal
	if(broken||destroyed)
		Function_Counter++
	if(bone_heiarchy&&bone_heiarchy.len)
		for(var/obj/item/organ/bone/B in bone_heiarchy)
			if(B.broken||B.destroyed)
				Function_Counter++
	if(Function_Counter>0)
		return 0
	return 1

//Wrist
/obj/item/organ/bone/wrist
	max_damage=20



/obj/item/organ/bone/wrist/l
	max_damage=20
	parent_bone=BONE_L_LOWERARM


/obj/item/organ/bone/wrist/r
	max_damage=20
	parent_bone=BONE_R_LOWERARM

//ARMS
/obj/item/organ/bone/arm_bone
	name="Arm Bone"
	max_damage=40

//Above Elbow
/obj/item/organ/bone/arm_bone/upper/r
	name="Upper Arm Bone"
	desc="A right upper arm bone"
	bone_tag=BONE_R_UPPERARM
	parent_organ = BP_R_ARM

/obj/item/organ/bone/arm_bone/upper/l
	name="Upper Arm Bone"
	desc="A left upper arm bone"
	bone_tag=BONE_L_UPPERARM
	parent_organ = BP_L_ARM

//Below Elbow
/obj/item/organ/bone/arm_bone/lower/r
	name="Arm Bone"
	desc="A right arm bone"
	bone_tag=BONE_R_LOWERARM
	parent_organ = BP_R_ARM
	parent_bone=BONE_R_UPPERARM

/obj/item/organ/bone/arm_bone/lower/l
	name="Arm Bone"
	desc="A left arm bone"
	bone_tag=BONE_L_LOWERARM
	parent_organ = BP_L_ARM
	parent_bone=BONE_L_UPPERARM

/obj/item/organ/bone/take_damage(amount, var/silent=0)
	..(amount,silent)

/obj/item/organ/bone/spine
/obj/item/organ/bone/spine/stem//ROOT, Top most of spine, controls everything
/obj/item/organ/bone/spine/upper// controls everything but brain
/obj/item/organ/bone/spine/lower//controls only legs, and genitals

