#version 450

in vec3 vertPos;
in vec2 vertUV;
out vec2 fragCoord;

void main() {
	gl_Position = vec4(vertPos, 1.0);
	fragCoord = vertUV;
}