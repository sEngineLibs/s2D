#version 450

uniform sampler2D tex;
uniform sampler2D positionMap;

// 0 - dof distance
// 1 - dof size
// 2 - mist scale near
// 3 - mist scale far
// 4 - mist color R
// 5 - mist color G
// 6 - mist color B
// 7 - mist color A
uniform float Params[8];

in vec2 texCoord;
in vec4 color;
out vec4 fragColor;

#define dofSamples 12
#define Pi2 6.28318530718

vec3 blur(sampler2D tex, vec2 uv, float radius) {
    vec3 col = vec3(0.0);
    float W = 0.0;

    for (float i = 0.0; i <= 1.0; i += 1.0 / dofSamples) {
        float a = i * Pi2;
        vec2 offset = vec2(cos(a), sin(a)) * radius;

        float w = exp(-dot(offset, offset) / (2.0 * radius * radius));
        col += texture(tex, uv + offset).rgb * w;
        W += w;
    }
    return col / W;
}

void main() {
    // fetch post-processing parameters
    float dofDistance = Params[0];
    float dofSize = Params[1];
    vec2 mistScale = vec2(Params[2], Params[3]);
    vec4 mistColor = vec4(Params[4], Params[5], Params[6], Params[7]);

    float depth = 1.0 - texture(positionMap, texCoord).z;
    vec3 color = texture(tex, texCoord).rgb;

    // dof
    // float dist = abs(depth - dofDistance);
    // float blurRadius = dist * dofSize;
    // color = blur(tex, texCoord, blurRadius);

    // mist
    float mistFactor = mistScale.x + depth * (mistScale.y - mistScale.x) * mistColor.a;
    color += mistColor.rgb * mistFactor;

    fragColor = vec4(color, 1.0);
}
