#version 450

uniform sampler2D tex;
uniform vec2 resolution;
uniform sampler2D positionMap;

// 0 - dof distance
// 1 - dof size
// 2 - mist near
// 3 - mist far
// 4 - mist color R
// 5 - mist color G
// 6 - mist color B
// 7 - mist color A
uniform float Params[8];

in vec2 texCoord;
in vec4 color;
out vec4 fragColor;

#define gamma 10.2
#define dofSamples 4
#define Pi2 6.28318530718

vec3 blur(sampler2D tex, vec2 uv, float size, float ratio) {
    float W = 0.0;
    vec3 col = vec3(0.0);
    
    for (float y = -1.0; y <= 1.0; y += 1.0 / dofSamples) {
        for (float x = -1.0; x <= 1.0; x += 1.0 / dofSamples) {
            vec2 p = vec2(x, y);
            float w = smoothstep(1.0, 0.0, distance(p, vec2(0.0)));
            vec2 offset = p * size * vec2(1.0, ratio);
            vec3 s = pow(texture(tex, uv + offset).rgb, vec3(gamma));
            
            W += w;
            col += s * w;
        }
    }
    
    return pow(col / W, vec3(1.0 / gamma));
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
    float dist = abs(depth - dofDistance);
    float blurRadius = dist * dofSize;
    color = blur(tex, texCoord, blurRadius, resolution.x / resolution.y);

    // mist
    float mist = mistScale.x + depth * (mistScale.y - mistScale.x);
    color += mistColor.rgb * mistColor.a * mist;

    fragColor = vec4(color, 1.0);
}
