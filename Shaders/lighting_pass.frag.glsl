#version 450

uniform sampler2D positionMap;
uniform sampler2D normalMap;
uniform sampler2D colorMap;
uniform sampler2D glowMap;
uniform sampler2D ormMap; // [occlusion, roughness, metalness]

uniform vec3 stageScale; // stage scale

uniform vec3 lightPos;
uniform vec3 lightColor;
uniform vec2 lightAttrib; // [intensity, radius]

in vec2 fragCoord;
in vec4 fragmentColor;
out vec4 fragColor;

const vec3 viewDir = vec3(0.0, 0.0, 1.0); // 2D
const float PI = 3.14159;

vec3 fresnelSchlick(float cosTheta, vec3 F0) {
    float factor = pow(1.0 - cosTheta, 5.0);
    return F0 + (1.0 - F0) * factor;
}

float distributionGGX(vec3 N, vec3 H, float roughness) {
    float a = roughness * roughness;
    float a2 = a * a;
    float NdotH = max(dot(N, H), 0.0);
    float denom = NdotH * (a2 - 1.0) + 1.0;
    return a2 / (PI * (denom * denom + 1e-4));
}

float geometrySchlickGGX(float NdotX, float k) {
    return NdotX / (NdotX * (1.0 - k) + k);
}

float geometrySmith(vec3 N, vec3 V, vec3 L, float roughness) {
    float k = roughness * roughness * 0.5;
    return geometrySchlickGGX(max(dot(N, V), 0.0), k) *
           geometrySchlickGGX(max(dot(N, L), 0.0), k);
}

void main() {
    // fetch gbuffer textures
    vec3 position = texture(positionMap, fragCoord).rgb;
    vec3 normal = texture(normalMap, fragCoord).rgb;
    vec3 color = texture(colorMap, fragCoord).rgb;
    vec3 orm = texture(ormMap, fragCoord).rgb;
    vec3 glow = texture(glowMap, fragCoord).rgb;

    float occlusion = orm.r;
    float roughness = orm.g;
    float metalness = orm.b;
    
    // adjust position
    position = (position * 2.0 - 1.0) / stageScale;

    vec3 l = lightPos - position;
    float distSq = dot(l, l);
    float dist = sqrt(distSq);
    vec3 dir = l / dist;

    float lightAttenuation = lightAttrib.x / (4.0 * PI * distSq + lightAttrib.y * lightAttrib.y);

    vec3 V = normalize(viewDir);
    vec3 H = normalize(dir + V);

    // Fresnel
    vec3 F0 = mix(vec3(0.04), color, metalness);
    vec3 F = fresnelSchlick(max(dot(H, V), 0.0), F0);

    // BRDF components
    float NDF = distributionGGX(normal, H, roughness);
    float G = geometrySmith(normal, V, dir, roughness);
    vec3 specularLight = NDF * G * F / max(4.0 * max(dot(normal, V), 0.0) * max(dot(normal, dir), 0.0), 1e-4);

    // diffuse
    vec3 kD = (1.0 - F) * (1.0 - metalness);
    vec3 diffuseLight = kD * color * max(dot(normal, dir), 0.0) / PI;
    
    fragColor = vec4(clamp(glow + occlusion * (diffuseLight + specularLight) * lightColor * lightAttenuation, 0.0, 1.0), 1.0);
}