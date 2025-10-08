#include <iostream>
#include <fstream>
#include <sstream>
#include <unordered_map>
#include <vector>
#include <string>
#include <algorithm>

using namespace std;

class VirtualMachine {
private:
    unordered_map<string, int> registers;
    unordered_map<string, string> stringMemory;
    vector<string> programMemory;
    unordered_map<string, int> labels;
    int programCounter;
    bool running;
    int flags;

public:
    VirtualMachine() {
        for (int i = 0; i < 6; i++) {
            registers["R" + to_string(i)] = 0;
        }
        programCounter = 0;
        running = true;
        flags = 0;
        initializeStringMemory();
    }
    
    void initializeStringMemory() {
        stringMemory["welcomeMsg"] = "=== Virtual Machine with Memory Management ===\n";
        stringMemory["menuPrompt"] = "Please select an option:\n1. Calculator\n2. String Operations\n3. Memory Management\n4. Exit Program\nEnter your choice (1-4): ";
        stringMemory["invalidChoice"] = "Invalid choice! Please enter 1-4.\n";
        stringMemory["resultMsg"] = "The result is: ";
    }
    
    void loadProgram(const string& filename) {
        ifstream file(filename);
        string line;
        vector<string> tempProgram;
        int lineNum = 0;
        
        cout << "=== LOADING PROGRAM ===" << endl;
        
        while (getline(file, line)) {
            size_t commentPos = line.find(';');
            if (commentPos != string::npos) {
                line = line.substr(0, commentPos);
            }
            
            line.erase(0, line.find_first_not_of(" \t"));
            line.erase(line.find_last_not_of(" \t") + 1);
            
            if (!line.empty()) {
                cout << "Line " << lineNum << ": " << line << endl;
                tempProgram.push_back(line);
                
                if (line.back() == ':') {
                    string label = line.substr(0, line.length() - 1);
                    labels[label] = lineNum;
                    cout << "  -> LABEL FOUND: '" << label << "' at position " << lineNum << endl;
                }
                
                lineNum++;
            }
        }
        file.close();
        
        programMemory = tempProgram;
        
        cout << "=== PROGRAM LOADED ===" << endl;
        cout << "Total instructions: " << programMemory.size() << endl;
        cout << "Labels found: " << labels.size() << endl;
        for (auto& label : labels) {
            cout << "  " << label.first << " -> line " << label.second << endl;
        }
        cout << "======================" << endl;
    }
    
    void run() {
        programCounter = 0;
        
        while (programCounter < programMemory.size() && running) {
            string instruction = programMemory[programCounter];
            cout << "\n[PC=" << programCounter << "] Executing: " << instruction << endl;
            
            // Execute the instruction (but don't increment PC yet)
            executeInstruction(instruction);
            
            // Only increment PC if it wasn't modified by a jump/call
            if (running) {
                // Check if PC was changed by CALL, JMP, etc.
                bool pcWasModified = false;
                
                vector<string> tokens = tokenize(instruction);
                if (!tokens.empty()) {
                    string opcode = tokens[0];
                    // If it's not a flow control instruction, increment PC
                    if (opcode != "CALL" && opcode != "JMP" && opcode != "JE" && opcode != "JNE" && opcode != "RET") {
                        programCounter++;
                    } else {
                        // For CALL/JMP, the PC was already set by executeInstruction
                        pcWasModified = true;
                    }
                } else {
                    programCounter++;
                }
                
                // Safety check
                if (programCounter >= programMemory.size()) {
                    cout << "Program reached end." << endl;
                    break;
                }
            }
        }
    }
    
