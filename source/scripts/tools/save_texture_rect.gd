extends TextureRect

func _ready():
	save()

func save():
	texture.get_image().save_png("user://%s.png" % name)
