/* spring_mass.c
 *
 * A program running on the ARM cortex with linux to control the operation of
 * the spring-mass system on FPGA.
 */

#include "address_map_arm_brl4.h" // physical memory addresses
#include <fcntl.h>                // defines open()
#include <stdio.h>                // printf()
#include <sys/mman.h>             // mmap()

/* #define BASE 0xFF200000 */
/* #define SPAN 0x00010000 */

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
  unsigned short *k23_m1 = (unsigned short *)(lw_base + 10);
  unsigned short *x1_0 = (unsigned short *)(lw_base + 20);
  unsigned short *x2_0 = (unsigned short *)(lw_base + 22);
  unsigned short *d1 = (unsigned short *)(lw_base + 24);
  unsigned short *d2 = (unsigned short *)(lw_base + 26);
  unsigned short *dt = (unsigned short *)(lw_base + 28);
  unsigned short *d_scale_fact = (unsigned short *)(lw_base + 30);

  *k1_m1 = (unsigned short)(2);
  printf("k1_m1: %x\n", *k1_m1);
  *k2_m2 = (unsigned short)(2);
  *km_m1 = (unsigned short)(2);
  *km_m2 = (unsigned short)(2);
  *k13_m1 = (unsigned short)(16);
  *k23_m1 = (unsigned short)(16);
  *x1_0 = (unsigned short)(150);
  *x2_0 = (unsigned short)(300);
  *d1 = (unsigned short)(1);
  *d2 = (unsigned short)(1);
  *dt = (unsigned short)(5);
  *d_scale_fact = (unsigned short)(2);
}
