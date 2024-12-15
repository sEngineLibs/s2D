#version 450

in vec3 vertData;
out float factor;

void main() {
	gl_Position = vec4(vertData.xy, 0.0, 1.0);
	factor = vertData.z;
}