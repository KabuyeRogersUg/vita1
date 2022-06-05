module Object.functions;

import std.stdio;
import std.conv;
import std.uni;

import node;
import eval;
import Object.datatype;
import Object.strings;


class Func: DataType{
	string name;
	Node[] code;
	ERROR errors;
	string file;
	string[] pars;
	DataType[] defaults;
	DataType[string] heap;
	DataType[string] attributes;

	this(string name, string[] pars, DataType[] defaults, Node[] code, DataType[string] heap, string file, ERROR errors){
		this.name = name;
		this.pars = pars;
		this.code = code;
		this.heap = heap;
		this.file = file;
		this.errors = errors;
		this.defaults = defaults;

		DataType repr__;

		if (this.name != "lambda"){
			repr__ =  new String(this.name ~ " (custom function)");
		} else {
			repr__ =  new String("(lambda function)");
		}

		this.attributes = [
				"this": new DataType(),
				"__name__": new String(name),
				"__repr__": repr__,
			];
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __call__(DataType[] params){
		DataType[string] hash = this.heap.dup;

		for(ulong i = params.length-1; i < this.defaults.length; i++){
			params ~= this.defaults[i];
		}

		if(params.length >= this.pars.length){
			for (int i = 0; i < this.pars.length; i++){
				hash[this.pars[i]] = params[i];
			}

			hash["this"] = this.attrs["this"];
			return new Eval(this.code, hash, this.file, this.errors).info["return"];
		} else {
			string args;

			for(ulong i = params.length; i < this.pars.length; i++){
				args ~= this.pars[i] ~ " ";
			}

			throw new Exception(this.name ~ "() is missing required arguments [ " ~ args ~ "]");
		}

		return new DataType();
	}

	override string __str__(){
		return this.attributes["__repr__"].__str__;
	}
}

