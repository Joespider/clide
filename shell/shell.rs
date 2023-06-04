use std::env;
use std::process::Command;

fn get_help(type_of_help: &str)
{
	let the_type_of_help = split_after(type_of_help,':');
	if the_type_of_help == "class"
	{
		println!("{{Usage}}");
		println!("class:<name> param:<params>,<param> var:<vars> method:<name>-<type> param:<params>,<param>");
		println!("");
		println!("{{EXAMPLE}}");
		println!("class:pizza params:one,two,three method:cheese params:four,five loop:for");
	}
	else if the_type_of_help == "struct"
	{
		println!("struct:<name>-<type> var:<var> var:<var>");
		println!("");
		println!("{{EXAMPLE}}");
		println!("struct:pizza var:topping-String var:number-int");
	}
	else if the_type_of_help == "method"
	{
		println!("method:<name>-<type> param:<params>,<param>");
	}
	else if the_type_of_help == "loop"
	{
		println!("loop:<type>");
		println!("");
		println!("{{EXAMPLE}}");
		println!("loop:for");
		println!("loop:do/while");
		println!("loop:while");

	}
	else if the_type_of_help == "logic"
	{
		println!("logic:<type>");
		println!("");
		println!("{{EXAMPLE}}");
		println!("logic:if");
		println!("logic:else-if");
		println!("logic:switch");
	}
	else if the_type_of_help == "var"
	{
		println!("var:<name>-<type>=value\tcreate a new variable");
		println!("var:<name>=value\tassign a new value to an existing variable");
		println!("");
		println!("{{EXAMPLE}}");
		println!("var:name-String=\"\" var:point-int=0 var:james-String=\"James\" var:help-int");
	}
	else
	{
		println!("Components to Generate");
		println!("class\t\t:\t\"Create a class\"");
		println!("struct\t\t:\t\"Create a struct\"");
		println!("method\t\t:\t\"Create a method\"");
		println!("loop\t\t:\t\"Create a loop\"");
		println!("logic\t\t:\t\"Create a logic\"");
		println!("var\t\t:\t\"Create a variable\"");
		println!("nest-<type>\t:\t\"next element is nested in previous element\"");
		println!("");
		println!("help:<type>");
	}
}

fn banner()
{
	let version = "0.0.11";
//	String cplV = getCplV();
	let the_os = get_os();
//	println!(cplV);
	println!("[Rust {}] on {}", version, the_os);
	println!("Type \"help\" for more information.");
}

fn get_os() -> String
{
	return env::consts::OS.to_string();
}

/*
fn get_sys_prop(please_get: String) -> String
{
	let value = match env::var_os(please_get)
	{
		Some(v) => v.into_string().unwrap(),
		None => panic!("{} is not set",please_get)
	};
	return value;
}
*/

fn is_in(str: &str, sub: &str) -> bool
{
	return str.contains(sub);
}

fn starts_with(str: &str, start: &str) -> bool
{
	return str.starts_with(start);
}

fn split_before(the_string: &str, split_at: char) -> String
{
	let mut new_string = String::new();
	match the_string.split_once(split_at)
	{
		Some((key, _value)) => {
			new_string.push_str(key);
		}
		None => {
			new_string.push_str(&the_string.to_string());
		}
	}
	return new_string;
}

fn split_after(the_string: &str, split_at: char) -> String
{
	let mut new_string = String::new();
	match the_string.split_once(split_at)
	{
		Some((_key, value)) => {
			new_string.push_str(value);
		}
		None => {
			new_string.push_str(&the_string.to_string());
		}
	}
	return new_string;
}
/*
fn ends_with(str: &str, end: &str) -> bool
{
	return str.ends_with(end);
}
*/
fn clear()
{
	Command::new("clear")
		.spawn()
		.expect("clear command failed to start");
}

fn get_struct(name: &str, content: &str) -> String
{
	let mut complete = String::new();
	let the_name = split_after(name,':');
	let struct_var = gen_code("\t",content);
	complete.push_str("struct {\n");
	if struct_var.is_empty() == false
	{
		complete.push_str(&struct_var);
	}
	complete.push_str("\n} ");
	complete.push_str(&the_name);
	complete.push_str(";\n");
	return complete;
}

