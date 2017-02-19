module player;

import std.conv;

import server,
       game;

class Player {
    private int id;
    private ClientThread connection;

    // TODO: Add getters/setters
    public int x, y, health;
    public char c = '@';

    // The connection the client has with the server. Used to send data back to the client and render the client's screen
    //private ClientThread connection;

    this(int id, ClientThread connection) {
        this.id = id;

        if(id == 2) c = '$';

        this.connection = connection;
    }

    public void sendScreen(string screen) {
        connection.sendScreen(screen);
    }

    // 0: UP 1: DOWN 2: RIGHT 3: LEFT
    public void input(byte[] input) {
        if(input == [27, 91, 65]) y--;
        if(input == [27, 91, 66]) y++;
        if(input == [27, 91, 67]) x++;
        if(input == [27, 91, 68]) x--;
    }

    public int getId() { return this.id; }
    public ClientThread getClient() { return this.connection; }
}