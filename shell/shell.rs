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
		new_the_type = split_after(&new_the_type,":");
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
fn gen_struct(the_name: &str, content: &str) -> String
{
	let mut complete = String::new();
	String StructVar = "";
	String Process = "";
	the_name = split_after(the_name,";");
	while (starts_with(Content, "var"))
	{
		Process = split_before(content," ");
		Content = split_after(content," ");
		StructVar.push_str(&gen_code("\t",Process));
	}
	complete.push_str("struct {\n");
	complete.push_str(&StructVar);
	complete.push_str("\n} ");
	complete.push_str(&the_name);
	complete.push_str(";\n");

	return complete;
}
*/
/*
fn gen_class(the_name: &str, content: &str) -> String
{
	let mut complete = String::new();
	let mut the_private_vars = String::new();
	let mut the_public_vars = String::new();
	String VarContent = "";
*/
/*
	String PublicOrPrivate = "";
	if (starts_with(the_name,"class("))
	if (is_in(the_name,")"))
	{
		PublicOrPrivate = split_after(the_name,"(");
		PublicOrPrivate = split_before(PublicOrPrivate,")");
	}
*/
/*

	the_name = split_after(the_name,";");
	String Process = "";
	String Params = "";
	let mut class_content = String::new();
	while (Content != "")
	{
		if ((starts_with(Content, "params")) && (Params == ""))
		{
			Process = split_before(Content," ");
			Params =  Parameters(Process,"class");
		}
		else if (starts_with(Content, "method"))
		{
			class_content.push_str(&gen_code("\t",Content));
		}
		else if (starts_with(Content, "var"))
		{
			if (starts_with(Content, "var(public)"))
			{
				Content = split_after(Content,')');
				VarContent = split_before(Content," ");
				VarContent = "var"+VarContent;
				the_public_vars.push_str(&gen_code("\t",VarContent));
			}
			else if (starts_with(Content, "var(private)"))
			{
				Content = split_after(Content,')');
				VarContent = split_before(Content," ");
				VarContent = "var"+VarContent;
				the_private_vars.push_str(&gen_code("\t",VarContent));
			}
		}

		if (is_in(Content," "))
		{
			Content = split_after(Content," ");
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

	complete.push_str("class ");
	complete.push_str(&the_name);
	complete.push_str(" {\n\n");
	complete.push_str(&the_private_vars);
	complete.push_str("public:");
	complete.push_str(&the_public_vars);
	complete.push_str("\n\t//class constructor\n\t");
	complete.push_str(&the_name);
	complete.push_str("(");
	complete.push_str(&Params);
	complete.push_str(")\n\t{\n\t\tthis->x = x;\n\t\tthis->y = y;\n\t}\n\n");
	complete.push_str(&class_content);
	complete.push_str("\n\t//class desctructor\n\t~");
	complete.push_str(&the_name);
	complete.push_str("()\n\t{\n\t}\n};\n");
	return Complete;
}

fn gen_method(tabs: &str, name: &str, content: &str) -> String
{
	let mut complete = String::new();
	name = split_after(name,";");
	String the_name = "";
	String Type = "";
	String Params = "";
	let mut method_content = String::new();
	String LastComp = "";
	String Process = "";

	if (is_in(Name,"-"))
	{
		the_name = split_before(name,"-");
		Type = split_after(name,"-");
	}
	else
	{
		the_name = name;
	}

	while (content != "")
	{
		if ((starts_with(content, "params")) && (Params == ""))
		{
			if (is_in(content," "))
			{
				Process = split_before(content," ");
			}
			else
			{
				Process = Content;
			}
			Params =  Parameters(Process,"method");
		}
		else if ((starts_with(Content, "method")) || (starts_with(Content, "class")))
		{
			break;
		}
		else
		{
			if (is_in(Content," method"))
			{
				std::vector<String> cmds = split(Content," method");
				Content = cmds[0];
			}
			method_content.push_str(&gen_code(tabs+"\t",Content));
		}

		if (is_in(Content," "))
		{
			Content = split_after(Content," ");
		}
		else
		{
			break;
		}
	}

	if ((Type == "") || (Type == "void"))
	{
		complete.push_str(tabs);
		complete.push_str("void ");
		complete.push_str(&the_name);
		complete.push_str("(");
		complete.push_str(&Params);
		complete.push_str(")\n");
		complete.push_str(tabs);
		complete.push_str("{\n");
		complete.push_str(&method_content);
		complete.push_str("\n");
		complete.push_str(tabs);
		complete.push_str("}\n");
	}
	else
	{
		complete.push_str(tabs);
		complete.push_str(&Type);
		complete.push_str(" ");
		complete.push_str(&the_name);
		complete.push_str("(");
		complete.push_str(&Params);
		complete.push_str(")\n");
		complete.push_str(tabs);
		complete.push_str("{\n");
		complete.push_str(tabs);
		complete.push_str("\t");
		complete.push_str(&Type);
		complete.push_str(" TheReturn;\n");
		complete.push_str(&method_content);
		complete.push_str("\n");
		complete.push_str(tabs);
		complete.push_str("\treturn TheReturn;\n");
		complete.push_str(tabs);
		complete.push_str("}\n");
	}
	return complete;
}
*/

