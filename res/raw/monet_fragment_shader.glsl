precision mediump float; 
uniform sampler2D u_Texture;
varying vec2 v_TexCoordinate; 

const vec3 W = vec3(0.2125, 0.7154, 0.0721);

void main() {

	float dx = 1./720.;
	float dy = 1./720.;

	float tempLumi;
	float minLumi = -1.0;
	float Quantize = 10.;
	vec3 color;
	
	//Go through all the the random selected pixels in a 5x5 patch to find the hightest
	
	vec3 sample0 = texture2D(u_Texture, vec2(v_TexCoordinate.x - dx, v_TexCoordinate.y + dy)).rgb;
	tempLumi = dot(sample0, W);
	if(tempLumi > minLumi){
		minLumi = tempLumi;
		color = sample0;
	}
	
	vec3 sample1 = texture2D(u_Texture, vec2(v_TexCoordinate.x - dx, v_TexCoordinate.y)).rgb;
	tempLumi = dot(sample1, W);
	if(tempLumi > minLumi){
		minLumi = tempLumi;
		color = sample1;
	}
		
	vec3 sample2 = texture2D(u_Texture, vec2(v_TexCoordinate.x - dx, v_TexCoordinate.y - dy)).rgb;
	tempLumi = dot(sample2, W);
	if(tempLumi > minLumi){
		minLumi = tempLumi;
		color = sample2;
	}
	
	vec3 sample4 = texture2D(u_Texture, vec2(v_TexCoordinate.x, v_TexCoordinate.y)).rgb;
	tempLumi = dot(sample4, W);
	if(tempLumi > minLumi){
		minLumi = tempLumi;
		color = sample4;
	}
	
	vec3 sample6 = texture2D(u_Texture, vec2(v_TexCoordinate.x + dx, v_TexCoordinate.y + dy)).rgb;
	tempLumi = dot(sample6, W);
	if(tempLumi > minLumi){
		minLumi = tempLumi;
		color = sample6;
	}
	
	vec3 sample7 = texture2D(u_Texture, vec2(v_TexCoordinate.x + dx, v_TexCoordinate.y)).rgb;
	tempLumi = dot(sample7, W);
	if(tempLumi > minLumi){
		minLumi = tempLumi;
		color = sample7;
	}
	
	vec3 sample9 = texture2D(u_Texture, vec2(v_TexCoordinate.x + 2.*dx, v_TexCoordinate.y)).rgb;
	tempLumi = dot(sample9, W);
	if(tempLumi > minLumi){
		minLumi = tempLumi;
		color = sample9;
	}
	
	vec3 sample10 = texture2D(u_Texture, vec2(v_TexCoordinate.x - 2.* dx, v_TexCoordinate.y)).rgb;
	tempLumi = dot(sample10, W);
	if(tempLumi > minLumi){
		minLumi = tempLumi;
		color = sample10;
	}
	
	vec3 sample11 = texture2D(u_Texture, vec2(v_TexCoordinate.x, v_TexCoordinate.y - 2.* dy)).rgb;
	tempLumi = dot(sample11, W);
	if(tempLumi > minLumi){
		minLumi = tempLumi;
		color = sample11;
	}
	
	vec3 sample12 = texture2D(u_Texture, vec2(v_TexCoordinate.x, v_TexCoordinate.y + 2.* dy)).rgb;
	tempLumi = dot(sample12, W);
	if(tempLumi > minLumi){
		minLumi = tempLumi;
		color = sample12;
	}
	
	vec3 sample13 = texture2D(u_Texture, vec2(v_TexCoordinate.x + 2.*dx, v_TexCoordinate.y + 2.* dy)).rgb;
	tempLumi = dot(sample13, W);
	if(tempLumi > minLumi){
		minLumi = tempLumi;
		color = sample13;
	}
	
	vec3 sample14 = texture2D(u_Texture, vec2(v_TexCoordinate.x - dx, v_TexCoordinate.y + 2.* dy)).rgb;
	tempLumi = dot(sample14, W);
	if(tempLumi > minLumi){
		minLumi = tempLumi;
		color = sample14;
	}
	
	vec3 sample15 = texture2D(u_Texture, vec2(v_TexCoordinate.x + dx, v_TexCoordinate.y + 2. *dy)).rgb;
	tempLumi = dot(sample15, W);
	if(tempLumi > minLumi){
		minLumi = tempLumi;
		color = sample15;
	}
	
	vec3 sample16 = texture2D(u_Texture, vec2(v_TexCoordinate.x- 2.*dx, v_TexCoordinate.y + dy)).rgb;
	tempLumi = dot(sample16, W);
	if(tempLumi > minLumi){
		minLumi = tempLumi;
		color = sample16;
	}
	
	color = floor(color * 10.0) * 0.1;
	
	gl_FragColor = vec4(color, 1.0);
}