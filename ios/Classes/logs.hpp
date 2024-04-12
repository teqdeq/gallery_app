#include <iostream>
#include <fstream>
string logsFile = "/storage/emulated/0/Documents/MatcherApp/log.txt";
int logCount = 0;
void log(String message) {
return;
    std::ofstream outputFile(logsFile, std::ios::app);
    if (!outputFile.is_open()) {
        std::cerr << "Failed to open the log file for writing." << std::endl;
        return;
    }
    outputFile <<logCount + 1<<": "<<message << std::endl;
    outputFile.close();
}
