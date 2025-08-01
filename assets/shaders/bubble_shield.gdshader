shader_type canvas_item;

const float MPI = 1.5707966326;

const int STEPS = 20;

const float LOWER_LIMIT = 0.01;

uniform float zoom_out : hint_range(1.0, 10.0) = 1.0;

uniform float border_decay : hint_range(0.0, 0.99) = 0.6;

uniform vec4 shield_tint : source_color = vec4(0.407843, 0.564706, 0.729412, 0.768627);

uniform vec4 shield_saturation : source_color = vec4(1., 1., 1., .76);

uniform float attack_angle : hint_range(-6.283185, 6.283185) = 0.;

uniform float attack_penetration : hint_range(0., 0.9) = 0.2;

uniform float attack_radius : hint_range(0., 3.) = 0.2;

uniform float attack_amplitude : hint_range(0., 1.) = 0.1;

uniform float wave_speed : hint_range(2., 40.) = 16.;

uniform float wave_num : hint_range(10., 40.) = 17.;

uniform sampler2D noise_texture : repeat_enable;

uniform sampler2D screen_tex : hint_screen_texture, repeat_disable;

uniform float noise_speed : hint_range(1.0, 10.0) = 3.;

uniform float noise_amplitude : hint_range(0.01, 1.) = 0.89;

uniform float noise_deformation : hint_range(1., 300.) = 100.;

float compute_z_radius(vec2 pos, float r) {
	vec3 o = vec3(pos, -1.);
	return -sqrt(1. - dot(o, o) + (r * r));
}

float compute_front_z(vec2 pos) {
	vec3 p = vec3(pos, -1.);
	return (-sqrt(2. - dot(p, p)));
}

void fragment() {
	// Sphere computation
	vec2 current_pos = (UV - 0.5) * (2.0 * zoom_out);
	float len = length(current_pos);
	vec2 attack_direction = vec2(cos(attack_angle), sin(attack_angle));
	vec4 noise_texel = texture(noise_texture, current_pos + TIME * attack_direction * noise_speed);
	vec4 noise_amount = (noise_texel * (1. - noise_amplitude)) + noise_amplitude;
	float noise_mask = (noise_amount.r + noise_amount.g + noise_amount.b) / 3.0;
	float amplitude_decay = (1. + attack_amplitude) * border_decay * noise_mask;
	float border_mask = clamp(len - amplitude_decay, 0., 1. - border_decay) / (1. - border_decay);
	float mask = clamp(ceil(noise_mask * (1. + attack_amplitude) - len), 0., 1.);
	vec4 shield_color = mix(shield_saturation, shield_tint, 1. - border_mask) * mask;
	vec2 deformation_mask = (noise_texel.rg - vec2(.5)) * 2. * mask;

	// Waves
	if(len <= 1. + attack_amplitude) {
		vec2 attack_norm = attack_direction * (1. - attack_penetration);
		vec3 attack_position = vec3(attack_norm, compute_front_z(attack_norm));
		float retained_len = 0.;
		float retained_intensity = 0.;
		float z_step = compute_z_radius(current_pos, 1. + attack_amplitude);
		float hdiff = 1. + attack_amplitude;
		float min_diff = hdiff;
		int step_id = STEPS;
		for(int i = 0; i < STEPS; ++i) {
			vec3 current_projection = vec3(current_pos, z_step);
			vec3 pos_on_surface = normalize(current_projection);
			float att_len = length(attack_position - pos_on_surface);
			if(att_len < attack_radius) {
				float intensity = (cos(att_len * wave_num - TIME * wave_speed) + 1.)/2. * cos((att_len / attack_radius) * MPI);
				hdiff = abs(length(current_projection) - 1. - (intensity * attack_amplitude));
				if(hdiff < min_diff) {
					retained_intensity = intensity;
					retained_len = att_len;
					min_diff = hdiff;
					if (hdiff < LOWER_LIMIT) {
						break;
					}
				}

				float extra = pos_on_surface.z * (1. + (intensity * attack_amplitude));
				z_step += (extra - z_step) * (1. - (float(i) / float(STEPS)));
			} else {
				break;
			}
		}
		if ((hdiff < LOWER_LIMIT) || ((step_id == STEPS) && (min_diff < (1.0 + attack_amplitude)))) {
			float attenuation = cos(((1. - (len / attack_radius))) * MPI);
			shield_color = mask*mix(shield_color, shield_saturation, retained_intensity);
			deformation_mask = mask*mix(current_pos * (1. - retained_intensity), deformation_mask, cos(((1. - (len / attack_radius))) * MPI));
		}
	}

	vec4 screen_color = texture(screen_tex, SCREEN_UV + (noise_deformation * deformation_mask * SCREEN_PIXEL_SIZE));
	COLOR = vec4(mix(screen_color.rgb, shield_color.rgb, shield_color.a), 1.0);
}