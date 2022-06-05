module helper;


import std.stdio;
import std.file;
import std.array;

import eval, parser, lexer;

import Object.datatype;
import Object.strings;
import Object.boolean;


string check(DataType path, string ext, DataType[string] importedModules){
	string ph, pt, ptt;
	bool archive = false;

	if (exists(ext)){
		return ext;

	} else if (ext in importedModules) {
		return ext;
	}

	ph = ext ~ ".vt";

	if (!exists(ph)){
		foreach(DataType i; path.__array__){
			ptt = i.__str__~'/'~ ext;
			pt = ptt ~ ".vt";

			if (exists(pt)){
				ph = pt;
				archive = true;
				break;

			} else if (exists(ptt)) {
				ph = ptt;
				archive = true;
				break;
			}
		}

		if (!archive){
			ph = "";
		}
	}

	return ph;
}


class Module: DataType{
	string name;
	DataType[string] attributes;

	this(DataType[string] attributes, string name){
		this.name = name;
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __str__(){
		return this.name~" (module object)";
	}
}


DataType act(Eval knite, string ext, string name, DataType[string] IMPORTED_MODULES){
	DataType[string] hash;
	string[] cop;
	string n2;

	if (ext in IMPORTED_MODULES){
		return IMPORTED_MODULES[ext];
	}

	if (isDir(ext)){
		foreach(string i; dirEntries(ext, "*.vt", SpanMode.shallow)){
			cop = split(split(i, ".")[0], '/');
			n2 = cop[cop.length-1];
			
			hash[n2] = act(knite, i, n2, IMPORTED_MODULES);
		}

		return new Module(hash, name);
	}
	string code;
	File script = File(ext, "r");

	while (!script.eof()){ code ~= script.readln(); }
	script.close();


	DataType[string] obj = new Eval(new Parse(new Lex(code).tokens, ext).ast, hash, ext, knite.errors).hash;

	DataType made = new Module(obj, name);
	IMPORTED_MODULES[ext] = made;

	return made;
}


import Modules.fs;
import Modules.env;
import Modules.math;
import Modules.time;
import Modules.files;
import Modules.random;
import Modules.socket;


DataType[string] IMPORTS(string[] argv) {
	return [
		"fs": new FileSystem(),
		"math": new Math(),
		"open": new Open(),
		"random": new Random(),
		"time": new Time(),
		"socket": new Sockets(),
		"env": new Env(argv),
	];
}


import lib.builtins;


DataType[string] BUILTINS(){
	return [
		"print": new print(),
		"readline": new readline(),
		"iter": new Iter(),
		"next": new Next(),
		"props": new dirs(),
		"super": new Super(),
		"len": new Length(),
		"range": new Range(),

		"delAttr": new DelAttr(),
		"getAttr": new GetAttr(),
		"setAttr": new SetAttr(),
	
	];
}

