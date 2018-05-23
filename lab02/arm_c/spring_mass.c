/* spring_mass.c
 *
 * A program running on the ARM cortex with linux to control the operation of
 * the spring-mass system on FPGA.
 */

#include "address_map_arm_brl4.h" // physical memory addresses
#include <fcntl.h>                // defines open()
#include <stdio.h>                // printf()
#include <sys/mman.h>             // mmap()


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

  unsigned short *k1_m1 = (unsigned short *)(lw_base + 0);
  unsigned short *k2_m2 = (unsigned short *)(lw_base + 2);
  unsigned short *km_m1 = (unsigned short *)(lw_base + 4);
  unsigned short *km_m2 = (unsigned short *)(lw_base + 6);
  unsigned short *k13_m1 = (unsigned short *)(lw_base + 8);
  unsigned short *k33_m2 = (unsigned short *)(lw_base + 10);
  unsigned short *x1_0 = (unsigned short *)(lw_base + 20);
  unsigned short *x2_0 = (unsigned short *)(lw_base + 22);
  unsigned short *d1 = (unsigned short *)(lw_base + 24);
  unsigned short *d2 = (unsigned short *)(lw_base + 26);
  unsigned short *dt = (unsigned short *)(lw_base + 28);
  unsigned short *d_scale_fact = (unsigned short *)(lw_base + 30);

  *k1_m1 = (unsigned short)(2);
  *k2_m2 = (unsigned short)(2);
  *km_m1 = (unsigned short)(2);
  *km_m2 = (unsigned short)(2);
  *k13_m1 = (unsigned short)(16);
  *k33_m2 = (unsigned short)(16);
  *x1_0 = (unsigned short)(150);
  *x2_0 = (unsigned short)(300);
  *d1 = (unsigned short)(1);
  *d2 = (unsigned short)(1);
  *dt = (unsigned short)(5);
  *d_scale_fact = (unsigned short)(2);

  printf("Feel free to redefine any of the parameters in this system.\n"
         "By default, the parameters are as follows:\n"
         "k1_m1=2\t\t(k/m for first spring),\n"
         "k2_m2=2\t\t(k/m for third spring),\n"
         "km_m1=2\t\t(k_middle/m1),\n"
         "km_m2=2\t\t(k_middle/m2),\n"
         "k13_m1=16\t\t(cubic term of spring 1),\n"
         "k33_m2=16\t\t(cubic term of spring 3),\n"
         "x1_0=150\t\t(origin of first mass (i.e. where spring displacement is 0)),\n"
         "x2_0=300\t\t(origin of second mass),\n"
         "d1=1\t\t(damping coefficient of mass 1),\n"
         "d2=1\t\t(damping coefficient of mass 2),\n"
         "dt=5\t\t(adjust the time interval -- as a bit shift),\n"
         "d_scale_fact=2\t(decreases damping coefficients -- as a bit shift).\n\n"

         "Please enter these one by one in exactly the syntax above. Enter as parameter <ENT> value <ENT>. All values must be integers.\n");

  while(1) {
    char param[256];
    if(fgets(param, sizeof(param), stdin) != NULL) {
      switch (param) {
        case "k1_m1" :
          char val[256];
          if(fgets(val, sizeof(val), stdin) != NULL) {
            *k1_m1 = atoi(val);
          } else {
            printf("Not valid. Start over.\n");
          }
          break;
        case "k2_m2" :
          char val[256];
          if(fgets(val, sizeof(val), stdin) != NULL) {
            *k2_m2 = atoi(val);
          } else {
            printf("Not valid. Start over.\n");
          }
          break;
        case "km_m1" :
          char val[256];
          if(fgets(val, sizeof(val), stdin) != NULL) {
            *km_m1 = atoi(val);
          } else {
            printf("Not valid. Start over.\n");
          }
          break;
        case "km_m2" :
          char val[256];
          if(fgets(val, sizeof(val), stdin) != NULL) {
            *km_m2 = atoi(val);
          } else {
            printf("Not valid. Start over.\n");
          }
          break;
        case "k13_m1" :
          char val[256];
          if(fgets(val, sizeof(val), stdin) != NULL) {
            *k13_m1 = atoi(val);
          } else {
            printf("Not valid. Start over.\n");
          }
          break;
        case "k33_m2" :
          char val[256];
          if(fgets(val, sizeof(val), stdin) != NULL) {
            *k2_m2 = atoi(val);
          } else {
            printf("Not valid. Start over.\n");
          }
          break;
        case "x1_0" :
          char val[256];
          if(fgets(val, sizeof(val), stdin) != NULL) {
            *x1_0 = atoi(val);
          } else {
            printf("Not valid. Start over.\n");
          }
          break;
        case "x2_0" :
          char val[256];
          if(fgets(val, sizeof(val), stdin) != NULL) {
            *x2_0 = atoi(val);
          } else {
            printf("Not valid. Start over.\n");
          }
          break;
        case "d1" :
          char val[256];
          if(fgets(val, sizeof(val), stdin) != NULL) {
            *d1 = atoi(val);
          } else {
            printf("Not valid. Start over.\n");
          }
          break;
        case "d2" :
          char val[256];
          if(fgets(val, sizeof(val), stdin) != NULL) {
            *d2 = atoi(val);
          } else {
            printf("Not valid. Start over.\n");
          }
          break;
        case "dt" :
          char* val[256];
          if(fgets(val, sizeof(val), stdin) != NULL) {
            *dt = atoi(val);
          } else {
            printf("Not valid. Start over.\n");
          }
          break;
        case "d_scale_fact" :
          char val[256];
          if(fgets(val, sizeof(val), stdin) != NULL) {
            *d_scale_fact = atoi(val);
          } else {
            printf("Not valid. Start over.\n");
          }
          break;
        default :
          printf("Not valid. Start over.\n");
          break;
      }
    } else {
      printf("Please enter a valid parameter.\n");
    }
  }
}
