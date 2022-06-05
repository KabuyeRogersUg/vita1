module Modules.socket;

import std.stdio;
import std.conv;
import std.socket;

import Object.datatype;
import Object.boolean;
import Object.strings;
import Object.numbers;
import Object.bytes;


AddressFamily[string] AddrFamilies(){
    return ["INET": AddressFamily.INET, "UNIX": AddressFamily.UNIX];
}

SocketType[string] sockTypes(){
    return ["STREAM": SocketType.STREAM, "DGRAM": SocketType.DGRAM];
}


class Soc_Bind: DataType{
    DataType[string] attributes;
    Socket socket;

    this(Socket socket){
        this.socket = socket;
    }

    override DataType __call__(DataType[] params){
        if (params.length > 1){
            this.socket.bind(new InternetAddress(params[0].__str__, to!ushort(params[1].number)));
        }

        return new None();
    }

    override string __str__() {
        return "bind (socket method)";
    }
}

class Soc_Listen: DataType{
    DataType[string] attributes;
    Soc socket;

    this(Soc socket){
        this.socket = socket;
    }

    override DataType __call__(DataType[] params){

        if (params.length){
            this.socket.socket.listen(to!int(params[0].number2));
        }

        this.socket.socket.listen(5);
        this.socket.readSet = new SocketSet();

        return new None();
    }

    override string __str__() {
        return "listen (socket method)";
    }
}

class Soc_Connect: DataType{
    DataType[string] attributes;
    Socket socket;

    this(Socket socket){
        this.socket = socket;
    }

    override DataType __call__(DataType[] params){
        if (params.length > 1){
            this.socket.connect(new InternetAddress(params[0].__str__, to!ushort(params[1].number)));
        }

        return new None();
    }

    override string __str__() {
        return "connect (socket method)";
    }
}

class Soc_Recv: DataType{
    DataType[string] attributes;
    char[2048] buffer;
    Socket socket;

    this(Socket socket){
        this.socket = socket;
        this.buffer = buffer;
    }

    override DataType __call__(DataType[] params){
        auto recv = socket.receive(this.buffer);

        if(params.length){
            long buf = params[0].number2;

            if (buf > -1){
                return new String(to!string(this.buffer[0 .. buf]));
            }

        } else if (recv > -1){
            return new String(to!string(this.buffer[0 .. recv]));
        }

        return new None();
    }

    override string __str__() {
        return "recv (socket method)";
    }
}

class Soc_Close: DataType{
    DataType[string] attributes;
    Socket socket;

    this(Socket socket){
        this.socket = socket;
    }

    override DataType __call__(DataType[] params){
        this.socket.close();
        return new None();
    }

    override string __str__() {
        return "close (socket method)";
    }
}

class Soc_Send: DataType{
    DataType[string] attributes;
    Socket socket;

    this(Socket socket){
        this.socket = socket;
    }

    override DataType __call__(DataType[] params){
        if (params.length){
            this.socket.send(params[0].__str__);
        }

        return new None();
    }

    override string __str__() {
        return "send (socket method)";
    }
}

class Soc_Accept: DataType{
    DataType[string] attributes;
    Soc soc;

    this(Soc soc){
        this.soc = soc;
    }

    override DataType __call__(DataType[] params){
        this.soc.readSet.reset();
        this.soc.readSet.add(this.soc.socket);

        foreach(client; this.soc.connectedClients) {
            this.soc.readSet.add(client);
        }

        if(Socket.select(this.soc.readSet, null, null)) {

            foreach(client; this.soc.connectedClients){
                if(this.soc.readSet.isSet(client)) {
                    //writeln(this.soc.connectedClients);
                }
            }

            if(this.soc.readSet.isSet(this.soc.socket)) {
                auto newSocket = this.soc.socket.accept();
                this.soc.connectedClients ~= newSocket;

                return new NewSoc(newSocket);
            }
        }

        return new NewSoc(this.soc.socket);
    }

    override string __str__() {
        return "accept (socket method)";
    }
}


class NewSoc: DataType{
    DataType[string] attributes;
    Socket socket;

    this(Socket socket){
        this.socket = socket;

        this.attributes = [
            "send": new Soc_Send(this.socket),
            "recv": new Soc_Recv(this.socket),
            "close": new Soc_Close(this.socket),
        ];
    }

    override DataType[string] attrs() {
        return this.attributes;
    }

    override DataType __call__(DataType[] params){
        return new None();
    }

    override string __str__() {
        return "socket (object)";
    }
}


class Soc: DataType{
    string address, types;
    DataType[string] attributes;
    Socket socket;

    Socket[] connectedClients;
    SocketSet readSet;

    this(string Addr, string Type){
        this.address = Addr;
        this.types = Type;

        this.connectedClients = connectedClients;
        this.readSet = readSet;

        this.socket = new Socket(AddrFamilies[Addr], sockTypes[Type]);

        this.attributes = [
            "bind": new Soc_Bind(this.socket),
            "connect": new Soc_Connect(this.socket),
            "listen": new Soc_Listen(this),
            "accept": new Soc_Accept(this),
            "send": new Soc_Send(this.socket),
            "recv": new Soc_Recv(this.socket),
            "close": new Soc_Close(this.socket),
        ];
    }

    override DataType[string] attrs() {
        return this.attributes;
    }

    override DataType __call__(DataType[] params){
        return new None();
    }

    override string __str__() {
        return "socket (family: "~this.address ~ ", type: "~this.types~")";
    }
}


class NSocket: DataType{
    override DataType __call__(DataType[] params){
        if (params.length > 1){
            return new Soc(params[0].__str__, params[1].__str__);

        } else {
            throw new Exception("Expects two args AddrFamily & SocketType.");
        }

        return new None();
    }

    override string __str__() {
        return "class (socket)";
    }
}



class Sockets: DataType{
    DataType[string] attributes;

    this(){
        this.attributes = [
            "socket": new NSocket(),

            // address family
            "INET": new String("INET"),
            "UNIX": new String("UNIX"),

            // socket types
            "STREAM": new String("STREAM"),
            "DGRAM": new String("DGRAM"),
        ];
    }

    override DataType[string] attrs() {
        return this.attributes;
    }

    override string __str__() {

        return "Socket (built-in module)";
    }
}