fn gen_conditions(input: &str,called_by: &str) -> String
{
//	let mut condit = split_after(&input,":");
	let condit = split_after(&input,":");
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
	String Params = split_after(input,";");
	if ((called_by == "class") || (called_by == "method") || (called_by == "stmt"))
	{
		if ((is_in(Params,"-")) && (is_in(Params,",")))
		{
			String Name = split_before(Params,"-");
			String Type = split_after(Params,"-");
			Type = split_before(Type,',');
			String more = split_after(Params,',');
			more = Parameters("params:"+more,called_by);
			Params = Type+" "+Name+", "+more;
		}
		else if ((is_in(Params,"-")) && (!is_in(Params,",")))
		{
			String Name = split_before(Params,"-");
			String Type = split_after(Params,"-");
			Params = Type+" "+Name;
		}
	}
	return Params;
}

//loop:
fn gen_loop(tabs: &str, the_kind_type: &str, content: &str) -> String
{
	bool the_last = false;
//	String NestTabs = "";
	String Complete = "";
	String the_name = "";
	String the_root_tag = "";
	String Type = "";
	String the_condition = "";
	String loop_content = "";
	String NewContent = "";
	String the_other_content = "".to_string();

	if (is_in(the_kind_type,":"))
	{
		the_kind_type = split_after(the_kind_type,";");
	}

	if (is_in(the_kind_type,"-"))
	{
		the_name = split_before(the_kind_type,"-");
		Type = split_after(the_kind_type,"-");
	}

	while (Content != "")
	{
		if ((!starts_with(Content, "nest-")) && (is_in(Content," nest-")))
		{
			let all: Vec<&str> = content.split(" nest-").collect();
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
					NewContent = "nest-"+all[lp];
				}
				else
				{
					NewContent = NewContent + " nest-"+all[lp];
				}
				lp += 1;
			}
			loop_content.push_str(&gen_code(tabs+"\t",the_other_content));
			Content = NewContent;
			the_other_content = "".to_string();
			NewContent = "";
		}

		if (starts_with(Content, "condition"))
		{
			the_condition = gen_conditions(Content,the_kind_type);
		}
		else if ((starts_with(Content, "method")) || (starts_with(Content, "class")))
		{
			break;
		}
		//nest-loop:
		else if (starts_with(Content, "nest-"))
		{
			the_root_tag = split_before(Content,'l');
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
						if (NewContent == "")
						{
							NewContent = the_root_tag+"l"+item;
						}
						else
						{
							NewContent = NewContent+" "+the_root_tag+"l"+item;
						}
					}
					lp += 1;
				}
			}
			else
			{
				the_other_content = Content;
			}

			Content = NewContent;
			NewContent = "";

			while (starts_with(the_other_content, "nest-"))
			{
				the_other_content = split_after(the_other_content,"-");
			}
			loop_content = loop_content + gen_code(tabs+"\t",the_other_content);
		}
		else
		{
			loop_content = loop_content + gen_code(tabs+"\t",Content);
			Content = "";
		}

		if (the_last)
		{
			break;
		}

		if (!is_in(Content," "))
		{
			the_last = true;
		}
	}
	//loop:for
	if (the_kind_type == "for")
	{
		Complete = tabs+"for ("+the_condition+")\n"+tabs+"{\n"+loop_content+tabs+"}\n";
	}
	//loop:do/while
	else if (the_kind_type == "do/while")
	{
		Complete = tabs+"do\n"+tabs+"{\n"+loop_content+tabs+"}\n"+tabs+"while ("+the_condition+");\n";
	}
	//loop:while
	else
	{
		Complete = tabs+"while ("+the_condition+")\n"+tabs+"{\n"+loop_content+tabs+"}\n";
	}
	return Complete;
}
*/
//logic:
fn gen_logic(tabs: &str, the_kind_type: &str, content: &str) -> String
{
	let mut the_last = false;
	let mut the_complete = String::new();
//	let mut the_name: String;
//	let mut the_type: String;
	let mut the_root_tag: String;
	let mut the_condition: String;
	let mut the_logic_content = String::new();
	let mut the_new_content = String::new();
	let mut the_other_content: String;
	let mut the_content: String = content.to_string();
	let mut new_kind_type: String = the_kind_type.to_string();
	let mut split_content = String::new();
	let mut the_gen_code: String;

	if is_in(&new_kind_type,":")
	{
		new_kind_type = split_after(&new_kind_type,";");
	}

/*
	if is_in(&new_kind_type,"-")
	{
		the_name = split_before(&new_kind_type,"-");
		the_type = split_after(&new_kind_type,"-");
	}
*/

	loop
	{
		if (!starts_with(&the_content, "nest-")) && is_in(&the_content," nest-")
		{
			let all: Vec<&str> = the_content.split(" nest-").collect();
			let mut lp = 0;
			for item in &all
			{
				if lp == 0
				{
					the_other_content = item.to_string();
				}
				else if lp == 1
				{
					the_new_content.push_str("nest-");
					the_new_content.push_str(item);
				}
				else
				{
					the_new_content.push_str(" nest-");
					the_new_content.push_str(item);
				}
				lp += 1;
			}

			split_content.clear();

			split_content.push_str(tabs);
			split_content.push_str("\t");

			the_gen_code = gen_code(&split_content,&the_other_content);
			if the_gen_code != ""
			{
				the_logic_content.push_str(&the_gen_code);
			}

			split_content.clear();

			if the_new_content != ""
			{
				the_content = the_new_content;
			}
			the_other_content = "".to_string();
			the_new_content = "".to_string();
		}

		if starts_with(&the_content, "condition")
		{
			if is_in(&the_content," ")
			{
				the_condition = split_before(&the_content," ");
				the_content = split_after(&the_content," ");
			}
			else
			{
				the_condition = the_content;
			}
			the_condition = gen_conditions(&the_condition,&new_kind_type);
		}
		else if starts_with(&the_content, "method") || starts_with(&the_content, "class")
		{
			break;
		}
		else if starts_with(&the_content, "nest-")
		{
			split_content.push_str(" ");
			split_content.push_str(&the_root_tag);
			split_content.push_str("l");

			the_root_tag = split_before(&the_content,"l");
			if is_in(&the_content,&the_content)
			{
				let mut lp = 0;

				let cmds: Vec<&str> = the_content.split(&split_content).collect();
				for item in &cmds
				{
					if lp == 0
					{
						the_other_content = item.to_string();
					}
					else
					{
						if the_new_content == ""
						{
							the_new_content.push_str(&the_root_tag);
							the_new_content.push_str("l");
							the_new_content.push_str(&item);
						}
						else
						{
							the_new_content.push_str(" ");
							the_new_content.push_str(&the_root_tag);
							the_new_content.push_str("l");
							the_new_content.push_str(&item);
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
			the_new_content = "".to_string();

			while starts_with(&the_other_content, "nest-")
			{
				the_other_content = split_after(&the_other_content,"-");
			}
			split_content.clear();
			split_content.push_str(tabs);
			split_content.push_str("\t");
			the_logic_content.push_str(&gen_code(&split_content,&the_other_content));
			split_content.clear();
		}
		else
		{
			split_content.clear();
			split_content.push_str(tabs);
			split_content.push_str("\t");
			the_logic_content.push_str(&gen_code(&split_content,&the_content));
			split_content.clear();
			the_content.clear();
		}

		if the_last
		{
			break;
		}

		if !is_in(&the_content," ")
		{
			the_last = true;
		}
	}

	if new_kind_type == "if"
	{
		the_complete.push_str(tabs);
		the_complete.push_str("if (");
		the_complete.push_str(&the_condition);
		the_complete.push_str(")\n");
		the_complete.push_str(tabs);
		the_complete.push_str("{\n");
		the_complete.push_str(&the_logic_content);
		the_complete.push_str(tabs);
		the_complete.push_str("}\n");
	}
	else if new_kind_type == "else-if".to_string()
	{
		the_complete.push_str(tabs);
		the_complete.push_str("else if (");
		the_complete.push_str(&the_condition);
		the_complete.push_str(")\n");
		the_complete.push_str(tabs);
		the_complete.push_str("{\n");
		the_complete.push_str(&the_logic_content);
		the_complete.push_str(tabs);
		the_complete.push_str("}\n");
	}
	else if new_kind_type == "else".to_string()
	{
		the_complete.push_str(tabs);
		the_complete.push_str("else\n");
		the_complete.push_str(tabs);
		the_complete.push_str("{\n");
		the_complete.push_str(&the_logic_content);
		the_complete.push_str(tabs);
		the_complete.push_str("}\n");
	}
	else if new_kind_type == "switch-case"
	{
		the_complete.push_str(tabs);
		the_complete.push_str("\tcase x:\n");
		the_complete.push_str(tabs);
		the_complete.push_str("\t\t//code here\n");
		the_complete.push_str(tabs);
		the_complete.push_str("\t\tbreak;");
	}
	else if starts_with(&new_kind_type, "switch")
	{
		let mut case_content = new_kind_type;
		let mut case_val: String;

		the_complete.push_str(tabs);
		the_complete.push_str("switch (");
		the_complete.push_str(&the_condition);
		the_complete.push_str(")\n");
		the_complete.push_str(tabs);
		the_complete.push_str("{\n\n");

		loop
		{
			if case_content != ""
			{
				break
			}

			case_val = split_before(&case_content,"-");
			if case_val != "switch"
			{
				the_complete.push_str(tabs);
				the_complete.push_str("\tcase ");
				the_complete.push_str(&case_val);
				the_complete.push_str(":\n");
				the_complete.push_str(tabs);
				the_complete.push_str("\t\t//code here\n");
				the_complete.push_str(tabs);
				the_complete.push_str("\t\tbreak;\n");
			}

			if is_in(&case_content,"-")
			{
				case_content = split_after(&case_content,"-");
			}
		}

		the_complete.push_str(tabs);
		the_complete.push_str("\tdefault:\n");
		the_complete.push_str(tabs);
		the_complete.push_str("\t\t//code here\n");
		the_complete.push_str(tabs);
		the_complete.push_str("\t\tbreak;\n");
		the_complete.push_str(tabs);
		the_complete.push_str("}\n");
	}

	return the_complete;
}
/*
//stmt:
fn gen_statements(tabs: &str, String the_kind_type, content: &str) -> String
{
	bool the_last = false;
	String Complete = "";
	String StatementContent = "";
	String the_other_content = "".to_string();
	String the_name = "";
	String Name = "";
	String Process = "";
	String Params = "";

	if (is_in(the_kind_type,":"))
	{
		the_kind_type = split_after(the_kind_type,";");
	}
	if (is_in(the_kind_type,"-"))
	{
		the_name = split_before(the_kind_type,"-");
		Name = split_after(the_kind_type,"-");
	}
	else
	{
		the_name = the_kind_type;
	}

	while (Content != "")
	{
		if ((starts_with(Content, "params")) && (Params == ""))
		{
			if (is_in(Content," "))
			{
				Process = split_before(Content," ");
			}
			else
			{
				Process = Content;
			}
			Params =  Parameters(Process,"stmt");
		}
		else
		{
			the_other_content = split_before(Content," ");
			StatementContent = StatementContent + gen_code(tabs,the_other_content);
			Content = split_after(Content," ");
		}

		if (the_last)
		{
			break;
		}
		if (!is_in(Content," "))
		{
			StatementContent = StatementContent + gen_code(tabs,Content);
			the_last = true;
		}
	}
	if (the_name == "method")
	{
		Complete = Name+"("+Params+")"+StatementContent;
	}
	else if (the_name == "endline")
	{
		Complete = StatementContent+";\n";
	}
	else if (the_name == "newline")
	{
		Complete = StatementContent+"\n";
	}

	return Complete;
}

//var:
fn gen_variables(tabs: &str, String the_kind_type, content: &str) -> String
{
	bool the_last = false;
	String NewVar = "";
	String Type = "";
	String Name = "";
	String VarType = "";
	String Value = "";
	String NewContent = "";
	String VariableContent = "";
	String the_other_content = "".to_string();

//	println!(the_kind_type+" "+Content);

	while (Content != "")
	{
*/
/*
		VariableContent = VariableContent + gen_code(tabs,Content);
		Content = split_after(Content," ");
*/
/*

		the_other_content = split_before(Content," ");
		Content = split_after(Content," ");
		if (starts_with(Content, "params"))
		{
			the_other_content = the_other_content+" "+split_before(Content," ");
			Content = split_after(Content," ");
		}
		VariableContent = VariableContent + gen_code(tabs,the_other_content);

		if (the_last)
		{
			break;
		}

		if (!is_in(Content," "))
		{
			VariableContent = VariableContent + gen_code(tabs,Content);
			the_last = true;
		}
	}
	//var:name-dataType=Value
	if ((is_in(the_kind_type,":")) && (is_in(the_kind_type,"-")) && (is_in(the_kind_type,"=")) && (!EndsWith(the_kind_type, "=")))
	{
		Type = split_after(the_kind_type,";");
		Name = split_before(Type,"-");
		VarType = split_after(Type,"-");
		Value = split_after(VarType,"=");
		VarType = split_before(VarType,"=");
		NewVar = tabs+VarType+" "+Name+" = "+Value;
		NewVar = NewVar+VariableContent;
	}
	//var:name=Value
	if ((is_in(the_kind_type,":")) && (!is_in(the_kind_type,"-")) && (is_in(the_kind_type,"=")) && (!EndsWith(the_kind_type, "=")))
	{
		Type = split_after(the_kind_type,";");
		Name = split_before(Type,"=");
		Value = split_after(Type,"=");
		NewVar = tabs+Name+" = "+Value;
		NewVar = NewVar+VariableContent;
	}
	//var:name-dataType=
	else if ((is_in(the_kind_type,":")) && (is_in(the_kind_type,"-")) && (EndsWith(the_kind_type, "=")))
	{
		Type = split_after(the_kind_type,";");
		Name = split_before(Type,"-");
		VarType = split_after(Type,"-");
		VarType = split_before(VarType,"=");
		NewVar = tabs+VarType+" "+Name+" = ";
		NewVar = NewVar+VariableContent;
	}
	//var:name=
	else if ((is_in(the_kind_type,":")) && (!is_in(the_kind_type,"-")) && (EndsWith(the_kind_type, "=")))
	{
		Type = split_after(the_kind_type,";");
		Name = split_before(Type,"=");
		Value = split_after(Type,"=");
		NewVar = tabs+Name+" = ";
		NewVar = NewVar+VariableContent;
	}
	//var:name-dataType
	else if ((is_in(the_kind_type,":")) && (is_in(the_kind_type,"-")) && (!is_in(the_kind_type,"=")))
	{
		Type = split_after(the_kind_type,";");
		Name = split_before(Type,"-");
		VarType = split_after(Type,"-");
		NewVar = tabs+VarType+" "+Name;
		NewVar = NewVar+VariableContent;
	}
	return NewVar;
}
*/
fn gen_code(tabs: &str, get_me: &str) -> String
{
	println!("parameters: {} {}",tabs,get_me);

	let mut the_code = String::new();
	let mut the_args: [String; 2] = ["".to_string(),"".to_string()];

	if is_in(&get_me," ")
	{
		the_args[0] = split_before(&get_me," ");
		the_args[1] = split_after(&get_me," ");
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
		the_code.push_str(gen_method(tabs,the_args[0],the_args[1]));
	}
	else if (starts_with(the_args[0], "loop"))
	{
		the_code.push_str(gen_loop(tabs,the_args[0],the_args[1]));
	}
	else if (starts_with(&the_args[0], "logic"))
*/
	if starts_with(&the_args[0], "logic")
	{
		the_code.push_str(&gen_logic(&tabs,&the_args[0],&the_args[1]));
	}
	println!("Content: {}", the_code);
/*
	else if (starts_with(the_args[0], "var"))
	{
		the_code.push_str(gen_variables(tabs, the_args[0], the_args[1]));
	}
	else if (starts_with(the_args[0], "stmt"))
	{
		the_code.push_str(gen_statements(tabs, the_args[0], the_args[1]));
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

//	return the_code;
	return "helped".to_string();
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
