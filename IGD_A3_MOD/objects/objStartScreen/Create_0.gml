function Update()
{
	if (keyboard_check_pressed(ord("1")))
	{
		objGm.multiplayer = true;
		room_goto(Room1);
	}
	else if (keyboard_check_pressed(ord("2")))
	{
		objGm.multiplayer = false;
		room_goto(Room1);
	}
}