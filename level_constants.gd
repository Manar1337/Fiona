extends Node
# level_constants.gd
enum LevelType {
	START,
	FLYING,
	WALKING,
	DEATH,
	POEM,
	HIGH_SCORE
}

enum SpecialLevel {
	DEATH,
	POEM,
	HIGH_SCORE
}

const level_structure: Dictionary = {
	"start": {"number": 0, "type": LevelType.START},
	"level_1": {"number": 1, "type": LevelType.FLYING},
	"level_2": {"number": 2, "type": LevelType.WALKING},
	"level_3": {"number": 3, "type": LevelType.FLYING},
	"level_4": {"number": 4, "type": LevelType.WALKING},
	"level_5": {"number": 5, "type": LevelType.FLYING},
	"level_6": {"number": 6, "type": LevelType.WALKING},
	"level_7": {"number": 7, "type": LevelType.FLYING},
	"level_8": {"number": 8, "type": LevelType.WALKING},
	"level_9": {"number": 9, "type": LevelType.FLYING},
	"level_10": {"number": 10, "type": LevelType.WALKING},
	"level_11": {"number": 11, "type": LevelType.FLYING},
	"level_12": {"number": 12, "type": LevelType.WALKING}
}