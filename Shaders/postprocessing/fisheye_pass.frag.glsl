#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D textureMap;
uniform vec2 resolution;
uniform vec2 fisheyePosition;
uniform float fisheyeStrength;

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

void main() {
    float ratio = resolution.x / resolution.y;
    vec2 uv = fisheyeUV(fragCoord, fisheyePosition, fisheyeStrength, ratio);
    vec3 col = texture(textureMap, uv).rgb;
    fragColor = vec4(col, 1.0);
}
