module Object.numbers;

import std.stdio;
import std.conv;
import std.uni;

import Object.datatype;


class Number: DataType{
	double data;
	DataType[] attrs;

	this(double data){
		this.data = data;
		this.attrs = attrs;
	}

	override double number(){
		return this.data;
	}

	override long number2(){
		return to!long(this.data);
	}

	override string __str__(){
		return to!string(this.data);
	}

	override bool capable(){
		if (this.data == 0){
			return false;
		}
		return true;
	}
}


