use std::env;
use std::process::Command;

fn the_version() -> String
{
	return "0.0.96".to_string();
}

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
		println!("{{}}<name>:(<type>)<name> var(public/private):<vars> method:<name>-<type> param:<params>,<param>");
		println!("");
		println!("{{EXAMPLE}}");
		example("{{}}pizza:(int)one,(bool)two,(float)three var(private):(int)toppings [String-mixture]cheese:(String)kind,(int)amount for: nest-for: [String]topping:(String)name,(int)amount if:good");
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
		println!("[<data>]<name>:<parameters>");
		println!("[<data>-<return>]<name>:<parameters>");
		println!("");
//		example("[String]help:(String)one,(int)two");
//		example("[String-Message]help:(String)one,(int)two");
//		example("[String-Type]FoodAndDrink:(String)Food if:Food(-ne)\"\" >if:[IsDrink]:drink(-eq)true +->tab +->tab +->tab +->()Type=\"Drink\" +->el +->>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Drink]:Food o->>el +->else-if:[IsFood]:Food(-eq)true +->tab +->tab +->tab +->()Type=\"Food\" +->el >>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Eat]:Food o->>el >else +->tab +->tab +->tab +->()Eat= +->(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el else +-tab +-tab +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el");
//		example("[String-Type]FoodAndDrink:(String)Food if:Food(-ne)\"\" >if:[IsDrink]:drink(-eq)true +->tab +->tab +->tab +->()Type=\"Drink\" +->el +->>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Drink]:Food o->>el >>if:mood(-ne)\"happy\" >>>do-while:mood(-eq)\"unhappy\" >>>>tab >>>>tab >>>>tab >>>>tab >>>>tab >>>>[ChearUp]:mood >>>>el +->else-if:[IsFood]:Food(-eq)true +->tab +->tab +->tab +->()Type=\"Food\" +->el >>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Eat]:Food o->>el >>if:mood(-ne)\"happy\" >>>do-while:mood(-eq)\"unhappy\" >>>>tab >>>>tab >>>>tab >>>>tab >>>>tab >>>>[ChearUp]:mood >>>>el >else +->tab +->tab +->tab +->(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el else +-tab +-tab +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el");
		example("[String-Type]FoodAndDrink:(String)Food if:Food(-ne)\"\" >if:[IsDrink]:drink(-eq)true +->tab +->tab +->tab +->()Type=\"Drink\" +->el +->>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Drink]:Food o->>el >>if:mood(-ne)\"happy\" >>>do-while:mood(-eq)\"unhappy\" o->>>>tab o->>>>tab o->>>>tab o->>>>tab o->>>>tab o->>>>[ChearUp]:mood o->>>>el +-[print]:\"I(-spc)am(-spc)\"+mood +-el +->else-if:[IsFood]:Food(-eq)true +->tab +->tab +->tab +->()Type=\"Food\" +->el >>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Eat]:Food o->>el >>if:mood(-ne)\"happy\" >>>do-while:mood(-eq)\"unhappy\" >>>>tab >>>>tab >>>>tab >>>>tab >>>>tab >>>>[ChearUp]:mood >>>>el +-[print]:\"I(-spc)am(-spc)\"+mood +-el >else +->tab +->tab +->tab +->(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el else +-tab +-tab +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el");
