module Object.strings;

import std.stdio;
import std.conv;
import std.uni;

import Object.bytes;
import Object.numbers;
import Object.boolean;
import Object.datatype;


class upperCase: DataType{
	string data;
	DataType[string] attributes;

	this(string data){
		this.data = data;
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __call__(DataType[] params){
		return new String(toUpper(this.data));	
	}

	override string __str__(){
		return "upperCase (built-in string function)";
	}
}


class lowerCase: DataType{
	string data;
	DataType[string] attributes;

	this(string data){
		this.data = data;
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __call__(DataType[] params){
		return new String(toLower(this.data));	
	}

	override string __str__(){
		return "lowerCase (built-in string function)";
	}
}


class String: DataType{
	string data;
	DataType[string] attributes;

	this(string data){
		this.data = data;
		this.attributes = ["upperCase": new upperCase(data), "lowerCase": new lowerCase(data)];
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __str__(){
		return this.data;
	}
	
	override DataType __length__(){
		return new Number(to!double(this.data.length));
	}

	override DataType __iter__(int index){
		if (index < this.data.length){
			string idx;
			return new String(idx~this.data[index]);
		}

		return new EOI();
	}

	override DataType __call__(DataType[] i){
		int x = to!int(i[0].number);

		if (x < this.data.length){
			return new String(to!string(this.data[x]));
		}

		return new None();
	}

	override ulong[] __listrepr__(){
		ulong[] ret;

		for(ulong i = 1; i < this.data.length+1; i++){
			ret ~= i;
		}

		return ret;
	}

	override bool capable(){
		if (this.data.length == 0){
			return false;
		}
		return true;
	}
}