fn get_class(name: &str, content: &str) -> String
{
	let mut parse_content: String = content.to_string();
	let mut complete = String::new();
	let the_name = split_after(name,':');
	let mut the_params: String = "".to_string();
	let mut class_content = String::new();

	loop
	{
		if starts_with(&parse_content, "params")
		{
			the_params = get_parameters(&parse_content,"class");
		}
		else if starts_with(&parse_content, "method")
		{
			class_content.push_str(&gen_code("\t",&parse_content));
		}

		if is_in(&parse_content, " ")
		{
			parse_content = split_after(&parse_content,' ');
		}
		else
		{
			break;
		}
	}

	println!("{}",the_params);
	complete.push_str("class ");
	complete.push_str(&the_name);
	complete.push_str(" {\n\nprivate:\n\tprivate variables\n\tint x, y;\npublic:\n\t//class constructor\n\t");
	complete.push_str(&the_name);
	complete.push_str("(int x, int y)\n\t{\n\t\tthis->x = x;\n\t\tthis->y = y;\n\t}\n\n");
	complete.push_str(&class_content);
	complete.push_str("\n\t//class desctructor\n\t~");
	complete.push_str(&the_name);
	complete.push_str("()\n\t{\n\t}\n};\n");
	return complete;
}

fn get_method(the_tabs: &str, name: &str, content: &str) -> String
{
	let mut parse_content: String = content.to_string();
	let mut complete = String::new();

	let mut the_name: String = split_before(&name,':');
	let the_type: String;
	let mut the_params = String::new();
	let mut method_content = String::new();
//	let mut last_comp = "";

	if is_in(name, "-")
	{
		the_name = split_before(&the_name,'-');
		the_type = split_after(name,'-');
	}
	else
	{
		the_type = "".to_string();
	}

	loop
	{
		if starts_with(&parse_content, "params")
		{
			the_params.push_str(&get_parameters(&parse_content,"method"));
		}
		else if starts_with(&parse_content, "method") == false && starts_with(&parse_content, "class") == false
		{
			let mut all_tabs = String::new();
			all_tabs.push_str(&the_tabs);
			all_tabs.push_str("\t");
			method_content.push_str(&gen_code(&all_tabs,&parse_content));
		}

		if is_in(&parse_content, " ")
		{
			parse_content = split_after(&parse_content,' ');
		}
		else
		{
			break;
		}
	}

	if the_type.is_empty()
	{
		complete.push_str(the_tabs);
		complete.push_str("fn ");
		complete.push_str(&the_name);
		complete.push_str("(");
		complete.push_str(&the_params);
		complete.push_str(")\n");
		complete.push_str(the_tabs);
		complete.push_str("{\n");
		complete.push_str(&method_content);
		complete.push_str("\n");
		complete.push_str(the_tabs);
		complete.push_str("}\n");
	}
	else
	{
		complete.push_str(the_tabs);
		complete.push_str("fn ");
		complete.push_str(&the_name);
		complete.push_str("(");
		complete.push_str(&the_params);
		complete.push_str(") -> ");
		complete.push_str(&the_type);
		complete.push_str("\n");
		complete.push_str(the_tabs);
		complete.push_str("{\n");
		complete.push_str(the_tabs);
		complete.push_str("\t" );
		complete.push_str("let TheReturn;\n");
		complete.push_str(&method_content);
		complete.push_str("\n");
		complete.push_str(the_tabs);
		complete.push_str("\treturn TheReturn;\n");
		complete.push_str(the_tabs);
		complete.push_str("}\n");
	}
	return complete;
}

fn get_variables(the_tabs: &str, input: &str) -> String
{
	let the_type: String;
	let mut name: String = "".to_string();
	let mut var_type: String = "".to_string();
	let mut the_value: String = "".to_string();
	let mut new_var = String::new();

	if is_in(input,":") && is_in(input,"-") && is_in(input,"=")
	{
		the_type = split_after(input,':');
		name = split_before(&the_type,'-');
		var_type = split_after(&the_type,'-');
		the_value = split_after(&var_type,'=');
		var_type = split_before(&var_type,'=');
	}
	else if is_in(input,":") && is_in(input,"=")
	{
		the_type = split_after(input,':');
		name = split_before(&the_type,'=');
		the_value = split_after(&the_type,'=');
		var_type = "".to_string();
	}
	else if is_in(input,":") && is_in(input,"-")
	{
		the_type = split_after(input,':');
		name = split_before(&the_type,'-');
		var_type = split_after(&the_type,'-');
		the_value = "".to_string();
	}
	else if is_in(input,":")
	{
		the_type = split_after(input,':');
		name = split_before(&the_type,'-');		
	}

	if the_value.is_empty()
	{
		new_var.push_str(&the_tabs);
		new_var.push_str("let ");
		new_var.push_str(&name);
//		new_var.push_str(":");
//		new_var.push_str(&var_type);
		new_var.push_str(";\n");
	}
	else if var_type.is_empty()
	{
		new_var.push_str(&the_tabs);
		new_var.push_str("let ");
		new_var.push_str(&name);
//		new_var.push_str(":");
//		new_var.push_str(&var_type);
		new_var.push_str(" = ");
		new_var.push_str(&the_value);
		new_var.push_str(";\n");
	}
	else
	{
		new_var.push_str(&the_tabs);
		new_var.push_str("let ");
		new_var.push_str(&name);
//		new_var.push_str(":");
//		new_var.push_str(&var_type);
		new_var.push_str(" = ");
		new_var.push_str(&the_value);
		new_var.push_str(";\n");
	}

	return new_var;
}

