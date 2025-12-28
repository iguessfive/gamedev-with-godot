@tool
class_name ToggleExternalEditor extends EditorScript

func _run() -> void:
	var settings = EditorInterface.get_editor_settings()
	const path = "text_editor/external/use_external_editor"
	var use_external = settings.get_setting(path)
	settings.set_setting(path, not use_external)
	
	if use_external:
		print_rich("[color=lightgreen]Switched to [b]Built-in[/b] Script Editor[/color]")
	else:
		print_rich("[color=lightgreen]Switched to [b]External[/b] Script Editor[/color]")
