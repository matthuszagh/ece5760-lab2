/* spring_mass.cpp
 *
 * A program running on the ARM cortex with linux to control the operation of
 * the spring-mass system on FPGA.
 */

#include <string>
//#include <cstring>  // memcpy
#include <map>
#include <iostream>
extern "C"
{
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
}

//std::map<std::string, char*> map;

int main() {
  int fd;
  int ret;

  if ((fd = open("/dev/lw_mem", O_WRONLY)) == -1) {
    std::cerr << "Couldn't map lightweight driver module.\n";
    return 1;
  }

  char* buf = new char[33];

  char k1_m1[2];// map["k1_m1"]=k1_m1;
  char k2_m2[2];// map["k2_m2"]=k2_m2;
  char km_m1[2];// map["km_m1"]=km_m1;
  char km_m2[2];// map["km_m2"]=km_m2;
  char k13_m1[2];// map["k13_m1"]=k13_m1;
  char k33_m2[2];// map["k33_m2"]=k33_m2;
  char x1_0[2];// map["x1_0"]=x1_0;
  char x2_0[2];// map["x2_0"]=x2_0;
  char d1[2];// map["d1"]=d1;
  char d2[2];// map["d2"]=d2;
  char dt[2];// map["dt"]=dt;
  char d_scale_fact[2];// map["d_scale_fact"]=d_scale_fact;

  k1_m1[0]=char(2>>8); k1_m1[1]=char(2); if (k1_m1[0]=='\0') k1_m1[0]=' ';
  k2_m2[0]=char(2>>8); k2_m2[1]=char(2); if (k2_m2[0]=='\0') k2_m2[0]=' ';
  km_m1[0]=char(2>>8); km_m1[1]=char(2); if (km_m1[0]=='\0') km_m1[0]=' ';
  km_m2[0]=char(2>>8); km_m2[1]=char(2); if (km_m2[0]=='\0') km_m2[0]=' ';
  k13_m1[0]=char(16>>8); k13_m1[1]=char(16); if (k13_m1[0]=='\0') k13_m1[0]=' ';
  k33_m2[0]=char(16>>8); k33_m2[1]=char(16); if (k33_m2[0]=='\0') k33_m2[0]=' ';
  x1_0[0]=char(150>>8); x1_0[1]=char(150); if (x1_0[0]=='\0') x1_0[0]=' ';
  x2_0[0]=char(300>>8); x2_0[1]=char(300); if (x2_0[0]=='\0') x2_0[0]=' ';
  d1[0]=char(1>>8); d1[1]=char(1); if (d1[0]=='\0') d1[0]=' ';
  d2[0]=char(1>>8); d2[1]=char(1); if (d2[0]=='\0') d2[0]=' ';
  dt[0]=char(4>>8); dt[1]=char(4); if (dt[0]=='\0') dt[0]=' ';
  d_scale_fact[0]=char(1>>8); d_scale_fact[1]=char(1); if (d_scale_fact[0]=='\0') d_scale_fact[0]=' ';

  memcpy(buf, k1_m1, 2*sizeof(char));
  memcpy(buf+2, k2_m2, 2*sizeof(char));
  memcpy(buf+4, km_m1, 2*sizeof(char));
  memcpy(buf+6, km_m2, 2*sizeof(char));
  memcpy(buf+8, k13_m1, 2*sizeof(char));
  memcpy(buf+10, k33_m2, 2*sizeof(char));
  memset(buf+12, int(' '), 2*sizeof(char));
  memset(buf+14, int(' '), 2*sizeof(char));
  memset(buf+16, int(' '), 2*sizeof(char));
  memset(buf+18, int(' '), 2*sizeof(char));
  memcpy(buf+20, x1_0, 2*sizeof(char));
  memcpy(buf+22, x2_0, 2*sizeof(char));
  memcpy(buf+24, d1, 2*sizeof(char));
  memcpy(buf+26, d2, 2*sizeof(char));
  memcpy(buf+28, dt, 2*sizeof(char));
  memcpy(buf+30, d_scale_fact, 2*sizeof(char));
  buf[32]='\0';

  printf("size: %d\n", (int)strlen(buf));
  printf("%s\n", buf);


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

  while (1) {
    // std::string entry;
    // std::cin >> entry;
    // std::size_t pos = entry.find("=");
    // std::string param = entry.substr(0, pos);
    // std::string val = entry.substr(pos+1);
    // int ival = std::stoi(val);
    // // if (*map[param]) {
    // //   *map[param]=ival;
    // // }
    // // Copy data to char buffer.
    // memcpy(buf, k1_m1, 2);
    // memcpy(buf+2, k2_m2, 2);
    // memcpy(buf+4, km_m1, 2);
    // memcpy(buf+6, km_m2, 2);
    // memcpy(buf+8, k13_m1, 2);
    // memcpy(buf+10, k33_m2, 2);
    // memset(buf+12, 0, 2);
    // memset(buf+14, 0, 2);
    // memset(buf+16, 0, 2);
    // memset(buf+18, 0, 2);
    // memcpy(buf+20, x1_0, 2);
    // memcpy(buf+22, x2_0, 2);
    // memcpy(buf+24, d1, 2);
    // memcpy(buf+26, d2, 2);
    // memcpy(buf+28, dt, 2);
    // memcpy(buf+30, d_scale_fact, 2);

    ret = write(fd, buf, 32);
    if (ret<0) {
      std::cerr << "Failed to write data to device\n";
      return errno;
    }
  }
}
