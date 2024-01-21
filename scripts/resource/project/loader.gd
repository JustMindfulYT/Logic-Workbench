extends ResourceFormatLoader

func _exists(path):
	return FileAccess.file_exists(path)
