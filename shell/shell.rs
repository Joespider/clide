use std::env;
use std::process::Command;

fn get_os() -> String
{
	return env::consts::OS.to_string();
}

fn the_help(the_type: &str)
{
	let mut new_the_type: String = the_type.to_string();

	if is_in(&new_the_type,":")
	{
		new_the_type = after_split(&new_the_type,":");
	}

	if new_the_type == "class"
	{
		println!("{{Usage}}");
		println!("{}:<name> param:<params>,<param> var(public/private):<vars> method:<name>-<type> param:<params>,<param>",new_the_type);
		println!("");
		println!("{{EXAMPLE}}");
		println!("{}:pizza params:one-int,two-bool,three-float var(private):toppings-int method:cheese-std::string params:four-int,five-int loop:for nest-loop:for",new_the_type);
	}
	else if new_the_type == "struct"
	{
		println!("{}:<name>-<type> var:<var> var:<var>",new_the_type);
		println!("");
		println!("{{EXAMPLE}}");
		println!("{}:pizza var:topping-std::string var:number-int",new_the_type);
	}
	else if new_the_type == "method"
	{
		println!("{}(public/private):<name>-<type> param:<params>,<param>",new_the_type);
		println!("{}:<name>-<type> param:<params>,<param>",new_the_type);
	}
	else if new_the_type == "loop"
	{
		println!("{}:<type>",new_the_type);
		println!("");
		println!("{{EXAMPLE}}");
		println!("{}:for",new_the_type);
		println!("{}:do/while",new_the_type);
		println!("{}:while",new_the_type);

	}
	else if new_the_type == "logic"
	{
		println!("{}:<type>",new_the_type);
		println!("");
		println!("{{EXAMPLE}}");
		println!("{}:if",new_the_type);
		println!("{}:else-if",new_the_type);
		println!("{}:switch",new_the_type);
	}
	else if new_the_type == "var"
	{
		println!("{}(public/private):<name>-<type>=value\tcreate a new variable",new_the_type);
		println!("{}:<name>-<type>[<num>]=value\tcreate a new variable as an array",new_the_type);
		println!("{}:<name>-<type>(<struct>)=value\tcreate a new variable a data structure",new_the_type);
		println!("{}:<name>=value\tassign a new value to an existing variable",new_the_type);

		println!("");
		println!("{{EXAMPLE}}");
		println!("{}:name-std::string[3]",new_the_type);
		println!("{}:name-std::string(vector)",new_the_type);
		println!("{}:name-std::string=\"\" var:point-int=0 stmt:endline var:james-std::string=\"James\" stmt:endline var:help-int",new_the_type);
	}
	else if new_the_type == "stmt"
	{
		println!("{}:<type>",new_the_type);
		println!("{}:endline\t\tPlace the \";\" at the end of the statement",new_the_type);
		println!("{}:newline\t\tPlace and empty line",new_the_type);
		println!("{}:method-<name>\tcall a method and the name of the method",new_the_type);
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
		println!("stmt\t\t:\t\"Create a statment\"");
		println!("nest-<type>\t:\t\"next element is nested in previous element\"");
		println!("");
		println!("help:<type>");
	}
}

/*
fn clear()
{
	shellExe("clear");
}
*/

fn get_cpl_version() -> String
{
	let mut the_version = String::new();
	let rustc_version = Command::new("rustc").arg("--version").output().expect("command failed to start");
	let cargo_version = Command::new("cargo").arg("--version").output().expect("command failed to start");
	
	if (rustc_version.status.success()) && (cargo_version.status.success())
	{
		let rustc = String::from_utf8_lossy(&rustc_version.stdout).to_string();
		let cargo = String::from_utf8_lossy(&cargo_version.stdout).to_string();
		the_version.push_str(&rustc);
		the_version.push_str(" & ");
		the_version.push_str(&cargo);
		return the_version;
	}
	else
	{
		return String::from_utf8_lossy(&rustc_version.stderr).to_string();
	}
}

fn is_in(str: &str, sub: &str) -> bool
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

fn starts_with(the_string: &str, start: &str) -> bool
{
	if the_string.starts_with(start)
	{
		return true;
	}
	else
	{
		return false;
	}
}

fn ends_with(the_string: &str, end: &str) -> bool
{
	if the_string.ends_with(end)
	{
		return true;
	}
	else
	{
		return false;
	}
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

/*
int len(std::vector<String> Vect)
{
	int StrLen = Vect.size();
	return StrLen;
}

fn len(message: &str) -> u32
{
	let thesize = message.len().to_string();
	return thesize.parse().unwrap();
}
*/

fn before_split(the_string: &str, split_at: &str) -> String
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

fn after_split(the_string: &str, split_at: &str) -> String
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
				new_string.push_str(&split_at);
				new_string.push_str(&part.to_string());
			}
			count += 1;
		}
	}
	return new_string;
}
/*
fn join(std::vector<String> Str, String ToJoin) -> String
{
	String NewString;
	int end;
	end = Str.size();
	NewString = Str[0];

	for (int lp = 1; lp < end; lp++)
	{
		NewString = NewString + ToJoin + Str[lp];
	}
	return NewString;
}
*/
fn replace_all(message: &str, s_by: &str, j_by: &str) -> String
{
	let mut new_message = String::from("");
	let split_message: Vec<&str> = message.split(s_by).collect();
	for item in &split_message
	{
		if new_message == ""
		{
			new_message.push_str(item);
		}
		else
		{
			new_message.push_str(j_by);
			new_message.push_str(item);
		}
	}
	return new_message;
}