fn get_conditions(input: &str, _called_by: &str) -> String
{
	let the_type = split_after(input,':');
	return the_type;
}

fn get_parameters(input: &str, _called_by: &str) -> String
{
	let the_type: String = split_after(input,':');
	return the_type;
}

fn get_loop(the_tabs: &str, kind_type: &str, content: &str) -> String
{
	let mut parse_content: String = content.to_string();
	let mut complete = String::new();
	let the_kind_type = split_after(kind_type,':');
	let mut _the_name = split_before(&the_kind_type,'-');
	let mut _the_type = split_after(&the_kind_type,'-');
	let mut the_condition: String = "".to_string();
	let mut loop_content = String::new();

	loop
	{
		if starts_with(&parse_content, "condition")
		{
			the_condition = get_conditions(&parse_content,&the_kind_type);

		}
		else if starts_with(&parse_content, "method") == false && starts_with(&parse_content, "class") == false && starts_with(&parse_content, "nest-")
		{
			parse_content = split_after(&parse_content,'-');
			loop_content.push_str(&gen_code(&(the_tabs.to_owned()+"\t"),&parse_content));
		}

		if is_in(&parse_content, " ")
		{
			parse_content = split_after(&parse_content,' ');
		}
		else
		{
			break;
		}
	}

	if the_kind_type == "for"
	{
		complete.push_str(the_tabs);
		complete.push_str("for ");
		complete.push_str(&the_condition);
		complete.push_str("\n");
		complete.push_str(the_tabs);
		complete.push_str("{\n");
		complete.push_str(the_tabs);
		complete.push_str("\t//do something here\n");
		complete.push_str(&loop_content);
		complete.push_str("\n");
		complete.push_str(the_tabs);
		complete.push_str("}\n");
	}
	else if the_kind_type == "do/while"
	{
		complete.push_str(the_tabs);
		complete.push_str("do\n");
		complete.push_str(the_tabs);
		complete.push_str("{\n");
		complete.push_str(the_tabs);
		complete.push_str("\t//do something here\n");
		complete.push_str(&loop_content);
		complete.push_str(the_tabs);
		complete.push_str("}\n");
		complete.push_str(the_tabs);
		complete.push_str("while ");
		complete.push_str(&the_condition);
		complete.push_str(";\n");
	}
	else
	{
		complete.push_str(the_tabs);
		complete.push_str("while ");
		complete.push_str(&the_condition);
		complete.push_str("\n");
		complete.push_str(the_tabs);
		complete.push_str("{\n");
		complete.push_str(the_tabs);
		complete.push_str("\t//do something here\n");
		complete.push_str(&loop_content);
		complete.push_str(the_tabs);
		complete.push_str("}\n");
	}
	return complete;
}

