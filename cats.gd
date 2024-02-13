extends Node2D

var player_position : Vector2 = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func _physics_process(delta):
    var children = get_children()
    for child in children:
        child.player_position = player_position
    

func _on_player_announce_position_signal(pos):
    player_position = pos


func _on_canvas_layer_reset_game():
    for child in get_children():
        child.queue_free()