/*
	----[shell]----
*/


fn replace_tag(the_content: &str, the_tag: &str) -> String
{
	let mut the_new_content = String::from("");
	let passed_content = the_content.to_string();

	if is_in(&passed_content," ") && starts_with(&passed_content, the_tag)
	{
		let mut new_content = String::new();
		let mut the_next: String;

		let all: Vec<&str> = passed_content.split(" ").collect();
		for item in &all
		{
			the_next = item.to_string();
			//element starts with tag
			if starts_with(&the_next, the_tag)
			{
				//remove tag
				the_next = after_split(&the_next,"-");
			}

			if new_content == ""
			{
				new_content.push_str(&the_next);
			}
			else
			{
				new_content.push_str(" ");
				new_content.push_str(&the_next);
			}
		}
		the_new_content = new_content;
	}
	//Parse Content as long as there is a Tag found at the beginning
	else if !is_in(&passed_content," ") && starts_with(&passed_content, the_tag)
	{
		//removing tag
		the_new_content = after_split(&passed_content,"-");
	}

	if the_new_content == ""
	{
		the_new_content = passed_content.clone();
	}
	return the_new_content;
}

fn banner()
{
	let cpl_version = get_cpl_version();
	let the_os = get_os();
	let version = "0.0.20";
	println!("{}",cpl_version);
	println!("[Rust {}] on {}",version,the_os);
	println!("Type \"help\" for more information.");
}

/*
//<<shell>> method:TranslateTag-String params:Input-String method-var:Action-String="" method-stmt:endline method-var:Value-String="" method-stmt:endline method-var:NewTag-String="" method-stmt:endline method-var:TheDataType-String="" method-stmt:endline method-var:Nest-String="" method-stmt:endline method-var:ContentFor-String="" method-stmt:endline method-stmt:newline logic:if logic-condition:IsIn(Input,":") logic:else method-stmt:newline loop:while loop-condition:StartsWith(Action,">") method-stmt:newline logic:else-if logic-condition:StartsWith(Action,"lg-") method-stmt:newline logic:else-if logic-condition:StartsWith(Action,"lp-") method-stmt:newline logic:else-if logic-condition:StartsWith(Action,"m-") method-stmt:newline logic:if logic-condition:Action(-eq)"if"(-or)Action(-eq)"else-if" logic:else-if logic-condition:Action(-eq)"else" logic:else-if logic-condition:Action(-eq)"while"(-or)Action(-eq)"for"(or)Action(-eq)"do/while" logic:else logic-nest-logic:if logic-condition:Value(-ne)"" logic-nest-logic:else
*/

//<<shell>> method:DataType-String params:Type-String,CalledBy-String logic:if condition:Type(-eq)"String"(-or)Type(-eq)"std::string" logic-var:TheReturn="String" logic-stmt:endline logic:else-if condition:Type(-eq)"boolean" logic-var:Type="bool" logic-stmt:endline logic:else logic-var:TheReturn=Type logic-stmt:endline
fn data_type(the_type: &str, called_by: &str) -> String
{
	println!("Called By: {}",called_by);
	if the_type == "String" || the_type == "std::string"
	{
		return "String".to_string();
	}
	else if the_type == "boolean"
	{
		return "bool".to_string();
	}
	else
	{
		return the_type.to_string();
	}
}

fn gen_conditions(input: &str,called_by: &str) -> String
{
	let mut condit = after_split(&input,":");

	if is_in(&condit,"(-eq)")
	{
		condit = replace_all(&condit, "(-eq)"," == ");
	}

	if is_in(&condit,"(-or)")
	{
		condit = replace_all(&condit, "(-or)"," || ");
	}

	if is_in(&condit,"(-and)")
	{
		condit = replace_all(&condit, "(-and)"," && ");
	}

	if is_in(&condit,"(-not)")
	{
		condit = replace_all(&condit, "(-not)","!");
	}

	if is_in(&condit,"(-ge)")
	{
		condit = replace_all(&condit, "(-ge)"," >= ");
	}

	if is_in(&condit,"(-gt)")
	{
		condit = replace_all(&condit, "(-gt)"," > ");
	}

	if is_in(&condit,"(-le)")
	{
		condit = replace_all(&condit, "(-le)"," <= ");
	}

	if is_in(&condit,"(-lt)")
	{
		condit = replace_all(&condit, "(-lt)"," < ");
	}

	if is_in(&condit,"(-ne)")
	{
		condit = replace_all(&condit, "(-ne)"," != ");
	}

	if is_in(&condit,"(-spc)")
	{
		condit = replace_all(&condit, "(-spc)"," ");
	}
/*
	if starts_with(condit, "(")
	{
		condit = condit[1:len(Condit)]
	}

	if ends_with(condit, ")")
	{
		condit = condit[:len(Condit)-1]
	}
*/
	if called_by == "class"
	{
		println!("condition: {}",called_by);
	}
	else if called_by == "method"
	{
		println!("condition: {}",called_by);
	}
	else if called_by == "loop"
	{
		println!("condition: {}", called_by);
	}
	return condit;
}

