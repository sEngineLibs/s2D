#version 450

uniform vec4 rot;
uniform sampler2D normalMap;
uniform sampler2D colorMap;
uniform sampler2D ormMap;
uniform sampler2D glowMap;

// blendMode
// depthScale
// glowStrength
uniform float matAttrib[3];

in vec3 fragPos;
in vec2 fragUV;

layout(location = 0) out vec4 position;
layout(location = 1) out vec4 normal;
layout(location = 2) out vec4 color;
layout(location = 3) out vec4 orm;
layout(location = 4) out vec4 glow;

void main() {
    int blendMode = int(matAttrib[0]);
    float depthScale = matAttrib[1];
    float glowStrength = matAttrib[2];

    vec3 n = texture(normalMap, fragUV).rgb;
    n.xy = n.xy * 2.0 - 1.0;
    position = vec4(fragPos, 1.0);
    position.z += (n.z) * depthScale;
    color = texture(colorMap, fragUV);
    orm = texture(ormMap, fragUV);
    glow = texture(glowMap, fragUV) * glowStrength;

    // tangent space -> world space
    normal.x = rot.x * n.x + rot.y * n.y;
    normal.y = rot.z * n.x + rot.w * n.y;
    normal.z = 1.0;
    normal = normalize(normal);

    float mask = 1.0;
    // opaque
    if (blendMode == 0) {
        color.a = mask;
    // alpha clip
    } else if (blendMode == 1) { 
        mask = smoothstep(0.49, 0.51, color.a);
        color.a = mask;
    // alpha blend
    } else { 
        mask = smoothstep(0.01, 1.0, color.a);
    }

    normal.a = mask;
    position.a = mask;
    orm.a = mask;
    glow.a = mask;
}
