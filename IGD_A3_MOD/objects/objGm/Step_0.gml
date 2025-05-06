if (room == Room1)
{
	if (!started)
	{
		Start();
		started = true;
	}
	Update();
}
show_debug_message("Player Hand: " + string(ds_list_size(objGm.playerHand)) + "\nComputer Hand: " + string(ds_list_size(objGm.computerHand)));