#version 450

#ifdef GL_ES
precision mediump float;
#endif

#define MAX_LIGHTS 16
#define LIGHT_STRUCT_SIZE 8

struct Light {
    vec3 position;
    vec3 color;
    float power;
    float radius;
};

uniform mat4 invVP;
uniform float lightsData[1 + MAX_LIGHTS * LIGHT_STRUCT_SIZE];
uniform sampler2D positionMap;
uniform sampler2D normalMap;
uniform sampler2D colorMap;
uniform sampler2D ormMap; // [occlusion, roughness, metalness]

in vec2 fragCoord;
out vec4 fragColor;

const vec3 viewDir = vec3(0.0, 0.0, 1.0); // 2D
const float PI = 3.14159;

Light getLight(int index) {
    int i = 1 + index * LIGHT_STRUCT_SIZE;

    Light light;
    light.position = vec3(lightsData[i + 0],
            lightsData[i + 1],
            lightsData[i + 2]);
    light.color = vec3(lightsData[i + 3],
            lightsData[i + 4],
            lightsData[i + 5]);
    light.power = lightsData[i + 6];
    light.radius = lightsData[i + 7];

    return light;
}

vec3 fresnelSchlick(float cosTheta, vec3 F0) {
    float factor = pow(1.0 - cosTheta, 5.0);
    return F0 + (1.0 - F0) * factor;
}

float distributionGGX(vec3 N, vec3 H, float roughnessE2) {
    float a = roughnessE2;
    float a2 = a * a;
    float NdotH = max(dot(N, H), 0.0);
    float denom = NdotH * (a2 - 1.0) + 1.0;
    return a2 / (PI * (denom * denom + 1e-4));
}

float geometrySchlickGGX(float NdotX, float k) {
    return NdotX / (NdotX * (1.0 - k) + k);
}

float geometrySmith(vec3 N, vec3 V, vec3 L, float roughnessE2) {
    float k = roughnessE2 * 0.5;
    return geometrySchlickGGX(max(dot(N, V), 0.0), k) *
        geometrySchlickGGX(max(dot(N, L), 0.0), k);
}

vec3 lighting(Light light, vec3 position, vec3 normal, vec3 color, float roughness, float metalness) {
    vec3 l = light.position - position;
    float distSq = dot(l, l);
    float dist = sqrt(distSq);
    vec3 dir = l / dist;

    float lightAttenuation = light.power / (4.0 * PI * distSq + light.radius * light.radius);

    vec3 V = normalize(viewDir);
    vec3 H = normalize(dir + V);

    // Fresnel
    vec3 F0 = mix(vec3(0.04), color, metalness);
    vec3 F = fresnelSchlick(dot(H, V), F0);

    // BRDF components
    float roughnessE2 = roughness * roughness;
    float NDF = distributionGGX(normal, H, roughnessE2);
    float G = geometrySmith(normal, V, dir, roughnessE2);
    vec3 specularLight = (NDF * G * F) / 4.0 * dot(normal, V) * dot(normal, dir);

    // diffuse
    vec3 kD = (1.0 - F) * (1.0 - metalness);
    vec3 diffuseLight = kD * color * max(dot(normal, dir), 0.0) / PI;

    return (diffuseLight + specularLight) * light.color * lightAttenuation;
}

void main() {
    // fetch gbuffer textures
    vec3 position = texture(positionMap, fragCoord).rgb;
    vec3 normal = texture(normalMap, fragCoord).rgb;
    vec3 color = texture(colorMap, fragCoord).rgb;
    vec3 orm = texture(ormMap, fragCoord).rgb;

    float occlusion = orm.r;
    float roughness = clamp(orm.g, 0.05, 1.0);
    float metalness = orm.b;

    // convert data
    vec4 worldPos = invVP * vec4(position * 2.0 - 1.0, 1.0);
    position = worldPos.xyz / worldPos.w;
    normal = normalize(normal * 2.0 - 1.0);

    // lighting
    vec3 c = vec3(0.0);
    int lightCount = min(int(lightsData[0]), MAX_LIGHTS);
    for (int i = 0; i < lightCount; ++i)
        c += lighting(getLight(i), position, normal, color, roughness, metalness);

    fragColor = vec4(occlusion * c, 1.0);
}
