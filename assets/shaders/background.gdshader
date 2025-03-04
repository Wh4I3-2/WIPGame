shader_type canvas_item;

uniform sampler2D _texture : filter_nearest, repeat_enable;
uniform float scale = 10.0;
uniform vec2 scroll;
uniform vec4 modulate : source_color;

void fragment() {
	vec2 ps = SCREEN_PIXEL_SIZE;
	vec2 ratio = (ps.x > ps.y) ? vec2(ps.y / ps.x, 1) : vec2(1, ps.x / ps.y);
	vec2 uv = SCREEN_UV * ratio * scale;
	uv += scroll * TIME;
	COLOR = texture(_texture, uv) * modulate;
}
