precision mediump float;

varying vec2 v_vTexcoord;

uniform float u_time;
uniform vec3 u_color1;
uniform vec3 u_color2;
uniform vec3 u_color3;
uniform vec2 u_resolution;

// Hash function to generate pseudo-random values
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// Smooth noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    // Four corners in 2D of a tile
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    // Cubic interpolation
    vec2 u = f*f*(3.0-2.0*f);
    
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractal noise (fbm)
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;

    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p * frequency);
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void main() {
    // Aspect-corrected UVs
    vec2 uv = gl_FragCoord.xy / u_resolution;
    uv = uv * 2.0 - 1.0;
    uv.x *= u_resolution.y / u_resolution.x;

    // Animate UVs slightly to keep the effect moving in place
    vec2 scale = vec2(2.5 * (u_resolution.y / u_resolution.x), 2.5);
	vec2 q = uv * scale;
    q += vec2(
        fbm(q + vec2(0.0, u_time * 0.1)),
        fbm(q + vec2(5.2, u_time * 0.1))
    );

    float marble_value = fbm(q + fbm(q));

    // Create sine-wave-based marble effect with warping
    float v = sin((uv.x + marble_value * 2.5 + u_time * 0.1) * 3.1415);
    v = smoothstep(-1.0, 1.0, v);

    vec3 color = mix(mix(u_color1, u_color2, v), u_color3, v * (1.0 - v) * 2.0);
    gl_FragColor = vec4(color, 1.0);
}