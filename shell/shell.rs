use std::env;
use std::process::Command;

fn get_help(type_of_help: &str)
{
	let the_type_of_help = split_after(type_of_help,":");
	match the_type_of_help.as_str()
	{
		"class" =>
		{
			println!("{{Usage}}");
			println!("class:<name> param:<params>,<param> var:<vars> method:<name>-<type> param:<params>,<param>");
			println!("");
			println!("{{EXAMPLE}}");
			println!("class:pizza params:one,two,three method:cheese params:four,five loop:for");
		}
		"struct" =>
		{
			println!("struct:<name>-<type> var:<var> var:<var>");
			println!("");
			println!("{{EXAMPLE}}");
			println!("struct:pizza var:topping-String var:number-int");
		}
		"method" =>
		{
			println!("method:<name>-<type> param:<params>,<param>");
		}
		"loop" =>
		{
			println!("loop:<type>");
			println!("");
			println!("{{EXAMPLE}}");
			println!("loop:for");
			println!("loop:do/while");
			println!("loop:while");
	
		}
		"logic" =>
		{
			println!("logic:<type>");
			println!("");
			println!("{{EXAMPLE}}");
			println!("logic:if");
			println!("logic:else-if");
			println!("logic:switch");
		}
		"var" =>
		{
			println!("var:<name>-<type>=value\tcreate a new variable");
			println!("var:<name>-<type>[<num>]=value\tcreate a new variable as an array");
			println!("var:<name>-<type>(<struct>)=value\tcreate a new variable a data structure");
			println!("var:<name>=value\tassign a new value to an existing variable");
			println!("");
			println!("{{EXAMPLE}}");
			println!("var:name-std::string[3]");
			println!("var:name-std::string(vector)");
			println!("var:name-std::string=\"\" var:point-int=0 var:james-std::string=\"James\" var:help-int");
		}
		_other =>
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
}

fn banner()
{
	let version = "0.0.20";
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

fn split_before(the_string: &str, split_at: &str) -> String
{
	let mut new_string = String::new();
	let end = the_string.len();
	let scount = the_string.matches(split_at).count();

	if end != 0 && scount != 0
	{
		for part in the_string.split(split_at)
		{
			new_string.push_str(&part.to_string());
			break;
		}
	}
	return new_string;
}

fn split_after(the_string: &str, split_at: &str) -> String
{
	let mut new_string = String::new();
	let end = the_string.len();
	let scount = the_string.matches(split_at).count();
	let mut count = 0;

	if end != 0 && scount != 0
	{
		for part in the_string.split(split_at)
		{
			if count == 1
			{
				new_string.push_str(&part.to_string());
			}
			else if count >= 1
			{
				new_string.push_str(split_at);
				new_string.push_str(&part.to_string());
			}
			count += 1;
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

fn conver_vars_for_struct(vars: &str) -> String
{
	let mut new: String;
	let mut new_struct_vars = String::new();
	let lines = vars.lines();
	for line in lines {
		new = split_after(line," ");
		new = split_before(&new,";");
		new_struct_vars.push_str("\t");
		new_struct_vars.push_str(&new);
		new_struct_vars.push_str(",\n");
	}
	new_struct_vars.pop();
	new_struct_vars.pop();
	new_struct_vars.push_str(",\n");
	return new_struct_vars;
}

fn get_struct(name: &str, content: &str) -> String
{
	let mut complete = String::new();
	let the_name = split_after(name,":");
	let mut struct_var = gen_code("\t",content);
	struct_var = conver_vars_for_struct(&struct_var);
	complete.push_str("struct ");
	complete.push_str(&the_name);
	complete.push_str(" {");
	if struct_var.is_empty() == false
	{
		complete.push_str("\n");
		complete.push_str(&struct_var);
	}
	else
	{
		complete.push_str("\n");
	}
	complete.push_str("}\n");
	return complete;
}

fn get_class(name: &str, content: &str) -> String
{
	let mut parse_content: String = content.to_string();
	let mut complete = String::new();
	let the_name = split_after(name,":");
	let mut the_params: String = "".to_string();
	let mut class_content = String::new();
//	let mut the_process: String = "".to_string();

	loop
	{
		if starts_with(&parse_content, "params")
		{
//			the_process = split_before(&parse_content," ");
//			the_params = get_parameters(&parse_content,"class");
			the_params = get_parameters(&split_before(&parse_content," "),"class");
		}
		else if starts_with(&parse_content, "method")
		{
			class_content.push_str(&gen_code("\t",&parse_content));
		}

		if is_in(&parse_content, " ")
		{
			parse_content = split_after(&parse_content," ");
		}
		else
		{
			break;
		}
	}
/*
struct Dog;
impl Dog {
 fn bark(&self) {
   println!(“baf!”);
 }
}
*/
	println!("{}",the_params);
	complete.push_str("struct ");
	complete.push_str(&the_name);
	complete.push_str(";\n");
	complete.push_str("impl ");
	complete.push_str(&the_name);
	complete.push_str(" {\n");
	complete.push_str(&class_content);
	complete.push_str("\n}\n");
	return complete;
}

fn get_method(the_tabs: &str, name: &str, content: &str) -> String
{
	let mut parse_content: String = content.to_string();
	let mut complete = String::new();
	let mut the_name: String = split_after(&name,":");
	let the_type: String;
	let mut the_params = String::new();
	let mut method_content = String::new();
//	let mut the_process: String = "".to_string();
//	let mut last_comp = "";

	if is_in(name, "-")
	{
		the_name = split_before(&the_name,"-");
		the_type = split_after(name,"-");
	}
	else
	{
		the_type = "".to_string();
	}

	loop
	{
		if starts_with(&parse_content, "params")
		{
//			the_params.push_str(&get_parameters(&parse_content,"method"));
			the_params.push_str(&get_parameters(&split_before(&parse_content," "),"method"));
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
			parse_content = split_after(&parse_content," ");
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
		complete.push_str("let mut TheReturn: ");
		complete.push_str(&the_type);
		complete.push_str(";\n");
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
		the_type = split_after(input,":");
		name = split_before(&the_type,"-");
		var_type = split_after(&the_type,"-");
		the_value = split_after(&var_type,"=");
		var_type = split_before(&var_type,"=");
	}
	else if is_in(input,":") && is_in(input,"=")
	{
		the_type = split_after(input,":");
		name = split_before(&the_type,"=");
		the_value = split_after(&the_type,"=");
		var_type = "".to_string();
	}
	else if is_in(input,":") && is_in(input,"-")
	{
		the_type = split_after(input,":");
		name = split_before(&the_type,"-");
		var_type = split_after(&the_type,"-");
		the_value = "".to_string();
	}
	else if is_in(input,":")
	{
		the_type = split_after(input,":");
		name = split_before(&the_type,"-");		
	}

	if the_value.is_empty()
	{
		new_var.push_str(&the_tabs);
		new_var.push_str("let ");
		new_var.push_str(&name);
		new_var.push_str(": ");
		new_var.push_str(&var_type);
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
	let the_type = split_after(input,":");
	return the_type;
}

fn get_parameters(input: &str, called_by: &str) -> String
{
	let mut the_param: String = split_after(&input,":");
	if called_by == "class" || called_by == "method"
	{
                if is_in(&the_param,"-") && is_in(&the_param,",")
                {
			let the_name: String = split_before(&the_param,"-");
			let mut the_type: String = split_after(&the_param,"-");
			the_type = split_before(&the_type,",");
			let mut the_more: String = split_after(&the_param,",");
			let mut ever_more = String::new();
			ever_more.push_str("params:");
			ever_more.push_str(&the_more);
			the_more = get_parameters(&ever_more,called_by);
			the_param = the_type;
			the_param.push_str(" ");
			the_param.push_str(&the_name);
			the_param.push_str(", ");
			the_param.push_str(&the_more);
                }
                else if is_in(&the_param,"-") && !is_in(&the_param,",")
                {
			let the_name: String = split_before(&the_param,"-");
			let the_type: String = split_after(&the_param,"-");
			the_param = the_type;
			the_param.push_str(" ");
			the_param.push_str(&the_name);

                }
	}
	return the_param;
}

fn get_loop(the_tabs: &str, kind_type: &str, content: &str) -> String
{
	let mut parse_content: String = content.to_string();
	let mut complete = String::new();
	let the_kind_type = split_after(kind_type,":");
	let mut _the_name = split_before(&the_kind_type,"-");
	let mut _the_type = split_after(&the_kind_type,"-");
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
			parse_content = split_after(&parse_content,"-");
			loop_content.push_str(&gen_code(&(the_tabs.to_owned()+"\t"),&parse_content));
		}

		if is_in(&parse_content, " ")
		{
			parse_content = split_after(&parse_content," ");
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
	let the_kind_type = split_after(kind_type,":");
	let _the_name = split_before(&the_kind_type,"-");
	let _the_type = split_after(&the_kind_type,"-");
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
			parse_content = split_after(&parse_content,"-");
			logic_nontent.push_str(&gen_code(&all_tabs,&parse_content));
		}

		if is_in(&parse_content, " ")
		{
			parse_content = split_after(&parse_content," ");
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
			case_val = split_before(&case_content,"-");
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
			case_content = split_after(&case_content,"-");
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
		arg1 = split_before(get_me," ");
		arg2 = split_after(get_me," ");
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
	let mut user_in: String;
	let mut content: String;
	let mut arg_pull = String::new();
	let mut arg_count = 0;

	//CLI arguments
	for args in env::args().skip(1)
	{
		arg_pull.push_str(&args);
		arg_pull.push_str(" ");
		arg_count += 1;
	}
	
	if arg_count == 0
	{
		banner();
	}
	else
	{
	}

	loop
	{
		//No CLI Arguments given
		if arg_count == 0
		{
			user_in = raw_input(">>> ".to_string());
		}
		else
		{
			user_in = arg_pull.trim().to_string();
		}

		if !user_in.is_empty()
		{
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
		if arg_count > 0
		{
			break;
		}
	}
}
