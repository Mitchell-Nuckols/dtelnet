module server;

import std.stdio,
       std.socket,
       std.array,
       std.conv;

import core.thread;

import game;

// Main server class. Creates a new thread for each client.
// The ClientThread class is intended to be allowed access to any public method or varable of it's parent (Test)TelnetServer

class TelnetServer {

    private ushort port;
    private Socket server;

    this(ushort port) {
        this.port = port;

        server = new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);

        server.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, true);
        server.bind(new InternetAddress(this.port));
        server.listen(1);
    }

    private Game game = new Game();

    public Game getGame() {
        return game;
    }

    public ClientThread[] clients;

    public void broadcast(byte[] message, ClientThread client) {
        foreach(c; clients) {
            c.sendMessage(message);
        }
    }

    public void clientInput(ClientThread conn, byte[] input) {
        game.getPlayer(conn).input(input);
    }

    public ClientThread[] getClients() {
        return clients;
    }

    public void begin() {
        while(true) {
            Socket client = server.accept();

            ClientThread clientConn = new ClientThread(client, this);
            clientConn.start();

            game.createPlayer(clientConn);

            // Add it to the list of client threads. Allows the program to keep track of all the threads
            clients ~= clientConn;
        }
    }
}

    // New threads are created for each client. This allows the input to be polled individually and (I'm guessing) asynchronously
    class ClientThread : Thread {
        private Socket client;
        private TelnetServer server;
        private bool isEnabled = true;

        this(Socket client, TelnetServer server) {
            this.client = client;
            this.server = server;
            super(&run);
        }

        // The main function of the thread. Listens for input which can then be processed using the Game class
        public void run() {
            writeln("Connected");

            int received;

            while(isEnabled) {
                byte[1024] buffer;

                received = client.receive(buffer);

                byte[] input;

                if(received > 0) input = buffer[0.. received];

                server.clientInput(this, input);
            }

            client.shutdown(SocketShutdown.BOTH);
            client.close();

            writeln("Disabled");
        }

        public void sendMessage(byte[] message) { client.send(message); }
        public void sendScreen(string screen) { client.send(screen); }

        public Socket getClient() { return this.client; }

        public void disable() { isEnabled = false; }
        public void enable() { isEnabled = true; }
    }