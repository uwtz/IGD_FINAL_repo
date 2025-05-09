global.multiplayer = false;

/// shader_set_color_uniform(uniform_name, r, g, b)
/// Usage: shader_set_color_uniform("u_color1", 255, 128, 64);
function shader_set_color_uniform(_name, _r, _g, _b)
{
	var name = _name;
	var r = _r / 255;
	var g = _g / 255;
	var b = _b / 255;

	var u = shader_get_uniform(marble_shader, name);
	if (u != -1) {
	    shader_set_uniform_f(u, r, g, b);
	}
}