//		example("[String-Type]FoodAndDrink:(String)Food if:Food(-ne)\"\" >if:[IsDrink]:drink(-eq)true >>tab >>tab >>tab >>()Type=\"Food\" >>el >>tab >>tab >>tab >>[Drink]:Food >>el >else-if:[IsFood]:Food(-eq)true +->>tab +->>tab +->>tab +->>()Type=\"Drink\" +->>el >>tab >>tab >>tab >>[Eat]:Food >>el >else +->tab +->tab +->tab +->(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +->el else +-tab +-tab +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el");
	}
	else if new_the_type == "loop"
	{
		println!("<type>:<param>");
		println!("");
		println!("{{EXAMPLE}}");
		println!("for:");
		println!("do-while:");
		println!("while");
	}
	else if new_the_type == "logic"
	{
		println!("<logic>:<condition>");
		println!("");
		example("if:Type(-spc)==(-spc)\"String\"");
		example("else-if:Type(-eq)\"String\"");
		example("else");
		example("if:true tab (String)drink= [Pop]:one,two el >if:[IsString]:drink(-eq)true >tab >tab >[drink]: >el >>if:drink(-eq)\"coke\" >>else >nl >else-if:[IsInt]:drink(-eq)false >nl >else >>if: >>nl >>else >nl");
		example("if:true tab (String)drink= [Pop]:one,two el >if:[IsString]:drink(-eq)true >>if:drink(-eq)\"coke\" >>else >nl >else-if:[IsInt]:drink(-eq)false >nl >else >>if: >>nl >>else >nl");
//		println!(Type+":switch");
	}
	else if new_the_type == "var"
	{
		example("(std::string)name=\"\" var:(int)point=0 stmt:endline var:james-std::string=\"James\" stmt:endline var:help-int");
		example("(std::string)name=\"\" el (int)point=0 el (std::string)james=\"James\" el (int)help el help=0");
		example("(std::string)name=\"\" el (int)point=0 el (std::string)james=\"James\" el (int)help el help=0");
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
	
	if rustc_version.status.success() && cargo_version.status.success()
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
/*
fn rem_last_char(value: &str, length: u8) -> &str
{
	let mut chars = value.chars();
	let mut cnt = 0;
	if length >= 1
	{
		while cnt != length
		{
			chars.next_back();
			cnt += 1;
		}
	}
	else
	{
		chars.next_back();
	}

	return chars.as_str();
}
*/
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
fn ends_with(str: &str, end: &str) -> bool
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

fn len_a(vec: &Vec<&str>) -> usize
{
	return vec.len();
}
/*
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
fn join(the_str: &Vec<&str>, to_join: &str) -> String
{
	return the_str.join(to_join);
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


fn replace_tag(the_content: &str, the_tag: &str, all: bool) -> String
{
	let mut the_new_content = String::from("");
	let passed_content = the_content.to_string();

	if is_in(&passed_content," ") && starts_with(&passed_content, the_tag)
	{
		let mut remove = true;
		let mut new_content = String::new();
		let mut the_next: String;

		let all_items: Vec<&str> = passed_content.split(" ").collect();
		for item in &all_items
		{
			the_next = item.to_string();
			//element starts with tag
			if starts_with(&the_next, the_tag) && remove == true
			{
				//remove tag
				the_next = after_split(&the_next,"-");
				if all
				{
					remove = false;
				}
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
	let version = &the_version();
	println!("{}",cpl_version);
	println!("[Rust {}] on {}",version,the_os);
	println!("Type \"help\" for more information.");
}

fn translate_tag(input: &str) -> String
{
	let mut the_return = String::new();
	let mut action = String::from(input);
	let mut value = String::new();
//	let mut the_var_name = String::new();
	let mut new_tag = String::new();
	let mut the_nest = String::new();
	let mut content_for = "";

	if starts_with(&action, "+-")
	{
		action = after_split(&action,"-");
		content_for = "logic-";
	}
	else if starts_with(&action, "o-")
	{
		action = after_split(&action,"-");
		content_for = "loop-";
	}
	else if starts_with(&action, "[]-")
	{
		action = after_split(&action,"-");
		content_for = "method-";
	}
	else if starts_with(&action, "{}-")
	{
		action = after_split(&action,"-");
		content_for = "class-";
	}

	// ">" becomes "nest-"
	while starts_with(&action, ">")
	{
		action = after_split(&action,">");
		the_nest.push_str("nest-");
	}
	if starts_with(&action, "if:") || starts_with(&action, "else-if:")
	{
		let tmp_value = after_split(&action,":");
		action = before_split(&action,":");
		new_tag.push_str("logic:");
		new_tag.push_str(&action);
		value.push_str("logic-condition:");
		value.push_str(&tmp_value);
		the_return.push_str(content_for);
		the_return.push_str(&the_nest);
		the_return.push_str(&new_tag);
		the_return.push_str(" ");
		the_return.push_str(&value);
	}
	else if action == "else"
	{
		new_tag.push_str("logic:");
		new_tag.push_str(&action);
		the_return.push_str(&content_for);
		the_return.push_str(&the_nest);
		the_return.push_str(&new_tag);
	}
	else if starts_with(&action, "while:") || starts_with(&action, "for:") || starts_with(&action, "do/while:")
	{
		let tmp_value = after_split(&action,":");
		action = before_split(&action,":");
		new_tag.push_str("loop:");
		new_tag.push_str(&action);
		value.push_str("loop-condition:");
		value.push_str(&tmp_value);
		the_return.push_str(&content_for);
		the_return.push_str(&the_nest);
		the_return.push_str(&new_tag);
		the_return.push_str(" ");
		the_return.push_str(&value);
	}
	else if starts_with(&action, "{") && is_in(&action,"}")
	{
		let tmp_action = &action.to_owned();
		action = after_split(&action,"}");

		if is_in(&action,":")
		{
			value = after_split(&action,":");
			action = before_split(&action,":");
		}

		if value != ""
		{
			let mut the_data_type = after_split(&before_split(tmp_action,"}"),"{");
			the_data_type = data_type(&the_data_type,false);

			the_return.push_str("class:(");
			the_return.push_str(&the_data_type);
			the_return.push_str(")");
			the_return.push_str(&action);
			the_return.push_str(" params:");
			the_return.push_str(&value);
		}
		else
		{
			let mut the_data_type = after_split(&before_split(tmp_action,"}"),"{");
			the_data_type = data_type(&the_data_type,false);

			the_return.push_str("class:(");
			the_return.push_str(&the_data_type);
			the_return.push_str(")");
			the_return.push_str(&action);
		}
	}
	else if starts_with(&action, "[") && is_in(&action,"]")
	{
		let tmp_action = after_split(&action.to_owned(),"]");
		if starts_with(&tmp_action,":")
		{
			let the_data_type = after_split(&before_split(&action,"]"),"[");

			value = after_split(&action,":");
			action = the_data_type;

			the_return.push_str(&content_for);
			the_return.push_str(&the_nest.to_string());
			the_return.push_str("stmt:method-");
			the_return.push_str(&action);
			the_return.push_str(" params:");
			the_return.push_str(&value);
		}
		//is a function
		else
		{
			if is_in(&tmp_action,":")
			{
				value = after_split(&tmp_action,":");
				action = before_split(&action,":");
			}

			if value != ""
			{
				let mut the_data_type = after_split(&before_split(&action,"]"),"[");
				the_data_type = data_type(&the_data_type,false);

				the_return.push_str(&content_for);
				the_return.push_str(&the_nest.to_string());
				the_return.push_str("method:(");
				the_return.push_str(&the_data_type);
				the_return.push_str(")");
				the_return.push_str(&action);
				the_return.push_str(" params:");
				the_return.push_str(&value);
			}
			else
			{
				let mut the_data_type = after_split(&before_split(&action,"]"),"[");
				the_data_type = data_type(&the_data_type,false);

				the_return.push_str(&content_for);
				the_return.push_str(&the_nest.to_string());
				the_return.push_str("method:(");
				the_return.push_str(&the_data_type);
				the_return.push_str(")");
				the_return.push_str(&action);
			}
		}

	}
	else if starts_with(&action, "(") && is_in(&action,")")
	{
		let tmp_action = after_split(&action.to_owned(),")");

		if is_in(&tmp_action,":")
		{
			value = after_split(&tmp_action,":");
			action = before_split(&action,":");
		}

		if value != ""
		{
			let mut the_data_type = after_split(&before_split(&action,")"),"(");
			the_data_type = data_type(&the_data_type,false);

			the_return.push_str(content_for);
			the_return.push_str("var:(");
			the_return.push_str(&the_data_type);
			the_return.push_str(")");
			the_return.push_str(&tmp_action);
			the_return.push_str("=");
			the_return.push_str(&value);
		}
		else
		{
			let mut the_data_type = after_split(&before_split(&action,")"),"(");
			the_data_type = data_type(&the_data_type,false);

			the_return.push_str(content_for);
			the_return.push_str("var:(");
			the_return.push_str(&the_data_type);
			the_return.push_str(")");
			the_return.push_str(&tmp_action);
		}
	}
	else if action == "el"
	{
		the_return.push_str(content_for);
		the_return.push_str("stmt:endline");
	}
	else if action == "nl"
	{
		the_return.push_str(content_for);
		the_return.push_str("stmt:newline");
	}
	else if action == "tab"
	{
		the_return.push_str(content_for);
		the_return.push_str("stmt:");
		the_return.push_str(&action);
	}
	else
	{
		if value != ""
		{
			the_return.push_str(content_for);
			the_return.push_str(&the_nest);
			the_return.push_str(&action);
			the_return.push_str(":");
			the_return.push_str(&value);
		}
		else
		{
			the_return.push_str(content_for);
			the_return.push_str(&the_nest);
			the_return.push_str(&action);
		}
	}

	return the_return.to_string();
}

fn handle_names(the_name: &str) -> String
{
//	let s = "Hello world!";
	let char_vec: Vec<char> = the_name.chars().collect();
	let mut the_return = String::new();
	let mut found = false;
	for c in char_vec
	{
		if c.is_alphabetic() == false
		{
			found = false;
		}

		if c.is_uppercase() && found == false
		{
			the_return.push_str(&c.to_lowercase().to_string());
			found = true;
		}
		else if c.is_uppercase() && found == true
		{
			the_return.push_str("_");
			the_return.push_str(&c.to_lowercase().to_string());
		}
		else
		{
			the_return.push_str(&c.to_string());
		}
	}
	return the_return.to_string();
}

fn data_type(the_type: &str, get_null: bool) -> String
{
	if get_null == false
	{
		//handle strings
		if the_type == "String" || the_type == "string" || the_type == "std::string"
		{
			return "String".to_string();
		}
		else if the_type == "boolean" || the_type == "bool"
		{
			return "bool".to_string();
		}
		else
		{
			return "".to_string();
		}
	}
	else if get_null == true
	{
		if the_type == "String" || the_type == "string" || the_type == "std::string"
		{
			return "\"\"".to_string();
		}
		else if the_type == "boolean" || the_type == "bool"
		{
			return "false".to_string();
		}
		else
		{
			return "".to_string();
		}
	}
	else if the_type == "false" || the_type == "False"
	{
		return "false".to_string();
	}
	else if the_type == "true" || the_type == "True"
	{
		return "true".to_string();
	}
	else
	{
		if get_null == false
		{
			return the_type.to_string();
		}
		else
		{
			return "".to_string();
		}
	}
}

fn gen_conditions(input: &str) -> String
{
	let mut condit = handle_names(&after_split(&input,":"));

	if is_in(&condit,"(-eq)")
	{
		condit = replace_all(&condit, "(-eq)"," == ");
	}

	if is_in(&condit,"(-le)")
	{
		condit = replace_all(&condit, "(-le)"," <= ");
	}

	if is_in(&condit,"(-lt)")
	{
		condit = replace_all(&condit, "(-lt)"," < ");
	}

	if is_in(&condit,"(-ge)")
	{
		condit = replace_all(&condit, "(-ge)"," >= ");
	}

	if is_in(&condit,"(-gt)")
	{
		condit = replace_all(&condit, "(-gt)"," > ");
	}

	if is_in(&condit,"(-ne)")
	{
		condit = replace_all(&condit, "(-ne)"," != ");
	}

	if is_in(&condit,"(-spc)")
	{
		condit = replace_all(&condit, "(-spc)"," ");
	}

	if is_in(&condit,"(-or)")
	{
		condit = replace_all(&condit, "(-or)"," || ");
	}

	if is_in(&condit,"(-and)")
	{
		condit = replace_all(&condit, "(-and)"," && ");
	}

	if is_in(&condit," ")
	{
		let mut tmp = String::from("");
		let conditions: Vec<&str> = condit.split(" ").collect();
		let mut lp = 0;
		let end = len_a(&conditions);
		while lp != end
		{
			let keep = String::from(&translate_tag(&conditions[lp]));
			let tmp_keep = String::from(&gen_code("",&keep.to_string()));
			if tmp_keep == ""
			{
				if tmp.to_string() == ""
				{
					tmp.push_str(&keep);
				}
				else
				{
					tmp.push_str(" ");
					tmp.push_str(&keep);
				}
			}
			else
			{
				if tmp.to_string() == ""
				{
					tmp.push_str(&tmp_keep);
				}
				else
				{
					tmp.push_str(" ");
					tmp.push_str(&tmp_keep);
				}
			}
			lp += 1;
		}
//		condit = join(&conditions, " ");
		condit = tmp.to_string();
	}
	else
	{
		let mut tmp = data_type(&condit,false);
		let old_condit = &tmp.clone();
		condit = translate_tag(&tmp);
		tmp = gen_code("",&condit);

		if tmp == ""
		{
			tmp = old_condit.to_string();
		}
		condit = tmp;
	}
	//logic
	if is_in(&condit,"(-not)")
	{
		condit = replace_all(&condit, "(-not)","!");
	}
/*
	if starts_with(condit, "(")
	{
		condit = condit[1:len(Condit)]
	}
	if ends_with(&condit, ")")
	{
		condit = rem_last_char(&condit, 1).to_string();
	}
*/
	return condit;
}

