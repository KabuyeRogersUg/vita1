module Object.lists;

import std.stdio;
import std.conv;
import std.uni;

import Object.datatype;
import Object.strings;
import Object.boolean;
import Object.numbers;


class Link: DataType{
	List data;

	this(List data){
		this.data = data;
	}

	override string __str__(){
		return "[ref]";
	}
}


class Push: DataType{
	List list;
	DataType[string] attributes;

	this(List list){
		this.list = list;
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __call__(DataType[] params){
		if (params.length){
			if (params[0] == this.list){
				this.list.data ~= new Link(this.list);

			} else {
				this.list.data ~= params[0];
			}
		}
		return new None();
	}

	override string __str__(){
		return "push (built-in list function)";
	}
}

class Dup: DataType{
	List list;
	DataType[string] attributes;

	this(List list){
		this.list = list;
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __call__(DataType[] params){
		return new List(this.list.data.dup);
	}

	override string __str__(){
		return "dup (built-in list function)";
	}
}



class List: DataType{
	DataType[] data;
	DataType[string] attributes;

	this(DataType[] data){
		this.data = data;
		this.attributes = [
							"push": new Push(this),
							"dup": new Dup(this),
						  ];
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType[] __array__(){
		return this.data;
	}

	override DataType __iter__(int index){
		if (index < this.data.length){
			return this.data[index];
		}

		return new EOI();
	}

	override string __str__(){
		string str = "[";
		DataType cur;
		DataType[] dt = this.data;

		if (dt.length){
			for(int i = 0; i < dt.length-1; i++){
				cur = dt[i];

				if (typeid(cur) == typeid(String)){
					str ~= "'" ~ cur.__str__ ~ "', ";
				} else {
					str ~= cur.__str__ ~ ", ";
				}
			}

		
			cur = dt[data.length-1];

			if (typeid(cur) == typeid(String)){
				str ~= "'" ~ cur.__str__ ~ "'";

			} else {
				str ~= cur.__str__;
			}
		}

		str ~= "]";
		return str;
	}

	override DataType __call__(DataType[] i){
		int x = to!int(i[0].number);

		if (x < this.data.length){
			return this.data[x];
		}

		return new EOI();
	}

	override DataType __index__(DataType[] i){
		int x = to!int(i[0].number);

		if (x < this.data.length){
			this.data[x] = i[1];
		}

		return new None();
	}

	override DataType __length__(){
		return new Number(to!double(this.data.length));
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

