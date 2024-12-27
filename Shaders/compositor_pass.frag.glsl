#version 450

uniform sampler2D textureMap;
uniform sampler2D positionMap;
uniform vec2 resolution;
uniform vec3 dofAttrib;
uniform float fisheyePower;

in vec2 fragCoord;
out vec4 fragColor;

vec4 DOF(sampler2D t, vec2 UV, float f, int numI, int numJ) {
    vec4 c = texture(t, UV);
    float W = 1.0;

    for (int i = 1; i <= numI; ++i) {
        float r = f * i / numI;
        float w = exp(-(r * r) * 1.0 / 2.56679); // 2.56679 = (2 * sigma * sigma) / (sigma * sqrt(PI * 2))

        for (int j = 0; j < numJ; ++j) {
            float a = j * 6.28318530718 / numJ; // 6.28318530718 = PI * 2
            vec2 o = vec2(cos(a), sin(a)) * r;
            c += texture(t, UV + o) * w;
            W += w;
        }
    }
    
    return c / W;
}

vec2 fisheye(vec2 p, float power) {
	float prop = resolution.x / resolution.y;

	vec2 m = vec2(0.5, 0.5 / prop);
	vec2 d = p - m;
	float r = sqrt(dot(d, d));

	float bind = sqrt(dot(m, m));
	if (power <= 0.0)  {
        if (prop < 1.0) 
            bind = m.x; 
        else 
            bind = m.y;
    }

	if (power > 0.0) // fisheye
		return m + normalize(d) * tan(r * power) * bind / tan( bind * power);
	else if (power < 0.0) // anti-fisheye
		return m + normalize(d) * atan(r * -power * 10.0) * bind / atan(-power * bind * 10.0);
}

void main() {
    float dist = abs(texture(positionMap, fragCoord).z - dofAttrib.x) / dofAttrib.y;
    vec2 UV = fisheye(fragCoord, fisheyePower);

    fragColor = DOF(textureMap, UV, dist, 8, int(dofAttrib[2])); // 8 = number of iterations
}
