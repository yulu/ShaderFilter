##Color and Art Effect in OpenGL Shaders
By [LittleCheeseCake](http://littlecheesecake.me)

It has been a year! A year ago I put up some posts on image processing using Shaders just for my own record. I have never expected that this to be rewarded. Now the work is integrated in my very own [app](http://littlecheesecake.me/apps/moodcamera), and included in a published [book](http://www.amazon.com/Android-Programming-Pushing-Erik-Hellman/dp/1118717376/ref=sr_1_1?ie=UTF8&qid=1394721713&sr=8-1&keywords=push+the+limit+android). It is my privilege to receive by emails the feedbacks, queries and thanks notes from people around the world about what I have shared. I was not excelled at programming, neither at drawing or design, but I never stop learning. More important thing is that I start to get the meaning of: 
>__CONNECTING THE DOTS__

Being busy with study, I could barely spare time working on this topic. But ideas and inspirations always jumped out sometime that I could stop but to code. Whenever I came across a nice picture, a smart algorithm or anything that reminds me the fantasy of the world we viewed, I would noted down and later explored on it. Thanks to the [Pixel Shader](http://pixelshaders.com) by Toby Schachman, I could instantly experiment on my ideas (also a lot of inspirations are from this interactive book). I gathered all the ideas of color and art effects and deliver a new [camera app](http://littlecheesecake.me) that allows us to explore the combination of filter effects on real-time. I also put the source code of some filter effects discussed here into this simple demo app to share.

------

###**1. The Tricks of Colors**

Colors can perform magic tricks I believe. The tone of a picture sometimes touches us more than the subjects do. I explored the idea of adjust the B/S/C of an image and blend color map on an image previously[1]. With the same blending process, here are some more interesting color gradient maps I could share.

####**1.1 Color Gradient on the Fly**

Previously I bind a color gradient map or pattern as a texture to an opengl target to perform the blending. Later I realized that the shader itself can produce color gradient map[2] (or patterns[3]) by playing around with the positions of the texels.

* __Gradient Functions__

It is a simple linear equation to represent gradient distributed over positions. The horizontal linear gradient is: 

```c
vec4 LinearGradientH(vec4 start, vec4 end)
{
    vec4 color;
    
    color = position.x * (end - start) + start;
    
    return color;
}
```

The radius linear gradient with a specified center point is:

```c
vec4 RadiusGradient(vec4 center, vec4 corner, vec2 center_point)
{
    vec4 color;
    vec2 p = position - center_point;
    float radius = length(p);

    color = radius * (corner - center) + center;
    
    return color;
}
```

* __Nice Combination by Accident__

More appealing effect is to randomly generate a warm color gradient map like this:

```c
vec3 RandomGradientWarm() {

    vec3 color;

    vec3 purple = vec3(180./255., 151./255., 202./255.);
    vec3 pink = vec3(213./255., 66./255., 108./255.);

    color.r = position.y * (purple.r - pink.r) + pink.r;
    color.g = position.y * (purple.g - pink.g) + pink.g;
    color.b = position.x * (purple.b - pink.b) + pink.b;
 
    return color;
}
```

![warm gradien](http://media.virbcdn.com/files/51/687d2174662035dd-warm_gradient.png "warm gradient")

Or a cool color gradient map like this:


```c
vec3 RandomGradientCool() {

    vec3 color;

    vec3 purple = vec3(180./255., 151./255., 202./255.);
    vec3 mint = vec3(28./255., 169./255., 178./255.);

    color.r = position.y * (purple.r - mint.r) + mint.r;
    color.g = position.x * (purple.g - mint.g) + mint.g;
    color.b = position.x * (purple.b - mint.b) + mint.b;
 
    return color;
}
```

![cool gradient](http://media.virbcdn.com/files/32/3d0cf497e5f38d6c-cool_gradient.png "cool gradient")

####**1.2 Blend Functions One More Time**

With these beautiful colors, I can blend them on an image and get the effect I want! Review the three blend mode[4] that is being used mostly.

* __Screen__

With Screen blend mode the values of the pixels in the two layers are inverted, multiplied, and then inverted again. This yields the opposite effect to multiply. The result is a brighter picture.Here introduce an alpha value to control the level of strength the screen blending is performed.

$$
f(a,b)=1-(1-a*\alpha)(1-b)
$$

```c
vec3 ScreenBlend(vec3 maskPixelComponent, float alpha, vec3 imagePixelComponent) {
	return 1.0 - (1.0 - (maskPixelComponent * alpha)) * (1.0 - imagePixelComponent);
}
```


* __Multiply__

Multiply blend mode multiplies the numbers for each pixel of the top layer with the corresponding pixel for the bottom layer. The result is a darker picture.

$$
f(a,b)= a*\alpha b
$$

```c
vec3 MultiplyBlend(vec3 overlayComponent, float alpha, vec3 underlayComponent) {
	return underlayComponent * overlayComponent * alpha;
}
```

* __Overlay__

Overlay combines Multiply and Screen blend modes. The parts of the top layer where base layer is light become lighter, the parts where the base layer is dark become darker. An overlay with the same picture looks like an S-curve.

$$
f(a,b)=\left\{ 
  \begin{array}{l l}
    2ab & \quad \text{if $b < 0.5$}\\
    1-2(1-a)(1-b) & \quad \text{otherwise}
  \end{array} \right.
$$

```c
vec3 OvelayBlender(vec3 Color, vec3 filter){
	vec3 filter_result;
	float luminance = dot(filter, W);
	
	if(luminance < 0.5)
		filter_result = 2. * filter * Color;
	else
		filter_result = 1. - (1. - (2. *(filter - 0.5)))*(1. - Color);
		
	return filter_result;
}
```

![flower](http://media.virbcdn.com/files/54/0ee55f68adc65c74-flower_2_s.png "flower")  ![warm](http://media.virbcdn.com/files/71/0da0456ad14d3a5d-flower_w_s.png "warm")

###**2. Being an Artist**

####**2.1 How to Draw**

Forget about the codes and equations for a while, let's talk about how to draw on paper (here, actually I drew this on iPad, but I think it's similar) A sketch of the outline is first created. Then roughly blend the color on it. If want a finer look, nicely touch on some details. This is a simple approach I used to draw. 

![drawing](http://media.virbcdn.com/files/96/752372330d3dd1f2-drawing.png "drawing")

How about asking the computer to draw for us like this? Emm, how to sketch a outline? Here again comes the very simple edge detection algorithm [Sobel filter](http://en.wikipedia.org/wiki/Sobel_operator). (Codes are shared in previous post[1])

How to blend the colors? We can pick up color from the real photo for each texel, but it seems look so real because too much fine details are included. We would like to make it less accurate. To do so by grouping the similar colors and giving them an average. In shader, to categorize each color channel into 10 groups can simply write like this by knowing that each channel in **vec4 color** ranges from 0 to 1:

```c
    color = floor(color * 10.0) * 0.1;

```

Now, we can sketch and blend like this:

![image_sketch](http://media.virbcdn.com/files/52/456e0a0a2378f1c3-1_crop.jpg)  ![image_blend](http://media.virbcdn.com/files/5a/0e91a1fd3e397f71-2_crop.jpg)


####**2.2 Masters' Styles: Just for Fun**

![waterlilies](http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Nympheas_71293_3.jpg/320px-Nympheas_71293_3.jpg "waterlilies") ![starry night](http://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/303px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg "starry night")


__Waterlilies__ by _Monet_ and __Starry Night__ by _Van Gogh_ are some famous masterpieces we all are familiar with. We can easily recognize the unique ways they blend colors. Monet,the Impressionist, in his work eliminated the edges and randomized the brush touches. To mimic an effect like this, I tried to combine the artistic effect without edge detection with the method[4] I discussed previously - scanning the random selected pixels around the center one, and take either the brightest or darkest to replace the center. This gives a quite nice view I feel, if not alike.

![flower](http://media.virbcdn.com/files/da/943cacb3bad52837-flower_1_s.png "flower")  ![monet](http://media.virbcdn.com/files/a5/142d959760b2549b-flower_m_s.png "monet")

Curved lines and circular brush touches are the identities of Vincent Van Gogh. To mimic the kind of circular motion feel, I give wave-patterned displacements to texels by using a sine function:

```c
vec2 circular(vec2 position){
	vec2 p = position;
	p.x = p.x + sin(p.y*80.)*0.003;
	p.y = p.y + sin(p.x*80.)*0.003;

	return p;
}
```

![lili](http://media.virbcdn.com/files/99/3fe6eb3659136fc5-lili_s.png "lily")  ![van](http://media.virbcdn.com/files/d2/90868f86169649eb-lili_v_s.png "van")

Just a trial, hope this is not taken as making fun of the great artists. I like painting, with pencils and brushes, or digitally[6], so I actually encourage us to draw with our hands, not a camera. But I also hope this artistic view can give us a new perspective of the real world, to appreciate the beauty hiding behind it. 


**2.3 Comic Book **

We often see dots in American comics. Ben-Day[7] dots was invented dating back to 1879, to produce more dynamic colors in printing, e.g. spaced dots of red colors gives pink. Later it was explored by pop artists to produce illustrations. Same in black-and-white Japanese comics, gray areas are sometimes shaded by strips. The intention of using dots and strips patterns in comics have gave me this inspiration - how about check the intensities of the texels, on the texels that are within a defined gray region, overlay the patterns. What kind of effect can I get?

To generate a strips pattern:

```c
vec3 StripsPattern(vec2 position)
{
	vec2 p = (position - 0.5) * 500.;

	float angle = 0.7;
	vec2 direction = vec2(cos(angle), sin(angle));
	float brightness = cos(dot(p, direction)); 
	vec3 color = vec3(1.-brightness);
	
	float gray = dot(color, W);
	if(gray > 0.5)
		return vec3(220./255., 220./255., 220./255.);
	else
		return vec3(120./255., 120./255., 120./255.);
}
```

To generate a dots pattern 

```c
float divation(float a, float b){
	float f = floor(a/b);
	float c = ceil(a/b);
	return min((a - b*f), (c*b - a));
}

vec3 DotsPattern(vec2 position, vec2 uPixelSize, float radius, float interval){
	
	vec2 center = position/uPixelSize;
	
	float mod_x = divation(center.x, interval);
	float mod_y = divation(center.y, interval);
	float mod_r = sqrt(mod_x*mod_x + mod_y*mod_y);
	
	if(mod_r < radius)
		return vec3(1.);
	else 
		return vec3(0.);
}
```

![image](http://media.virbcdn.com/files/ee/69476dc5505702e6-5.jpg)  ![mango](http://media.virbcdn.com/files/97/1fca6b08702ed223-4.jpg)



###The Issue!

I think I have not really figured out the way to do blurring. Blur effect seems to be very popular after the releasing of IOS7. Gaussian blur however involves heavy computation. I tried using 9-by-9 Gaussian kernels to do blurring, with the optimized method proposed by Daniel Rakos[8], it runs really slowly on my Note II! So I give up the idea of trying filtering multiple times or with larger sized kernel. I also studied through the post and dig into the codes by Brad Larson[9], luckily I learned the way to write loop for shader! However I still cannot got the idea to do a fast blur with larger sized Gaussian kernel. How can it be so fast on iPhone? Is it the hardware issue or my understanding is not accurate. I think there should be smarter way to implement blurring. Later I will revisit some fundamentals of OpenGL.

I come up with another way to do blur, also get inspiration from here[10]. Instead of using Gaussian kernel, I first mosaic the image, and then use the `smoothstep` and `mix` function to perform color interpolation. 

```
vec3 mosaic(vec2 position){
	vec2 p = floor(position)/10.;
	return texture2D(sTexture, p).rgb;
}

vec2 sw(vec2 p) {return vec2( floor(p.x) , floor(p.y) );}
vec2 se(vec2 p) {return vec2( ceil(p.x) , floor(p.y) );}
vec2 nw(vec2 p) {return vec2( floor(p.x) , ceil(p.y) );}
vec2 ne(vec2 p) {return vec2( ceil(p.x) , ceil(p.y) );}

vec3 blur(vec2 p) {
	vec2 inter = smoothstep(0., 1., fract(p));
	vec3 s = mix(mosaic(sw(p)), mosaic(se(p)), inter.x);
	vec3 n = mix(mosaic(nw(p)), mosaic(ne(p)), inter.x);
	return mix(s, n, inter.y);
	}

vec3 main()
{
	return blur(vTextureCoord*10.);
}
```

![green](http://media.virbcdn.com/files/41/c50af659badc9ed4-green_s.png "green")  ![blur](http://media.virbcdn.com/files/8e/2ce2e352cfb2ab95-green_b_s.png "blur")

###Closure

It is wonderful to combine the two things I like most - coding and painting together, to create something beautiful and smart. Hope this will give you little hints in your hacking. Happy coding, and photographing! Painting also!


> A Camera App on [Google Play]()

> Credit of nice photos goes to my adventurous nerd, [Flickr](http://www.flickr.com/photos/fenixzhang/).

[1]:http://littlecheesecake.me/blog/13804700/opengles-shader
[2]:http://pixelshaders.com/sample/
[3]:http://pixelshaders.com/examples/quasicrystal.html
[4]:http://en.wikipedia.org/wiki/Blend_modes
[5]:http://littlecheesecake.me/blog/13804472/more-filters-fragment-shader
[6]:http://littlecheesecake.me/arts
[7]:http://en.wikipedia.org/wiki/Ben-Day_dots
[8]:http://rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/
[9]:http://www.sunsetlakesoftware.com/2013/10/21/optimizing-gaussian-blurs-mobile-gpu
[10]:http://pixelshaders.com/examples/noise.html
