module Modules.files;

import core.stdc.errno;
import std.exception;
import std.stdio;
import std.conv;
import std.file;

import Object.datatype;
import Object.boolean;
import Object.strings;
import Object.bytes;
import Object.lists;


class Open: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = attributes;
	}

	override DataType[string] attrs() {
		return this.attributes;
	}

	override DataType __call__(DataType[] params){
		if (params.length){
			switch (params.length){
				case 1:
					return new OpenFile(params[0].__str__, "r");
				default:
					return new OpenFile(params[0].__str__, params[1].__str__);
					break;
			}

		} else {
			throw new Exception("Expected a string 'FilePath and Mode'.");
		}

		return new None();
	}

	override string __str__() {
		return "open (built-in file object)";
	}
}


class OpenFile: DataType{
	File file;
	string name, mode;
	DataType[string] attributes;

	this(string name, string mode){
		this.name = name;
		this.mode = mode;
 
 		try{
			this.file = File(name, mode);
	    
	    } catch (ErrnoException ex) {
	        switch(ex.errno)
	        {
	            case EPERM:
	            case EACCES:
	            	// Permission denied
	                throw new Exception("opening '"~name ~ "': Permission denied!");	
	            case ENOENT:
	                // File does not exist
	                throw new Exception("file "~name ~ ": Not found!");
	            default:
	                // Handle other errors
	                throw ex;
	                break;
	        }
	    }


		this.attributes = [
			"read": new Reader(this.file),
			"close": new Closer(this.file),
			"toPos": new Seeker(this.file),
			"write": new Writer(this.file),
			"writebytes": new WriteBytes(this.file),
			"readbytes": new ReadBytes(this.file),
			"readlines": new ReadLines(this.file),
		];
	}

	override DataType[string] attrs() {
		return this.attributes;
	}

	override string __str__() {
		return "open (file: '" ~ this.name ~ "' mode: 'r')";
	}

}


class Reader: DataType{
	File file;

	this(File file){
		this.file = file;
	}

	override DataType __call__(DataType[] params){
		string Encoding = "UTF-8";

		if (params.length){
			Encoding = params[0].__str__;
		}

		try {
			switch (Encoding){
				case "UTF-16":
					return new String(to!string(readText!(wstring)(this.file.name)));
				case "UTF-32":
					return new String(to!string(readText!(dstring)(this.file.name)));
				default:
					return new String(readText(this.file.name));
					break;
			}

		} catch (Exception ex){
			throw ex;
		}
	}

	override string __str__() {
		return "read (open method)"; 
	}
}

class Closer: DataType{
	File data;

	this(File data){
		this.data = data;
	}

	override DataType __call__(DataType[] params){
		this.data.close();
		return new None();
	}

	override string __str__() {
		return "close (open method)";
	}
}


// move to a different starting point of a file before writing to to
class Seeker: DataType{
	File file;

	this(File file){
		this.file = file;
	}

	override DataType __call__(DataType[] params){
		int Bytes;
		string pos = "START";

		if (params.length){
			Bytes = to!int(params[0].number);

			if (params.length > 1){
				pos = params[1].__str__;
			}

			try {
				switch (pos) {
					case "END":
						this.file.seek(Bytes, SEEK_END);
						break;

					case "CUR":
						this.file.seek(Bytes, SEEK_CUR);
						break;

					default:
						this.file.seek(Bytes, SEEK_SET);
						break;
				}

			} catch (ErrnoException ex) {
				throw ex;
			}

		} else {
			throw new Exception("Expected 2 args 'int' & 'string'.");
		}

		return new None();
	}

	override string __str__() {
		return "toPos (open method)"; 
	}
}

// writing a string to a file
class Writer: DataType{
	File file;

	this(File file){
		this.file = file;
	}

	override DataType __call__(DataType[] params){
		if (params.length) {
			try {
				this.file.write(params[0].__str__);

			} catch (FileException ex) {
				throw ex;
			}
		}
		return new None();
	}

	override string __str__() {
		return "read (open method)"; 
	}
}

// writing bytes to a file
class WriteBytes: DataType{
	File file;

	this(File file){
		this.file = file;
	}

	override DataType __call__(DataType[] params){
		if (params.length) {
			try {
				this.file.rawWrite(params[0].__bytes__);

			} catch (FileException ex) {
				throw ex;
			}
		}
		return new None();
	}

	override string __str__() {
		return "readbytes (open method)"; 
	}
}

// read bytes from a file
class ReadBytes: DataType{
	File file;

	this(File file){
		this.file = file;
	}

	override DataType __call__(DataType[] params){
		byte[] buffer;

		if (params.length) {
			buffer.length = to!int(params[0].number);
		}

		try {
			return new Bytes(this.file.rawRead(buffer));

		} catch (FileException ex) {
			throw ex;
		}
		return new None();
	}

	override string __str__() {
		return "readbytes (open method)"; 
	}
}


// read string lines from a file
class ReadLines: DataType{
	File file;

	this(File file){
		this.file = file;
	}

	override DataType __call__(DataType[] params){
		DataType[] lines;
		string line;

		try {
			while ((line = file.readln()) !is null)
	        {
	        	lines ~= new String(line);
	        }
			return new List(lines);

		} catch (FileException ex) {
			throw ex;
		}

		return new List(lines);
	}

	override string __str__() {
		return "readlines (open method)"; 
	}
}

