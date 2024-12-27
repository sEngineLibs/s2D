#version 450

uniform sampler2D tex;
uniform sampler2D positionMap;
uniform vec2 dofAttrib;

in vec2 texCoord;
in vec4 color;
out vec4 fragColor;

#define dofQuality 8.0
#define dofWeight (2.0 * dofQuality * dofQuality)

vec3 blur(sampler2D tex, float size, vec2 uv) {
    vec3 col = texture(tex, uv).rgb;
    for (float y = -1.0; y < 1.0; y += 1.0 / dofQuality) 
        for (float x = -1.0; x < 1.0; x += 1.0 / dofQuality) 
            col += texture(tex, uv + vec2(x, y) * size).rgb;
    return col / dofWeight;
}

void main() {
    float dist = abs(texture(positionMap, texCoord).z - dofAttrib.x);

    vec3 col = blur(tex, dist * dofAttrib.y, texCoord);
    fragColor = vec4(col, 1.0);
}
