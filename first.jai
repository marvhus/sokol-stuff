main :: () {
	set_build_options_dc(.{do_output=false});

	workspace := compiler_create_workspace("JMP");
	if !workspace {
		print("Failed to create workspace.\n");
		return;
	}

	make_directory_if_it_does_not_exist("bin");

	// Set build options
	target_options := get_build_options(workspace);

	target_options.output_executable_name = "jmp";
	target_options.output_path = "bin/";

	set_build_options(target_options, workspace);

	// Add file to build
	compiler_begin_intercept(workspace);
	add_build_file(tprint("%/src/main.jai", #filepath), workspace);
	compiler_end_intercept(workspace);
	
}
	#run main();

#import "File";
#import "Basic";
#import "Compiler";
