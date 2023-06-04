use std::env;
use std::io::Write;
use std::path::Path;

fn help()
{
	println!("Author: Joespider");
	println!("Program: \"newRust\"");
	println!("Version: 0.1.22");
	println!("Purpose: make new Rust programs");
	println!("Usage: newRust <args>");
	println!("\t--user <username> : get username for help page");
	println!("\t-n <name> : program name");
	println!("\t--name <name> : program name");
	println!("\t--no-save : only show out of code; no file source code is created");
	println!("\t--cli : enable command line (Main file ONLY)");
	println!("\t--main : main file");
	println!("\t--prop : enable custom system property");
	println!("\t--pipe : enable piping (Main file and project ONLY)");
	println!("\t--shell : unix shell");
	println!("\t--reverse : enable \"rev\" method");
	println!("\t--random : enable \"random\" int method");
	println!("\t--check-file : enable \"fexists\" file method");
	println!("\t--write-file : enable \"write\" file method");
	println!("\t--read-file : enable \"read\" file method");
	println!("\t--is-in : enable string contains methods");
	println!("\t--user-input : enable \"Raw_Input\" file method");
	println!("\t--split : enable split");
	println!("\t--join : enable join");
	println!("\t--thread : enable threading (Main file and project ONLY)");
	println!("\t--sleep : enable sleep method");
	println!("\t--get-length : enable \"length\" methods");
	println!("\t--upper : enable upper case methods");
	println!("\t--lower : enable lower case methods");
}

fn get_sys_prop(please_get: &str) -> String
{
	let value = match env::var_os(please_get)
	{
		Some(v) => v.into_string().unwrap(),
		None => panic!("{} is not set",please_get)
	};
	return value;
}

fn get_help(thename: String,theuser: String, hasargs: bool) -> String
{
	let mut helpmethod = String::new();
	if hasargs == true && theuser == ""
	{
		let gettheuser = get_sys_prop("USER");
		helpmethod.push_str("fn help()\n");
		helpmethod.push_str("{\n");
		helpmethod.push_str("\tprintln!(\"Author: ");
		helpmethod.push_str(&gettheuser);
		helpmethod.push_str("\");\n");
		helpmethod.push_str("\tprintln!(\"Program: \\\"");
		helpmethod.push_str(&thename);
		helpmethod.push_str("\\\"\");\n");
		helpmethod.push_str("\tprintln!(\"Version: 0.0.0\");\n");
		helpmethod.push_str("\tprintln!(\"Purpose: \");\n");
		helpmethod.push_str("\tprintln!(\"Usage: ");
		helpmethod.push_str(&thename);
		helpmethod.push_str(" <args>\");\n");
		helpmethod.push_str("}\n\n");
	}
	else if hasargs == true && theuser != ""
	{
		helpmethod.push_str("fn help()\n");
		helpmethod.push_str("{\n");
		helpmethod.push_str("\tprintln!(\"Author: ");
		helpmethod.push_str(&theuser);
		helpmethod.push_str("\");\n");
		helpmethod.push_str("\tprintln!(\"Program: \\\"");
		helpmethod.push_str(&thename);
		helpmethod.push_str("\\\"\");\n");
		helpmethod.push_str("\tprintln!(\"Version: 0.0.0\");\n");
		helpmethod.push_str("\tprintln!(\"Purpose: \");\n");
		helpmethod.push_str("\tprintln!(\"Usage: ");
		helpmethod.push_str(&thename);
		helpmethod.push_str(" <args>\");\n");
		helpmethod.push_str("}\n\n");
	}
	else
	{
		helpmethod.push_str("");
	}
	return helpmethod;
}


fn get_imports(getcheckfile: bool, getreadfile: bool, getwritefile: bool, getcli: bool, getpipe: bool, getsysprop: bool, getthread: bool, getsleep: bool, getshell: bool) -> String
{
	let mut theimports = String::new();
	if getcli == true || getsysprop == true || getshell == true
	{
		theimports.push_str("use std::env;\n");
	}
	if getcheckfile == true
	{
		theimports.push_str("use std::path::Path;\n");
	}
	if getreadfile == true && getwritefile == false
	{
		theimports.push_str("use std::fs::File;\nuse std::io::{BufRead, BufReader};\n");
	}
	if getreadfile == false && getwritefile == true
	{
		theimports.push_str("use std::io::Write;\n");
	}
	if getthread == true || getsleep == true
	{
		theimports.push_str("use std::thread;\n");
	}
	if getsleep == true
	{
		theimports.push_str("use std::time;\n");
	}
	if getreadfile == true && getwritefile == true
	{
		theimports.push_str("use std::fs::File;\nuse std::io::{BufRead, BufReader, Write};\n");
	}
	if getpipe == true && getreadfile == false && getwritefile == false
	{
		theimports.push_str("/*\nThis needs to be a rust project\nIn file 'Cargo.toml', account for the following\n\n[dependencies]\nisatty = \"0.1\"\n\nextern crate isatty;\nuse isatty::{stdin_isatty};\nuse std::io::{self, BufRead};\n*/\n");
	}
	if getpipe == true && getreadfile == true && getwritefile == true
	{
		theimports.push_str("/*\nThis needs to be a rust project\nIn file 'Cargo.toml', account for the following\n\n[dependencies]\nisatty = \"0.1\"\n\nextern crate isatty;\nuse isatty::{stdin_isatty};\n*/\n");
	}
	if getshell == true
	{
		theimports.push_str("use std::process::Command;");
	}

	theimports.push_str("\n");
	return theimports;
}

