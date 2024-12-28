#version 450

uniform sampler2D tex;

// 0 - distortion x
// 1 - distortion y
// 2 - distortion strength
// 3 - vignette strength
uniform float Params[4];

in vec2 texCoord;
in vec4 color;
out vec4 fragColor;

vec2 distortion(vec2 coord, vec2 dp, float strength) {
    vec2 d = coord - dp;
    float r = length(d);
    vec2 dir = d / r;
    return dp + dir * pow(r, strength);
}

void main() {
    // fetch compositor parameters
    vec2 distortionPos = vec2(Params[0], Params[1]);
    float distortionStrength = Params[2];
    float vignetteStrength = Params[3];

    // uv distortion goes first
    vec2 UV = texCoord;
    UV = distortion(UV, distortionPos, distortionStrength);

    // color compositing
    vec3 col = texture(tex, UV).rgb;

    // vignette
    float vignette = 1.0 - distance(texCoord, vec2(0.5)) * vignetteStrength;
    col *= vignette;

    fragColor = vec4(col, 1.0);
}