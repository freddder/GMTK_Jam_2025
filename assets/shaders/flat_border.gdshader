shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec2 size = vec2(1.0, 1.0);
uniform float border_size: hint_range(0.0, 0.5) = 0.1;
uniform float border_fade_in: hint_range(0.0, 0.5) = 0.0;
uniform float border_fade_out: hint_range(0.0, 0.5) = 0.0;
uniform float corner_radius = 0.0;

float rectangle(vec2 position) {
	vec2 component_wise_edge_distance = abs(position) - (vec2(0.5, 0.5) * size + corner_radius * (size - 1.0));
	float outside_distance = length(max(component_wise_edge_distance, 0));
    float inside_distance = min(max(component_wise_edge_distance.x, component_wise_edge_distance.y), 0);
    return outside_distance + inside_distance;
}

void fragment() {
	COLOR = border_color;
	float border_scale = 1.0 + 2.0 * corner_radius;
	float d = rectangle((UV - 0.5) * size * border_scale);
	float border_width = (border_size + border_fade_in + border_fade_out) * border_scale;

	if (d >= corner_radius - border_width && d <= corner_radius) {
		float rel_d = (d - corner_radius + border_width) / border_width;
		float alpha = min((rel_d / (border_fade_in * border_scale / border_width)), (1.0 - (rel_d)) / (border_fade_out * border_scale / border_width));
		if (d < corner_radius - (border_size + border_fade_out) * border_scale) {
			COLOR = mix(color, border_color, alpha);
		} else {
			COLOR = border_color;
		}
	} else if (d < corner_radius - border_width ) {
		COLOR = color;
	}
}