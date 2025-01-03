#version 450

#ifdef GL_ES
precision mediump float;
#endif

#define dofQuality 6
#define dofWeight (dofQuality * dofQuality * 2.0)

uniform sampler2D textureMap;
uniform vec2 resolution;
uniform sampler2D positionMap;
uniform mat4 invVP;
uniform vec3 cameraPos;
uniform float focusDistance;
uniform float blurSize;

in vec2 fragCoord;
out vec4 fragColor;

vec3 dof(sampler2D tex, vec2 uv, float size) {
    vec3 col = vec3(0.0);
    for (float y = -1.0; y <= 1.0; y += 1.0 / dofQuality)
        for (float x = -1.0; x <= 1.0; x += 1.0 / dofQuality)
            col += texture(tex, uv + vec2(x, y) * size).rgb;
    return col / dofWeight;
}

void main() {
    vec3 position = texture(positionMap, fragCoord).rgb;
    vec4 worldPos = invVP * vec4(position * 2.0 - 1.0, 1.0);
    position = worldPos.xyz / worldPos.w;
    float cameraDist = abs(-position.z - cameraPos.z - focusDistance);

    // dof
    vec3 color = dof(textureMap, fragCoord, cameraDist * blurSize);

    fragColor = vec4(color, 1.0);
}
