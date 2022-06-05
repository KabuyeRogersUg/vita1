module lexer;

import node;

import std.stdio;
import std.conv;
import std.algorithm;
import std.typecons;



string letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIKLMNOPQRSTUVWXYZ_$";
string keys =  "abcdefghijklmnopqrstuvwxyzABCDEFGHIKLMNOPQRSTUVWXYZ_$1234567890";
string numbers = "1234567890";
string numbs = "1234567890._";
string meters = "?;,({[]}):.";
string expr = "=!<>";
string aliases = "&|";
string operators = "+-*/%";


class Lex{
	int pos, line, tab, loc;
	Token[] tokens;
	string code;
	char tok;
	bool end;

	this(string code){
		this.code = code;
		this.pos = -1;
		this.tok = tok;
		this.loc = 0;
		this.tab = 0;
		this.line = 1;
		this.tokens = tokens;
		this.end = true;
		this.next();
		this.parse();
	}

	void next(){
		this.pos += 1;
		this.loc += 1;

		if (this.pos < this.code.length){
			this.tok = this.code[this.pos];
		} else {
			this.end = false;
		}
	}

	void rString(){
		char quot = this.tok;
		string str;
		this.next();

		while (this.end && this.tok != quot && this.tok != '\n'){
			if (this.tok == '\\'){
				this.next();
				str ~= '\\';

				if (this.end){
					str ~= this.tok;
					this.next();
				}

			} else {
				str ~= this.tok;
				this.next();
			}
		}

		this.next();
		this.tokens ~= new Token(str, "STR", this.tab, this.line, this.loc);
	}

	void lex_keywords(){
		string key;
		while (this.end && find(keys, this.tok).length){
			key ~= this.tok;
			this.next();
		}

		switch (key){
			case "if":
				this.tokens ~= new Token(key, "IF", this.tab, this.line, this.loc);
				break;
			case "else":
				this.tokens ~= new Token(key, "ELSE", this.tab, this.line, this.loc);
				break;
			case "elif":
				this.tokens ~= new Token(key, "ELIF", this.tab, this.line, this.loc);
				break;
			case "in":
				this.tokens ~= new Token(key, "IN", this.tab, this.line, this.loc);
				break;
			case "return":
				this.tokens ~= new Token(key, "RET", this.tab, this.line, this.loc);
				break;
			case "true":
				this.tokens ~= new Token(key, "TRUE", this.tab, this.line, this.loc);
				break;
			case "false":
				this.tokens ~= new Token(key, "FALSE", this.tab, this.line, this.loc);
				break;
			case "none":
				this.tokens ~= new Token(key, "NONE", this.tab, this.line, this.loc);
				break;
			case "while":
				this.tokens ~= new Token(key, "WHILE", this.tab, this.line, this.loc);
				break;
			case "for":
				this.tokens ~= new Token(key, "FOR", this.tab, this.line, this.loc);
				break;
			case "switch":
				this.tokens ~= new Token(key, "SWITCH", this.tab, this.line, this.loc);
				break;
			case "when":
				this.tokens ~= new Token(key, "CASE", this.tab, this.line, this.loc);
				break;
			case "break":
				this.tokens ~= new Token(key, "BREAK", this.tab, this.line, this.loc);
				break;
			case "default":
				this.tokens ~= new Token(key, "DF", this.tab, this.line, this.loc);
				break;
			case "continue":
				this.tokens ~= new Token("cont", "CONT", this.tab, this.line, this.loc);
				break;
			case "try":
				this.tokens ~= new Token(key, "TRY", this.tab, this.line, this.loc);
				break;
			case "except":
				this.tokens ~= new Token(key, "CATCH", this.tab, this.line, this.loc);
				break;
			case "fn":
				this.tokens ~= new Token(key, "FN", this.tab, this.line, this.loc);
				break;
			case "and":
				this.tokens ~= new Token(key, "AND", this.tab, this.line, this.loc);
				break;
			case "or":
				this.tokens ~= new Token(key, "OR", this.tab, this.line, this.loc);
				break;
			case "not":
				this.tokens ~= new Token(key, "NOT", this.tab, this.line, this.loc);
				break;
			case "import":
				this.tokens ~= new Token(key, "IM", this.tab, this.line, this.loc);
				break;
			case "from":
				this.tokens ~= new Token(key, "FR", this.tab, this.line, this.loc);
				break;
			case "as":
				this.tokens ~= new Token(key, "AS", this.tab, this.line, this.loc);
				break;
			case "class":
				this.tokens ~= new Token(key, "CL", this.tab, this.line, this.loc);
				break;
			case "let":
				break;
			default:
				if (key == "r" && find("'\"", this.tok).length){
					this.rString();

				} else {
					this.tokens ~= new Token(key, "ID", this.tab, this.line, this.loc);
				}

				break;
		}
	}

