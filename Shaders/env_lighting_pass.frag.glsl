#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D normalMap;
uniform sampler2D colorMap;
uniform sampler2D glowMap;
uniform sampler2D ormMap; // [occlusion, roughness, metalness]
uniform sampler2D envMap;

in vec2 fragCoord;
out vec4 fragColor;

const vec3 viewDir = vec3(0.0, 0.0, 1.0); // 2D

vec3 fresnelSchlick(float cosTheta, vec3 F0) {
    float factor = pow(1.0 - cosTheta, 5.0);
    return F0 + (1.0 - F0) * factor;
}

vec3 envLighting(vec3 normal, vec3 color, float roughness, float metalness) {
    vec3 V = normalize(viewDir);

    // radiance
    vec3 reflection = normalize(reflect(-V, normal));
    float mipLevel = roughness * 8.0;
    vec3 radiance = textureLod(envMap, reflection.xy * 0.5 + 0.5, mipLevel).rgb;

    // Fresnel
    vec3 F0 = mix(vec3(0.04), color, metalness);
    vec3 F = fresnelSchlick(max(dot(normal, V), 0.0), F0);

    vec3 specular = radiance * F;

    // irradiance
    vec3 diffuseIrradiance = textureLod(envMap, normal.xy * 0.5 + 0.5, 8.0).rgb;
    vec3 kD = (1.0 - F) * (1.0 - metalness);
    vec3 diffuse = kD * color * diffuseIrradiance;

    return diffuse + specular;
}

void main() {
    // fetch gbuffer textures
    vec3 normal = texture(normalMap, fragCoord).rgb;
    vec3 color = texture(colorMap, fragCoord).rgb;
    vec3 orm = texture(ormMap, fragCoord).rgb;
    vec3 glow = texture(glowMap, fragCoord).rgb;

    float occlusion = orm.r;
    float roughness = clamp(orm.g, 0.05, 1.0);
    float metalness = orm.b;

    // convert data
    normal = normalize(normal * 2.0 - 1.0);

    vec3 e = envLighting(normal, color, roughness, metalness);
    fragColor = vec4(glow + occlusion * e, 1.0);
}
