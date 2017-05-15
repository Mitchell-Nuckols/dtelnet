/*module server;

import std.stdio;
import std.socket;
import std.array;
import std.conv;

public byte[][string] keys;

public char[20][20] map;

public int xPos = 0, yPos = 0;

public string formatText(string input, string formatting) {
    return "" ~ byte(27) ~ '[' ~ formatting ~ input ~ byte(27) ~ "[0m";
}

public string drawScreen() {
    string rendered = "\f";

    // Hud rendering
    rendered ~= "x: " ~ to!string(xPos) ~ " y: " ~ to!string(yPos) ~ "\r\n";

    // Map rendering
    for(int y = 0; y < map.length; y++) {
        for(int x = 0; x < map[y].length; x++) {
            if(y == yPos && x == xPos) rendered ~= formatText("@", "0;32m");
            else rendered ~= map[y][x];
        }

        rendered ~= "\r\n";
    }

    return rendered;
}

public void removeLater() {
    keys["up"] = [27, 91, 65];
    keys["down"] = [27, 91, 66];
    keys["right"] = [27, 91, 67];
    keys["left"] = [27, 91, 68];

    // Create map
    for(int y = 0; y < map.length; y++) {
        for(int x = 0; x < map[y].length; x++) {
            map[y][x] = '_';
        }
    }
}

class TelnetServer {

    private ushort port;

    private Socket server;

    private bool running;

    this(ushort port) {

        removeLater();

        this.port = port;

        server = new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);

        server.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, true);
        server.bind(new InternetAddress(this.port));
        server.listen(1);
    }

     public void begin() {
        while(true) {
            Socket client = server.accept();

            writeln("Connection begin");

            byte[] input;

            client.send(drawScreen());

            while(client.isAlive) {
                byte[1024] buffer;
                auto received = client.receive(buffer);

                if(received > 0) {

                    writefln("The client said:\n%s", buffer[0.. received]);

                    input = buffer[0.. received];

                    if(input == keys["up"]) yPos--;
                    if(input == keys["down"]) yPos++;
                    if(input == keys["right"]) xPos++;
                    if(input == keys["left"]) xPos--;

                    writeln(to!string(xPos) ~ ", " ~ to!string(yPos));

                    client.send(drawScreen());
                }else {
                    client.shutdown(SocketShutdown.BOTH);
                    client.close();
                }
            }

            xPos = 0;
            yPos = 0;

            writeln("Connection end");
        }
     }
}*/