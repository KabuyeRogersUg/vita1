module lib.builtins;

import std.stdio;
import std.conv;
import std.string;

import Object.datatype;
import Object.strings;
import Object.numbers;
import Object.boolean;
import Object.lists;


class print: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __call__(DataType[] params){
		foreach(DataType i; params){
			writef("%s ", i.__str__);
		}

		writeln();
		return this;
	}
}


class dirs: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = attributes;
	}

	override DataType __call__(DataType[] params){
		DataType[] dir;

		foreach(string i; params[0].attrs.keys){
			dir ~= new String(i);
		}

		return new List(dir);
	}
}


class readline: DataType{	
	override string __str__(){
		return "readline (built-in function)";
	}

	override DataType __call__(DataType[] params){
		foreach(DataType i; params){
			writef("%s", i.__str__);
		}

		return new String(chomp(readln()));
	}
}


class iterObject: DataType{
	int len;
	string repr;
	DataType data;
	DataType[string] attributes;

	this(DataType data){
		this.data = data;
		this.len = -1;
		this.attributes = ["__iter__": this.data];

		if (typeid(data) == typeid(String)){
			this.repr = "string_iterator (Object)";

		} else if (typeid(data) == typeid(Range)) {
			this.repr = "range ()";

		} else {
			this.repr = "list_iterator (Object)";
		}
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __fetch__(){
		this.len += 1;
		return this.data.__iter__(this.len);
	}

	override string __str__(){
		return this.repr;
	}

	override DataType __length__(){
		return this.data.__length__;
	}
}


class Range: DataType{
	double start;
	double end;
	DataType[string] attributes;

	this(){
		this.start = -1;
		this.end = end;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __iter__(int index){
		if (this.start < this.end){
			this.start += 1;
			return new Number(this.start);
		}

		return new EOI();
	}

	override DataType __call__(DataType[] params){
		if (params.length == 1){
			this.end = params[0].number-1;
		} else {
			this.start = params[0].number-1;
			this.end = params[1].number-1;
		}

		return new iterObject(this);
	}

	override string __str__(){
		return "range (built-in function)";
	}
}


class Iter: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __call__(DataType[] params){
		if ("__iter__" in params[0].attrs){
			return params[0];
		} else {
			return new iterObject(params[0]);
		}
	}

	override string __str__(){
		return "iter (built-in function)";
	}
}


class Next: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __call__(DataType[] params){
		return params[0].__fetch__;
	}

	override string __str__(){
		return "next (built-in function)";
	}
}


// super
class _super: DataType{
	DataType obj;
	DataType inst;
	DataType[string] attributes;

	this(DataType obj, DataType inst){
		this.obj = obj;
		this.inst = inst;
		this.attributes = attributes;
	}

	override DataType __call__(DataType[] params){
		this.obj.__heap__[this.inst.attrs["__name__"].__str__].__call__(params);
		return new DataType();
	}
}


class Super: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __call__(DataType[] params){
		return new _super(params[0], params[1]);
		return this;
	}

	override string __str__(){
		return "super (built-in function)";
	}
}


class Length: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __call__(DataType[] params){
		return params[0].__length__;
	}

	override string __str__(){
		return "super (built-in function)";
	}
}


class GetAttr: DataType{
	override DataType __call__(DataType[] params){
		if (params.length > 1){
			string att = params[1].__str__;

			if (att in params[0].attrs) {
				return params[0].attrs[att];

			} else {
				throw new Exception("Attribute '"~att~"' not found.");
			}
		}

		return new None();
	}

	override string __str__(){
		return "getAttr (built-in function)";
	}
}

class SetAttr: DataType{
	override DataType __call__(DataType[] params){
		if (params.length > 2){
			string att = params[1].__str__;
			
			params[0].attrs[att] = params[2];
			return new True();
		}

		return new None();
	}

	override string __str__(){
		return "setAttr (built-in function)";
	}
}


class DelAttr: DataType{
	override DataType __call__(DataType[] params){
		if (params.length > 1){
			string att = params[1].__str__;

			if (att in params[0].attrs) {
				params[0].attrs.remove(att);
				return new True();
			}
		}

		return new None();
	}

	override string __str__(){
		return "delAttr (built-in function)";
	}
}
