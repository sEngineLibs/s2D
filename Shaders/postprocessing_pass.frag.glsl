#version 450

uniform sampler2D tex;
uniform sampler2D positionMap;
uniform vec2 dofAttrib;

in vec2 texCoord;
in vec4 color;
out vec4 fragColor;

#define dofSamples 12
#define pi 3.14159265359

vec3 blur(sampler2D tex, vec2 uv, float radius) {
    vec3 col = vec3(0.0);
    float totalWeight = 0.0;

    for (int i = 0; i < dofSamples; ++i) {
        float angle = float(i) / float(dofSamples) * 2.0 * pi;
        vec2 offset = vec2(cos(angle), sin(angle)) * radius;

        float weight = exp(-dot(offset, offset) / (2.0 * radius * radius));
        col += texture(tex, uv + offset).rgb * weight;
        totalWeight += weight;
    }
    return col / totalWeight;
}

void main() {
    float depth = texture(positionMap, texCoord).z;
    float dist = abs(depth - dofAttrib.x);

    float blurRadius = dist * dofAttrib.y;
    vec3 col = blur(tex, texCoord, blurRadius);

    fragColor = vec4(col, 1.0);
}
