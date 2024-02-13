extends CanvasLayer
@onready var button = $Button
@onready var healths = $Healths
@onready var bullets = $Bullets
@onready var player = get_node("/root/Map/Player")

var bullet_count = 3:
    set(val):
        for child in bullets.get_children():
            child.visible = true
        if val < 3:
            bullets.get_children()[2].visible = false
        if val < 2:
            bullets.get_children()[1].visible = false
        if val < 1:
            bullets.get_children()[0].visible = false
        bullet_count =val
        
var health = 3:
    set(val):
        for child in healths.get_children():
            child.visible = true
        if val < 3:
            healths.get_children()[2].visible = false
        if val < 2:
            healths.get_children()[1].visible = false
        if val < 1:
            healths.get_children()[0].visible = false
        health = val 



signal reset_game
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func on_game_over():
    button.visible = true


func _on_button_button_down():
    button.visible = false
    reset_game.emit()
    health = 3
    bullet_count = 3


func _on_player_bullet_collected():
    bullet_count +=1


func _on_player_bullet_used():
   bullet_count -=1


func _on_player_health_lost():
    health -=1
    if health <= 0 :
        on_game_over()
        player.visible= false
