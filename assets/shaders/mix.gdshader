shader_type canvas_item;

uniform vec3 modulate : source_color;
uniform float mix_value = 0.5;

void fragment() {
	COLOR.rgb = mix(COLOR.rgb, modulate, mix_value);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
