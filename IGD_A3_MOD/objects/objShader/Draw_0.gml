
shader_set(marble_shader);

var t = current_time * 0.001;
var w = 1200;
var h = 800;

shader_set_uniform_f(shader_get_uniform(marble_shader, "u_time"), t);
shader_set_uniform_f(shader_get_uniform(marble_shader, "u_resolution"), w, h);
shader_set_color_uniform("u_color1", 84, 14, 14); // white
shader_set_color_uniform("u_color2", 30, 30, 30); // light blue-gray
shader_set_color_uniform("u_color3", 15, 31, 84);    // deep indigo

draw_rectangle(0, 0, w, h, false);
shader_reset();

