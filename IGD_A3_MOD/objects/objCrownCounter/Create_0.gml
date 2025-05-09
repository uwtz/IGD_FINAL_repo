count = 0;
baseScale = 1.5;
bwounceScale = 3;
lerpSpd = .5;

function Update()
{
	if (abs(image_xscale-baseScale)>.1)
	{image_xscale = lerp(image_xscale,baseScale, lerpSpd);}
	else
	{image_xscale = baseScale;}
	
	if (abs(image_yscale-baseScale)>.1)
	{image_yscale = lerp(image_yscale,baseScale, lerpSpd);}
	else
	{image_yscale = baseScale;}
}

function Bwounce()
{
	image_xscale = bwounceScale;
	image_yscale = bwounceScale;
}