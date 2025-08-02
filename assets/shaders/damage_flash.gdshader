shader_type canvas_item;

uniform vec3 color: source_color = vec3(1.f);
uniform float alpha: hint_range(0.f, 1.f) = 1.f;

void fragment() {
	COLOR.rgb = mix(COLOR.rgb, color, alpha);
}