fn get_methods(getcheckfile: bool, getreadfile: bool, getwritefile: bool, getrawinput: bool, getsysprop: bool, getsleep: bool, getshell: bool, getrev: bool, getsplit: bool, getisin: bool, getlen: bool, getupper: bool, getlower: bool) -> String
{
	let mut themethods = String::new();
	if getrawinput == true
	{
		themethods.push_str("fn raw_input(message: &str) -> String\n{\n\tuse std::io::{stdin,stdout,Write};\n\tlet mut s=String::new();\n\tprint!(\"{}\",message);\n\tlet _=stdout().flush();\n\tstdin().read_line(&mut s).expect(\"Did not enter a correct string\");\n\tif let Some('\\n')=s.chars().next_back() {\n\t\ts.pop();\n\t}\n\tif let Some('\\r')=s.chars().next_back() {\n\t\ts.pop();\n\t}\n\treturn s;\n}\n\n");
	}
	if getcheckfile == true
	{
		themethods.push_str("fn fexists(afile: &str) -> bool\n{\n\treturn Path::new(afile).exists();\n}\n\n");
	}
	if getreadfile == true
	{
		themethods.push_str("fn read_file(filename: String) -> String\n{\n\t// Open the file in read-only mode (ignoring errors).\n\tlet file = File::open(filename).unwrap();\n\tlet reader = BufReader::new(file);\n\n\t// Read the file line by line using the lines() iterator from std::io::BufRead.\n\tfor line in reader.lines()\n\t{\n\t\t// Ignore errors.\n\t\tlet line = line.unwrap();\n\t\t// Show the line and its number.\n\t\tprintln!(\"{}\", line)\n\t}\n}\n\n");
	}
	if getrev == true
	{
		themethods.push_str("fn rev(theword: &str) -> String\n{\n\tlet mut newstr = String::new();\n\tlet mut plc = 0;\n\tlet charlen = theword.len();\n\twhile plc != charlen\n\t{\n\t\tplc += 1;\n\t\tnewstr.push_str(&theword.chars().nth(charlen - plc).unwrap().to_string());\n\t}\n\treturn newstr;\n}\n\n");
	}
	if getsplit == true
	{
		themethods.push_str("fn split_before(the_string: &str, split_at: char) -> String\n{\n\tlet mut new_string = String::new();\n\tlet end = the_string.len();\n\tif end != 0\n\t{\n\t\tfor ch in the_string.chars()\n\t\t{\n\t\t\tif ch == split_at\n\t\t\t{\n\t\t\t\tbreak;\n\t\t\t}\n\t\t\telse\n\t\t\t{\n\t\t\t\tnew_string.push_str(&ch.to_string());\n\t\t\t}\n\t\t}\n\t}\n\treturn new_string;\n}\n\n");
		themethods.push_str("fn split_after(the_string: &str, split_at: char) -> String\n{\n\tlet mut show = false;\n\tlet mut new_string = String::new();\n\tlet end = the_string.len();\n\tif end != 0\n\t{\n\t\tfor ch in the_string.chars()\n\t\t{\n\t\t\tif show == true\n\t\t\t{\n\t\t\t\tnew_string.push_str(&ch.to_string());\n\t\t\t}\n\t\t\tif ch == split_at && show != true\n\t\t\t{\n\t\t\t\tshow = true;\n\t\t\t}\n\t\t}\n\t}\n\treturn new_string;\n}\n\n");
	}
	if getwritefile == true
	{
		themethods.push_str("fn write_file(filename: String, thecontent: String)\n{\n\tlet mut file = std::fs::File::create(filename).expect(\"create failed\");\n\tfile.write_all(thecontent.as_bytes()).expect(\"write failed\");\n}\n\n");
	}
	if getsysprop == true
	{
		themethods.push_str("fn get_sys_prop(please_get: &str) -> String\n{\n\tlet value = match env::var_os(please_get)\n\t{\n\t\tSome(v) => v.into_string().unwrap(),\n\t\tNone => panic!(\"{} is not set\",please_get)\n\t};\n\treturn value;\n}\n\n");
	}
	if getshell == true
	{
		themethods.push_str("fn get_os() -> String\n{\n\treturn env::consts::OS.to_string();\n}\n\n");
	}
	if getsleep == true
	{
		themethods.push_str("fn sleep()\n{\n\t// 3 * 1000 = 3 sec\n\tlet ten_millis = time::Duration::from_millis(3000);\n\tlet now = time::Instant::now();\n\n\tthread::sleep(ten_millis);\n\n\tassert!(now.elapsed() >= ten_millis);\n}\n\n");
	}
	if getisin == true
	{
		themethods.push_str("fn contains(str: &str, sub: &str) -> bool\n{\n\tif str.contains(sub)\n\t{\n\t\treturn true;\n\t}\n\telse\n\t{\n\t\treturn false;\n\t}\n}\n\n");
		themethods.push_str("fn starts_with(str: &str, start: &str) -> bool\n{\n\treturn str.starts_with(start);\n}\n\n");
		themethods.push_str("fn ends_with(str: &str, end: &str) -> bool\n{\n\tif str.ends_with(end)\n\t{\n\t\treturn true;\n\t}\n\telse\n\t{\n\t\treturn false;\n\t}\n}\n\n");
	}
	if getlen == true
	{
		themethods.push_str("fn len(message: &str) -> u32\n{\n\tlet thesize = message.len().to_string();\n\treturn thesize.parse().unwrap();\n}\n\n");
	}
	if getupper == true
	{
		themethods.push_str("fn to_uppercase(message: &str) -> String\n{\n\tlet upper = message.to_uppercase();\n\treturn upper;\n}\n\n");
		themethods.push_str("fn to_uppercase_at(message: &str, plc: usize) -> String\n{\n\tlet mut newmsg = String::new();\n\tlet size = message.chars().count();\n\tfor c in 0..size\n\t{\n\t\tlet mut letter = message.chars().nth(c).unwrap();\n\t\tif c == plc\n\t\t{\n\t\t\tletter = letter.to_ascii_uppercase();\n\t\t}\n\t\tnewmsg.push(letter);\n\t}\n\treturn newmsg;\n}\n\n");
	}
	if getlower == true
	{
		themethods.push_str("fn to_lowercase(message: &str) -> String\n{\n\tlet lower = message.to_lowercase();\n\treturn lower;\n}\n\n");
		themethods.push_str("fn to_lowercase_at(message: &str, plc: usize) -> String\n{\n\tlet mut newmsg = String::new();\n\tlet size = message.chars().count();\n\tfor c in 0..size\n\t{\n\t\tlet mut letter = message.chars().nth(c).unwrap();\n\t\tif c == plc\n\t\t{\n\t\t\tletter = letter.to_ascii_lowercase();\n\t\t}\n\t\tnewmsg.push(letter);\n\t}\n\treturn newmsg;\n}\n\n");
	}

	return themethods;
}

