extends CharacterBody2D
@onready var sprite = $Sprite2D
@onready var collider = $CollisionShape2D
var facing : float = 1:
    set(val):
        facing = val
        sprite.flip_h = facing < 0
        
        
var travel_speed = 150
var max_speed = 600

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _physics_process(delta):
    velocity = Vector2(facing*travel_speed,0)
    var collision = move_and_collide(velocity*delta)
    if collision:
        var collider = collision.get_collider()
        var is_wall = collider.is_in_group("Wall")
        if is_wall:
            facing = -facing
            
            if travel_speed < max_speed:
                travel_speed *=1.2
            if travel_speed > max_speed:
                travel_speed = max_speed
                
        var is_player = collider.is_in_group("Player")
        if is_player:
            collider.collect_bullet()
            queue_free()
            
        var is_cat = collider.is_in_group("Cat")
        if is_cat:
            collider.on_hit()
               
                
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
