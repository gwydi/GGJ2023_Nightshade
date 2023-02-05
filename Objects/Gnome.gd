extends Sprite

onready var soundGnomed = $AudioStreamPlayer2D


func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		soundGnomed.play()
