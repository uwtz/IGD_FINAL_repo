function Update()
{
	if (keyboard_check_pressed(ord("1")))
	{
		global.multiplayer = true;
		room_goto(Room1);
	}
	else if (keyboard_check_pressed(ord("2")))
	{
		global.multiplayer = false;
		room_goto(Room1);
	}
}