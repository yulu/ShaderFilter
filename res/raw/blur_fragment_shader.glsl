precision mediump float; 
uniform sampler2D u_Texture;
varying vec2 v_TexCoordinate; 

vec3 mosaic(vec2 position){
	vec2 p = floor(position)/8.;
	return texture2D(u_Texture, p).rgb;
}

vec2 sw(vec2 p) {return vec2( floor(p.x) , floor(p.y) );}
vec2 se(vec2 p) {return vec2( ceil(p.x) , floor(p.y) );}
vec2 nw(vec2 p) {return vec2( floor(p.x) , ceil(p.y) );}
vec2 ne(vec2 p) {return vec2( ceil(p.x) , ceil(p.y) );}

vec3 glass(vec2 p) {
	vec2 inter = smoothstep(0., 1., fract(p));
	vec3 s = mix(mosaic(sw(p)), mosaic(se(p)), inter.x);
	vec3 n = mix(mosaic(nw(p)), mosaic(ne(p)), inter.x);
	return mix(s, n, inter.y);
}


void main()
{
	vec3 color = glass(v_TexCoordinate*8.);
	gl_FragColor = vec4(color, 1.);
}