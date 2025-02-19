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
/*
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
*/

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

fn replace_all(String message, String sBy, String jBy) -> String
{
	std::vector<String> SplitMessage = split(message,sBy);
	message = join(SplitMessage,jBy);
	return message;
}
*/


/*
	----[shell]----
*/


fn banner()
{
	let cpl_version = get_cpl_version();
	let the_os = get_os();
	let version = "0.0.4";
	println!("{}",cpl_version);
	println!("[Rust {}] on {}",version,the_os);
	println!("Type \"help\" for more information.");
}
/*
fn gen_struct(the_name: &str, the_content: &str) -> String
{
	let mut the_complete = String::new();
	String StructVar = "";
	String Process = "";
	the_name = after_split(the_name,";");
	while (starts_with(the_content, "var"))
	{
		Process = before_split(the_content," ");
		the_content = after_split(the_content," ");
		StructVar.push_str(&gen_code("\t",Process));
	}
	the_complete.push_str("struct {\n");
	the_complete.push_str(&StructVar);
	the_complete.push_str("\n} ");
	the_complete.push_str(&the_name);
	the_complete.push_str(";\n");

	return the_complete;
}
*/
/*
fn gen_class(the_name: &str, the_content: &str) -> String
{
	let mut the_complete = String::new();
	let mut the_private_vars = String::new();
	let mut the_public_vars = String::new();
	String VarContent = "";
*/
/*
	String PublicOrPrivate = "";
	if (starts_with(the_name,"class("))
	if (is_in(the_name,")"))
	{
		PublicOrPrivate = after_split(the_name,"(");
		PublicOrPrivate = before_split(PublicOrPrivate,")");
	}
*/
/*

	the_name = after_split(the_name,";");
	String Process = "";
	String Params = "";
	let mut class_content = String::new();
	while (the_content != "")
	{
		if ((starts_with(the_content, "params")) && (Params == ""))
		{
			Process = before_split(the_content," ");
			Params =  Parameters(Process,"class");
		}
		else if (starts_with(the_content, "method"))
		{
			class_content.push_str(&gen_code("\t",the_content));
		}
		else if (starts_with(the_content, "var"))
		{
			if (starts_with(the_content, "var(public)"))
			{
				the_content = after_split(the_content,")");
				VarContent = before_split(the_content," ");
				VarContent = "var"+VarContent;
				the_public_vars.push_str(&gen_code("\t",VarContent));
			}
			else if (starts_with(the_content, "var(private)"))
			{
				the_content = after_split(the_content,")");
				VarContent = before_split(the_content," ");
				VarContent = "var"+VarContent;
				the_private_vars.push_str(&gen_code("\t",VarContent));
			}
		}

		if (is_in(the_content," "))
		{
			the_content = after_split(the_content," ");
		}
		else
		{
			break;
		}
	}

	if (the_private_vars != "")
	{
		the_private_vars.push_str("private:\n\t//private variables\n");
		the_private_vars.push_str(&the_private_vars);
		the_private_vars.push_str("\n");
	}
	if (the_public_vars != "")
	{
		the_public_vars = "\n\t//public variables\n"+the_public_vars;
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
	the_complete.push_str(&Params);
	the_complete.push_str(")\n\t{\n\t\tthis->x = x;\n\t\tthis->y = y;\n\t}\n\n");
	the_complete.push_str(&class_content);
	the_complete.push_str("\n\t//class desctructor\n\t~");
	the_complete.push_str(&the_name);
	the_complete.push_str("()\n\t{\n\t}\n};\n");
	return the_complete;
}

fn gen_method(the_tabs: &str, name: &str, the_content: &str) -> String
{
	let mut the_complete = String::new();
	name = after_split(name,";");
	String the_name = "";
	String Type = "";
	String Params = "";
	let mut method_content = String::new();
	String LastComp = "";
	String Process = "";

	if (is_in(Name,"-"))
	{
		the_name = before_split(name,"-");
		Type = after_split(name,"-");
	}
	else
	{
		the_name = name;
	}

	while (the_content != "")
	{
		if ((starts_with(the_content, "params")) && (Params == ""))
		{
			if (is_in(the_content," "))
			{
				Process = before_split(the_content," ");
			}
			else
			{
				Process = the_content;
			}
			Params =  Parameters(Process,"method");
		}
		else if ((starts_with(the_content, "method")) || (starts_with(the_content, "class")))
		{
			break;
		}
		else
		{
			if (is_in(the_content," method"))
			{
				std::vector<String> cmds = split(the_content," method");
				the_content = cmds[0];
			}
			method_content.push_str(&gen_code(new_tabs,the_content));
		}

		if (is_in(the_content," "))
		{
			the_content = after_split(the_content," ");
		}
		else
		{
			break;
		}
	}

	if ((Type == "") || (Type == "void"))
	{
		the_complete.push_str(the_tabs);
		the_complete.push_str("void ");
		the_complete.push_str(&the_name);
		the_complete.push_str("(");
		the_complete.push_str(&Params);
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
		the_complete.push_str(&Type);
		the_complete.push_str(" ");
		the_complete.push_str(&the_name);
		the_complete.push_str("(");
		the_complete.push_str(&Params);
		the_complete.push_str(")\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("{\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("\t");
		the_complete.push_str(&Type);
		the_complete.push_str(" TheReturn;\n");
		the_complete.push_str(&method_content);
		the_complete.push_str("\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("\treturn TheReturn;\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("}\n");
	}
	return the_complete;
}
*/

