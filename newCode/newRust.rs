use std::env;

fn print(message: &str)
{
	println!("{}", message);
}

fn help()
{
	print("Author: Joespider");
	print("Program: \"newRust\"");
	print("Version: 0.0.1");
	print("Purpose: make new Rust programs");
	print("Usage: newRust <args>");
	print("\t-n <name> : program name");
	print("\t--name <name> : program name");
	print("\t--cli : enable command line (Main file ONLY)");
	print("\t--main : main file");
	print("\t--random : enable \"random\" int method");
	print("\t--write-file : enable \"write\" file method");
	print("\t--read-file : enable \"read\" file method");
	print("\t--is-in : enable \"IsIn\" file method");
	print("\t--user-input : enable \"Raw_Input\" file method");
}

fn main()
{
	let mut arg_count = 0;
	//CLI arguments
	for args in env::args()
	{
		if arg_count > 0
		{
			println!("{}", args);
		}
		arg_count += 1;
	}

	if arg_count == 0
	{
		print!("");
	}
	else
	{
		help();
	}
}