fn get_main(getmain: bool, getcli: bool, getpipe: bool, getthread: bool, getsplit: bool, getjoin: bool, getshell: bool) -> String
{
	let mut themain = String::new();
	if getmain == true
	{
		themain.push_str("fn main()\n{\n");
		if getcli == true
		{
			themain.push_str("\tlet mut arg_count = 0;\n\t//CLI arguments\n\tfor args in env::args().skip(1)\n\t{\n\t\tprintln!(\"{}\", args);\n\t\targ_count += 1;\n\t}\n\n\t//No CLI Arguments given\n\tif arg_count == 0\n\t{\n\t\t//Show Help Page\n\t\thelp();\n\t}\n");
		}
		if getpipe == true
		{
			themain.push_str("\n/*\n\tif stdin_isatty() == false\n\t{\n\t\tprintln!(\"[Pipe]\");\n\t\tprintln!(\"{{\");\n\t\tlet stdin = io::stdin();\n\t\tfor line in stdin.lock().lines()\n\t\t{\n\t\t\tprintln!(\"{}\", line.unwrap());\n\t\t}\n\t\tprintln!(\"}}\");\n\t}\n\telse\n\t{\n\t\tprintln!(\"nothing was piped in\");\n\t}\n*/");
		}
		if getsplit == true
		{
			themain.push_str("\n/*\n\tlet message = \"This is how we will win the game\";\n\tlet sby = \" \";\n\tlet split: Vec<&str> = message.split(sby).collect();\n*/");
		}
		if getjoin == true
		{
			themain.push_str("\n/*\n\t//Needs to be Vec<&str>\n\tlet joined = split.join(\"-\");\n*/");
		}
		if getthread == true
		{
			themain.push_str("\n/*\n\t// https://doc.rust-lang.org/std/thread/\n\tlet thread_join_handle = thread::spawn(|| {\n\t\t//do stuff here\n\t});\n\t//join thread\n\tthread_join_handle.join().unwrap();\n*/");
		}
		if getshell == true
		{
			themain.push_str("\nCommand::new(\"ls\")\n\t.arg(\"-l\")\n\t.arg(\"-a\")\n\t.spawn()\n\t.expect(\"ls command failed to start\");\n");
		}
		themain.push_str("\n}\n");
	}
	return themain;
}

