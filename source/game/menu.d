module menu;

struct MenuItem {
    string text;
    void delegate() action;
}

class Menu {
    MenuItem[] menuItems;

    void bindItem(string text, void delegate() action) {
        menuItems ~= MenuItem(text, action);
    }

    void render() {

    }
}