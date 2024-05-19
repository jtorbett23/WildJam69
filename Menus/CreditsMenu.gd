extends MenuTurbo

class_name CreditsMenu

func _ready() -> void:
	var credits_text = "Art:
	Level & Character
	- Momo
	Dialogue Manager
	- Nathan Hoald
	"
	
	self.set_content("Credits", 
	[	{"name": "Credits", "type": Label, "text": credits_text},
		{"name": "Return", "callback": Callable(self, "close")}
	])

func close() -> void:
	self.queue_free()