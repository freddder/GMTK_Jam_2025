shader_type canvas_item;

uniform bool debug = false;
uniform float progress: hint_range(0.f, 1.f) = 0.f;
uniform float thickness: hint_range(0.f, 0.1f) = 0.05f;
uniform vec4 color: source_color = vec4(1.f);

void fragment() {
	float dist = distance(UV, vec2(0.5));
	float actual_progress = debug ? mod(TIME, 1.f) : progress;
	float radius = actual_progress / 2.f;
	float dist_from_edge = abs(dist - radius);
	if (thickness > dist_from_edge)
	{
		float alpha = 1.f - sin(dist_from_edge / thickness * 3.14 / 2.f);
		COLOR.rgb = color.rgb;
		COLOR.a = (1.f - actual_progress) * alpha * color.a;
	}
	else
	{
		COLOR = vec4(0.f);
	}
}