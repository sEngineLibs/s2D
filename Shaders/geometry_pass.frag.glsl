#version 450

uniform sampler2D normalMap;
uniform sampler2D colorMap;
uniform sampler2D ormMap;
uniform sampler2D emissionMap;
uniform int blendMode;
uniform float depthScale;

in vec3 fragPos;
in vec2 fragUV;

layout(location = 0) out vec4 position;
layout(location = 1) out vec4 normal;
layout(location = 2) out vec4 color;
layout(location = 3) out vec4 orm;
layout(location = 4) out vec4 emission;

void main() {
    normal = texture(normalMap, fragUV);
    position = vec4(fragPos, 1.0);
    position.z += (normal.z - 0.5) * depthScale;
    color = texture(colorMap, fragUV);
    orm = texture(ormMap, fragUV);
    emission = texture(emissionMap, fragUV);

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
    emission.a = mask;
}