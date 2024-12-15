#version 450

in float factor;
out vec4 fragColor;

void main() {
    fragColor = vec4(vec3(factor), 1.0);
}
