main :: () {
	set_build_options_dc(.{do_output=false});

	workspace := compiler_create_workspace("JMP");
	if !workspace {
		log_error("Failed to create workspace.\n");
		return;
	}

	// Create outpur directory
	make_directory_if_it_does_not_exist("bin");

	// configure build options
	options := get_build_options(workspace);

	options.output_executable_name = "jmp";
	options.output_path = "bin/";

	import_path: [..]string;
	array_add(*import_path, tprint("modules/"));
	array_add(*import_path, ..options.import_path);
	options.import_path = import_path;

	set_build_options(options, workspace);

	// Add file to compile
	add_build_file(tprint("src/main.jai"), workspace);
}
#run main();

#import "File";
#import "Basic";
#import "Compiler";
