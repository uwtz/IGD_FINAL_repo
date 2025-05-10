function Update()
{
	if (position_meeting(mouse_x, mouse_y, id) &&
		mouse_check_button(mb_left))
	{
		image_index = 1;
	}
	if (position_meeting(mouse_x, mouse_y, id) &&
		mouse_check_button_released(mb_left))
	{
		global.multiplayer = mult;
		room_goto(Room1);
	}
}

image_alpha = .1;