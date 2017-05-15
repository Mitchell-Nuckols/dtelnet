module app;

import core.thread;

import std.stdio,
       std.conv;

import server,
       game;

/*
DTELNET: A generic rpg game programmed using D and played through telnet (SyncTerm is pretty good)
This program in it's current state is actually horrible
So far, everything I have tested works fine, it's just that the program structure is complete garbage
Like, seriously, try and follow what it's doing. Pretty (unreasonably) complicated
So,
TODOS:
- Fix program structure. Creating a Game instance from the TelnetServer instance is NOT a good way to do this.
- Research how safe it is to keep these thread objects kept stored with the player objects (most likely okay).
(kinda done) Draw a map and process input from multiple clients. A key step to actually making this a game.
    - Now I need to make it so the screen is rendered to each client individually, allowing for different views on
        each client
    - I'm thinking the Player class will have to be upgraded, along with the Game class, and a possible new Map class
    - The rendering might be a bit weird, but I don't think I should even consider attempting it until my whole program
        structure is actually not shit

FAR AWAY TODOS:
- Create a class to manage the rendering (as in, like, hud info, the map, text, etc. all being organized
    in a class, easy to add new elements to the gui)
- Actual game mechanics. Monsters, items, weapons, spells, etc.
*/


private TelnetServer ts;

public Game gameInst;

void main() {
    ts = new TelnetServer(23);

    // So we can do other things while the server is running
    auto server = new Thread(&ts.begin).start();

    gameInst = ts.getGame();

    gameInst.run();
}