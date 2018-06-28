/* sin.cpp

   Generate a full-period sine wave with some specified bit precision in 2s complement with
   a specified number of steps. Write the data to a file in a specified format.
*/

#include <bitset>
#include <cmath>
#include <fstream>

/* 1st argument is the number of steps in a full period.
   2nd argument is the number of bits used to store the data.
   3rd argument can be either `verilog` or `vhdl`
*/
const double pi = std::acos(-1);

int main(int argc, char* argv[])
{
  std::ofstream mem_file;
  mem_file.open("sin.mem");

  for (size_t i=0; i<100; ++i) {
    std::string result = std::bitset<24>((int)((pow(2,23))*sin(i*pi/50))).to_string();
    mem_file << result << '\n';
  }
}
