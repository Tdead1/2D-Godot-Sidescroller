extends KinematicBody;

var inputwalk = 0.0;
var inputslide = false;
var inputjump = false;

var velocity     = Vector2(0,0);
var acceleration = Vector2(0,0);

var recovertimer = 0.0;
var recovercooldown = 0.2;

var jumpcooldown = 0.5;
var jumptimer = 0.0;
var jumpforce = 120;
var jumping = false;

var sliding = false;

export var speed = 10.0;
export var gravity = 20.0;

func _init():
	pass;

func _input(event):
	inputwalk = 0.0;
	inputslide = false;
	inputjump = false;
	
	if(Input.is_action_pressed("Slide")):
		inputslide = true;		
	if(Input.is_action_just_pressed("Jump")):
		inputjump = true;
	else:
		inputjump = false;
	if(Input.is_action_pressed("WalkRight")):
		inputwalk = 1.0;
	if(Input.is_action_pressed("WalkLeft")):
		inputwalk = -1.0;
	pass;
	
func _process(delta):
	if(recovertimer >= 0):
		recovertimer -= delta;
	
	if(jumping):
		jumptimer -= delta;
		if(jumptimer < 0 && is_on_floor()):
			jumping = false;
			jumptimer = jumpcooldown;
			recovertimer = recovercooldown;
	
	if(inputjump == true && is_on_floor() && recovertimer <= 0 && !sliding):
		jumptimer = jumpcooldown;
		jumping = true;
	
	if(inputslide == true):
		if(recovertimer <= 0 && !jumping):
			sliding = true;
	elif(sliding == true):
		sliding = false;
		recovertimer = recovercooldown;
		
		
	pass;
	
func _physics_process(delta):
	var movement;
	acceleration = Vector2(inputwalk * speed, -gravity);
	
	if(jumping):
		acceleration.y += jumpforce * jumptimer;
		acceleration.x *= 1.2;
	
	if(!sliding):
		velocity = Vector2(0,0);
		movement = velocity + acceleration;
		movement.x = clamp(movement.x, -15, 15);
		movement.y = clamp(movement.y, -30, 30);
		movement = move_and_slide(Vector3(movement.x, movement.y, 0.0), Vector3(0, 1, 0), true);
		
	else:
		velocity.y = 0;
		acceleration.x = 0;
		movement = velocity + acceleration;
		print(velocity);
		movement.x = clamp(movement.x, -15, 15);
		movement.y = clamp(movement.y, -30, 30);
		movement = move_and_slide(Vector3(movement.x, movement.y, 0.0), Vector3(0, 1, 0), false);
	
	velocity = Vector2(movement.x, movement.y);
	pass;
