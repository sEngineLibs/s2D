#version 450

uniform mat4 MVP;

in vec3 vertPos;
in vec2 vertUV;
out vec2 fragCoord;

void main() {
	gl_Position = MVP * vec4(vertPos, 1.0);
	fragCoord = vertUV;
}