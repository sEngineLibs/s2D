#version 450

uniform sampler2D normalMap;
uniform sampler2D diffuseMap;
uniform sampler2D emissionMap;

uniform vec3 lightPos;
uniform vec3 lightColor;
uniform float lightPower;

in vec2 fragCoord;
out vec4 fragColor;

const vec3 viewDir = vec3(0.0, 0.0, 1.0); // 2D

const float toonSteps = 3.0;
const vec3 edgeColor = vec3(0.0, 0.0, 0.0);
const float edgeThreshold = 0.2;

void main() {
    vec3 diffuse = texture(diffuseMap, fragCoord).rgb;
    vec3 emission = texture(emissionMap, fragCoord).rgb;
    vec3 normal = normalize(texture(normalMap, fragCoord).rgb * 2.0 - 1.0);

    vec3 l = vec3(lightPos.xy - fragCoord, lightPos.z);
    float distSq = dot(l, l);
    vec3 dir = normalize(l);

    float lightFactor = max(dot(normal, dir), 0.0);
    lightFactor = floor(lightFactor * toonSteps) / toonSteps;

    vec3 lighting = diffuse * lightColor * lightFactor * lightPower;

    float edgeFactor = 1.0 - max(dot(normal, viewDir), 0.0);
    vec3 edge = step(edgeThreshold, edgeFactor) * edgeColor;

    fragColor = vec4(emission + lighting + edge, 1.0);
}
