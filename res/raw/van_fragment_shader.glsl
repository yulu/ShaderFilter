precision mediump float; 
uniform sampler2D u_Texture;
varying vec2 v_TexCoordinate;

vec2 circular(vec2 position){
	vec2 p = position;
	p.x = p.x + sin(p.y*80.)*0.003;
	p.y = p.y + sin(p.x*80.)*0.003;

	return p;
}

void main(){
	vec3 color;	
	vec2 p = circular(v_TexCoordinate);
	
	//find the edge and draw
	vec3 border;	
	float dx = 1./720.;
	float dy = 1./720.;
	vec3 sample0 = texture2D(u_Texture, vec2(p.x - dx, p.y + dy)).rgb;
	vec3 sample1 = texture2D(u_Texture, vec2(p.x - dx, p.y)).rgb;
	vec3 sample2 = texture2D(u_Texture, vec2(p.x - dx, p.y - dy)).rgb;
	vec3 sample3 = texture2D(u_Texture, vec2(p.x, p.y + dy)).rgb;
	vec3 sample4 = texture2D(u_Texture, vec2(p.x, p.y)).rgb;
	vec3 sample5 = texture2D(u_Texture, vec2(p.x, p.y - dy)).rgb;
	vec3 sample6 = texture2D(u_Texture, vec2(p.x + dx, p.y + dy)).rgb;
	vec3 sample7 = texture2D(u_Texture, vec2(p.x + dx, p.y)).rgb;
	vec3 sample8 = texture2D(u_Texture, vec2(p.x + dx, p.y - dy)).rgb;

	//color = (sample0 + sample1 + sample2 + sample3 + sample4 + sample5 + sample6 + sample7 + sample8) / 9.0;

	vec3 horizEdge = sample2 + sample5 + sample8 - (sample0 + sample3 + sample6);
	vec3 vertEdge = sample0 + sample1 + sample2 - (sample6 + sample7 + sample8);

	border = sqrt((horizEdge * horizEdge) + (vertEdge * vertEdge));

	if (border.r > 0.5 || border.g > 0.5 || border.b > 0.5){
		color = vec3(0.0) ;
	}else{
		color = texture2D(u_Texture, p).rgb;
	}
	
	color = floor(color * 10.0) * 0.1;
	
	gl_FragColor = vec4(color, 1.0);
}	