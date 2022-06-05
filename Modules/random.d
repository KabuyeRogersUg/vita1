module Modules.random;

import std.stdio;
import std.random;
import std.conv;
import std.datetime;
import std.algorithm;

import Object.datatype;
import Object.boolean;
import Object.strings;
import Object.numbers;
import Object.lists;


class Dice: DataType{
    override DataType __call__(DataType[] params){
        if (params.length){
            return params[0].__array__.choice;
        }

        return new None();
    }

    override string __str__() {
        return "dice (random method)";
    }
}

class Shuffle: DataType{
    override DataType __call__(DataType[] params){
        if (params.length){      
            DataType[] dupl, arr;

            ulong[] ret = params[0].__listrepr__;
            ulong pos;

            if (typeid(params[0]) == typeid(List)){
                arr = params[0].__array__.dup;

                while (arr.length){
                    pos = dice(ret);
                    dupl ~= arr[pos];

                    ret = ret.remove(pos);
                    arr = arr.remove(pos);
                }

                return new List(dupl);

            }
        }

        return new None();
    }

    override string __str__() {
        return "shuffle (random method)";
    }
}

class Randint: DataType{
    override DataType __call__(DataType[] params){
        if (params.length){
            if (params.length > 1) {
                return new Number(uniform(params[0].number, params[1].number));
            } else {
                return new Number(uniform(0, params[0].number));
            }
        }

        return new Number(0);
    }

    override string __str__() {
        return "randint (random method)";
    }
}


class Random: DataType{
    DataType[string] attributes;

    this(){
        this.attributes = [
            "dice": new Dice(),
            "shuffle": new Shuffle(),
            "randint": new Randint(),
        ];
    }

    override DataType[string] attrs() {
        return this.attributes;
    }

    override string __str__() {
        return "random (built-in Random object)";
    }
}

