module Object.bytes;

import std.stdio;
import std.conv;
import std.uni;

import Object.numbers;
import Object.boolean;
import Object.datatype;


class Bytes: DataType{
	byte[] bytes;
	DataType[string] attributes;

	this(byte[] bytes){
		this.bytes = bytes;
		this.attributes = attrs;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __str__(){
		return to!string(this.bytes);
	}

	override byte[] __bytes__(){
		return this.bytes;
	}

	override bool capable(){
		if (this.__str__.length == 0){
			return false;
		}
		return true;
	}
}
