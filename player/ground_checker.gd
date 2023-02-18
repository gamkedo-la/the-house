extends RayCast

class_name GroundChecker


enum WalkingOn { Unknown, OutsideGround, BuildingGround }


func currently_walking_on() -> int:
	var collider = get_collider()
	if collider is StaticBody:
		if collider.name == "landscape":
			return WalkingOn.OutsideGround
		else:
			return WalkingOn.BuildingGround
	else:
		return WalkingOn.Unknown
