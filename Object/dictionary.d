module Object.dictionary;

import std.stdio;
import std.conv;
import std.uni;

import Object.datatype;
import Object.strings;
import Object.numbers;
import Object.boolean;
import Object.lists;


class Keys: DataType{
	Dict data;
	DataType[string] attributes;

	this(Dict data){
		this.data = data;
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __call__(DataType[] params){
		DataType[] keys;

		foreach(key, value; this.data.data){
			keys ~= new String(key);
		}
		return new List(keys);
	}

	override string __str__(){
		return "keys (built-in dictionary function)";
	}
}


class Values: DataType{
	Dict data;
	DataType[string] attributes;

	this(Dict data){
		this.data = data;
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __call__(DataType[] params){
		//DataType[] keys;

		//foreach(key, value; this.data.data){
		//	keys ~= key;
		//}

		return new List(this.data.data.values);
	}

	override string __str__(){
		return "values (built-in dictionary function)";
	}
}


class Dict: DataType{
	DataType[string] data;
	DataType[string] attributes;

	this(DataType[string] data){
		this.data = data;
		this.attributes = ["keys": new Keys(this), "values": new Values(this)];
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __str__(){
		string repr = "{";
		int x = 0;
		string end = ",";

		if (this.data.length){
			foreach(key, value; this.data){
				x += 1;
				if (x == this.data.length){
					end = " ";
				}

				if (typeid(value) == typeid(String)){
					repr ~= ' ' ~ key ~ ": '" ~ value.__str__ ~ "'" ~ end;
				} else {
					repr ~= ' ' ~ key ~ ": " ~ value.__str__  ~ end;
				}

			}
		}

		repr ~= "}";
		return repr;
	}

	override DataType __call__(DataType[] i){
		string x = i[0].__str__;

		if (x in this.data){
			return this.data[x];
		}

		return new EOI();
	}

	override DataType __index__(DataType[] i){
		string x = i[0].__str__;

		if (x in this.data){
			this.data[x] = i[1];
		}

		return new None();
	}

	override DataType __length__(){
		return new Number(to!double(this.data.length));
	}

	override bool capable(){
		if (this.data.length == 0){
			return false;
		}
		return true;
	}
}

