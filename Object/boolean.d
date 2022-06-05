module Object.boolean;

import Object.datatype;


class None: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __str__(){
		return "none";
	}
}

class True: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __str__(){
		return "true";
	}

	override bool capable(){
		return true;
	}
}


class False: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __str__(){
		return "false";
	}
}


class EOI: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __str__(){
		return "NaN";
	}
}
