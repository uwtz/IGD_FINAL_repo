if (room == Room1)
{
	if (!started)
	{
		Start();
		started = true;
	}
	Update();
}