//params:
fn gen_parameters(input: &str, called_by: &str) -> String
{
	let name: String;
	let the_params = after_split(input,":");
	let mut new_params = String::new();
	if called_by == "class" || called_by == "method" || called_by == "stmt"
	{
		//param-type,param-type,param-type
		if is_in(&the_params,"-") && is_in(&the_params,",")
		{
			//param
			name = before_split(&the_params,"-");
			//type,param-type,param-type
			let mut the_type = after_split(&the_params,"-");
			//type
			the_type = before_split(&the_type,",");
			the_type = data_type(&the_type, "params");

			//param-type,param-type
			//recursion to get more parameters
			let more: String = gen_parameters(&["params:",&after_split(&the_params,",")].concat(),called_by);

			//param: type, param: type, param: type
			new_params.push_str(&name);
			new_params.push_str(": ");
			new_params.push_str(&the_type);
			new_params.push_str(", ");
			new_params.push_str(&more);
		}
		//param-type
		else if is_in(&the_params,"-") && !is_in(&the_params,",")
		{
			name = before_split(&the_params,"-");
			let mut the_type = after_split(&the_params,"-");
			the_type = data_type(&the_type, "params");

			//param: type
			new_params.push_str(&name);
			new_params.push_str(": ");
			new_params.push_str(&the_type);
		}
	}
	return new_params;
}

fn gen_struct(the_name: &str, the_content: &str) -> String
{
	let mut the_complete = String::new();
	let mut struct_var = String::new();
	let mut the_process: String;
//	let new_name = after_split(the_name,":");
	let mut passed_content = the_content.to_string();

	while starts_with(&passed_content, "var")
	{
		the_process = before_split(&passed_content," ");
		passed_content = after_split(&passed_content," ");
		struct_var.push_str(&gen_code("\t",&the_process));
	}
	the_complete.push_str("struct {\n");
	the_complete.push_str(&struct_var);
	the_complete.push_str("\n} ");
	the_complete.push_str(&the_name);
	the_complete.push_str(";\n");

	return the_complete;
}

fn gen_class(the_name: &str, the_content: &str) -> String
{
	let mut the_complete = String::new();
	let mut the_private_vars = String::new();
	let mut the_public_vars = String::new();
	let mut var_content = String::new();

/*
	String PublicOrPrivate = "";
	if (starts_with(the_name,"class("))
	if (is_in(the_name,")"))
	{
		PublicOrPrivate = after_split(the_name,"(");
		PublicOrPrivate = before_split(PublicOrPrivate,")");
	}
*/

//	let new_name = after_split(the_name,":");
	let mut the_process: String;
	let mut the_params = String::from("");
	let mut class_content = String::new();
	let mut passed_content = the_content.to_string();

	while passed_content != ""
	{
		if starts_with(&passed_content, "params") && the_params == ""
		{
			the_process = before_split(&passed_content," ");
			the_params = gen_parameters(&the_process,"class");
		}
		else if starts_with(&passed_content, "method")
		{
			class_content.push_str(&gen_code("\t",&passed_content));
		}
		else if starts_with(&passed_content, "var")
		{
			if starts_with(&passed_content, "var(public)")
			{
				passed_content = after_split(&passed_content,")");
				var_content.push_str("var");
				var_content.push_str(&before_split(&passed_content," "));
				the_public_vars.push_str(&gen_code("\t",&var_content));
			}
			else if starts_with(&passed_content, "var(private)")
			{
				passed_content = after_split(&passed_content,")");
				var_content.push_str("var");
				var_content.push_str(&before_split(&passed_content," "));
				the_private_vars.push_str(&gen_code("\t",&var_content));
			}
		}

		if is_in(&passed_content," ")
		{
			passed_content = after_split(&passed_content," ");
		}
		else
		{
			break;
		}
	}

	if the_private_vars != ""
	{
		the_private_vars.push_str("private:\n\t//private variables\n");
//		the_private_vars.push_str(&the_private_vars);
		the_private_vars.push_str("\n");
	}
	if the_public_vars != ""
	{
		the_public_vars.push_str("\n\t//public variables\n");
//		the_public_vars.push_str(&the_public_vars);
	}
	the_complete.push_str("class ");
	the_complete.push_str(&the_name);
	the_complete.push_str(" {\n\n");
	the_complete.push_str(&the_private_vars);
	the_complete.push_str("public:");
	the_complete.push_str(&the_public_vars);
	the_complete.push_str("\n\t//class constructor\n\t");
	the_complete.push_str(&the_name);
	the_complete.push_str("(");
	the_complete.push_str(&the_params);
	the_complete.push_str(")\n\t{\n\t\tthis->x = x;\n\t\tthis->y = y;\n\t}\n\n");
	the_complete.push_str(&class_content);
	the_complete.push_str("\n\t//class desctructor\n\t~");
	the_complete.push_str(&the_name);
	the_complete.push_str("()\n\t{\n\t}\n};\n");

	return the_complete;
}

