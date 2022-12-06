use std::env;
use std::path::Path;
use std::thread;
use std::time;
use std::fs::File;
use std::io::{BufRead, BufReader, Write};
/*
This needs to be a rust project
In file 'Cargo.toml', account for the following

[dependencies]
isatty = "0.1"

extern crate isatty;
use isatty::{stdin_isatty};
*/

fn help()
{
	println!("Author: joespider");
	println!("Program: \"shell\"");
	println!("Version: 0.0.0");
	println!("Purpose: ");
	println!("Usage: shell <args>");
}

fn raw_input(message: &str) -> String
{
	use std::io::{stdin,stdout,Write};
	let mut s=String::new();
	print!("{}",message);
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

fn fexists(afile: &str) -> bool
{
	return Path::new(afile).exists();
}

fn read_file(filename: String) -> String
{
	// Open the file in read-only mode (ignoring errors).
	let file = File::open(filename).unwrap();
	let reader = BufReader::new(file);

	// Read the file line by line using the lines() iterator from std::io::BufRead.
	for line in reader.lines()
	{
		// Ignore errors.
		let line = line.unwrap();
		// Show the line and its number.
		println!("{}", line)
	}
}

fn rev(theword: &str) -> String
{
	let mut newstr = String::new();
	let mut plc = 0;
	let charlen = theword.len();
	while plc != charlen
	{
		plc += 1;
		newstr.push_str(&theword.chars().nth(charlen - plc).unwrap().to_string());
	}
	return newstr;
}

fn write_file(filename: String, thecontent: String)
{
	let mut file = std::fs::File::create(filename).expect("create failed");
	file.write_all(thecontent.as_bytes()).expect("write failed");
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

fn sleep()
{
	// 3 * 1000 = 3 sec
	let ten_millis = time::Duration::from_millis(3000);
	let now = time::Instant::now();

	thread::sleep(ten_millis);

	assert!(now.elapsed() >= ten_millis);
}

fn contains(str: &str, sub: &str) -> bool
{
	if str.contains(sub)
	{
		return true;
	}
	else
	{
		return false;
	}
}

fn startswith(str: &str, start: &str) -> bool
{
	if str.starts_with(start)
	{
		return true;
	}
	else
	{
		return false;
	}
}

fn endswith(str: &str, end: &str) -> bool
{
	if str.ends_with(end)
	{
		return true;
	}
	else
	{
		return false;
	}
}

fn len(message: &str) -> u32
{
	let thesize = message.len().to_string();
	return thesize.parse().unwrap();
}

fn touppercase(message: &str) -> String
{
	let upper = message.to_uppercase();
	return upper;
}

fn touppercase_at(message: &str, plc: usize) -> String
{
	let mut newmsg = String::new();
	let size = message.chars().count();
	for c in 0..size
	{
		let mut letter = message.chars().nth(c).unwrap();
		if c == plc
		{
			letter = letter.to_ascii_uppercase();
		}
		newmsg.push(letter);
	}
	return newmsg;
}

fn tolowercase(message: &str) -> String
{
	let lower = message.to_lowercase();
	return lower;
}

fn tolowercase_at(message: &str, plc: usize) -> String
{
	let mut newmsg = String::new();
	let size = message.chars().count();
	for c in 0..size
	{
		let mut letter = message.chars().nth(c).unwrap();
		if c == plc
		{
			letter = letter.to_ascii_lowercase();
		}
		newmsg.push(letter);
	}
	return newmsg;
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

	//No CLI Arguments given
	if arg_count == 1
	{
		//Show Help Page
		help();
	}

/*
	if stdin_isatty() == false
	{
		println!("[Pipe]");
		println!("{{");
		let stdin = io::stdin();
		for line in stdin.lock().lines()
		{
			println!("{}", line.unwrap());
		}
		println!("}}");
	}
	else
	{
		println!("nothing was piped in");
	}
*/
/*
	let message = "This is how we will win the game";
	let sby = " ";
	let split: Vec<&str> = message.split(sby).collect();
*/
/*
	//Needs to be Vec<&str>
	let joined = split.join("-");
*/
/*
	// https://doc.rust-lang.org/std/thread/
	let thread_join_handle = thread::spawn(|| {
		//do stuff here
	});
	//join thread
	thread_join_handle.join().unwrap();
*/
}
