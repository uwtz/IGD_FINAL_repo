clr = c_white;
audio_play_sound(sndCrown, 0, false);

lerpSpd = .2;
targetX = x;
targetY = y;
destroyOnTarget = false;
targetCounter = noone;

function Update()
{
	// lerping
	if (abs(x-targetX)>50)
	{x = lerp(x,targetX,lerpSpd);}
	else {x = targetX;}
	
	if (abs(y-targetY)>50)
	{y = lerp(y,targetY,lerpSpd);}
	else {y = targetY;}
	
	if (destroyOnTarget && x == targetX && y == targetY)
	{
		targetCounter.Bwounce();
		instance_destroy(self);
	}
}

function SetTargetLoc(_x, _y)
{
	targetX = _x;
	targetY = _y;
}