//method:
fn gen_method(the_tabs: &str, name: &str, the_content: &str) -> String
{
	let mut the_last = false;
	let mut can_split = true;
	let new_tabs = [the_tabs,"\t"].concat();
	let mut the_complete = String::new();
	let new_name = after_split(name,":");
	let the_name: String;
	let mut the_type = String::new();
	let mut the_params = String::new();
	let mut method_content = String::new();
	let mut the_process = String::new();
	let mut passed_content = the_content.to_string();
	let mut the_other_content = String::from("");
	let mut new_content = String::from("");

	//method:<name>-<type>
	if is_in(&new_name,"-")
	{
		//get method name
		the_name = before_split(&new_name,"-");
		the_type.push_str(&after_split(&new_name,"-"));
	}
	//method:<name>
	else
	{
		//get method name
		the_name = new_name.clone();
	}

	while passed_content != ""
	{
		if starts_with(&passed_content, "params") && the_params == ""
		{
			if is_in(&passed_content," ")
			{
				the_process.push_str(&before_split(&passed_content," "));
			}
			else
			{
				the_process = passed_content.clone();
			}
			the_params = gen_parameters(&the_process,"method");
		}
		//ignore content if calling a "method" or a "class"
		else if starts_with(&passed_content, "method:") || starts_with(&passed_content, "class:")
		{
			break;
		}
		else
		{
			//This is called when a called from the "class" method
			// EX: class:name method:first method:second
			if is_in(&passed_content," method:")
			{
				//Only account for the first method content
				let cmds: Vec<&str> = passed_content.split(" method:").collect();
				passed_content = cmds[0].to_string();
			}

			if starts_with(&passed_content, "method-")
			{
				let all: Vec<&str> = passed_content.split(" ").collect();

				let mut no_more = false;
				for item in &all
				{
					if starts_with(item, "method-") && no_more == false
					{
						if the_other_content == ""
						{
							the_other_content.push_str(item);
						}
						else
						{
							the_other_content.push_str(" ");
							the_other_content.push_str(item);
						}
					}
					else
					{
						if new_content == ""
						{
							new_content.push_str(item);
						}
						else
						{
							new_content.push_str(" ");
							new_content.push_str(item);
						}
						no_more = true;
					}
				}
				can_split = false;
			}
			else
			{
				the_other_content = passed_content.clone();
				can_split = true;
			}

			the_other_content = replace_tag(&the_other_content, "method-");

			let mut parse_content = String::from("");

			let cmds: Vec<&str> = the_other_content.split(" ").collect();
			for item in &cmds
			{
				//starts with "logic:" or "loop:"
				if starts_with(item,"logic:") || starts_with(item,"loop:") || starts_with(item,"var:") || starts_with(item,"stmt:")
				{
					//Only process code that starts with "logic:" or "loop:"
					if parse_content != ""
					{
						//process content
						method_content.push_str(&gen_code(&new_tabs,&parse_content));
					}
					//Reset content
					parse_content = String::from("");
					parse_content.push_str(item);
				}
				//start another line to process
				else
				{
					//append content
					parse_content.push_str(" ");
					parse_content.push_str(item);
				}
			}

			//process the rest
			if parse_content != ""
			{
				the_other_content = parse_content.clone();
			}

			method_content.push_str(&gen_code(&new_tabs,&the_other_content));
			passed_content = new_content.clone();

			the_other_content = "".to_string();
			new_content = "".to_string();
		}

		if the_last == true
		{
			break;
		}

		if is_in(&passed_content," ")
		{
			if can_split == true
			{
				passed_content = after_split(&passed_content," ");
			}
		}
		else
		{
			passed_content = "".to_string();
			the_last = true;
		}
	}

	//build method based on content
	if the_type == "" || the_type == "void"
	{
		the_complete.push_str(the_tabs);
		the_complete.push_str("fn ");
		the_complete.push_str(&the_name);
		the_complete.push_str("(");
		the_complete.push_str(&the_params);
		the_complete.push_str(")\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("{\n");
		the_complete.push_str(&method_content);
		the_complete.push_str("\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("}\n");
	}
	else
	{
		the_complete.push_str(the_tabs);
		the_complete.push_str("fn ");
		the_complete.push_str(&the_name);
		the_complete.push_str("(");
		the_complete.push_str(&the_params);
		the_complete.push_str(") -> ");
		the_complete.push_str(&the_type);
		the_complete.push_str("\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("{\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("\tlet the_return: ");
		the_complete.push_str(&the_type);
		the_complete.push_str(";\n");
		the_complete.push_str(&method_content);
		the_complete.push_str("\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("\treturn the_return;\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("}\n");
	}
	return the_complete;
}

//loop:
fn gen_loop(the_tabs: &str, the_kind_type: &str, the_content: &str) -> String
{
	let mut the_last = false;
	let new_tabs = [the_tabs,"\t"].concat();
	let mut new_kind: String = the_kind_type.to_string();
	let mut the_complete = String::new();
	let mut root_tag: String;
	let mut new_root_tag: String;
	let mut the_condition = String::from("");
	let mut loop_content = String::new();
	let mut new_content = String::new();
	let mut the_other_content = String::from("");
	let mut passed_content = the_content.to_string();

	if is_in(&new_kind,":")
	{
		new_kind = after_split(&new_kind,":");
	}

	while passed_content != ""
	{
		passed_content = replace_tag(&passed_content, "loop-");

		if starts_with(&passed_content, "condition:")
		{
			if is_in(&passed_content," ")
			{
				the_condition = before_split(&passed_content," ");
				passed_content = after_split(&passed_content," ");
			}
			else
			{
				the_condition = passed_content.clone();
			}
			the_condition = gen_conditions(&the_condition,&new_kind);
		}

		//nest-<type> <other content>
		//{or}
		//<other content> nest-<type>
		if !starts_with(&passed_content, "nest-") && is_in(&passed_content," nest-")
		{
			//This section is meant to make sure the recursion is handled correctly
			//The nested loops and logic statements are split accordingly

			//split string wherever a " nest-" is located
			//ALL "nest-" are ignored...notice there is no space before the "nest-"
			let cmds: Vec<&str> = passed_content.split(" nest-").collect();
			let mut lp = 0;
			for item in &cmds
			{
				//This content will be processed as content for loop
				if lp == 0
				{
					//nest-<type>
					//{or}
					//<other content>
					the_other_content = item.to_string();
				}
				//The remaining content is for the next loop
				//nest-<type> <other content> nest-<type> <other content>
				else if lp == 1
				{
					new_content.push_str("nest-");
					new_content.push_str(item);
				}
				else
				{
					new_content.push_str(" nest-");
					new_content.push_str(item);
				}
				lp += 1;
			}
			//Generate the loop content
			loop_content.push_str(&gen_code(&new_tabs,&the_other_content));
			//The remaning content gets processed
			passed_content = new_content.to_string();
			//reset old and new content
			the_other_content = "".to_string();
			new_content = "".to_string();
		}

		//stop recursive loop if the next element is a "method" or a "class"
		if starts_with(&passed_content, "method:") || starts_with(&passed_content, "class:")
		{
			break;
		}
		//nest-<type>
		else if starts_with(&passed_content, "nest-")
		{
			//"nest-loop" becomes ["nest-", "oop"]
			//{or}
			//"nest-logic" becomes "nest-", "ogic"]
			root_tag = before_split(&passed_content,"l");
			new_root_tag = [" ",&root_tag,"l"].concat();
			//check of " nest-l" is in content
			if is_in(&passed_content,&new_root_tag)
			{
				//This section is meant to separate the "nest-loop" from the "nest-logic"
				//loops won't process logic and vise versa

				//split string wherever a " nest-l" is located
				//ALL "nest-l" are ignored...notice there is no space before the "nest-l"
				let cmds: Vec<&str> = passed_content.split(&new_root_tag).collect();
				let mut lp = 0;
				for item in &cmds
				{
					if lp == 0
					{
						the_other_content = item.to_string();
					}
					else
					{
						if new_content == ""
						{
							new_content.push_str(&root_tag);
							new_content.push_str("l");
							new_content.push_str(item);
						}
						else
						{
							new_content.push_str(" ");
							new_content.push_str(&root_tag);
							new_content.push_str("l");
							new_content.push_str(item);
						}
					}
					lp += 1;
				}
			}

			//no " nest-l" found
			else
			{
				the_other_content = passed_content.to_string();
			}

			passed_content = new_content.to_string();
//			new_content = "".to_string();

			//"nest-loop" and "nest-nest-loop" becomes "loop"
			while starts_with(&the_other_content, "nest-")
			{
				the_other_content = after_split(&the_other_content,"-");
			}
			loop_content.push_str(&gen_code(&new_tabs,&the_other_content));

			//nest-stmt: or nest-var:
			if starts_with(&the_other_content, "stmt:") || starts_with(&the_other_content, "var:")
			{
				/*
				This code works, however, it does mean that parent recursion
				does not have any content. Only nested statements give content to
				*/
				the_other_content = "".to_string();
				passed_content = "".to_string();
			}
			new_content = "".to_string();
		}
		else if starts_with(&passed_content, "loop-") || starts_with(&passed_content, "var:") || starts_with(&passed_content, "stmt:")
		{
			passed_content = replace_tag(&passed_content, "loop-");
			loop_content.push_str(&gen_code(&new_tabs,&passed_content));
			passed_content = "".to_string();
		}
		else
		{
			passed_content = "".to_string();
		}

		if the_last
		{
			break;
		}

		if !is_in(&passed_content," ")
		{
			the_last = true;
		}
	}

	//loop:for
	if new_kind == "for"
	{
		the_complete.push_str(the_tabs);
		the_complete.push_str("for ");
		the_complete.push_str(&the_condition);
		the_complete.push_str("\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("{\n");
		the_complete.push_str(&loop_content);
		the_complete.push_str(the_tabs);
		the_complete.push_str("}\n");
	}
	//loop:do/while
	else if new_kind == "do/while"
	{
		the_complete.push_str(the_tabs);
		the_complete.push_str("do\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("{\n");
		the_complete.push_str(&loop_content);
		the_complete.push_str(the_tabs);
		the_complete.push_str("}\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("while ");
		the_complete.push_str(&the_condition);
		the_complete.push_str(";\n");
	}
	//loop:do/while
	else if new_kind == "while"
	{
		the_complete.push_str(the_tabs);
		the_complete.push_str("while ");
		the_complete.push_str(&the_condition);
		the_complete.push_str("\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("{\n");
		the_complete.push_str(&loop_content);
		the_complete.push_str(the_tabs);
		the_complete.push_str("}\n");
	}
	//loop:
	else
	{
		the_complete.push_str(the_tabs);
		the_complete.push_str("loop\n{\n");
		the_complete.push_str(&loop_content);
		the_complete.push_str(the_tabs);
		the_complete.push_str("}\n");
	}
	return the_complete;
}


//logic:
fn gen_logic(the_tabs: &str, the_kind_type: &str, the_content: &str) -> String
{
	let mut the_last = false;
	let new_tabs = [the_tabs,"\t"].concat();
	let mut new_kind: String = the_kind_type.to_string();
	let mut the_complete = String::new();
	let mut root_tag: String;
	let mut new_root_tag: String;
	let mut the_condition = String::from("");
	let mut logic_content = String::new();
	let mut new_content = String::new();
	let mut the_other_content = String::from("");
	let mut passed_content = the_content.to_string();

	if is_in(&new_kind,":")
	{
		new_kind = after_split(&new_kind,":");
	}

	while passed_content != ""
	{
		passed_content = replace_tag(&passed_content, "logic-");

		if starts_with(&passed_content, "condition:")
		{
			if is_in(&passed_content," ")
			{
				the_condition = before_split(&passed_content," ");
				passed_content = after_split(&passed_content," ");
			}
			else
			{
				the_condition = passed_content.clone();
			}
			the_condition = gen_conditions(&the_condition,&new_kind);
		}

		if !starts_with(&passed_content, "nest-") && is_in(&passed_content," nest-")
		{
			let cmds: Vec<&str> = passed_content.split(" nest-").collect();
			let mut lp = 0;
			for item in &cmds
			{
				if lp == 0
				{
					the_other_content = item.to_string();
				}
				else if lp == 1
				{
					new_content.push_str("nest-");
					new_content.push_str(item);
				}
				else
				{
					new_content.push_str(" nest-");
					new_content.push_str(item);
				}
				lp += 1;
			}
			logic_content.push_str(&gen_code(&new_tabs,&the_other_content));
			passed_content = new_content.to_string();
			the_other_content = "".to_string();
			new_content = "".to_string();
		}

		if starts_with(&passed_content, "method:") || starts_with(&passed_content, "class:")
		{
			break;
		}
		else if starts_with(&passed_content, "nest-")
		{
			root_tag = before_split(&passed_content,"l");
			new_root_tag = [" ",&root_tag,"l"].concat();
			if is_in(&passed_content,&new_root_tag)
			{
				let cmds: Vec<&str> = passed_content.split(&new_root_tag).collect();
				let mut lp = 0;
				for item in &cmds
				{
					if lp == 0
					{
						the_other_content = item.to_string();
					}
					else
					{
						if new_content == ""
						{
							new_content.push_str(&root_tag);
							new_content.push_str("l");
							new_content.push_str(item);
						}
						else
						{
							new_content.push_str(" ");
							new_content.push_str(&root_tag);
							new_content.push_str("l");
							new_content.push_str(item);
						}
					}
					lp += 1;
				}
			}
			else
			{
				the_other_content = passed_content.to_string();
			}

			passed_content = new_content.to_string();
//			new_content = "".to_string();

			while starts_with(&the_other_content, "nest-")
			{
				the_other_content = after_split(&the_other_content,"-");
			}
			logic_content.push_str(&gen_code(&new_tabs,&the_other_content));

			//nest-stmt: or nest-var:
			if starts_with(&the_other_content, "stmt:") || starts_with(&the_other_content, "var:")
			{
				/*
				This code works, however, it does mean that parent recursion
				does not have any content. Only nested statements give content to
				*/
				the_other_content = "".to_string();
				passed_content = "".to_string();
			}
			new_content = "".to_string();
		}
		else if starts_with(&passed_content, "logic-") || starts_with(&passed_content, "var:") || starts_with(&passed_content, "stmt:")
		{
			passed_content = replace_tag(&passed_content, "logic-");
			logic_content.push_str(&gen_code(&new_tabs,&passed_content));
			passed_content = "".to_string();
		}
		else
		{
			passed_content = "".to_string();
		}

		if the_last
		{
			break;
		}

		if !is_in(&passed_content," ")
		{
			the_last = true;
		}
	}

	if new_kind == "if"
	{
		the_complete.push_str(the_tabs);
		the_complete.push_str("if ");
		the_complete.push_str(&the_condition);
		the_complete.push_str("\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("{\n");
		the_complete.push_str(&logic_content);
		the_complete.push_str(the_tabs);
		the_complete.push_str("}\n");
	}
	else if new_kind == "else-if"
	{
		the_complete.push_str(the_tabs);
		the_complete.push_str("else if ");
		the_complete.push_str(&the_condition);
		the_complete.push_str("\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("{\n");
		the_complete.push_str(&logic_content);
		the_complete.push_str(the_tabs);
		the_complete.push_str("}\n");
	}
	else if new_kind == "else"
	{
		the_complete.push_str(the_tabs);
		the_complete.push_str("else\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("{\n");
		the_complete.push_str(&logic_content);
		the_complete.push_str(the_tabs);
		the_complete.push_str("}\n");

	}
	else if new_kind == "switch-case"
	{
		the_complete.push_str(the_tabs);
		the_complete.push_str("\tcase x:\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("\t\t//code here\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("\t\tbreak;");

	}

	else if starts_with(&new_kind, "switch")
	{
		let mut the_case_content = new_kind;
		let mut the_case_val: String;

		the_complete.push_str(the_tabs);
		the_complete.push_str("switch (");
		the_complete.push_str(&the_condition);
		the_complete.push_str(")\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("{\n\n");

		loop
		{
			the_case_val = before_split(&the_case_content,"-");
			if the_case_val != "switch"
			{
				the_complete.push_str(the_tabs);
				the_complete.push_str("\tcase ");
				the_complete.push_str(&the_case_val);
				the_complete.push_str(":\n");
				the_complete.push_str(the_tabs);
				the_complete.push_str("\t\t//code here\n");
				the_complete.push_str(the_tabs);
				the_complete.push_str("\t\tbreak;\n");
			}

			if is_in(&the_case_content,"-")
			{
				the_case_content = after_split(&the_case_content,"-");
			}

			if the_case_content != ""
			{
				break;
			}
		}

		the_complete.push_str(the_tabs);
		the_complete.push_str("\tdefault:\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("\t\t//code here\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("\t\tbreak;\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("}\n");
	}

	return the_complete;
}

//stmt:
fn gen_statements(the_tabs: &str, the_kind_type: &str, the_content: &str) -> String
{
	let mut the_last = false;
	let mut new_kind = the_kind_type.to_string();
	let mut the_complete = String::new();
	let mut statement_content = String::new();
	let mut the_other_content: String;
//	let mut the_other_content: &str;
	let the_name: String;
	let mut name = String::from("");
	let mut the_process: String;
	let mut the_params = String::from("");
	let mut passed_content = the_content.to_string();

	if is_in(&new_kind,":")
	{
		new_kind = after_split(&new_kind,":");
	}

	if is_in(&new_kind,"-")
	{
		the_name = before_split(&new_kind,"-");
		name = after_split(&new_kind,"-");
	}
	else
	{
		the_name = new_kind;
	}

	while passed_content != ""
	{
		//This handles the parameters of the statements
		if starts_with(&passed_content, "params") && the_params == ""
		{
			if is_in(&passed_content," ")
			{
				the_process = before_split(&passed_content," ");
			}
			else
			{
				the_process = passed_content.clone();
			}
			the_params = gen_parameters(&the_process,"stmt");
		}

		if the_last
		{
			break;
		}

		while starts_with(&passed_content, "nest-")
		{
			passed_content = after_split(&passed_content,"-");
		}

		if !is_in(&passed_content," ")
		{
			statement_content.push_str(&gen_code(the_tabs,&passed_content));
			the_last = true;
		}
		else
		{
			the_other_content = before_split(&passed_content," ");
			statement_content.push_str(&gen_code(the_tabs,&the_other_content));
			passed_content = after_split(&passed_content," ");
		}
	}

	if the_name == "method"
	{
		the_complete.push_str(&name);
		the_complete.push_str("(");
		the_complete.push_str(&the_params);
		the_complete.push_str(")");
		the_complete.push_str(&statement_content);
	}
	else if the_name == "endline"
	{
		the_complete.push_str(&statement_content);
		the_complete.push_str(";\n");
	}
	else if the_name == "newline"
	{
		the_complete.push_str(&statement_content);
		the_complete.push_str("\n");
	}

	return the_complete;
}

//var:
fn gen_variables(the_tabs: &str, the_kind_type: &str, the_content: &str) -> String
{
	let mut the_last = false;
	let mut new_var = String::new();
	let the_type: String;
	let the_name: String;
	let mut var_type: String;
	let the_value: String;
//	let the_new_content = String::new();
	let mut variable_content = String::new();
	let mut the_other_content = String::from("");
	let mut passed_content = the_content.to_string();

	while passed_content != ""
	{
		if starts_with(&passed_content, "params:")
		{
			the_other_content.push_str(" ");
			the_other_content.push_str(&before_split(&passed_content," "));
			passed_content = after_split(&passed_content," ");
		}

		if the_last
		{
			break;
		}

		while starts_with(&passed_content, "nest-")
		{
			passed_content = after_split(&passed_content,"-");
		}

		if !is_in(&passed_content," ")
		{
			variable_content.push_str(&gen_code(the_tabs,&passed_content));
			the_last = true;
		}
		else
		{
			the_other_content = String::from(&before_split(&passed_content," "));
			variable_content.push_str(&gen_code(the_tabs,&the_other_content));
			passed_content = after_split(&passed_content," ");
		}
	}

	//var:name-dataType=Value
	if is_in(the_kind_type,":") && is_in(the_kind_type,"-") && is_in(the_kind_type,"=") && !ends_with(the_kind_type, "=")
	{
		the_type = String::from(&after_split(the_kind_type,":"));
		the_name = String::from(&before_split(&the_type,"-"));
		var_type = String::from(&after_split(&the_type,"-"));
		the_value = String::from(&after_split(&var_type,"="));
		var_type = String::from(&before_split(&var_type,"="));

		new_var.push_str(the_tabs);
		new_var.push_str("let ");
		new_var.push_str(&the_name);
		new_var.push_str(": ");
		new_var.push_str(&var_type);
		new_var.push_str(" = ");

		new_var.push_str(&the_value);
		new_var.push_str(&variable_content);
	}
	//var:name=Value
	else if is_in(the_kind_type,":") && !is_in(the_kind_type,"-") && is_in(the_kind_type,"=") && !ends_with(the_kind_type, "=")
	{
		the_type = String::from(&after_split(the_kind_type,":"));
		the_name = String::from(&before_split(&the_type,"="));
		the_value = after_split(&the_type,"=");

		new_var.push_str(the_tabs);
		new_var.push_str(&the_name);
		new_var.push_str(" = ");
		new_var.push_str(&the_value);

		new_var.push_str(&variable_content);
	}
	//var:name-dataType=
	else if is_in(the_kind_type,":") && is_in(the_kind_type,"-") && ends_with(the_kind_type, "=")
	{
		the_type = String::from(&after_split(the_kind_type,":"));
		the_name = String::from(&before_split(&the_type,"-"));
		var_type = String::from(&after_split(&the_type,"-"));
		var_type = String::from(&before_split(&var_type,"="));

		new_var.push_str(the_tabs);
		new_var.push_str("let ");
		new_var.push_str(&the_name);
		new_var.push_str(": ");
		new_var.push_str(&var_type);
		new_var.push_str(" = ");
		new_var.push_str(&variable_content);
	}
	//var:name=
	else if is_in(the_kind_type,":") && !is_in(the_kind_type,"-") && ends_with(the_kind_type, "=")
	{
		the_type = String::from(&after_split(the_kind_type,":"));
		the_name = String::from(&before_split(&the_type,"="));
		//Value = after_split(the_type,"=");

		new_var.push_str(the_tabs);
		new_var.push_str(&the_name);
		new_var.push_str(" = ");
		new_var.push_str(&variable_content);
	}
	//var:name-dataType
	else if is_in(the_kind_type,":") && is_in(the_kind_type,"-") && !is_in(the_kind_type,"=")
	{
		the_type = String::from(&after_split(the_kind_type,":"));
		the_name = String::from(&before_split(&the_type,"-"));
		var_type = after_split(&the_type,"-");

		new_var.push_str(the_tabs);
		new_var.push_str(&var_type);
		new_var.push_str(" ");
		new_var.push_str(&the_name);
		new_var.push_str(&variable_content);
	}
	return new_var;
}

fn gen_code(the_tabs: &str, get_me: &str) -> String
{
	let mut the_code = String::new();
	let mut the_args: [String; 2] = ["".to_string(),"".to_string()];

	if is_in(&get_me," ")
	{
		the_args[0] = before_split(&get_me," ");
		the_args[1] = after_split(&get_me," ");
	}
	else
	{
		the_args[0] = get_me.to_string();
		the_args[1] = "".to_string();
	}

	if starts_with(&the_args[0], "class:")
	{
		the_code.push_str(&gen_class(&the_args[0],&the_args[1]));
	}
	else if starts_with(&the_args[0], "struct:")
	{
		the_code.push_str(&gen_struct(&the_args[0],&the_args[1]));
	}
	else if starts_with(&the_args[0], "method:")
	{
		the_code.push_str(&gen_method(&the_tabs,&the_args[0],&the_args[1]));
	}
	else if starts_with(&the_args[0], "loop:")
	{
		the_code.push_str(&gen_loop(&the_tabs, &the_args[0], &the_args[1]));
	}
	else if starts_with(&the_args[0], "logic:")
	{
		the_code.push_str(&gen_logic(&the_tabs, &the_args[0], &the_args[1]));
	}
	else if starts_with(&the_args[0], "var:")
	{
		the_code.push_str(&gen_variables(&the_tabs, &the_args[0], &the_args[1]));
	}
	else if starts_with(&the_args[0], "stmt:")
	{
		the_code.push_str(&gen_statements(&the_tabs, &the_args[0], &the_args[1]));
	}
/*
	else if starts_with(&the_args[0], "condition")
	{
		the_code.push_str(&gen_conditions(&the_args[0]));
	}
	else if starts_with(&the_args[0], "params")
	{
		the_code.push_str(&gen_parameters(&the_tabs, &the_args[0]));
	}
*/
	return the_code;
}

fn main()
{
	let mut has_run_banner = false;
	let mut arg_count = 0;
	let mut user_in = String::new();
	let mut finished_content: String;

	loop
	{
		//CLI arguments
		for args in env::args().skip(1)
		{
			if arg_count == 0
			{
				user_in.push_str(&args);
			}
			else
			{
				user_in.push_str(" ");
				user_in.push_str(&args);
			}
			arg_count += 1;
		}

		if arg_count == 0
		{
			if has_run_banner == false
			{
				banner();
				has_run_banner = true;
			}

			user_in = raw_input(">>> ");

			if user_in == "exit()"
			{
				break;
			}
			else if user_in == "exit"
			{
				println!("Use exit()");
			}
/*
			else if (user_in == "clear")
			{
				clear();
			}
*/
			else if starts_with(&user_in, "help")
			{
				the_help(&user_in);
			}
		}

		if starts_with(&user_in, "help")
		{
			the_help(&user_in);
		}
		else
		{
			finished_content = gen_code("",&user_in);
			if finished_content != ""
			{
				println!("{}",finished_content);
			}
		}
		if arg_count > 0
		{
			break;
		}
	}
}
