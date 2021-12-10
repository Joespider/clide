use std::env;

fn print(message: &str)
{
	println!("{}", message);
}

fn help()
{
	print("Author: Joespider");
	print("Program: \"newRust\"");
	print("Version: 0.0.4");
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

/*
fn raw_input(message: &str) -> String
{
	use std::io::{stdin,stdout,Write};
	let mut s=String::new();
	print!("{} ",message);
	let _=stdout().flush();
	stdin().read_line(&mut s).expect("Did not enter a correct string");
	if let Some('\n')=s.chars().next_back() {
		s.pop();
	}
	if let Some('\r')=s.chars().next_back() {
		s.pop();
	}
	return s;
}
*/

fn main()
{
	let mut program_name = String::new();
	let mut is_name = false;
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
				name_set = true;
				is_name = false;
			}
			else if args == "-n" || args == "--name"
			{
				is_name = true;
			}
			else if args == "--cli"
			{
				println!("{}", args);
			}
			else if args == "--main"
			{
				println!("{}", args);
			}
			else if args == "--random"
			{
				println!("{}", args);
			}
			else if args == "--write-file"
			{
				println!("{}", args);
			}
			else if args == "--read-file"
			{
				println!("{}", args);
			}
			else if args == "--is-in"
			{
				println!("{}", args);
			}
			else if args == "--user-input"
			{
				println!("{}", args);
			}
			else
			{
				println!("nope");
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
		println!("Program : \"{}\"", program_name);
	}
}