fn get_logic(the_tabs: &str, kind_type: &str, content: &str) -> String
{
	let mut parse_content: String = content.to_string();
	let mut complete = String::new();
	let the_kind_type = split_after(kind_type,':');
	let _the_name = split_before(&the_kind_type,'-');
	let _the_type = split_after(&the_kind_type,'-');
	let mut the_condition: String = "".to_string();
	let mut logic_nontent = String::new();
	let mut case_content: String = "".to_string();
	let mut case_val: String = "".to_string();

	loop
	{
		if starts_with(content, "condition")
		{
			the_condition = get_conditions(&parse_content,&the_kind_type);
		}
		else if starts_with(content, "method") == false && starts_with(content, "class") == false && starts_with(content, "nest-")
		{
			let mut all_tabs = String::new();
			all_tabs.push_str(the_tabs);
			all_tabs.push_str("\t");
			parse_content = split_after(&parse_content,'-');
			logic_nontent.push_str(&gen_code(&all_tabs,&parse_content));
		}

		if is_in(&parse_content, " ")
		{
			parse_content = split_after(&parse_content,' ');
		}
		else
		{
			break;
		}
	}

	if the_kind_type == "if"
	{
		complete.push_str(the_tabs);
		complete.push_str("if ");
		complete.push_str(&the_condition);
		complete.push_str("\n");
		complete.push_str(the_tabs);
		complete.push_str("{\n");
		complete.push_str(the_tabs);
		complete.push_str("\t//do something here\n");
		complete.push_str(&logic_nontent);
		complete.push_str(the_tabs);
		complete.push_str("}\n");
	}
	else if the_kind_type == "else-if"
	{
		complete.push_str(the_tabs);
		complete.push_str("else if ");
		complete.push_str(&the_condition);
		complete.push_str("\n");
		complete.push_str(the_tabs);
		complete.push_str("{\n");
		complete.push_str(the_tabs);
		complete.push_str("\t//do something here\n");
		complete.push_str(&logic_nontent);
		complete.push_str(the_tabs);
		complete.push_str("}\n");
	}
	else if the_kind_type == "else"
	{
		complete.push_str(the_tabs);
		complete.push_str("else\n");
		complete.push_str(the_tabs);
		complete.push_str("{\n");
		complete.push_str(the_tabs);
		complete.push_str("\t//do something here\n");
		complete.push_str(&logic_nontent);
		complete.push_str(the_tabs);
		complete.push_str("}\n");
	}
	else if the_kind_type == "switch-case"
	{
		complete.push_str(the_tabs);
		complete.push_str("\tmatch (x):\n");
		complete.push_str(the_tabs);
		complete.push_str("\t\t//code here\n");
		complete.push_str(the_tabs);
		complete.push_str("\t\tbreak;");

	}
	else if starts_with(&the_kind_type, "switch")
	{
//		case_content = the_kind_type;
//		case_val = "".to_string();
		println!("{}",case_val);

		complete.push_str(the_tabs);
		complete.push_str("match (");
		complete.push_str(&the_condition);
		complete.push_str(")\n");
		complete.push_str(the_tabs);
		complete.push_str("{\n\n");
		while case_content != ""
		{
			case_val = split_before(&case_content,'-');
			if case_val != "switch"
			{
				complete.push_str(the_tabs);
				complete.push_str("\tmatch ");
				complete.push_str(&case_val);
				complete.push_str(":\n");
				complete.push_str(the_tabs);
				complete.push_str("\t\t//code here\n");
				complete.push_str(the_tabs);
				complete.push_str("\t\tbreak;\n");
			}
			case_content = split_after(&case_content,'-');
		}
		complete.push_str(the_tabs);
		complete.push_str("\tdefault:\n");
		complete.push_str(the_tabs);
		complete.push_str("\t\t//code here\n");
		complete.push_str(the_tabs);
		complete.push_str("\t\tbreak;\n");
		complete.push_str(the_tabs);
		complete.push_str("}\n");
	}
	return complete;
}

fn gen_code(the_tabs: &str,get_me: &str) -> String
{
	let mut the_code = String::new();
	let mut arg1: String = get_me.to_string();
	let mut arg2: String = "".to_string();
	
	if is_in(get_me, " ")
	{
		arg1 = split_before(get_me,' ');
		arg2 = split_after(get_me,' ');
	}

	if starts_with(&arg1, "class")
	{
		the_code.push_str(&get_class(&arg1,&arg2));
	}
	else if starts_with(&arg1, "struct")
	{
		the_code.push_str(&get_struct(&arg1,&arg2));
	}
	else if starts_with(&arg1, "method")
	{
		the_code.push_str(&get_method(the_tabs,&arg1,&arg2));
		the_code.push_str(the_tabs);
	}
	else if starts_with(&arg1, "loop")
	{
		the_code.push_str(&get_loop(the_tabs,&arg1,&arg2));
	}
	else if starts_with(&arg1, "logic")
	{
		the_code.push_str(&get_logic(the_tabs,&arg1,&arg2));
	}
	else if starts_with(&arg1, "var")
	{
		the_code.push_str(&get_variables(the_tabs,&arg1));
		the_code.push_str(&gen_code(the_tabs,&arg2));
	}
	else if starts_with(&arg1, "condition")
	{
		the_code = get_conditions(&arg1,"");
	}
	else if starts_with(&arg1, "the_params")
	{
		the_code = get_parameters(&arg1,"");
	}

	return the_code;
}

fn raw_input(message: String) -> String
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

//Rust main
fn main()
{
	banner();
	let mut user_in: String;
	let mut content: String;

	loop
	{
		user_in = raw_input(">>> ".to_string());
		if user_in == "exit()"
		{
			break;
		}
		else if user_in == "exit"
		{
			println!("Use exit()");
		}
		else if user_in == "clear"
		{
			clear();
		}
		else if starts_with(&user_in, "help")
		{
			get_help(&user_in);
		}
		else
		{
			content = gen_code("",&user_in);
			if content != ""
			{
				println!("{}",content);
			}
		}
	}
}