fn gen_conditions(input: &str,called_by: &str) -> String
{
//	let mut condit = after_split(&input,":");
	let condit = after_split(&input,":");
//	condit = replace_all(condit, "|", " ");
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


/*
fn gen_parameters(input: &str,called_by: &str) -> String
{
	String Params = after_split(input,";");
	if ((called_by == "class") || (called_by == "method") || (called_by == "stmt"))
	{
		if ((is_in(Params,"-")) && (is_in(Params,",")))
		{
			String Name = before_split(Params,"-");
			String Type = after_split(Params,"-");
			Type = before_split(Type,",");
			String more = after_split(Params,",");
			more = Parameters("params:"+more,called_by);
			Params = Type+" "+Name+", "+more;
		}
		else if ((is_in(Params,"-")) && (!is_in(Params,",")))
		{
			String Name = before_split(Params,"-");
			String Type = after_split(Params,"-");
			Params = Type+" "+Name;
		}
	}
	return Params;
}

//loop:
fn gen_loop(the_tabs: &str, the_kind_type: &str, the_content: &str) -> String
{
	bool the_last = false;
//	String NestTabs = "";
	String the_complete = "";
	String the_name = "";
	String the_root_tag = "";
	String Type = "";
	String the_condition = "";
	String loop_content = "";
	String the_new_content = "";
	String the_other_content = "".to_string();

	if (is_in(the_kind_type,":"))
	{
		the_kind_type = after_split(the_kind_type,";");
	}

	if (is_in(the_kind_type,"-"))
	{
		the_name = before_split(the_kind_type,"-");
		Type = after_split(the_kind_type,"-");
	}

	while (the_content != "")
	{
		if ((!starts_with(the_content, "nest-")) && (is_in(the_content," nest-")))
		{
			let all: Vec<&str> = the_content.split(" nest-").collect();
			int end = len(all);
			int lp = 0;
			while (lp != end)
			{
				if (lp == 0)
				{
					the_other_content = all[lp];
				}
				else if (lp == 1)
				{
					the_new_content = "nest-"+all[lp];
				}
				else
				{
					the_new_content = the_new_content + " nest-"+all[lp];
				}
				lp += 1;
			}
			loop_content.push_str(&gen_code(new_tabs,the_other_content));
			the_content = the_new_content;
			the_other_content = "".to_string();
			the_new_content = "";
		}

		if (starts_with(the_content, "condition"))
		{
			the_condition = gen_conditions(the_content,the_kind_type);
		}
		else if ((starts_with(the_content, "method")) || (starts_with(the_content, "class")))
		{
			break;
		}
		//nest-loop:
		else if (starts_with(the_content, "nest-"))
		{
			the_root_tag = before_split(the_content,"l");
			if (is_in(Content," "+the_root_tag+"l"))
			{
				let cmds: Vec<&str> = the_content.split(" "+the_root_tag+"l").collect();
				let mut lp = 0;
				for item in &all
				while (lp != end)
				{
					if (lp == 0)
					{
						the_other_content = item;
					}
					else
					{
						if (the_new_content == "")
						{
							the_new_content = the_root_tag+"l"+item;
						}
						else
						{
							the_new_content = the_new_content+" "+the_root_tag+"l"+item;
						}
					}
					lp += 1;
				}
			}
			else
			{
				the_other_content = the_content;
			}

			the_content = the_new_content;
			the_new_content = "";

			while (starts_with(the_other_content, "nest-"))
			{
				the_other_content = after_split(the_other_content,"-");
			}
			loop_content = loop_content + gen_code(new_tabs,the_other_content);
		}
		else
		{
			loop_content = loop_content + gen_code(new_tabs,the_content);
			the_content = "";
		}

		if (the_last)
		{
			break;
		}

		if (!is_in(the_content," "))
		{
			the_last = true;
		}
	}
	//loop:for
	if (the_kind_type == "for")
	{
		the_complete = the_tabs+"for ("+the_condition+")\n"+the_tabs+"{\n"+loop_content+the_tabs+"}\n";
	}
	//loop:do/while
	else if (the_kind_type == "do/while")
	{
		the_complete = the_tabs+"do\n"+the_tabs+"{\n"+loop_content+the_tabs+"}\n"+the_tabs+"while ("+the_condition+");\n";
	}
	//loop:while
	else
	{
		the_complete = the_tabs+"while ("+the_condition+")\n"+the_tabs+"{\n"+loop_content+the_tabs+"}\n";
	}
	return the_complete;
}
*/

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
	let mut other_content = String::from("");
	let mut passed_content = the_content.to_string();

	if is_in(&new_kind,":")
	{
		new_kind = after_split(&new_kind,":");
	}

	loop
	{
		if !starts_with(&passed_content, "nest-") && is_in(&passed_content," nest-")
		{
			let cmds: Vec<&str> = passed_content.split(" nest-").collect();
			let mut lp = 0;
			for item in &cmds
			{
				if lp == 0
				{
					other_content = item.to_string();
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
			logic_content.push_str(&gen_code(&new_tabs,&other_content));
			passed_content = new_content.to_string();
			other_content = String::from("");
			new_content = String::new();
		}

		if starts_with(&passed_content, "condition")
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
		else if starts_with(&passed_content, "method") || starts_with(&passed_content, "class")
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
						other_content = item.to_string();
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
				other_content = passed_content.to_string();
			}

			passed_content = new_content.to_string();
			new_content = String::from("");

			while starts_with(&other_content, "nest-")
			{
				other_content = after_split(&other_content,"-");
			}
			logic_content.push_str(&gen_code(&new_tabs,&other_content));
		}
		else
		{
			logic_content.push_str(&gen_code(&new_tabs,&passed_content));
			passed_content = "".to_string();
		}

		if the_last || passed_content != ""
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
		the_complete.push_str("if (");
		the_complete.push_str(&the_condition);
		the_complete.push_str(")\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("{\n");
		the_complete.push_str(&logic_content);
		the_complete.push_str(the_tabs);
		the_complete.push_str("}\n");
	}
	else if new_kind == "else-if"
	{
		the_complete.push_str(the_tabs);
		the_complete.push_str("else if (");
		the_complete.push_str(&the_condition);
		the_complete.push_str(")\n");
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
/*
	else if starts_with(new_kind, "switch")
	{
		let mut the_case_content = new_kind;
		let mut the_case_val;

		the_complete.push_str(the_tabs);
		the_complete.push_str("switch (");
		the_complete.push_str(&the_condition);
		the_complete.push_str(")\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("{\n\n");

		loop
		{
			the_case_val = &before_split(the_case_content,"-");
			if the_case_val != "switch"
			{
				the_complete.push_str(the_tabs);
				the_complete.push_str("\tcase ");
				the_complete.push_str(the_case_val);
				the_complete.push_str(":\n");
				the_complete.push_str(the_tabs);
				the_complete.push_str("\t\t//code here\n");
				the_complete.push_str(the_tabs);
				the_complete.push_str("\t\tbreak;\n");
			}

			if is_in(the_case_content,"-")
			{
				the_case_content = &after_split(the_case_content,"-");
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
*/
	return the_complete;
}
/*
//stmt:
fn gen_statements(the_tabs: &str, String the_kind_type, the_content: &str) -> String
{
	bool the_last = false;
	String the_complete = "";
	String StatementContent = "";
	String the_other_content = "".to_string();
	String the_name = "";
	String Name = "";
	String Process = "";
	String Params = "";

	if (is_in(the_kind_type,":"))
	{
		the_kind_type = after_split(the_kind_type,";");
	}
	if (is_in(the_kind_type,"-"))
	{
		the_name = before_split(the_kind_type,"-");
		Name = after_split(the_kind_type,"-");
	}
	else
	{
		the_name = the_kind_type;
	}

	while (the_content != "")
	{
		if ((starts_with(the_content, "params")) && (Params == ""))
		{
			if (is_in(the_content," "))
			{
				Process = before_split(the_content," ");
			}
			else
			{
				Process = the_content;
			}
			Params =  Parameters(Process,"stmt");
		}
		else
		{
			the_other_content = before_split(the_content," ");
			StatementContent = StatementContent + gen_code(the_tabs,the_other_content);
			the_content = after_split(the_content," ");
		}

		if (the_last)
		{
			break;
		}
		if (!is_in(the_content," "))
		{
			StatementContent = StatementContent + gen_code(the_tabs,the_content);
			the_last = true;
		}
	}
	if (the_name == "method")
	{
		the_complete = Name+"("+Params+")"+StatementContent;
	}
	else if (the_name == "endline")
	{
		the_complete = StatementContent+";\n";
	}
	else if (the_name == "newline")
	{
		the_complete = StatementContent+"\n";
	}

	return the_complete;
}

//var:
fn gen_variables(the_tabs: &str, String the_kind_type, the_content: &str) -> String
{
	bool the_last = false;
	String NewVar = "";
	String Type = "";
	String Name = "";
	String VarType = "";
	String Value = "";
	String the_new_content = "";
	String VariableContent = "";
	String the_other_content = "".to_string();

//	println!(the_kind_type+" "+the_content);

	while (the_content != "")
	{
*/
/*
		VariableContent = VariableContent + gen_code(the_tabs,the_content);
		the_content = after_split(the_content," ");
*/
/*

		the_other_content = before_split(the_content," ");
		the_content = after_split(the_content," ");
		if (starts_with(Content, "params"))
		{
			the_other_content = the_other_content+" "+before_split(the_content," ");
			the_content = after_split(the_content," ");
		}
		VariableContent = VariableContent + gen_code(the_tabs,the_other_content);

		if (the_last)
		{
			break;
		}

		if (!is_in(the_content," "))
		{
			VariableContent = VariableContent + gen_code(the_tabs,the_content);
			the_last = true;
		}
	}
	//var:name-dataType=Value
	if ((is_in(the_kind_type,":")) && (is_in(the_kind_type,"-")) && (is_in(the_kind_type,"=")) && (!EndsWith(the_kind_type, "=")))
	{
		Type = after_split(the_kind_type,";");
		Name = before_split(Type,"-");
		VarType = after_split(Type,"-");
		Value = after_split(VarType,"=");
		VarType = before_split(VarType,"=");
		NewVar = the_tabs+VarType+" "+Name+" = "+Value;
		NewVar = NewVar+VariableContent;
	}
	//var:name=Value
	if ((is_in(the_kind_type,":")) && (!is_in(the_kind_type,"-")) && (is_in(the_kind_type,"=")) && (!EndsWith(the_kind_type, "=")))
	{
		Type = after_split(the_kind_type,";");
		Name = before_split(Type,"=");
		Value = after_split(Type,"=");
		NewVar = the_tabs+Name+" = "+Value;
		NewVar = NewVar+VariableContent;
	}
	//var:name-dataType=
	else if ((is_in(the_kind_type,":")) && (is_in(the_kind_type,"-")) && (EndsWith(the_kind_type, "=")))
	{
		Type = after_split(the_kind_type,";");
		Name = before_split(Type,"-");
		VarType = after_split(Type,"-");
		VarType = before_split(VarType,"=");
		NewVar = the_tabs+VarType+" "+Name+" = ";
		NewVar = NewVar+VariableContent;
	}
	//var:name=
	else if ((is_in(the_kind_type,":")) && (!is_in(the_kind_type,"-")) && (EndsWith(the_kind_type, "=")))
	{
		Type = after_split(the_kind_type,";");
		Name = before_split(Type,"=");
		Value = after_split(Type,"=");
		NewVar = the_tabs+Name+" = ";
		NewVar = NewVar+VariableContent;
	}
	//var:name-dataType
	else if ((is_in(the_kind_type,":")) && (is_in(the_kind_type,"-")) && (!is_in(the_kind_type,"=")))
	{
		Type = after_split(the_kind_type,";");
		Name = before_split(Type,"-");
		VarType = after_split(Type,"-");
		NewVar = the_tabs+VarType+" "+Name;
		NewVar = NewVar+VariableContent;
	}
	return NewVar;
}
*/
fn gen_code(the_tabs: &str, get_me: &str) -> String
{
//	println!("parameters: {} {}",the_tabs,get_me);

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
/*
	if (starts_with(the_args[0], "class"))
	{
		the_code.push_str(gen_class(the_args[0],the_args[1]));
	}
	else if (starts_with(the_args[0], "struct"))
	{
		the_code.push_str(get_struct(the_args[0],the_args[1]));
	}
	else if (starts_with(the_args[0], "method"))
	{
		the_code.push_str(gen_method(the_tabs,the_args[0],the_args[1]));
	}
	else if (starts_with(the_args[0], "loop"))
	{
		the_code.push_str(gen_loop(the_tabs,the_args[0],the_args[1]));
	}
	else if (starts_with(&the_args[0], "logic"))
*/
	if starts_with(&the_args[0], "logic")
	{
		the_code.push_str(&gen_logic(&the_tabs,&the_args[0],&the_args[1]));
	}
//	println!("the_content: {}", the_code);
/*
	else if (starts_with(the_args[0], "var"))
	{
		the_code.push_str(gen_variables(the_tabs, the_args[0], the_args[1]));
	}
	else if (starts_with(the_args[0], "stmt"))
	{
		the_code.push_str(gen_statements(the_tabs, the_args[0], the_args[1]));
	}
*/
/*
	else if (starts_with(the_args[0], "condition"))
	{
		the_code.push_str(gen_conditions(the_args[0]));
	}
	else if (starts_with(the_args[0], "params"))
	{
		the_code.push_str(gen_parameters(the_args[0]));
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

		finished_content = gen_code("",&user_in);
		if finished_content != ""
		{
			println!("{}",finished_content);
		}

		if arg_count > 0
		{
			break;
		}
	}
}
