precision mediump float; 
uniform sampler2D u_Texture;
varying vec2 v_TexCoordinate; 

const vec3 W = vec3(0.2125, 0.7154, 0.0721);

float divation(float a, float b){
	float f = floor(a/b);
	float c = ceil(a/b);
	return min((a - b*f), (c*b - a));
}

float locate(vec2 pos, float dx, float dy, float radius, float interval){
	float x = pos.x/dx;
	float y = pos.y/dy;
	
	float mod_x = divation(x, interval);
	float mod_y = divation(y, interval);
	
	float mod_r = sqrt(mod_x*mod_x + mod_y*mod_y);
	
	if(mod_r < radius)
		return 0.0;
	else 
		return mod_r;
}

vec3 overlay(vec3 overlayComponent, vec3 underlayComponent, float alpha) {
	vec3 underlay = underlayComponent * alpha;
	return underlay * (underlay + (2.0 * overlayComponent * (1.0 - underlay)));
}

vec3 brightness(vec3 color, float brightness) {
	float scaled = brightness / 2.0;
	if (scaled < 0.0) {
		return color * (1.0 + scaled);
	} else {
		return color + ((1.0 - color) * scaled);
	}
}

vec3 contrast(vec3 color, float contrast) {
	const float PI = 3.14159265;
	return min(vec3(1.0), ((color - 0.5) * (tan((contrast + 1.0) * PI / 4.0) ) + 0.5));
}

vec3 saturation(vec3 color, float sat) {
	float luminance = dot(color, W);
	vec3 gray = vec3(luminance, luminance, luminance);
	
	vec3 satColor = mix(gray, color, sat+1.0);
	return satColor;
}

void main()
{
	vec3 color;	
	
	float dx = 1./720.;
	float dy = 1./720.;
	
	color = texture2D(u_Texture, v_TexCoordinate).rgb;
	float gray = dot(color, W);
	
	//if bright, set to white
	if(gray >= 0.9)
		color = vec3(1.);
		
	//middle gray, overlay with dot!
	if(gray >=0.4 && gray < 0.6){
		if(locate(v_TexCoordinate, dx, dy, 4., 16.) == 0.0)
			color = overlay(vec3(0.,0.,0.8), color, 1.0);
	}
	
	//if dark, set to black
	if(gray <= 0.1)
		color = vec3(0.);
		
	color = brightness(color, 0.1);
	color = contrast(color, 0.2);
	color = saturation(color, 0.3);
		
	gl_FragColor = vec4(color, 1.0);
}