    void executeInstruction(const string& instruction) {
        vector<string> tokens = tokenize(instruction);
        if (tokens.empty()) return;
        
        string opcode = tokens[0];
        
        // Skip label definitions during execution
        if (opcode.back() == ':') {
            return;
        }
        
        if (opcode == "CALL") {
            if (tokens.size() > 1) {
                string label = tokens[1];
                cout << "  CALL instruction: trying to call '" << label << "'" << endl;
                
                if (labels.find(label) != labels.end()) {
                    int labelPosition = labels[label];
                    cout << "  -> Label '" << label << "' found at line " << labelPosition << endl;
                    
                    // Save return address (current PC + 1 because next instruction should execute after return)
                    int returnAddress = programCounter + 1;
                    cout << "  -> Saving return address: " << returnAddress << endl;
                    
                    // Jump to the label
                    programCounter = labelPosition;
                    cout << "  -> Jumping to line " << programCounter << endl;
                    
                    // Execute the subroutine
                    executeSubroutine(returnAddress);
                    
                } else {
                    cout << "  -> ERROR: Label '" << label << "' not found!" << endl;
                }
            }
        }
        else if (opcode == "JMP") {
            if (tokens.size() > 1) {
                string label = tokens[1];
                if (labels.find(label) != labels.end()) {
                    programCounter = labels[label];
                    cout << "  -> Jumping to " << label << " at line " << programCounter << endl;
                }
            }
        }
        else if (opcode == "PRINT_STR") {
            if (tokens.size() > 1 && stringMemory.find(tokens[1]) != stringMemory.end()) {
                cout << stringMemory[tokens[1]];
            }
        }
        else if (opcode == "READ_INT") {
            if (tokens.size() > 1 && isRegister(tokens[1])) {
                cout << "  Enter value for " << tokens[1] << ": ";
                cin >> registers[tokens[1]];
                cout << "  -> " << tokens[1] << " = " << registers[tokens[1]] << endl;
            }
        }
        else if (opcode == "HALT") {
            running = false;
            cout << "  -> Program halted." << endl;
        }
        else if (opcode == "RET") {
            // RET is handled in executeSubroutine
            return;
        }
        // NEW INSTRUCTIONS FOR ADDITION
        else if (opcode == "ADD") {
            if (tokens.size() > 3 && isRegister(tokens[1]) && isRegister(tokens[2]) && isRegister(tokens[3])) {
                registers[tokens[1]] = registers[tokens[2]] + registers[tokens[3]];
                cout << "  -> ADD: " << tokens[1] << " = " << tokens[2] << " + " << tokens[3] 
                     << " = " << registers[tokens[2]] << " + " << registers[tokens[3]] 
                     << " = " << registers[tokens[1]] << endl;
            }
        }
        else if (opcode == "PRINT_INT") {
            if (tokens.size() > 1 && isRegister(tokens[1])) {
                cout << "  -> " << tokens[1] << " = " << registers[tokens[1]] << endl;
            }
        }
        else if (opcode == "PRINT_RESULT") {
            if (tokens.size() > 1 && isRegister(tokens[1])) {
                cout << stringMemory["resultMsg"] << registers[tokens[1]] << endl;
            }
        }
    }
    
    void executeSubroutine(int returnAddress) {
        cout << "  [SUBROUTINE] Starting at line " << programCounter << endl;
        
        while (programCounter < programMemory.size() && running) {
            string instruction = programMemory[programCounter];
            vector<string> tokens = tokenize(instruction);
            
            // Check for RET instruction
            if (!tokens.empty() && tokens[0] == "RET") {
                cout << "  [SUBROUTINE] RET found at line " << programCounter << endl;
                programCounter = returnAddress;
                cout << "  [SUBROUTINE] Returning to line " << programCounter << endl;
                return;
            }
            
            // Execute the current instruction
            executeInstruction(instruction);
            
            // Move to next instruction in subroutine
            programCounter++;
            
            if (programCounter >= programMemory.size()) {
                cout << "  [SUBROUTINE] Reached end of program unexpectedly!" << endl;
                break;
            }
        }
    }
    
    vector<string> tokenize(const string& line) {
        vector<string> tokens;
        stringstream ss(line);
        string token;
        while (ss >> token) {
            token.erase(remove(token.begin(), token.end(), ','), token.end());
            tokens.push_back(token);
        }
        return tokens;
    }
    
    bool isRegister(const string& token) {
        return token[0] == 'R' && token.size() == 2 && isdigit(token[1]);
    }
};

int main() {
    VirtualMachine vm;
    
    // Create an extended test program that reads two values, adds them, and displays result
    ofstream testFile("test_program.asm");
    testFile << "START:\n";
    testFile << "    CALL DisplayWelcome\n";
    testFile << "    CALL GetUserInput\n";
    testFile << "    CALL AddNumbers\n";
    testFile << "    CALL DisplayResult\n";
    testFile << "    HALT\n";
    testFile << "\n";
    testFile << "DisplayWelcome:\n";
    testFile << "    PRINT_STR welcomeMsg\n";
    testFile << "    RET\n";
    testFile << "\n";
    testFile << "GetUserInput:\n";
    testFile << "    READ_INT R0\n";
    testFile << "    READ_INT R1\n";
    testFile << "    RET\n";
    testFile << "\n";
    testFile << "AddNumbers:\n";
    testFile << "    ADD R2, R0, R1\n";
    testFile << "    RET\n";
    testFile << "\n";
    testFile << "DisplayResult:\n";
    testFile << "    PRINT_STR resultMsg\n";
    testFile << "    PRINT_INT R2\n";
    testFile << "    RET\n";
    testFile.close();
    
    cout << "=== TESTING ADDITION PROGRAM ===" << endl;
    vm.loadProgram("test_program.asm");
    vm.run();
    
    return 0;
}