fn fexists(afile: &str) -> bool
{
	return Path::new(afile).exists();
}

fn write_file(thename: String, theimports: String, thehelp: String, themethods: String, themain: String)
{
	let mut file = std::fs::File::create(thename).expect("create failed");
	file.write_all(theimports.as_bytes()).expect("write failed");
	file.write_all(thehelp.as_bytes()).expect("help failed");
	file.write_all(themethods.as_bytes()).expect("methods failed");
	file.write_all(themain.as_bytes()).expect("main failed");
}

fn main()
{
	let mut program_name = String::new();
	let mut the_user = String::new();
	let mut get_input_method = false;
	let mut no_save = false;
	let mut is_name = false;
	let mut is_user = false;
	let mut is_main = false;
//	let mut is_a_random = false;
	let mut is_cli = false;
	let mut is_check_file = false;
	let mut is_read_file = false;
	let mut is_write_file = false;
	let mut is_prop = false;
	let mut is_thread = false;
	let mut is_pipe = false;
	let mut is_rev = false;
	let mut is_shell = false;
	let mut is_in = false;
	let mut is_len = false;
	let mut is_split = false;
	let mut is_join = false;
	let mut is_sleep = false;
	let mut is_upper = false;
	let mut is_lower = false;
	let mut name_set = false;
	//CLI arguments
	for args in env::args().skip(1)
	{
		if is_name == true
		{
			program_name.push_str(&args);
			name_set = true;
			is_name = false;
		}
		else if is_user == true
		{
			the_user.push_str(&args);
			is_user = false;
		}
		else if args == "-n" || args == "--name"
		{
			is_name = true;
		}
		else if args == "--user"
		{
			is_user = true;
		}
		else if args == "--no-save"
		{
			no_save = true;
		}
		else if args == "--split"
		{
			is_split = true;
		}
		else if args == "--join"
		{
			is_join = true;
		}
		else if args == "--shell"
		{
			is_shell = true;
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
		else if args == "--check-file"
		{
			is_check_file = true;
		}
		else if args == "--user-input"
		{
			get_input_method = true;
		}
		else if args == "--thread"
		{
			is_thread = true;
		}
		else if args == "--get-length"
		{
			is_len = true;
		}
		else if args == "--pipe"
		{
			is_pipe = true;
		}
		else if args == "--reverse"
		{
			is_rev = true;
		}
		else if args == "--prop"
		{
			is_prop = true;
		}
		else if args == "--is-in"
		{
			is_in = true;
		}
		else if args == "--sleep"
		{
			is_sleep = true;
		}
		else if args == "--upper"
		{
			is_upper = true;
		}
		else if args == "--lower"
		{
			is_lower = true;
		}
	}

	if name_set == false && no_save == false
	{
		help();
	}
	else
	{
		let mut check_file = String::new();
		check_file.push_str(&program_name);
		check_file.push_str(".rs");
		let file_exists = fexists(&check_file);
		if file_exists == false || no_save == true
		{
			let the_imports = get_imports(is_check_file, is_read_file, is_write_file, is_cli, is_pipe, is_prop, is_thread, is_sleep, is_shell);
			let the_helps = get_help(program_name.to_string(),the_user.to_string(),is_cli);
			program_name.push_str(".rs");
			let the_methods = get_methods(is_check_file, is_read_file, is_write_file, get_input_method, is_prop, is_sleep, is_shell, is_rev, is_split, is_in, is_len, is_upper, is_lower);
			let the_main = get_main(is_main, is_cli, is_pipe, is_thread, is_split, is_join, is_shell);
			if no_save == false
			{
				write_file(program_name, the_imports, the_helps, the_methods, the_main);
			}
			else
			{
				println!("{}\n{}\n{}\n{}",the_imports, the_helps, the_methods, the_main);
			}
		}
		else
		{
			println!("\"{}\" already exists",check_file);
		}
	}
}
