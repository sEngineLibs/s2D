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

vec3 filterLinear(sampler2D tex, vec2 UV) {
    vec2 texSize = vec2(textureSize(tex, 0));
    vec2 texelSize = 1.0 / texSize;

    vec2 baseUV = floor(UV * texSize) / texSize;
    vec2 fracUV = fract(UV * texSize);

    vec3 c00 = texture(tex, baseUV).rgb;
    vec3 c10 = texture(tex, baseUV + vec2(texelSize.x, 0.0)).rgb;
    vec3 c01 = texture(tex, baseUV + vec2(0.0, texelSize.y)).rgb;
    vec3 c11 = texture(tex, baseUV + texelSize).rgb;

    // interpolation
    vec3 col = mix(
        mix(c00, c10, fracUV.x),
        mix(c01, c11, fracUV.x),
        fracUV.y
    );

    return col;
}

void main() {
    // fetch compositor parameters
    vec2 distortionPos = vec2(Params[0], Params[1]);
    float distortionStrength = Params[2];
    float vignetteStrength = Params[3];

    // uv distortion goes first
    vec2 UV = texCoord;
    UV = distortion(UV, distortionPos, distortionStrength);

    vec3 col = filterLinear(tex, UV);

    // vignette
    float vignette = 1.0 - distance(texCoord, vec2(0.5)) * vignetteStrength;
    col *= vignette;

    fragColor = vec4(col, 1.0);
}
