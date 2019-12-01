return love.graphics.newShader([[
		vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
        {
			vec4 pixel = Texel(tex, tc);
			number p = (pixel.r + pixel.g + pixel.b) / 3.0;
			pixel.r = p;
			pixel.g= p;
			pixel.b = p;
			return pixel;
		}
	]])
