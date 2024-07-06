![Header Image](https://i.imgur.com/G4WFAI0.png)
# 234218-data-structures-wet1-spring2024
1. **First**, create a `test` folder in the root directory of the project. 

## Project Structure

Ensure to create a `test` folder in the root directory of your project. The project files should **not** be inside the `test` folder. Below is the recommended directory structure:

```plaintext
project/
├── pirates24b1.h
├── wet1util.h
└── test/
    ├── makefile
    ├── main_test.cpp
    ├── tester.sh
    ├── diff.sh
    └── fileTests/
```
This structure ensures that your project files and test directory are organized correctly within your project's root directory.

2. Extract the zip file inside the `test` folder.
3. Add the following function in the public section of your  `pirates24b1.h` file: (**Don't forget to delete the public function we added to pirates24b1.h before submission**)
```cpp
void print_avl_tree() const
{
    ships.print();
}
```
4. In your `AVL Tree template`, add the following functions to the public section. These functions will handle the printing of the tree: (must )
```cpp
void print() const
{
    if (!root)
    {
        std::cout << "Tree is empty.\n";
        return;
    }
    printTree(root.yourRootMethod(), 0);
}
```
```cpp
void printTree(Node *node, int space) const
{
    if (!node)
        return;

    const int COUNT = 5;
    space += COUNT;

    printTree(node->yourRightChildMethod(), space);

    std::cout << std::endl;
    for (int i = COUNT; i < space; ++i)
    {
        std::cout << " ";
    }
    std::cout << node->yourKeyMethod() << "\n";

    printTree(node->yourLeftChildMethod(), space);
}
```
- Replace yourRootMethod() with the method you use to get the root of your AVL tree.
- Replace NodeType with the actual type of your node.
- Replace node->yourRightChildMethod() with the method you use to get the right child of a node.
- Replace node->yourKeyMethod() with the method you use to get the key of a node.
- Replace node->yourLeftChildMethod() with the method you use to get the left child of a node.
5. Navigate to the `test` directory and execute the 3 commands (**second command if needed**):
```bash
make -f makefile
```
```bash
chmod +x tester.sh
```
```bash
./tester.sh
```
![Image](https://i.imgur.com/5JMISpB.png)

## Test on Technion CS server - Bug with valgrind
Execute the 3 commands:
```bash
mkdir -p ~/tmp
```
```bash
chmod 700 ~/tmp
```
```bash
export TMPDIR=/tmp
```
## Diagnosing Failed Tests with diff.sh
If you encounter any failed tests, the diff.sh script is here to help. This utility allows you to compare the expected and actual outputs of a test, providing clarity on what went wrong.
```bash
chmod +x diff.sh
```
```bash
./diff.sh <test_number>
```
This command will display any discrepancies, aiding in your debugging process.
No Differences Found? If diff.sh does not show any differences, it suggests that the test's expected and actual results match. The failure may be due to external factors or configurations.