//params:
fn gen_parameters(input: &str, called_by: &str) -> String
{
	let mut name: String;
	let the_params = after_split(input,":");
	let mut new_params = String::new();

	if called_by == "class" || called_by == "method" || called_by == "stmt"
	{
		//param-type,param-type,param-type
		if starts_with(&the_params,"(") && is_in(&the_params,")") && is_in(&the_params,",")
		{
			//param
			name = handle_names(&before_split(&the_params,","));
			let mut more = after_split(&the_params,",");
			let mut the_type = before_split(&name,")");

			name = after_split(&name,")");
			the_type = after_split(&the_type,"(");
			the_type = data_type(&the_type, false);

			let mut more_params = String::new();
			more_params.push_str("params:");
			more_params.push_str(&more);
			more = gen_parameters(&more_params.to_string(), &called_by);

			//param: type, param: type, param: type
			new_params.push_str(&name);
			new_params.push_str(": ");
			new_params.push_str(&the_type);
			new_params.push_str(", ");
			new_params.push_str(&more);
		}
		//param-type
		else if starts_with(&the_params,"(") && is_in(&the_params,")")
		{
			name = handle_names(&after_split(&the_params,")"));
			let mut the_type = before_split(&the_params,")");
			the_type = after_split(&the_type,"(");
			the_type = data_type(&the_type, false);

			//param: type
			new_params.push_str(&name);
			new_params.push_str(": ");
			new_params.push_str(&the_type);
		}
		else
		{
			new_params.push_str(&handle_names(&the_params));
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
	the_complete.push_str(&handle_names(&the_name));
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

	return the_complete.to_string();
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
	let mut return_var = String::from("the_return");
	let mut default_value = String::from("");
	let mut the_type = String::new();
	let mut the_params = String::new();
	let mut method_content = String::new();
	let mut the_process = String::new();
	let mut passed_content = the_content.to_string();
	let mut the_other_content = String::from("");
	let mut new_content = String::from("");

	//method:(<type>)<name>
	if starts_with(&new_name,"(") && is_in(&new_name,")")
	{
		the_type = after_split(&before_split(&new_name,")"),"(");
		//get method name
		the_name = handle_names(&after_split(&new_name,")"));
		if is_in(&the_name,"-")
		{
			return_var = after_split(&the_type,"-");
			the_type = before_split(&the_type,"-");
		}
		default_value.push_str(&data_type(&the_type,true));
		//Converting data type to correct C++ type
		the_type = data_type(&the_type,true);
	}
	//method:<name>
	else
	{
		//get method name
		the_name = handle_names(&new_name.clone());
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

//			the_other_content = replace_tag(&the_other_content, "method-");

			let mut parse_content = String::from("");

			let cmds: Vec<&str> = the_other_content.split(" ").collect();
			for item in &cmds
			{
				let corrected = replace_tag(&item, "method-",false).clone();

				//starts with "logic:" or "loop:"
				if starts_with(&corrected,"logic:") || starts_with(&corrected,"loop:") || starts_with(&corrected,"var:") || starts_with(&corrected,"stmt:")
				{
					//Only process code that starts with "logic:" or "loop:"
					if parse_content != ""
					{
						//process content
						method_content.push_str(&gen_code(&new_tabs,&parse_content));
					}
					//Reset content
					parse_content = String::from("");
					parse_content.push_str(&corrected);
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
		the_complete.push_str(&handle_names(&the_name));
		the_complete.push_str("(");
		the_complete.push_str(&the_params);
		the_complete.push_str(")\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("{\n");
		the_complete.push_str(&method_content.to_string());
		the_complete.push_str("\n");
		the_complete.push_str(the_tabs);
		the_complete.push_str("}\n");
	}
	else
	{
		if default_value.to_string() == ""
		{
			the_complete.push_str(the_tabs);
			the_complete.push_str("fn ");
			the_complete.push_str(&handle_names(&the_name));
			the_complete.push_str("(");
			the_complete.push_str(&the_params);
			the_complete.push_str(") -> ");
			the_complete.push_str(&the_type);
			the_complete.push_str("\n");
			the_complete.push_str(the_tabs);
			the_complete.push_str("{\n");
			the_complete.push_str(the_tabs);
			the_complete.push_str("\tlet ");
			the_complete.push_str(&return_var);
			the_complete.push_str(": ");
			the_complete.push_str(&the_type);
			the_complete.push_str(";\n");
			the_complete.push_str(&method_content.to_string());
			the_complete.push_str("\n");
			the_complete.push_str(the_tabs);
			the_complete.push_str("\treturn ");
			the_complete.push_str(&return_var);
			the_complete.push_str(";\n");
			the_complete.push_str(the_tabs);
			the_complete.push_str("}\n");
		}
		else
		{
			the_complete.push_str(the_tabs);
			the_complete.push_str("fn ");
			the_complete.push_str(&handle_names(&the_name));
			the_complete.push_str("(");
			the_complete.push_str(&the_params);
			the_complete.push_str(") -> ");
			the_complete.push_str(&the_type);
			the_complete.push_str("\n");
			the_complete.push_str(the_tabs);
			the_complete.push_str("{\n");
			the_complete.push_str(the_tabs);
			the_complete.push_str("\tlet ");
			the_complete.push_str(&return_var);
			the_complete.push_str(": ");
			the_complete.push_str(&the_type);
			the_complete.push_str(" = ");
			the_complete.push_str(&default_value.to_string());
			the_complete.push_str(";\n");
			the_complete.push_str(&method_content.to_string());
			the_complete.push_str("\n");
			the_complete.push_str(the_tabs);
			the_complete.push_str("\treturn ");
			the_complete.push_str(&return_var);
			the_complete.push_str(";\n");
			the_complete.push_str(the_tabs);
			the_complete.push_str("}\n");
		}
	}
	return the_complete.to_string();
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

	//loop:<type>
	if starts_with(&new_kind,"loop:")
	{
		new_kind = after_split(&new_kind,":");
	}

	while passed_content != ""
	{
		passed_content = replace_tag(&passed_content, "loop-",false);
//		passed_content = replace_tag(&passed_content, "loop-",true);

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
			the_condition = gen_conditions(&the_condition,);
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
//			loop_content.push_str(&gen_code(&new_tabs,&the_other_content));

			//handle the content if the first tag is a stmt: or var:
			if starts_with(&the_other_content, "stmt:") || starts_with(&the_other_content, "var:") && is_in(&the_other_content," ")
			{
				let cmds: Vec<&str> = the_other_content.split(" ").collect();
				let mut more_new_content = String::from("");
				let mut more_the_other_content = String::from("");
				for item in &cmds
				{
					//as long as the beginning of the tag is stmt:, var:, or params: make sure to build the non-loop/logic tags
					if is_in(item,"stmt:") || is_in(item,"var:") || is_in(item,"params:") && new_content.to_string() == ""
					{
						if more_the_other_content.to_string() == ""
						{
							more_the_other_content.push_str(item);
						}
						else
						{
							more_the_other_content.push_str(" ");
							more_the_other_content.push_str(item);
						}
					}
					//build the rest of the content
					else
					{
						if more_new_content.to_string() == ""
						{
							more_new_content.push_str(item);
						}
						else
						{
							more_new_content.push_str(" ");
							more_new_content.push_str(item);
						}
					}
				}

				the_other_content = more_the_other_content.to_string();
				new_content = more_new_content.to_string();

				//processes all the statements before a loop/logic
				loop_content.push_str(&gen_code(&new_tabs,&the_other_content));

				//Lets group the nested tages one more time...I am not sure how to avoide this being done again
				if starts_with(&new_content, "nest-")
				{
					root_tag = before_split(&new_content,"l");
					new_root_tag = [" ",&root_tag,"l"].concat();
					if is_in(&new_content,&new_root_tag)
					{
						let other_tag = [" ",&new_root_tag,"l"].concat();
						//split up the loops and logic accordingly
						let cmds: Vec<&str> = new_content.split(&other_tag).collect();
						let mut new_content = String::new();
						let end = len_a(&cmds);
						let mut lp = 0;
						while lp != end
						{
							if lp == 0
							{
								the_other_content = String::from(cmds[lp]);
								//remove all nest-
								while starts_with(&the_other_content, "nest-")
								{
									the_other_content = after_split(&the_other_content,"-");
								}
								//process loop/logic
								loop_content.push_str(&gen_code(&new_tabs,&the_other_content));
							}
							else
							{
								if new_content.to_string() == ""
								{
									new_content.push_str(&root_tag);
									new_content.push_str("l");
									new_content.push_str(&cmds[lp]);
								}
								else
								{
									new_content.push_str(" ");
									new_content.push_str(&root_tag);
									new_content.push_str("l");
									new_content.push_str(&cmds[lp]);
								}
							}
							lp += 1;
						}
					}

					while starts_with(&new_content, "nest-")
					{
						new_content = String::from(&after_split(&new_content,"-"));
					}
					//process the remaining nest-loop/logic
					loop_content.push_str(&gen_code(&new_tabs,&new_content));
				}
			}
			//just process as is
			else
			{
				loop_content.push_str(&gen_code(&new_tabs,&the_other_content));
			}
			//clear new content
			new_content = "".to_string();
		}
		else if starts_with(&passed_content, "loop-") || starts_with(&passed_content, "var:") || starts_with(&passed_content, "stmt:")
		{
			passed_content = replace_tag(&passed_content, "loop-",true);
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
		passed_content = replace_tag(&passed_content, "logic-",false);
//		passed_content = replace_tag(&passed_content, "logic-",true);

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
			the_condition = gen_conditions(&the_condition);
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
			logic_content.push_str(&gen_code(&new_tabs,&the_other_content));
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
//			logic_content.push_str(&gen_code(&new_tabs,&the_other_content));

			//handle the content if the first tag is a stmt: or var:
			if starts_with(&the_other_content, "stmt:") || starts_with(&the_other_content, "var:") && is_in(&the_other_content," ")
			{
				let cmds: Vec<&str> = the_other_content.split(" ").collect();
				let mut more_new_content = String::new();
				let mut more_the_other_content = String::from("");
				for item in &cmds
				{
					//as long as the beginning of the tag is stmt:, var:, or params: make sure to build the non-loop/logic tags
					if is_in(item,"stmt:") || is_in(item,"var:") || is_in(item,"params:") && new_content.to_string() == ""
					{
						if more_the_other_content.to_string() == ""
						{
							more_the_other_content.push_str(item);
						}
						else
						{
							more_the_other_content.push_str(" ");
							more_the_other_content.push_str(item);
						}
					}
					//build the rest of the content
					else
					{
						if more_new_content.to_string() == ""
						{
							more_new_content.push_str(item);
						}
						else
						{
							more_new_content.push_str(" ");
							more_new_content.push_str(item);
						}
					}
				}

				the_other_content = more_the_other_content.to_string();
				new_content = more_new_content.to_string();

				//processes all the statements before a loop/logic
				logic_content.push_str(&gen_code(&new_tabs,&the_other_content));

				//Lets group the nested tages one more time...I am not sure how to avoide this being done again
				if starts_with(&new_content, "nest-")
				{
					println!("{}",new_content);
					root_tag = before_split(&new_content,"l");
					new_root_tag = [" ",&root_tag,"l"].concat();
					if is_in(&new_content,&new_root_tag)
					{
						let other_tag = [" ",&new_root_tag,"l"].concat();
						//split up the loops and logic accordingly
						let cmds: Vec<&str> = new_content.split(&other_tag).collect();
						let mut new_content = String::new();
						let end = len_a(&cmds);
						let mut lp = 0;
						while lp != end
						{
							if lp == 0
							{
								the_other_content = String::from(cmds[lp]);
								//remove all nest-
								while starts_with(&the_other_content, "nest-")
								{
									the_other_content = after_split(&the_other_content,"-");
								}
								//process loop/logic
								logic_content.push_str(&gen_code(&new_tabs,&the_other_content));
							}
							else
							{
								if new_content.to_string() == ""
								{
									new_content.push_str(&root_tag);
									new_content.push_str("l");
									new_content.push_str(&cmds[lp]);
								}
								else
								{
									new_content.push_str(" ");
									new_content.push_str(&root_tag);
									new_content.push_str("l");
									new_content.push_str(&cmds[lp]);
								}
							}
							lp += 1;
						}
					}

					while starts_with(&new_content, "nest-")
					{
						new_content = String::from(&after_split(&new_content,"-"));
					}
					//process the remaining nest-loop/logic
					logic_content.push_str(&gen_code(&new_tabs,&new_content));
				}
			}
			//just process as is
			else
			{
				logic_content.push_str(&gen_code(&new_tabs,&the_other_content));
			}
			//clear new content
			new_content = "".to_string();
		}
		else if starts_with(&passed_content, "logic-") || starts_with(&passed_content, "var:") || starts_with(&passed_content, "stmt:")
		{
			passed_content = replace_tag(&passed_content, "logic-",true);
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

	if starts_with(&new_kind, "stmt:")
	{
		new_kind = after_split(&new_kind,":");
	}

	if is_in(&new_kind,"-")
	{
		the_name = handle_names(&before_split(&new_kind,"-"));
		name = handle_names(&after_split(&new_kind,"-"));
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
			passed_content = after_split(&passed_content," ");
			if starts_with(&passed_content, "params:")
			{
				let mut newer_other_content = String::from("");
				newer_other_content.push_str(&the_other_content);
				newer_other_content.push_str(" ");
				newer_other_content.push_str(&before_split(&passed_content," "));
				the_other_content = newer_other_content.to_string();
				passed_content = after_split(&passed_content," ");
			}
			statement_content.push_str(&gen_code(the_tabs,&the_other_content));
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
	else if the_name == "tab"
	{
		the_complete.push_str("\t");
		the_complete.push_str(&statement_content);
	}

	return the_complete;
}

//var:
fn gen_variables(the_tabs: &str, the_kind_type: &str, the_content: &str) -> String
{
	let mut the_last = false;
	let mut make_equal = false;
	let mut new_kind = the_kind_type.to_string();
	let mut new_var = String::new();
//	let the_type: String;
	let mut the_name = String::from("");
	let mut var_type = String::from("");
	let mut the_value = String::from("");
//	let the_new_content = String::new();
	let mut variable_content = String::new();
//	let mut the_other_content = String::from("");
	let mut the_other_content: String;
	let mut passed_content = the_content.to_string();

	if starts_with(&new_kind, "var:")
	{
		new_kind = after_split(&new_kind,":");
		new_kind = handle_names(&new_kind);
	}

	while passed_content != ""
	{
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
			the_other_content = before_split(&passed_content," ");
			passed_content = after_split(&passed_content," ");
			if starts_with(&passed_content, "params:")
			{
				let mut newer_other_content = String::from("");
				newer_other_content.push_str(&the_other_content);
				newer_other_content.push_str(" ");
				newer_other_content.push_str(&before_split(&passed_content," "));
				the_other_content = newer_other_content.to_string();
				passed_content = after_split(&passed_content," ");
			}
			variable_content.push_str(&gen_code(the_tabs,&the_other_content));
		}
	}

	//Pull Variable Type
	if starts_with(&new_kind,"(") && is_in(&new_kind,")")
	{
		var_type = String::from(&data_type(&after_split(&before_split(&new_kind,")"),"("),false));
		new_kind = after_split(&new_kind,")");
		the_name = String::from(new_kind.clone());
	}

	//Assign Value
	if is_in(&new_kind,"=")
	{
		make_equal = true;
		the_name = before_split(&new_kind,"=");
		the_value = after_split(&new_kind,"=");
	}

	if var_type != ""
	{
		new_var.push_str("let ");
		new_var.push_str(&the_name);
		new_var.push_str(": ");
		new_var.push_str(&var_type);
	}
	else
	{
		new_var.push_str(&the_name);
	}

	if make_equal == true
	{
		new_var.push_str(" = ");
		new_var.push_str(&the_value);
	}
	new_var.push_str(&variable_content);

	return new_var.to_string();
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

/*
<<shell>> []Example:(String)tag while:true o-if:IsIn el
// params:Type-String if:Type(-eq)"String"(-or)Type(-eq)"string" +-var:TheReturn="std::string" +-stmt:endline else-if:Type(-eq)"boolean" +-var:Type="bool" +-stmt:endline else +-var:TheReturn=Type +-stmt:endline
*/
fn example(tag: &str)
{
	let mut user_in = String::new();
//	let mut new_user_in = String::from("");
	if is_in(tag, " ")
	{
		let all: Vec<&str> = tag.split(" ").collect();
		for item in &all
		{
			if user_in == ""
			{
				user_in.push_str(&translate_tag(&item));
			}
			else
			{
				user_in.push_str(&translate_tag(" "));
				user_in.push_str(&translate_tag(&item));
			}
		}
	}
//	print("Command: "+UserIn);
	println!("");
	println!("\t{{OUTPUT}}");
	println!("{}",gen_code("", &user_in));
}

fn main()
{
	let mut has_run_banner = false;
	let mut arg_count = 0;
	let mut user_in = String::new();
	let mut finished_content: String;
	let version = &the_version();

	loop
	{
		//CLI arguments
		for args in env::args().skip(1)
		{
			if arg_count == 0
			{ 
//				user_in.push_str(&args);
				user_in.push_str(&translate_tag(&args));
			}
			else
			{
				user_in.push_str(" ");
//				user_in.push_str(&args);
				user_in.push_str(&translate_tag(&args));
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
			else if user_in == "version"
			{
				println!("{}",version);
			}
			else if starts_with(&user_in, "help")
			{
				the_help(&user_in);
			}
		}

		if starts_with(&user_in, "help")
		{
			the_help(&user_in);
		}
		else if user_in == "-v" || user_in == "--version"
		{
			println!("{}",version);
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
