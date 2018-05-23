/* spring_mass.cpp
 *
 * A program running on the ARM cortex with linux to control the operation of
 * the spring-mass system on FPGA.
 */

#include "address_map_arm_brl4.h" // physical memory addresses
#include <string>
#include <map>
#include <iostream>
extern "C"
{
  #include "fcntl.h"
  #include "unistd.h"
  #include "sys/mman.h"
  #include "stdio.h"
}

std::map<std::string, char16_t*> map;

int main() {
  int fd;
  void *lw_base;

  if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1) {
    printf("ERROR: could not open \"/dev/mem\"...\n");
    return 1;
  }

  lw_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);
  if (lw_base == MAP_FAILED) {
    printf("ERROR: mmap() failed...\n");
    close(fd);
    return 1;
  }

  char16_t *k1_m1 = (char16_t *)lw_base + 0; map["k1_m1"]=k1_m1;
  char16_t *k2_m2 = (char16_t *)lw_base + 1; map["k2_m2"]=k2_m2;
  char16_t *km_m1 = (char16_t *)lw_base + 2; map["km_m1"]=km_m1;
  char16_t *km_m2 = (char16_t *)lw_base + 3; map["km_m2"]=km_m2;
  char16_t *k13_m1 = (char16_t *)lw_base + 4; map["k13_m1"]=k13_m1;
  char16_t *k33_m2 = (char16_t *)lw_base + 5; map["k33_m2"]=k33_m2;
  char16_t *x1_0 = (char16_t *)lw_base + 10; map["x1_0"]=x1_0;
  char16_t *x2_0 = (char16_t *)lw_base + 11; map["x2_0"]=x2_0;
  char16_t *d1 = (char16_t *)lw_base + 12; map["d1"]=d1;
  char16_t *d2 = (char16_t *)lw_base + 13; map["d2"]=d2;
  char16_t *dt = (char16_t *)lw_base + 14; map["dt"]=dt;
  char16_t *d_scale_fact = (char16_t *)lw_base + 15; map["d_scale_fact"]=d_scale_fact;

  *k1_m1 = (char16_t)(2);
  *k2_m2 = (char16_t)(2);
  *km_m1 = (char16_t)(2);
  *km_m2 = (char16_t)(2);
  *k13_m1 = (char16_t)(16);
  *k33_m2 = (char16_t)(16);
  *x1_0 = (char16_t)(150);
  *x2_0 = (char16_t)(300);
  *d1 = (char16_t)(1);
  *d2 = (char16_t)(1);
  *dt = (char16_t)(4);
  *d_scale_fact = (char16_t)(1);

  printf("\nFeel free to redefine any of the parameters in this system.\n"
         "By default, the parameters are as follows:\n"
         "k1_m1=2\t\t(k/m for first spring),\n"
         "k2_m2=2\t\t(k/m for third spring),\n"
         "km_m1=2\t\t(k_middle/m1),\n"
         "km_m2=2\t\t(k_middle/m2),\n"
         "k13_m1=16\t(cubic term of spring 1),\n"
         "k33_m2=16\t(cubic term of spring 3),\n"
         "x1_0=150\t(origin of first mass (i.e. where spring displacement is 0)),\n"
         "x2_0=300\t(origin of second mass),\n"
         "d1=1\t\t(damping coefficient of mass 1),\n"
         "d2=1\t\t(damping coefficient of mass 2),\n"
         "dt=5\t\t(adjust the time interval -- as a bit shift),\n"
         "d_scale_fact=1\t(decreases damping coefficients -- as a bit shift).\n\n"

         "Please enter these one by one in exactly the syntax above. Enter as parameter=value <ENT>. All values must be integers.\n");

  while(1) {
    std::string entry;
    std::cin >> entry;
    std::size_t pos = entry.find("=");
    std::string param = entry.substr(0, pos);
    std::string val = entry.substr(pos+1);
    int ival = std::stoi(val);
    if (*map[param]) {
      *map[param]=ival;
    }
  }
}
