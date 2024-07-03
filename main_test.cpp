#include "pirates24b1.h"
#include <string>
#include <iostream>

using namespace std;

void print(string cmd, StatusType res);
void print(string cmd, output_t<int> res);
void print_avl_tree(const Ocean &ocean);

int main()
{
    int d1, d2, d3;

    // Init
    Ocean *obj = new Ocean();

    // Execute all commands in file
    string op;
    while (cin >> op)
    {
        if (!op.compare("add_ship"))
        {
            cin >> d1 >> d2;
            print(op, obj->add_ship(d1, d2));
        }
        else if (!op.compare("remove_ship"))
        {
            cin >> d1;
            print(op, obj->remove_ship(d1));
        }
        else if (!op.compare("add_pirate"))
        {
            cin >> d1 >> d2 >> d3;
            print(op, obj->add_pirate(d1, d2, d3));
        }
        else if (!op.compare("remove_pirate"))
        {
            cin >> d1;
            print(op, obj->remove_pirate(d1));
        }
        else if (!op.compare("treason"))
        {
            cin >> d1 >> d2;
            print(op, obj->treason(d1, d2));
        }
        else if (!op.compare("update_pirate_treasure"))
        {
            cin >> d1 >> d2;
            print(op, obj->update_pirate_treasure(d1, d2));
        }
        else if (!op.compare("get_treasure"))
        {
            cin >> d1;
            print(op, obj->get_treasure(d1));
        }
        else if (!op.compare("get_cannons"))
        {
            cin >> d1;
            print(op, obj->get_cannons(d1));
        }
        else if (!op.compare("get_richest_pirate"))
        {
            cin >> d1;
            print(op, obj->get_richest_pirate(d1));
        }
        else if (!op.compare("ships_battle"))
        {
            cin >> d1 >> d2;
            print(op, obj->ships_battle(d1, d2));
        }
        else if (!op.compare("avl_ll"))
        {
            cout << "before LL" << endl;
            obj->add_ship(12, 12);
            obj->add_ship(8, 8);
            obj->add_ship(15, 15);
            obj->add_ship(6, 6);
            obj->add_ship(10, 10);
            obj->add_ship(14, 14);
            obj->add_ship(24, 24);
            obj->add_ship(4, 4);
            obj->add_ship(11, 11);
            obj->add_ship(13, 13);
            obj->add_ship(20, 20);
            obj->add_ship(29, 29);
            obj->add_ship(19, 19);
            print_avl_tree(*obj);
            cout << "after LL" << endl;
            obj->add_ship(18, 18); // Simulate add_ship that should trigger LL rotation
            print_avl_tree(*obj);
        }
        else if (!op.compare("avl_lr"))
        {
            cout << "before LR" << endl;
            obj->add_ship(15, 15);
            obj->add_ship(10, 10);
            obj->add_ship(20, 20);
            obj->add_ship(6, 6);
            obj->add_ship(13, 13);
            obj->add_ship(17, 17);
            obj->add_ship(24, 24);
            obj->add_ship(4, 4);
            obj->add_ship(7, 7);
            obj->add_ship(12, 12);
            obj->add_ship(14, 14);
            print_avl_tree(*obj);
            cout << "after LR" << endl;
            obj->add_ship(11, 11); // Simulate add_ship that should trigger LR rotation
            print_avl_tree(*obj);
        }
        else if (!op.compare("avl_rl"))
        {
            cout << "before RL" << endl;
            obj->add_ship(11, 11);
            obj->add_ship(8, 8);
            obj->add_ship(19, 19);
            obj->add_ship(6, 6);
            obj->add_ship(10, 10);
            obj->add_ship(13, 13);
            obj->add_ship(25, 25);
            obj->add_ship(12, 12);
            obj->add_ship(17, 17);
            obj->add_ship(23, 23);
            obj->add_ship(29, 29);
            print_avl_tree(*obj);
            cout << "after RL" << endl;
            obj->add_ship(15, 15); // Simulate add_ship that should trigger RL rotation
            print_avl_tree(*obj);
        }
        else if (!op.compare("avl_rr"))
        {
            obj->add_ship(10, 10);
            obj->add_ship(5, 5);
            obj->add_ship(20, 20);
            obj->add_ship(30, 30);
            obj->add_ship(40, 40); // Simulate add_ship that should trigger RR rotation
            print_avl_tree(*obj);
        }
        else if (!op.compare("avl_remove"))
        {
            cout << "before remove" << endl;
            obj->add_ship(5, 5);
            obj->add_ship(2, 2);
            obj->add_ship(8, 8);
            obj->add_ship(1, 1);
            obj->add_ship(4, 4);
            obj->add_ship(6, 6);
            obj->add_ship(10, 10);
            obj->add_ship(3, 3);
            obj->add_ship(7, 7);
            obj->add_ship(9, 9);
            obj->add_ship(12, 12);
            obj->add_ship(11, 11);
            print_avl_tree(*obj);
            obj->remove_ship(1); // Assuming remove_ship
            cout << "after remove" << endl;
            print_avl_tree(*obj);
        }
        else
        {
            cout << "Unknown command: " << op << endl;
            delete obj;
            return -1;
        }

        // Verify no faults
        if (cin.fail())
        {
            cout << "Invalid input format" << endl;
            delete obj;
            return -1;
        }
    }

    // Quit
    delete obj;
    return 0;
}

// Helpers
static const char *StatusTypeStr[] =
    {
        "SUCCESS",
        "ALLOCATION_ERROR",
        "INVALID_INPUT",
        "FAILURE"};

void print(string cmd, StatusType res)
{
    cout << cmd << ": " << StatusTypeStr[(int)res] << endl;
}

void print(string cmd, output_t<int> res)
{
    if (res.status() == StatusType::SUCCESS)
    {
        cout << cmd << ": " << StatusTypeStr[(int)res.status()] << ", " << res.ans() << endl;
    }
    else
    {
        cout << cmd << ": " << StatusTypeStr[(int)res.status()] << endl;
    }
}

void print_avl_tree(const Ocean &ocean)
{
    ocean.print_avl_tree();
}
