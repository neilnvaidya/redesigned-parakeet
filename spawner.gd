extends Node2D
 
@onready var container =$cats
@onready var cat_prefab = preload("res://cat.tscn")
const delay = 4
var timer = 0
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _physics_process(delta):
    timer += delta
    if timer > delay:
        var rng = randi() % 3
        var pos = get_children()[rng].position
        spawn_cat(pos)
        timer = 0
        
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func spawn_cat(pos):
    var cat = cat_prefab.instantiate()
    container.add_child(cat)
    cat.position = pos
    
