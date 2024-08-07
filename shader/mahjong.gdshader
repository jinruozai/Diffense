shader_type spatial;

uniform sampler2D mahjong_texture;
uniform vec4 body_color:source_color = vec4(1.0, 1.0,1.0,1.0);
uniform vec4 bottom_color:source_color = vec4(0.0,0.0,1.0,1.0);

void fragment() {
    // 获取UV坐标
	vec2 uv = UV;
	vec4 color=body_color;
	vec4 texcolor=texture(mahjong_texture,uv);
	//ALBEDO = color.rgb;
	if(uv.y>=1.0){
		color=bottom_color;
	}else{
		if(uv.y>0.0){
			color=mix(body_color,texcolor,texcolor.a);
		}
	}
	ALBEDO=color.rgb;
}
