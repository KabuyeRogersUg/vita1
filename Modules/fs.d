module Modules.fs;

import std.stdio;
import std.file;

import Object.datatype;
import Object.strings;
import Object.boolean;


class isDirectory: DataType{
	override DataType __call__(DataType[] params){

		if (!params.length || !exists(params[0].__str__)) {
			throw new Exception("isdir expects an existing path.");
		
		} else if (isDir(params[0].__str__)) {
			return new True();
		}

		return new False();
	}
	override string __str__() { return "isdir (fs method)"; }
}

class isAFile: DataType{
	override DataType __call__(DataType[] params){

		if (!params.length || !exists(params[0].__str__)) {
			throw new Exception("isfile expects an existing path.");
		
		} else if (isFile(params[0].__str__)) {
			return new True();
		}

		return new False();
	}
	override string __str__() { return "isfile (fs method)"; }
}


class Cut: DataType{
	override DataType __call__(DataType[] params){
		if (exists(params[0].__str__)) {
			rename(params[0].__str__, params[1].__str__);
		}
		return new None();
	}

	override string __str__() {
		return "cut (fs method)";
	}
}


class Copy: DataType{
	override DataType __call__(DataType[] params){
		if (exists(params[0].__str__)) {
			copy(params[0].__str__, params[1].__str__);
		}
		return new None();
	}
	override string __str__() { return "copy (fs method)"; }
}


class PathExists: DataType{
	override DataType __call__(DataType[] params){

		if (!params.length){
			throw new Exception("exists expects a string argument.");
		} else if (exists(params[0].__str__)) {
			return new True();
		}

		return new False();
	}
	override string __str__() { return "exists (fs method)"; }
}


class changeDir: DataType{
	override DataType __call__(DataType[] params){

		if (!params.length || !exists(params[0].__str__)) {
			throw new Exception("chdir expects an existing path.");
		}
		
		chdir(params[0].__str__);
		return new None();
	}
	override string __str__() { return "chdir (fs method)"; }
}


class makeDirs: DataType{
	override DataType __call__(DataType[] params){

		if (!params.length){
			throw new Exception("mkdirs expects a string path.");
		} else if (exists(params[0].__str__)) {
			return new None();
		} else {			
			mkdirRecurse(params[0].__str__);
		}

		return new None();
	}
	override string __str__() { return "mkdirs (fs method)"; }
}


class removeDirs: DataType{
	override DataType __call__(DataType[] params){

		if (!params.length || !exists(params[0].__str__)) {
			throw new Exception("rmdirs expects an existing path.");
		}
		
		rmdirRecurse(params[0].__str__);
		return new None();
	}
	override string __str__() { return "rmdirs (fs method)"; }
}


class Remove: DataType{
	override DataType __call__(DataType[] params){

		if (!params.length || !exists(params[0].__str__)) {
			throw new Exception("rmdirs expects an existing path.");
		}
		
		remove(params[0].__str__);
		return new None();
	}
	override string __str__() { return "rmdirs (fs method)"; }
}


class PWD: DataType{
	override DataType __call__(DataType[] params){
		return new String(getcwd());
	}
	override string __str__() { return "getcwd (fs method)"; }
}


class FileSystem: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = [
							"exists": new PathExists(),
							"isfile": new isAFile(),
							"isdir": new isDirectory(),
							"cut": new Cut(),
							"copy": new Copy(),
							"chdir": new changeDir(),
							"mkdirs": new makeDirs(),
							"rmdirs": new removeDirs(),
							"getcwd": new PWD(),
							"remove": new Remove()
						];
	}
	
	override DataType[string] attrs() {
		return this.attributes;
	}

	override string __str__() { return "fs (built-in file-system object)"; }
}



