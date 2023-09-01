c_context: Context;

main :: () {
	desc := sapp_desc.{
		init_cb = () #c_call {
			push_context c_context { init(); }
		},
		frame_cb = () #c_call {
			push_context c_context { frame(); }
		},
		cleanup_cb = () #c_call {
			push_context c_context { cleanup(); }
		},
		event_cb = (e: *sapp_event) #c_call {
			push_context c_context { event(e); }
		},

		width  = 640,
		height = 480,
		gl_force_gles2 = true,
		window_title = "JMP"
	};

	sapp_run(*desc);
}

// VERTEX SHADER
VERT_SHADER :: #string END_VERT
#version 330

layout(location=0) in vec4 position;
layout(location=1) in vec4 color0;
out vec4 color;

void main() {
	gl_Position = position;
	color = color0;
}
END_VERT;

// FRAGMENT SHADER
FRAG_SHADER :: #string END_FRAG
#version 330

in vec4 color;
out vec4 frag_color;

void main() {
	frag_color = color;
}
END_FRAG;

state: struct {
	pipeline    : sg_pipeline;
	bindings    : sg_bindings;
	pass_action : sg_pass_action;

	verticies: []Vertex;
	indices: []u16;
} = .{
	pass_action = .{
		colors[0] = .{
			action = .CLEAR,
			value  = .{ 0.5, 0.5, 1.0, 1.0 },
		}
	},

	verticies = .[
		.{-1.00,  1.00,   1, 0, 0},
		.{ 1.00,  1.00,   0, 1, 0},
		.{ 1.00, -1.00,   0, 0, 1},
		.{-1.00, -1.00,   1, 0, 1},
	],

	indices = .[
		0, 1, 2,
		0, 2, 3,
	]
};

Vertex :: struct {
	x, y: float;
	r, g, b: float;
}

init :: () {
	desc: sg_desc;
	desc._context = sapp_sgcontext();
	sg_setup(*desc);

	using state;

	// Vetex Buffer
	bindings.vertex_buffers[0] = sg_make_buffer(*sg_buffer_desc.{
		type = .VERTEXBUFFER,
		data = sg_range.{
			ptr = verticies.data,
			size = verticies.count * size_of(Vertex),
		},
		size = verticies.count * size_of(Vertex),
		label = "vertex-buffer",
	});

	// Index Buffer
	bindings.index_buffer = sg_make_buffer(*sg_buffer_desc.{
		type = .INDEXBUFFER,
		data = sg_range.{
			ptr = indices.data,
			size = indices.count * size_of(u16),
		},
		size = indices.count * size_of(u16),
		label = "index-buffer",
	});

	// Shader Pipeline
	pipeline = sg_make_pipeline(*sg_pipeline_desc.{
		shader = sg_make_shader(*sg_shader_desc.{
			label = "simple-shader",
			attrs[0].name = "position",
			attrs[1].name = "color0",
			vs = .{
				entry = "main",
				source = VERT_SHADER,
			},
			fs = .{
				entry = "main",
				source = FRAG_SHADER,
			},
		}),
		index_type = .UINT16,
		layout = sg_layout_desc.{
			attrs[0].format = .FLOAT2,
			attrs[1].format = .FLOAT3,
		},
		label = "pipeline",
	});
}

cleanup :: () {
	sg_shutdown();
}

frame :: () {
	using state;

	sg_begin_default_pass(*pass_action, sapp_width(), sapp_height());

	sg_apply_pipeline(pipeline);

	sg_apply_bindings(*bindings);
	sg_draw(0, xx indices.count, 1);

	sg_end_pass();
	sg_commit();
}

event :: (e: *sapp_event) {
	if e.type == .KEY_DOWN {
		if e.key_code == {
			case .KEYCODE_ESCAPE;
				sapp_request_quit();
			case .KEYCODE_SPACE;
				log("Pressed space\n");
		}
	}
}

#import "Basic";
#import "Sokol";
