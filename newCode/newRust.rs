use std::env;
use std::io::Write;
use std::path::Path;

fn help()
{
	println!("Author: Joespider");
	println!("Program: \"newRust\"");
	println!("Version: 0.1.32");
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
	println!("\t--files : enable filesystem Rust specific code");
	println!("\t--reverse : enable \"rev\" method");
	println!("\t--split : enable split");
	println!("\t--join : enable join");
	println!("\t--random : enable \"random\" int method");
/*
	println!("\t--check-file : enable \"fexists\" file method");
	println!("\t--write-file : enable \"write\" file method");
	println!("\t--read-file : enable \"read\" file method");
	println!("\t--is-in : enable string contains methods");
*/
	println!("\t--user-input : enable \"raw_input\" file method");
	println!("\t--vectors : enable vector arrays (Main file ONLY)");
	println!("\t--thread : enable threading (Main file and project ONLY)");
	println!("\t--sleep : enable sleep method");
	println!("\t--sub-string : enable sub-string methods");
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

fn get_help(theuser: String, hasargs: bool) -> String
{
	let mut helpmethod = String::new();
	if hasargs == true && theuser == ""
	{
		let get_theuser = get_sys_prop("USER");
		helpmethod.push_str("fn get_exec_name() -> Option<String>\n");
		helpmethod.push_str("{\n");
		helpmethod.push_str("\tstd::env::current_exe()\n");
		helpmethod.push_str("\t.ok()\n");
		helpmethod.push_str("\t.and_then(|pb| pb.file_name().map(|s| s.to_os_string()))\n");
		helpmethod.push_str("\t.and_then(|s| s.into_string().ok())\n");
		helpmethod.push_str("}\n");
		helpmethod.push_str("\n");
		helpmethod.push_str("fn help()\n");
		helpmethod.push_str("{\n");
		helpmethod.push_str("\tlet program_name = get_exec_name().unwrap();\n");
		helpmethod.push_str("\n");
		helpmethod.push_str("\tprintln!(\"Author: ");
		helpmethod.push_str(&get_theuser);
		helpmethod.push_str("\");\n");
		helpmethod.push_str("\tprintln!(\"Program: \\\"");
		helpmethod.push_str("{}");
		helpmethod.push_str("\\\"\",program_name);\n");
		helpmethod.push_str("\tprintln!(\"Version: 0.0.0\");\n");
		helpmethod.push_str("\tprintln!(\"Purpose: \");\n");
		helpmethod.push_str("\tprintln!(\"Usage: ");
		helpmethod.push_str("{}");
		helpmethod.push_str(" <args>\",program_name);\n");
		helpmethod.push_str("}\n\n");
	}
	else if hasargs == true && theuser != ""
	{
		helpmethod.push_str("fn get_exec_name() -> Option<String>\n");
		helpmethod.push_str("{\n");
		helpmethod.push_str("\tstd::env::current_exe()\n");
		helpmethod.push_str("\t.ok()\n");
		helpmethod.push_str("\t.and_then(|pb| pb.file_name().map(|s| s.to_os_string()))\n");
		helpmethod.push_str("\t.and_then(|s| s.into_string().ok())\n");
		helpmethod.push_str("}\n");
		helpmethod.push_str("\n");
		helpmethod.push_str("fn help()\n");
		helpmethod.push_str("{\n");
		helpmethod.push_str("\tlet program_name = get_exec_name().unwrap();\n");
		helpmethod.push_str("\n");
		helpmethod.push_str("\tprintln!(\"Author: ");
		helpmethod.push_str(&theuser);
		helpmethod.push_str("\");\n");
		helpmethod.push_str("\tprintln!(\"Program: \\\"");
		helpmethod.push_str("{}");
		helpmethod.push_str("\\\"\",program_name);\n");
		helpmethod.push_str("\tprintln!(\"Version: 0.0.0\");\n");
		helpmethod.push_str("\tprintln!(\"Purpose: \");\n");
		helpmethod.push_str("\tprintln!(\"Usage: ");
		helpmethod.push_str("{}");
		helpmethod.push_str(" <args>\",program_name);\n");
		helpmethod.push_str("}\n\n");
	}
	else
	{
		helpmethod.push_str("");
	}
	return helpmethod;
}


fn get_imports(get_checkfile: bool, get_readfile: bool, get_writefile: bool, get_cli: bool, get_pipe: bool, get_sysprop: bool, get_thread: bool, get_sleep: bool, get_shell: bool) -> String
{
	let mut theimports = String::new();
	if get_cli == true || get_sysprop == true || get_shell == true
	{
		theimports.push_str("use std::env;\n");
	}
	if get_checkfile == true
	{
		theimports.push_str("use std::path::Path;\n");
	}
	if get_readfile == true && get_writefile == false
	{
		theimports.push_str("use std::fs::File;\nuse std::io::{BufRead, BufReader};\n");
	}
	if get_readfile == false && get_writefile == true
	{
		theimports.push_str("use std::io::Write;\n");
	}
	if get_thread == true || get_sleep == true
	{
		theimports.push_str("use std::thread;\n");
	}
	if get_sleep == true
	{
		theimports.push_str("use std::time;\n");
	}
	if get_readfile == true && get_writefile == true
	{
		theimports.push_str("use std::fs::File;\nuse std::io::{BufRead, BufReader, Write};\n");
	}
	if get_pipe == true && get_readfile == false && get_writefile == false
	{
		theimports.push_str("/*\nThis needs to be a rust project\nIn file 'Cargo.toml', account for the following\n\n[dependencies]\nisatty = \"0.1\"\n\nextern crate isatty;\nuse isatty::{stdin_isatty};\nuse std::io::{self, BufRead};\n*/\n");
	}
	if get_pipe == true && get_readfile == true && get_writefile == true
	{
		theimports.push_str("/*\nThis needs to be a rust project\nIn file 'Cargo.toml', account for the following\n\n[dependencies]\nisatty = \"0.1\"\n\nextern crate isatty;\nuse isatty::{stdin_isatty};\n*/\n");
	}
	if get_shell == true
	{
		theimports.push_str("use std::process::Command;");
	}

	theimports.push_str("\n");
	return theimports;
}

fn get_methods(get_checkfile: bool, get_readfile: bool, get_writefile: bool, get_rawinput: bool, get_sysprop: bool, get_sleep: bool, get_shell: bool, get_rev: bool, get_split: bool, get_join: bool, get_vect: bool, get_substr: bool, get_isin: bool, get_len: bool, get_upper: bool, get_lower: bool) -> String
{
	let mut themethods = String::new();
	if get_rawinput == true
	{
		themethods.push_str("fn raw_input(message: &str) -> String\n{\n\tuse std::io::{stdin,stdout,Write};\n\tlet mut s=String::new();\n\tprint!(\"{}\",message);\n\tlet _=stdout().flush();\n\tstdin().read_line(&mut s).expect(\"Did not enter a correct string\");\n\tif let Some('\\n')=s.chars().next_back() {\n\t\ts.pop();\n\t}\n\tif let Some('\\r')=s.chars().next_back() {\n\t\ts.pop();\n\t}\n\treturn s;\n}\n\n");
	}
	if get_checkfile == true
	{
		themethods.push_str("fn fexists(afile: &str) -> bool\n{\n\treturn Path::new(afile).exists();\n}\n\n");
	}
	if get_readfile == true
	{
		themethods.push_str("fn read_file(filename: String) -> String\n{\n\t// Open the file in read-only mode (ignoring errors).\n\tlet file = File::open(filename).unwrap();\n\tlet reader = BufReader::new(file);\n\n\t// Read the file line by line using the lines() iterator from std::io::BufRead.\n\tfor line in reader.lines()\n\t{\n\t\t// Ignore errors.\n\t\tlet line = line.unwrap();\n\t\t// Show the line and its number.\n\t\tprintln!(\"{}\", line)\n\t}\n}\n\n");
	}
	if get_rev == true
	{
		themethods.push_str("fn rev(theword: &str) -> String\n{\n\tlet mut newstr = String::new();\n\tlet mut plc = 0;\n\tlet charlen = theword.len();\n\twhile plc != charlen\n\t{\n\t\tplc += 1;\n\t\tnewstr.push_str(&theword.chars().nth(charlen - plc).unwrap().to_string());\n\t}\n\treturn newstr;\n}\n\n");
	}
	if get_join == true
	{
		themethods.push_str("fn join(the_str: &Vec<&str>, to_join: &str) -> String\n{\n\treturn the_str.join(to_join);\n}\n\n");
	}
	if get_split == true
	{
		themethods.push_str("fn split_before(the_string: &str, split_at: &str) -> String\n{\n\tlet mut new_string = String::new();\n\tlet end = the_string.len();\n\tlet scount = the_string.matches(split_at).count();\n\n\tif end != 0 && scount != 0\n\t{\n\t\tfor part in the_string.split(split_at)\n\t\t{\n\t\t\tnew_string.push_str(&part.to_string());\n\t\t\tbreak;\n\t\t}\n\t}\n\treturn new_string;\n}\n\n");
		themethods.push_str("fn split_after(the_string: &str, split_at: &str) -> String\n{\n\tlet mut new_string = String::new();\n\tlet end = the_string.len();\n\tlet scount = the_string.matches(split_at).count();\n\tlet mut count = 0;\n\n\tif end != 0 && scount != 0\n\t{\n\t\tfor part in the_string.split(split_at)\n\t\t{\n\t\t\tif count == 1\n\t\t\t{\n\t\t\t\tnew_string.push_str(&part.to_string());\n\t\t\t}\n\t\t\telse if count >= 1\n\t\t\t{\n\t\t\t\tnew_string.push_str(split_at);\n\t\t\t\tnew_string.push_str(&part.to_string());\n\t\t\t}\n\t\t\tcount += 1;\n\t\t}\n\t}\n\treturn new_string;\n}\n\n");
	}
	if  get_substr == true
	{
		themethods.push_str("fn rem_first_and_last(value: &str) -> &str\n{\n\tlet mut chars = value.chars();\n\tchars.next();\n\tchars.next_back();\n\treturn chars.as_str();\n}\n\n");
		themethods.push_str("fn rem_first_char(value: &str, length: u8) -> &str\n{\n\tlet mut chars = value.chars();\n\tif length >= 1\n\t{\n\t\tlet mut cnt = 0;\n\t\twhile cnt != length\n\t\t{\n\t\t\tchars.next();\n\t\t\tcnt += 1;\n\t\t}\n\t}\n\telse\n\t{\n\t\tchars.next();\n\t}\n\n\treturn chars.as_str();\n}\n\n");
		themethods.push_str("fn rem_last_char(value: &str, length: u8) -> &str\n{\n\tlet mut chars = value.chars();\n\tlet mut cnt = 0;\n\tif length >= 1\n\t{\n\t\twhile cnt != length\n\t\t{\n\t\t\tchars.next_back();\n\t\t\tcnt += 1;\n\t\t}\n\t}\n\telse\n\t{\n\t\tchars.next_back();\n\t}\n\n\treturn chars.as_str();\n}\n\n");
	}
	if get_writefile == true
	{
		themethods.push_str("fn write_file(filename: String, thecontent: String)\n{\n\tlet mut file = std::fs::File::create(filename).expect(\"create failed\");\n\tfile.write_all(thecontent.as_bytes()).expect(\"write failed\");\n}\n\n");
	}
	if get_sysprop == true
	{
		themethods.push_str("fn get_sys_prop(please_get: &str) -> String\n{\n\tlet value = match env::var_os(please_get)\n\t{\n\t\tSome(v) => v.into_string().unwrap(),\n\t\tNone => panic!(\"{} is not set\",please_get)\n\t};\n\treturn value;\n}\n\n");
	}
	if get_shell == true
	{
		themethods.push_str("fn get_os() -> String\n{\n\treturn env::consts::OS.to_string();\n}\n\n");
		themethods.push_str("fn run_command(cmd: &str) -> String {\n\tlet output = Command::new(cmd)\n//\t\t\t.arg(\"-l\")\n//\t\t\t.arg(\"-a\")\n\t\t\t.output()\n\t\t\t.expect(\"command failed to start\");\n\t\n\tif output.status.success()\n\t{\n\t\treturn String::from_utf8_lossy(&output.stdout).to_string();\n\t}\n\telse\n\t{\n\t\treturn String::from_utf8_lossy(&output.stderr).to_string();\n\t}\n}\n\n");
	}
	if get_sleep == true
	{
		themethods.push_str("fn sleep()\n{\n\t// 3 * 1000 = 3 sec\n\tlet ten_millis = time::Duration::from_millis(3000);\n\tlet now = time::Instant::now();\n\n\tthread::sleep(ten_millis);\n\n\tassert!(now.elapsed() >= ten_millis);\n}\n\n");
	}
	if get_isin == true
	{
		themethods.push_str("fn contains(str: &str, sub: &str) -> bool\n{\n\tif str.contains(sub)\n\t{\n\t\treturn true;\n\t}\n\telse\n\t{\n\t\treturn false;\n\t}\n}\n\n");
		themethods.push_str("fn starts_with(str: &str, start: &str) -> bool\n{\n\treturn str.starts_with(start);\n}\n\n");
		themethods.push_str("fn ends_with(str: &str, end: &str) -> bool\n{\n\tif str.ends_with(end)\n\t{\n\t\treturn true;\n\t}\n\telse\n\t{\n\t\treturn false;\n\t}\n}\n\n");
	}
	if get_len == true
	{
		themethods.push_str("fn len(message: &str) -> u32\n{\n\tlet thesize = message.len().to_string();\n\treturn thesize.parse().unwrap();\n}\n\n");
		if get_vect == true
		{
			themethods.push_str("fn len_a(vec: Vec<&str>) -> usize\n{\n\treturn vec.len();\n}\n\n");
		}
	}
	if get_upper == true
	{
		themethods.push_str("fn to_uppercase(message: &str) -> String\n{\n\tlet upper = message.to_uppercase();\n\treturn upper;\n}\n\n");
		themethods.push_str("fn to_uppercase_at(message: &str, plc: usize) -> String\n{\n\tlet mut newmsg = String::new();\n\tlet size = message.chars().count();\n\tfor c in 0..size\n\t{\n\t\tlet mut letter = message.chars().nth(c).unwrap();\n\t\tif c == plc\n\t\t{\n\t\t\tletter = letter.to_ascii_uppercase();\n\t\t}\n\t\tnewmsg.push(letter);\n\t}\n\treturn newmsg;\n}\n\n");
	}
	if get_lower == true
	{
		themethods.push_str("fn to_lowercase(message: &str) -> String\n{\n\tlet lower = message.to_lowercase();\n\treturn lower;\n}\n\n");
		themethods.push_str("fn to_lowercase_at(message: &str, plc: usize) -> String\n{\n\tlet mut newmsg = String::new();\n\tlet size = message.chars().count();\n\tfor c in 0..size\n\t{\n\t\tlet mut letter = message.chars().nth(c).unwrap();\n\t\tif c == plc\n\t\t{\n\t\t\tletter = letter.to_ascii_lowercase();\n\t\t}\n\t\tnewmsg.push(letter);\n\t}\n\treturn newmsg;\n}\n\n");
	}

	return themethods;
}

fn get_main(get_main: bool, get_cli: bool, get_pipe: bool, get_thread: bool, get_split: bool, get_vect: bool, get_shell: bool) -> String
{
	let mut themain = String::new();
	if get_main == true
	{
		themain.push_str("fn main()\n{\n");
		if get_cli == true
		{
			themain.push_str("\tlet mut arg_count = 0;\n\t//CLI arguments\n\tfor args in env::args().skip(1)\n\t{\n\t\tprintln!(\"{}\", args);\n\t\targ_count += 1;\n\t}\n\n\t//No CLI Arguments given\n\tif arg_count == 0\n\t{\n\t\t//Show Help Page\n\t\thelp();\n\t}\n");
		}
		if get_pipe == true
		{
			themain.push_str("\n/*\n\tif stdin_isatty() == false\n\t{\n\t\tprintln!(\"[Pipe]\");\n\t\tprintln!(\"{{\");\n\t\tlet stdin = io::stdin();\n\t\tfor line in stdin.lock().lines()\n\t\t{\n\t\t\tprintln!(\"{}\", line.unwrap());\n\t\t}\n\t\tprintln!(\"}}\");\n\t}\n\telse\n\t{\n\t\tprintln!(\"nothing was piped in\");\n\t}\n*/");
		}
		if get_split == true
		{
			themain.push_str("\n/*\n\tlet message = \"This is how we will win the game\";\n\tlet sby = \" \";\n\tlet split: Vec<&str> = message.split(sby).collect();\n*/");
		}
		if get_vect == true
		{
			themain.push_str("\n/*\n\tlet split_message: Vec<&str> = message.split(s_by).collect();\n*/");
		}
		if get_thread == true
		{
			themain.push_str("\n/*\n\t// https://doc.rust-lang.org/std/thread/\n\tlet thread_join_handle = thread::spawn(|| {\n\t\t//do stuff here\n\t});\n\t//join thread\n\tthread_join_handle.join().unwrap();\n*/");
		}
		if get_shell == true
		{
			themain.push_str("\n\tlet output = Command::new(\"ls\")\n\t\t\t.arg(\"-l\")\n\t\t\t.arg(\"-a\")\n\t\t\t.output()\n\t\t\t.expect(\"ls command failed to start\");\n\n\tif output.status.success()\n\t{\n\t\tprintln!(\"{}\", String::from_utf8_lossy(&output.stdout));\n\t}\n\telse\n\t{\n\t\tprintln!(\"{}\", String::from_utf8_lossy(&output.stderr));\n\t}\n");
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
	let mut is_vect = false;
	let mut is_sub_str = false;
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
		else if args == "--vectors"
		{
			is_vect = true;
		}
		else if args == "--sub-string"
		{
			is_sub_str = true;
			is_in = true;
		}
		else if args == "--shell"
		{
			is_shell = true;
		}
		else if args == "--files"
		{
			is_write_file = true;
			is_read_file = true;
			is_check_file = true;
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
*/
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
/*
		else if args == "--is-in"
		{
			is_in = true;
		}
*/
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
			let the_helps = get_help(the_user.to_string(),is_cli);
			program_name.push_str(".rs");
			let the_methods = get_methods(is_check_file, is_read_file, is_write_file, get_input_method, is_prop, is_sleep, is_shell, is_rev, is_split, is_join, is_vect, is_sub_str, is_in, is_len, is_upper, is_lower);
			let the_main = get_main(is_main, is_cli, is_pipe, is_thread, is_split, is_vect, is_shell);
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
