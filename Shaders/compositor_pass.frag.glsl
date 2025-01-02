#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D textureMap;
uniform vec2 resolution;

// 0 - distortion x
// 1 - distortion y
// 2 - distortion strength
// 3 - vignette strength
// 4 - convolution filter 00
// 5 - convolution filter 01
// 6 - convolution filter 02
// 7 - convolution filter 10
// 8 - convolution filter 11
// 9 - convolution filter 12
// 10 - convolution filter 20
// 11 - convolution filter 21
// 12 - convolution filter 22
// 13 - posterize gamma
// 14 - posterize n.o. steps
uniform float Params[15];

in vec2 fragCoord;
out vec4 fragColor;

vec2 fisheyeUV(vec2 coord, vec2 position, float strength, float ratio) {
    if (strength == 0.0)
        return coord;

    vec2 d = coord - position;
    float len = length(d);

    float bind;
    if (strength > 0.0)
        bind = length(position);
    else if (ratio < 1.0)
        bind = position.x;
    else
        bind = position.y;

    float scale;
    if (strength > 0.0)
        scale = tan(len * strength) / tan(strength * bind);
    else
        scale = atan(len * -strength) / atan(-strength * bind);

    return position + normalize(d) * scale * bind;
}

vec3 convolve3x3(sampler2D tex, vec2 texelSize, vec2 coord, mat3 mat) {
    vec3 col = vec3(0.0);
    vec2 offset;
    for (int i = 0; i < 3; i++) {
        offset.x = texelSize.x * (i - 1);
        for (int j = 0; j < 3; j++) {
            offset.y = texelSize.y * (j - 1);
            col += texture(tex, coord + offset).rgb * mat[i][j];
        }
    }
    return col;
}

vec3 posterize(vec3 col, float gamma, float steps) {
    col = pow(col, vec3(gamma));
    col = floor(col * steps) / steps;
    col = pow(col, vec3(1.0 / gamma));
    return col;
}

float vignette(vec2 coord, float strength, vec2 resolution) {
    vec2 center = resolution * 0.5;
    float normalizedDist = distance(coord, center) / distance(vec2(0.0), center);
    float vignetteValue = 1.0 - pow(normalizedDist, strength);
    return clamp(vignetteValue, 0.0, 1.0);
}

void main() {
    float ratio = resolution.x / resolution.y;

    // fetch compositor parameters
    vec2 distortionPos = vec2(Params[0], Params[1]);
    float distortion = Params[2];
    float vignetteStrength = Params[3];
    mat3 convFilter = mat3(
            Params[4], Params[5], Params[6],
            Params[7], Params[8], Params[9],
            Params[10], Params[11], Params[12]
        );
    float posterizeGamma = Params[13];
    float posterizeSteps = Params[14];

    // uv distortion goes first
    vec2 UV = fragCoord;
    UV = fisheyeUV(UV, distortionPos, distortion, ratio);

    vec3 col = convolve3x3(textureMap, vec2(1.0) / resolution, UV, convFilter);
    col = posterize(col, posterizeGamma, posterizeSteps);
    
    // vignette
    // col *= vignette(fragCoord, vignetteStrength, resolution);

    fragColor = vec4(col, 1.0);
}
