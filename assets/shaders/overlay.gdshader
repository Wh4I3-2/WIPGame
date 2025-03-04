shader_type canvas_item;

uniform sampler2D _texture : repeat_enable, filter_nearest;
uniform vec2 scale;
uniform vec2 scroll;
uniform vec4 modulate : source_color = vec4(1);
uniform float alpha;
uniform float alpha_speed;
uniform float alpha_offset;

uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
	vec2 ps = SCREEN_PIXEL_SIZE;
	vec2 ratio = (ps.x > ps.y) ? vec2(ps.y / ps.x, 1) : vec2(1, ps.x / ps.y);
	vec2 uv = SCREEN_UV * ratio * scale;
	uv += scroll * TIME;
	vec4 _modulate = vec4(modulate.rgb, abs(sin(TIME * alpha_speed)) * alpha + alpha_offset);
	COLOR = texture(_texture, uv) * _modulate;
}