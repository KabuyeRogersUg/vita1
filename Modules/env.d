module Modules.env;

import std.stdio;
import std.file;

import Object.datatype;
import Object.strings;
import Object.boolean;
import Object.lists;


class Env: DataType{
	string[] argv;
	DataType[string] attributes;

	this(string[] argv){
		DataType[] argc;

		for(ulong i = 1; i < argv.length; i++){
			argc ~= new String(argv[i]);
		}

		this.attributes = [
							"path": new List([new String(""), new String(getcwd())]),
							"argv": new List(argc),
						];
	}
	
	override DataType[string] attrs() {
		return this.attributes;
	}

	override string __str__() { return "env (built-in env-variables object)"; }
}



