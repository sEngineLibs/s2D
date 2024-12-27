#version 450

uniform sampler2D tex;
uniform vec2 resolution;
uniform vec3 distortionAttrib; // [x, y, strength]

in vec2 texCoord;
in vec4 color;
out vec4 fragColor;

vec2 distortion(vec2 coord, vec2 dp, float strength) {
    vec2 d = coord - dp;
    float r = length(d);
    vec2 dir = d / r;
    return dp + dir * pow(r, strength);
}

void main() {
    vec2 UV = distortion(texCoord, distortionAttrib.xy, distortionAttrib.z);
    fragColor = texture(tex, UV); // 8 = number of iterations
}