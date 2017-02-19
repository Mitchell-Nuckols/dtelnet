module game;

import std.conv,
       std.stdio;

import core.thread;

import player,
       game,
       server;

class Game {
    private Player[int] players;

    private char[20][20] map;

    // TODO: Put in enum
    /*public const byte[][string] keys = [
      "UP": [27, 91, 65],
      "DOWN": [27, 91, 66],
      "RIGHT": [27, 91, 67],
      "LEFT": [27, 91, 68]
    ];*/

    // Init
    this() {
      // Map
      for(int y = 0; y < map.length; y++)
        for(int x = 0; x < map[y].length; x++)
          map[y][x] = '_';
    }

    public void createPlayer(ClientThread connection) {
      int id = players.length + 1;
      players[id] = (new Player(id, connection));

      writeln("Created player with id: " ~ to!string(id));
    }

    public Player getPlayer(ClientThread conn) {
      foreach(p; players)
        if(p.getClient() == conn) return p;

      return null;
    }

    // Not the correct word, but I'd like to think it's the same concept
    public string rasterizeMap() {
      string rendered = "";
      char[20][20] flattened;

      // TODO: Remove this (actually like all of this) for something better
      for(int y = 0; y < flattened.length; y++)
        for(int x = 0; x < flattened[y].length; x++)
          flattened[y][x] = map[y][x];

      foreach(p; players) {
        flattened[p.y][p.x] = p.c;
      }

      foreach(y; flattened) {
        foreach(x; y)
          rendered ~= x;

        rendered ~= "\r\n";
      }

      return rendered;
    }

    public string formatText(string input, string formatting) {
      return "" ~ byte(27) ~ '[' ~ formatting ~ input ~ byte(27) ~ "[0m";
    }

    public void render() {
      string map = rasterizeMap();

      foreach(p; players) {
        p.sendScreen("\fX: " ~ to!string(p.x) ~ "\tY: " ~ to!string(p.y) ~ "\tHP: " ~ to!string(p.health) ~ "\r\n" ~ map);
      }
    }

    public Player getPlayer(int id) {
      return players[id];
    }

    void run() {
      while(true) {
        if(players.length > 0) render();
        Thread.sleep(dur!("msecs")(50));
      }
    }

    public void tick() {

    }
}