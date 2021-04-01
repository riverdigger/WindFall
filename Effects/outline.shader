shader_type canvas_item;
uniform float age;
uniform sampler2D hat_back_texture;
uniform sampler2D hair_back_texture;
uniform sampler2D cape_back_texture;
uniform sampler2D body_texture;
uniform sampler2D bottom_texture;
uniform sampler2D top_texture;
uniform sampler2D shoes_texture;
uniform sampler2D cape_texture;
uniform sampler2D hair_texture;
uniform sampler2D eyes_texture;
uniform sampler2D hat_texture;

uniform float outline_width = 2.0;
uniform vec4 outline_color: hint_color;


void fragment() {
	vec4 col = texture(hat_back_texture, UV); // + texture(hair_back_texture, UV) + texture(cape_back_texture, UV) + texture(body_texture, UV) + texture(bottom_texture, UV) + texture(top_texture, UV) + texture(shoes_texture, UV) + texture(cape_texture, UV) + texture(hair_texture, UV) + texture(eyes_texture, UV) + texture(hat_texture, UV);
	vec2 ps = TEXTURE_PIXEL_SIZE;
	float a;
	float maxa = col.a;
	float mina = col.a;

	a = texture(TEXTURE, UV + vec2(0.0, -outline_width) * ps).a;
	maxa = max(a, maxa);
	mina = min(a, mina);

	a = texture(TEXTURE, UV + vec2(0.0, outline_width) * ps).a;
	maxa = max(a, maxa);
	mina = min(a, mina);

	a = texture(TEXTURE, UV + vec2(-outline_width, 0.0) * ps).a;
	maxa = max(a, maxa);
	mina = min(a, mina);

	a = texture(TEXTURE, UV + vec2(outline_width, 0.0) * ps).a;
	maxa = max(a, maxa);
	mina = min(a, mina);

	COLOR = mix(col, outline_color, maxa - mina);
	COLOR = col;
//	COLOR = vec4(mix(), 1.0);
}
