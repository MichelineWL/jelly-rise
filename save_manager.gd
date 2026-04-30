extends Node

# Path file save
const SAVE_PATH = "user://save_data.json"

var high_score := 0

func _ready():
	load_game()

func save_game(score: int):
	var data = {
		"high_score": max(score, high_score)
	}
	high_score = data["high_score"]
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		print("Game saved! High score:", high_score)

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found, starting fresh.")
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var err = json.parse(content)
		if err == OK:
			var data = json.get_data()
			high_score = data.get("high_score", 0)
			print("Loaded! High score:", high_score)

func get_high_score() -> int:
	return high_score
