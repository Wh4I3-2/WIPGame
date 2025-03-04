shader_type canvas_item;

uniform sampler2D texture : filter_nearest, repeat_enable;
uniform sampler2D noise : filter_nearest, repeat_enable;
uniform float speed_scale = 1;

vec3 screen(vec3 a, vec3 b) {
	return vec3(1.0 - (1.0 - a.r) * (1.0 - b.r), 1.0 - (1.0 - a.g) * (1.0 - b.g), 1.0 - (1.0 - a.b) * (1.0 - b.b));
}

void fragment() {
	vec2 ps = SCREEN_PIXEL_SIZE;
	vec2 ratio = (ps.x > ps.y) ? vec2(ps.y / ps.x, 1) : vec2(1, ps.x / ps.y);
	vec2 uv = SCREEN_UV * ratio;
	
	vec2 uv2 = vec2(uv.x * 1.2, uv.y * 1.2 - TIME * 0.5 * speed_scale);
	vec3 color2 = texture(texture, uv2).rgb * vec3(0.6, 1.0, 0.9);
	
	vec2 uv3 = vec2(uv.x * 1.4, uv.y * 1.4 - TIME * 0.3 * speed_scale);
	vec3 color3 = texture(texture, uv3).rgb * vec3(1.0, 1.0, 0.7);
	
	vec3 color = screen(color2, color3);
	
	vec2 nebula_uv1 = vec2((uv.x * 1.2 - TIME * 0.02 * speed_scale) - 0.3, (uv.y * 1.2 - TIME * 0.15 * speed_scale) - 0.2);
	vec3 nebula_color1 = texture(noise, nebula_uv1).rgb * vec3(0.05, 0.9, 1.0);
	
	vec2 nebula_uv2 = vec2((uv.x * 1.2 - TIME * 0.01 * speed_scale) + 0.4, (uv.y * 1.2 - TIME * 0.1 * speed_scale) + 0.1);
	vec3 nebula_color2 = texture(noise, nebula_uv2).rgb * vec3(0.8, 0.3, 1.0);
	
	vec2 nebula_uv3 = vec2(uv.x * 1.2 + TIME * 0.01 * speed_scale, uv.y * 1.2 - TIME * 0.05 * speed_scale);
	vec3 nebula_color3 = texture(noise, nebula_uv3).rgb * vec3(1.0, 0.4, 0.1);
	
	vec3 nebula_color = (nebula_color1 + nebula_color2 + nebula_color3) * 0.5;
	
	COLOR = vec4(color.rgb + nebula_color.rgb, COLOR.a);
}