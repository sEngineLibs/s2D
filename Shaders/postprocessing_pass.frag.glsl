#version 450

uniform sampler2D textureMap;
uniform sampler2D positionMap;

uniform mat4 InvVP;
uniform vec3 cameraPos;

// 0 - dof distance
// 1 - dof size
// 2 - mist near
// 3 - mist far
// 4 - mist color R
// 5 - mist color G
// 6 - mist color B
// 7 - mist color A
// 8 - motion blur blend
uniform float Params[9];

in vec2 fragCoord;
out vec4 fragColor;

#define blurQuality 6
#define blurWeight (blurQuality * blurQuality * 2.0)
#define Pi2 6.28318530718

vec3 blur(sampler2D tex, vec2 uv, float size) {
    vec3 col = vec3(0.0);
    for (float y = -1.0; y <= 1.0; y += 1.0 / blurQuality) 
        for (float x = -1.0; x <= 1.0; x += 1.0 / blurQuality) 
            col += texture(tex, uv + vec2(x, y) * size).rgb;
    return col / blurWeight;
}

void main() {
    // fetch gbuffer textures
    vec3 position = texture(positionMap, fragCoord).rgb;

    // fetch post-processing parameters
    float dofDistance = Params[0];
    float dofSize = Params[1];
    vec2 mistScale = vec2(Params[2], Params[3]);
    vec4 mistColor = vec4(Params[4], Params[5], Params[6], Params[7]);

    // adjust position
    position = normalize(InvVP * vec4(position * 2.0 - 1.0, 1.0)).xyz;

    float cameraDist = 1.0 - abs(position.z - cameraPos.z);

    // dof
    float dofF = abs(cameraDist - dofDistance);
    vec3 color = blur(textureMap, fragCoord, dofF * dofSize);

    // mist
    float mist = mistScale.x + cameraDist * (mistScale.y - mistScale.x);
    color += mistColor.rgb * mistColor.a * mist;

    fragColor = vec4(color, Params[8]);
}
