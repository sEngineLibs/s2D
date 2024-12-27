#version 450

in vec3 vertexPosition;
in vec4 vertexColor;
uniform mat4 projectionMatrix;
out vec4 fragmentColor;
out vec2 fragCoord;

void main() {
	gl_Position = projectionMatrix * vec4(vertexPosition, 1.0);
	fragmentColor = vertexColor;
    fragCoord = gl_Position.xy * 0.5 + 0.5;
}
