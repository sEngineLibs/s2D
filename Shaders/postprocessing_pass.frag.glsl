#version 450

uniform sampler2D textureMap;
uniform sampler2D positionMap;
uniform vec2 dofAttrib;

in vec2 fragCoord;
out vec4 fragColor;

#define dofQuality 6.0
#define dofWeight (2.0 * dofQuality * dofQuality)

vec3 blur(sampler2D tex, float size, vec2 uv) {
    vec3 col = texture(tex, uv).rgb;
    for (float y = -1.0 / dofQuality; y < 1.0; y += 1.0 / dofQuality) 
        for (float x = -1.0 / dofQuality; x < 1.0; x += 1.0 / dofQuality) 
            col += texture(tex, uv + vec2(x, y) * size).rgb;
    return col / dofWeight;
}

void main() {
    float dist = abs(texture(positionMap, fragCoord).z - dofAttrib.x);

    vec3 col = blur(textureMap, dist * dofAttrib.y, fragCoord);
    fragColor = vec4(col, 1.0);
}
