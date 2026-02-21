shader_type canvas_item;

uniform float time_scale = 1.0;
uniform vec4 glow_color : source_color = vec4(0.78, 0., 1.0, 1.0);
uniform float glow_strength = 2.0;
uniform float flicker_speed = 3.0;
uniform float flicker_intensity = 0.15;

void fragment(){
    // Sample text slightly offset in each color channel
    // creates chromatic aberration on edges
    float offset = 0.003;
    float r = texture(TEXTURE, UV + vec2(offset, 0.0)).a;
    float g = texture(TEXTURE, UV).a;
    float b = texture(TEXTURE, UV - vec2(offset, 0.0)).a;
    
    vec4 col = texture(TEXTURE, UV);
    
    // Flicker effect
    float flicker = 1.0 - flicker_intensity * 
    sin(TIME * flicker_speed) * sin(TIME * flicker_speed * 2.3);
    
    // Apply glow on edges where channels split
    vec3 chromatic = vec3(r, g, b);
    COLOR.rgb = col.rgb + glow_color.rgb * (chromatic - col.a) * glow_strength;
    COLOR.a = col.a * flicker;
}
