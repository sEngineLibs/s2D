#version 450

uniform sampler2D textureMap;
uniform sampler2D positionMap;
uniform vec3 dofAttrib;

in vec2 fragCoord;
out vec4 fragColor;

const float Pi2 = 6.28318530718; // Pi * 2
const float blurQuality = 32.0;

void main() {
    vec4 color = texture(textureMap, fragCoord);
    float dist = abs(texture(positionMap, fragCoord).z - dofAttrib[0]) * 1 / dofAttrib[1];

    for (float d = 0.0; d < Pi2; d += Pi2 / dofAttrib[2]) 
        for (float i = 0.0; i <= 1.0; i += 1.0 / blurQuality) 
            color += texture(textureMap, fragCoord + dist * vec2(cos(d), sin(d)) * i);

    color /= blurQuality * dofAttrib[2];
    fragColor = color;
}