	void lex_operators(){
		string toky;
		toky ~= this.tok;
		this.next();

		if (this.tok == '='){
			this.tokens ~= new Token(toky, "AA", this.tab, this.line, this.loc);
			this.next();

		} else {
			this.tokens ~= new Token(toky, toky, this.tab, this.line, this.loc-1);
		}
	}

	void lex_meters(){
		string[char] metersCase = ['.': ".", ',': ",", ';': ";", ':': ":", '[': "[", ']': "]", '{': "{", '}': "}", '(': "(", ')': ")", '?':"?"];
		this.tokens ~= new Token(metersCase[this.tok], metersCase[this.tok], this.tab, this.line, this.loc);
		this.next();
	}

	void lex_expr(){
		string option;
		option ~= this.tok;
		this.next();

		if (this.tok == '='){
			this.next();

			switch (option){
				case "=":
					this.tokens ~= new Token("==", "==", this.tab, this.line, this.loc);
					break;
				case "<":
					this.tokens ~= new Token("<=", "<=", this.tab, this.line, this.loc);
					break;
				case ">":
					this.tokens ~= new Token(">=", ">=", this.tab, this.line, this.loc);
					break;
				default:
					this.tokens ~= new Token("!=", "!=", this.tab, this.line, this.loc);
					break;
			}

		} else if (this.tok == '>' && option == "="){
			this.next();
			this.tokens ~= new Token("=>", "ARR", this.tab, this.line, this.loc);

		} else if (option == "!") {
			this.tokens ~= new Token(option, "NOT", this.tab, this.line, this.loc);


		} else {
			this.tokens ~= new Token(option, option, this.tab, this.line, this.loc);
		}
	}

	void lex_number(){
		string num;

		while (this.end && find(numbs, this.tok).length){
			if (this.tok != '_'){
				num ~= this.tok;
			}
			this.next();
		}

		this.tokens ~= new Token(num, "NUM", this.tab, this.line, this.loc);
	}

	void Aliases(){
		string op;
		op ~= this.tok;
		this.next();

		if (find("&|", this.tok).length){
			op ~= this.tok;
			this.next();
		}

		if (op == "&&"){
			this.tokens ~= new Token(op, "AND", this.tab, this.line, this.loc);
		} else {
			this.tokens ~= new Token(op, "OR", this.tab, this.line, this.loc);
		}
	}

	string lex_string(){
		char key;
		char quot = this.tok;
		string str;
		this.next();
		char[char] escapes = ['r':'\r', 't':'\t', 'n':'\n', 'b':'\b', '\\': '\\'];

		while (this.end && this.tok != quot && this.tok != '\n'){
			if (this.tok == '\\'){
				key = this.tok;
				this.next();

				if (find("btnr\\", this.tok).length){
					str ~= escapes[this.tok];
				} else if (this.tok == quot){
					str ~= quot;
				}
			} else{
				str ~= this.tok;
			}
			this.next();
		}

		this.next();
		return str;
	}

	string lex_multline_string(){
		char[char] escapes = ['r':'\r', 't':'\t', 'n':'\n', 'b':'\b', '\\': '\\'];
		string str;
		char key;
		this.next();

		while (this.end && this.tok != '`'){
			if (this.tok == '\\'){
				this.next();

				if (find("btnr\\", this.tok).length){
					str ~= escapes[this.tok];
				} else if (this.tok == '`'){
					str ~= '`';
				}
			} else{
				str ~= this.tok;
			}
			this.next();

		}
		this.next();
		return str;
	}

	void parse(){
		while (this.end){
			if (find(letters, this.tok).length){
				this.lex_keywords();

			} else if (find(meters, this.tok).length){
				this.lex_meters();

			} else if (find(operators, this.tok).length){
				this.lex_operators();

			} else if (find("\"'", this.tok).length){
				this.tokens ~= new Token(this.lex_string, "STR", this.tab, this.line, this.loc);

			} else if (find(numbers, this.tok).length){
				this.lex_number();

			} else if (this.tok == '\n'){
				this.tokens ~= new Token("\\n", "NL", this.tab, this.line, this.loc);
				this.tab = 0;
				this.line += 1;
				this.next();
				this.loc = -1;

			} else if (this.tok == '\t'){
				this.tab += 1;
				this.next();

			} else if (find("&|", this.tok).length) {
				this.Aliases();

			} else if (find(expr, this.tok).length){
				this.lex_expr();

			} else if (this.tok == '#') {
				this.next();

				while (this.end && this.tok != '\n'){
					this.next();
				}

			} else if(this.tok == '`'){
				this.tokens ~= new Token(this.lex_multline_string, "FMT", this.tab, this.line, this.loc);

			} else if (this.tok == ' ') {
				string tabz;

				while (this.end && this.tok == ' '){
					tabz ~= this.tok;
					this.next();

					if (tabz == "  "){
						tabz = "";
						this.tab += 1;
					}
				}

			} else {
				this.next();
			}
		}

		if (this.tokens.length > 0){
			this.tokens ~= new Token("EOF", "NL", this.tab, this.line, this.loc);
		}		
	}
}


