shader_type spatial;

render_mode blend_mix,
			cull_disabled, 
			depth_prepass_alpha, 
			shadows_disabled, 
			specular_disabled, 
			vertex_lighting;

uniform sampler2D albedo_texture: source_color, filter_nearest;
uniform vec2 texture_tile = vec2(1, 1);

uniform bool snap_enabled = true;
uniform float snap_resolution: hint_range(60.0, 480.0, 1.0) = 148.0;

uniform float affine_weight : hint_range(0.0, 1.0) = 0.1;

varying vec2 uv_affine;
varying vec2 uv_persp;
varying float clip_w;

void vertex() {
	vec4 view_space_pos = MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
	vec4 clip_space_pos = PROJECTION_MATRIX * view_space_pos;
	
	if(snap_enabled){
		vec2 ndc = clip_space_pos.xy / clip_space_pos.w;
		ndc = round(ndc * snap_resolution) / snap_resolution;
		clip_space_pos.xy = ndc * clip_space_pos.w;
	}
	
	clip_w = clip_space_pos.w;
	uv_affine = UV * clip_w;
	uv_persp = UV;
	
	POSITION = clip_space_pos;
}

void fragment() {
	vec2 uv_aff = uv_affine / clip_w;
	vec2 uv_final = mix(uv_persp, uv_aff, affine_weight);
	
	vec4 albedo = texture(albedo_texture, uv_final * texture_tile);
	ALBEDO = albedo.rgb;
	ALPHA = albedo.a;
}
