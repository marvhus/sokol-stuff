c_context: Context;

state: struct {
	pipeline    : sg_pipeline;
	bindings    : sg_bindings;
	pass_action : sg_pass_action;
};

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

init :: () {
	desc: sg_desc;
	desc._context = sapp_sgcontext();
	sg_setup(*desc);

	verts := float.[
		// postions       // colors
		 0.0,  0.5, 0.5,  1.0, 0.0, 0.0, 1.0,
		 0.5, -0.5, 0.5,  0.0, 1.0, 0.0, 1.0,
		-0.5, -0.5, 0.5,  0.0, 0.0, 1.0, 1.0,
	];
	{
		state.bindings.vertex_buffers[0] = sg_make_buffer(*sg_buffer_desc.{
			data = sg_range.{
				ptr = verts.data,
				size = verts.count * size_of(float),
			},
			size = verts.count * size_of(float),
			label = "triangle-verticies",
		});
	}
	{
		state.pipeline = sg_make_pipeline(*sg_pipeline_desc.{
			shader = sg_make_shader(*sg_shader_desc.{
				label = "simple_shader",
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
			layout = sg_layout_desc.{
				attrs[0].format = .FLOAT3,
				attrs[1].format = .FLOAT4,
			},
			label = "triangle-pipeline",
		});
	}

	state.pass_action = .{
		colors[0] = .{
			action = .CLEAR,
			value  = .{ 0, 0, 0, 1 },
		}
	};
}

cleanup :: () {
	sg_shutdown();
}

frame :: () {
	sg_begin_default_pass(*state.pass_action, sapp_width(), sapp_height());

	sg_apply_pipeline(state.pipeline);
	sg_apply_bindings(*state.bindings);
	sg_draw(0, 3, 1);

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

VERT_SHADER :: #string END_VERT
#version 330

layout(location = 0) in vec4 position;
layout(location = 1) in vec4 color0;
out vec4 color;

void main() {
	gl_Position = position;
	color = color0;
}
END_VERT;

FRAG_SHADER :: #string END_FRAG
#version 330

in vec4 color;
out vec4 frag_color;

void main() {
	frag_color = color;
}
END_FRAG;

#import "Basic";
#import "Sokol";
