use std::env;
use std::io::Write;

fn print(message: &str)
{
	println!("{}", message);
}

fn help()
{
	print("Author: Joespider");
	print("Program: \"newRust\"");
	print("Version: 0.1.0");
	print("Purpose: make new Rust programs");
	print("Usage: newRust <args>");
	print("\t-n <name> : program name");
	print("\t--name <name> : program name");
	print("\t--cli : enable command line (Main file ONLY)");
	print("\t--main : main file");
	print("\t--random : enable \"random\" int method");
	print("\t--write-file : enable \"write\" file method");
	print("\t--read-file : enable \"read\" file method");
	print("\t--user-input : enable \"Raw_Input\" file method");
}

fn get_imports(getreadfile: bool, getwritefile: bool, getcli: bool) -> String
{
	let mut theimports = String::new();
	if getcli == true
	{
		theimports.push_str("use std::env;\n");
	}
	if getreadfile == true && getwritefile == false
	{
		theimports.push_str("use std::fs::File;\nuse std::io::{BufRead, BufReader};\n");
	}
	if getreadfile == false && getwritefile == true
	{
		theimports.push_str("use std::io::Write;\n");
	}
	if getreadfile == true && getwritefile == true
	{
		theimports.push_str("use std::fs::File;\nuse std::io::{BufRead, BufReader, Write};\n");
	}
	theimports.push_str("\n");
	return theimports;
}

fn get_methods(getreadfile: bool, getwritefile: bool, getrawinput: bool) -> String
{
	let mut themethods = String::new();
	if getrawinput == true
	{
		themethods.push_str("fn raw_input(message: &str) -> String\n{\n\tuse std::io::{stdin,stdout,Write};\n\tlet mut s=String::new();\n\tprint!(\"{} \",message);\n\tlet _=stdout().flush();\n\tstdin().read_line(&mut s).expect(\"Did not enter a correct string\");\n\tif let Some('\\n')=s.chars().next_back() {\n\t\ts.pop();\n\t}\n\tif let Some('\\r')=s.chars().next_back() {\n\t\ts.pop();\n\t}\n\treturn s;\n}\n\n");
	}
	if getreadfile == true
	{
		themethods.push_str("fn read_file(filename: String) -> String\n{\n\t// Open the file in read-only mode (ignoring errors).\n\tlet file = File::open(filename).unwrap();\n\tlet reader = BufReader::new(file);\n\n\t// Read the file line by line using the lines() iterator from std::io::BufRead.\n\tfor line in reader.lines()\n\t{\n\t\t// Ignore errors.\n\t\tlet line = line.unwrap();\n\t\t// Show the line and its number.\n\t\tprintln!(\"{}\", line)\n\t}\n}\n\n");
	}
	if getwritefile == true
	{
		themethods.push_str("fn write_file(filename: String, thecontent: String)\n{\n\tlet mut file = std::fs::File::create(filename).expect(\"create failed\");\n\tfile.write_all(thecontent.as_bytes()).expect(\"write failed\");\n}\n\n");
	}
	return themethods;
}

fn get_main(getmain: bool, getcli: bool) -> String
{
	let mut themain = String::new();
	if getmain == true
	{
		themain.push_str("fn main()\n{\n");
		if getcli == true
		{
			themain.push_str("\tlet mut arg_count = 0;\n\t//CLI arguments\n\tfor args in env::args()\n\t{\n\t\tif arg_count > 0\n\t\t{\n\t\t\tprintln!(\"{}\", args);\n\t\t}\n\t\targ_count += 1;\n\t}\n");
		}
		themain.push_str("\n}");
	}
	return themain;
}

fn write_file(thename: String, theimports: String, themethods: String, themain: String)
{
	let mut file = std::fs::File::create(thename).expect("create failed");
	file.write_all(theimports.as_bytes()).expect("write failed");
	file.write_all(themethods.as_bytes()).expect("write failed");
	file.write_all(themain.as_bytes()).expect("write failed");
}

fn main()
{
	let mut program_name = String::new();
	let mut get_input_method = false;
	let mut is_name = false;
	let mut is_main = false;
//	let mut is_in_string = false;
//	let mut is_a_random = false;
	let mut is_cli = false;
	let mut is_read_file = false;
	let mut is_write_file = false;
	let mut name_set = false;
	let mut arg_count = 0;
	//CLI arguments
	for args in env::args()
	{
		if arg_count > 0
		{
			if is_name == true
			{
				//program_name = &args;
				program_name.push_str(&args);
				program_name.push_str(".rs");
				name_set = true;
				is_name = false;
			}
			else if args == "-n" || args == "--name"
			{
				is_name = true;
			}
			else if args == "--cli"
			{
				is_cli = true;
			}
			else if args == "--main"
			{
				is_main = true;
			}
/*
			else if args == "--random"
			{
				is_a_random = true;
			}
*/
			else if args == "--write-file"
			{
				is_write_file = true;
			}
			else if args == "--read-file"
			{
				is_read_file = true;
			}
/*
			else if args == "--is-in"
			{
				is_in_string = true;
			}
*/
			else if args == "--user-input"
			{
				get_input_method = true;
			}
		}
		arg_count += 1;
	}

	if name_set == false
	{
		help();
	}
	else
	{
		let the_imports = get_imports(is_read_file, is_write_file, is_cli);
		let the_methods = get_methods(is_read_file, is_write_file, get_input_method);
		let the_main = get_main(is_main, is_cli);
		write_file(program_name, the_imports, the_methods, the_main);
	}
}
