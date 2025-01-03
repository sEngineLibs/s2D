#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform mat4 model;
uniform mat4 viewProjection;

uniform sampler2D colorMap;
uniform sampler2D normalMap;
uniform sampler2D ormMap;
uniform sampler2D glowMap;

// 1 - depth scale
uniform float Params[1];

in vec3 fragPos;
in vec2 fragUV;

layout(location = 0) out vec4 position;
layout(location = 1) out vec4 normal;
layout(location = 2) out vec4 color;
layout(location = 3) out vec4 orm;
layout(location = 4) out vec4 glow;

void main() {
    // fetch material parameters
    float depthScale = Params[0];

    vec3 s = vec3(viewProjection[0][2], viewProjection[1][2], viewProjection[2][2]);
    float scaleZ = sqrt(s.x * s.x + s.y * s.y + s.z * s.z);

    float rot = atan(model[1][0], model[0][0]);
    float rotSin = sin(rot);
    float rotCos = cos(rot);

    // fetch material textures
    color = texture(colorMap, fragUV);
    orm = texture(ormMap, fragUV);
    glow = texture(glowMap, fragUV);
    normal = texture(normalMap, fragUV);

    // convert data
    position = vec4(fragPos, 1.0);
    position.z += normal.z * depthScale / scaleZ;

    // tangent space -> world space
    vec2 n = normal.xy * 2.0 - 1.0;
    normal.x = rotCos * n.x + rotSin * n.y;
    normal.y = -rotSin * n.x + rotCos * n.y;
    normal.z = sqrt(max(0.5, 1.0 - normal.x * normal.x - normal.y * normal.y));
    normal = normal * 0.5 + 0.5;

    // color.a = step(0.5, color.a);
    // premultiply alpha
    normal.rgb *= color.a;
    normal.a = color.a;
    position.rgb *= color.a;
    position.a = color.a;
    orm.rgb *= color.a;
    orm.a = color.a;
    glow.rgb *= color.a;
    glow.a = color.a;
}
