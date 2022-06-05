module Modules.time;

import std.uni;
import std.conv;
import std.stdio;
import std.algorithm;

import core.time;
import core.stdc.time;
import std.datetime;
import core.thread;

import Object.lists;
import Object.dictionary;
import Object.strings;
import Object.numbers;
import Object.datatype;


DataType toD(ulong x){
    return new Number(to!double(x));
}

string toC(string i){
    string[string] months = ["jan":"Jan", "feb":"Feb", "mar":"Mar", "apr":"Apr", "may":"May", "jun":"Jun", "jul":"Jul", "aug":"Aug", "sept":"Sept", "oct":"Oct", "nov":"Nov", "dec":"Dec"];

    if (i in months){
        return months[i];
    }
    return i;
}

class Currtime: DataType{
    override DataType __call__(DataType[] params){
        string ctime;
        auto ct = std.datetime.systime.Clock.currTime;

        string mon = to!string(ct.month);
        
        ctime ~= toC(mon) ~ ' ';
        ctime ~= to!string(ct.day) ~ ' ';
        ctime ~= to!string(ct.hour) ~ ':';
        ctime ~= to!string(ct.minute) ~ ':';
        ctime ~= to!string(ct.second) ~ ' ';
        ctime ~= to!string(ct.year);

        return new String(ctime);
    }

    override string __str__() {
        return "ctime (time method)";
    }
}

class Sleep: DataType{
    override DataType __call__(DataType[] params){
        if (params.length == 1){
            Thread.sleep(dur!"seconds"(params[0].number2));

        } else if (params.length){
            Thread.sleep(dur!"msecs"(params[0].number2));
        }

        return new Number(0);
    }

    override string __str__() {
        return "sleep (time method)";
    }
}

class DateTime: DataType{
    override DataType __call__(DataType[] params){
        DataType[string] DateO;
        auto ct = std.datetime.systime.Clock.currTime;

        string mon = to!string(ct.month);

        DateO["month"] = new String(toC(mon));
        DateO["day"] = new String(to!string(ct.day));
        DateO["hour"] = new String(to!string(ct.hour));
        DateO["minute"] = new String(to!string(ct.minute));
        DateO["second"] = new String(to!string(ct.second));
        DateO["year"] = new String(to!string(ct.year));

        return new Dict(DateO);
    }

    override string __str__() {
        return "date (time method)";
    }
}

class Days: DataType{
    override DataType __call__(DataType[] params){
        DataType[string] TC;

        if (params.length){
            auto Tm = dur!"days"(to!int(params[0].number));

            TC["weeks"] = toD(Tm.total!"weeks");
            TC["days"] = toD(Tm.total!"days");
            TC["hours"] = toD(Tm.total!"hours");
            TC["minutes"] = toD(Tm.total!"minutes");
            TC["secs"] = toD(Tm.total!"seconds");
            TC["msecs"] = toD(Tm.total!"msecs");
            TC["usecs"] = toD(Tm.total!"usecs");
            TC["hnsecs"] = toD(Tm.total!"hnsecs");
            TC["nsecs"] = toD(Tm.total!"nsecs");
        }
        return new Dict(TC);
    }

    override string __str__() {
        return "days (time method)";
    }
}

class Weeks: DataType{
    override DataType __call__(DataType[] params){
        DataType[string] TC;

        if (params.length){
            auto Tm = dur!"weeks"(to!int(params[0].number));

            TC["weeks"] = toD(Tm.total!"weeks");
            TC["days"] = toD(Tm.total!"days");
            TC["hours"] = toD(Tm.total!"hours");
            TC["minutes"] = toD(Tm.total!"minutes");
            TC["secs"] = toD(Tm.total!"seconds");
            TC["msecs"] = toD(Tm.total!"msecs");
            TC["usecs"] = toD(Tm.total!"usecs");
            TC["hnsecs"] = toD(Tm.total!"hnsecs");
            TC["nsecs"] = toD(Tm.total!"nsecs");
        }
        return new Dict(TC);    }

    override string __str__() {
        return "weeks (time method)";
    }
}

class Hours: DataType{
    override DataType __call__(DataType[] params){
        DataType[string] TC;

        if (params.length){
            auto Tm = dur!"hours"(to!int(params[0].number));

            TC["weeks"] = toD(Tm.total!"weeks");
            TC["days"] = toD(Tm.total!"days");
            TC["hours"] = toD(Tm.total!"hours");
            TC["minutes"] = toD(Tm.total!"minutes");
            TC["secs"] = toD(Tm.total!"seconds");
            TC["msecs"] = toD(Tm.total!"msecs");
            TC["usecs"] = toD(Tm.total!"usecs");
            TC["hnsecs"] = toD(Tm.total!"hnsecs");
            TC["nsecs"] = toD(Tm.total!"nsecs");
        }

        return new Dict(TC);
    }

    override string __str__() {
        return "hours (time method)";
    }
}

class Minutes: DataType{
    override DataType __call__(DataType[] params){
        DataType[string] TC;

        if (params.length){
            auto Tm = dur!"minutes"(to!int(params[0].number));

            TC["weeks"] = toD(Tm.total!"weeks");
            TC["days"] = toD(Tm.total!"days");
            TC["hours"] = toD(Tm.total!"hours");
            TC["minutes"] = toD(Tm.total!"minutes");
            TC["secs"] = toD(Tm.total!"seconds");
            TC["msecs"] = toD(Tm.total!"msecs");
            TC["usecs"] = toD(Tm.total!"usecs");
            TC["hnsecs"] = toD(Tm.total!"hnsecs");
            TC["nsecs"] = toD(Tm.total!"nsecs");
        }
        return new Dict(TC);
    }

    override string __str__() {
        return "minutes (time method)";
    }
}

class Seconds: DataType{
    override DataType __call__(DataType[] params){
        DataType[string] TC;

        if (params.length){
            auto Tm = dur!"seconds"(to!int(params[0].number));

            TC["weeks"] = toD(Tm.total!"weeks");
            TC["days"] = toD(Tm.total!"days");
            TC["hours"] = toD(Tm.total!"hours");
            TC["minutes"] = toD(Tm.total!"minutes");
            TC["secs"] = toD(Tm.total!"seconds");
            TC["msecs"] = toD(Tm.total!"msecs");
            TC["usecs"] = toD(Tm.total!"usecs");
            TC["hnsecs"] = toD(Tm.total!"hnsecs");
            TC["nsecs"] = toD(Tm.total!"nsecs");
        }
        return new Dict(TC);
    }

    override string __str__() {
        return "minutes (time method)";
    }
}


class Time: DataType{
    DataType[string] attributes;

    this(){
        this.attributes = [
            "ctime": new Currtime(),
            "sleep": new Sleep(),
            "date": new DateTime(),
            "days": new Days(),
            "weeks": new Weeks(),
            "hours": new Hours(),
            "minutes": new Minutes(),
            "seconds": new Seconds(),
        ];
    }

    override DataType[string] attrs() {
        return this.attributes;
    }

    override string __str__() {
        return "time (built-in Time object)";
    }
}

