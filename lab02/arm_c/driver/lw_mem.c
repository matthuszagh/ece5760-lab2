/* lw_mem.c
 *
 * A Linux device driver that mounts the memory-mapped lightweight
 * avalon bus to Sysfs so that our C++ program can interact with it.
 */


#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/string.h>  // memcpy
#include <linux/fs.h>      // file operations
#include <linux/device.h>
#include <linux/ioport.h>  // request_mem_region, release_mem_region
#include <asm/io.h>        // ioremap, iounmap
#include <asm/errno.h>     // error macros
#include <asm/uaccess.h>
#include "address_map_arm_brl4.h";
MODULE_LICENSE("Dual BSD/GPL");

#define DEVICE_NAME "lw_mem"
#define CLASS_NAME "lw"


/* Prototypes for device functions */
static int dev_open(struct inode *, struct file *);
static int dev_release(struct inode *, struct file *);
static ssize_t dev_read(struct file *, char *, size_t, loff_t *);
static ssize_t dev_write(struct file *, const char *, size_t, loff_t *);

static int major_num;
static int dev_open_count = 0;
static char *msg_ptr;
static void* virt_mem;
static struct class* lw_class = NULL;
static struct device* lw_device = NULL;

static struct file_operations file_ops = {
  .read = dev_read,
  .write = dev_write,
  .open = dev_open,
  .release = dev_release
};

// Register the driver.
static int __init mem_init(void)
{
  struct resource* phys_mem;

  // Allocate a major number for the device.
  major_num = register_chrdev(0, DEVICE_NAME, &file_ops);
  if (major_num < 0) {
    printk(KERN_ALERT "Could not register device: %d\n", major_num);
    return major_num;
  }
  printk(KERN_INFO "lw_mem module loaded with device major number %d\n", major_num);

  // Register the device class.
  lw_class = class_create(THIS_MODULE, CLASS_NAME);
  if (IS_ERR(lw_class)) {
    unregister_chrdev(major_num, DEVICE_NAME);
    printk(KERN_ALERT "Failed to register device class\n");
    return PTR_ERR(lw_class);
  }
  printk(KERN_INFO "lw_mem: device class registered correctly\n");

  // Register the device driver.
  lw_device = device_create(lw_class, NULL, MKDEV(major_num, 0), NULL, DEVICE_NAME);
  if (IS_ERR(lw_device)) {
    class_destroy(lw_class);
    unregister_chrdev(major_num, DEVICE_NAME);
    printk(KERN_ALERT "Failed to create the device\n");
    return PTR_ERR(lw_device);
  }
  printk(KERN_INFO "lw_mem: Device created correctly\n");

  if ((phys_mem = request_mem_region(HW_REGS_BASE, PAGE_SIZE, DEVICE_NAME)) == NULL) {
    pr_err("Lightweight bus memory initialization unsuccessful.\n");
    return -EBUSY;
  }
  if ((virt_mem = ioremap(HW_REGS_BASE, PAGE_SIZE)) == NULL) {
    return -EFAULT;
  }
  pr_info("Initialized memory for memory-mapped lightweight Avalon bus.\n");
  return 0;
}

static void __exit mem_exit(void)
{
  iounmap(virt_mem);
  release_mem_region(HW_REGS_BASE, PAGE_SIZE);
  device_destroy(lw_class, MKDEV(major_num, 0));
  class_unregister(lw_class);
  class_destroy(lw_class);
  unregister_chrdev(major_num, DEVICE_NAME);
  printk(KERN_INFO "lw_mem unregistered\n");
}


/* When a process reads from our device, this gets called. */
static ssize_t dev_read(struct file *flip, char *buffer, size_t len, loff_t *offset) {
  printk(KERN_ALERT "Reading is not supported.\n");
  return -EINVAL;
}

/* Called when a process tries to write to our device */
static ssize_t dev_write(struct file *filep, const char *buf, size_t len, loff_t *offset) {
  u16 buf0;
  u16 buf1;
  u16 buf2;
  u16 buf3;
  u16 buf4;
  u16 buf5;
  u16 buf6;
  u16 buf7;
  u16 buf8;
  u16 buf9;
  u16 buf10;
  u16 buf11;
  u16 buf12;
  u16 buf13;
  u16 buf14;
  u16 buf15;

  if (buf == NULL) {
    pr_err("Data passed to lightweight bus driver must not be NULL.\n");
    return -EINVAL;
  }
  if (strlen(buf) != 32) {
    pr_err("Data passed to lightweight bus driver should be 32 bytes.\n");
    return -EINVAL;
  }

  memcpy(&buf0, &buf[0], 2);
  memcpy(&buf1, &buf[2], 2);
  memcpy(&buf2, &buf[4], 2);
  memcpy(&buf3, &buf[6], 2);
  memcpy(&buf4, &buf[8], 2);
  memcpy(&buf5, &buf[10], 2);
  memcpy(&buf6, &buf[12], 2);
  memcpy(&buf7, &buf[14], 2);
  memcpy(&buf8, &buf[16], 2);
  memcpy(&buf9, &buf[18], 2);
  memcpy(&buf10, &buf[20], 2);
  memcpy(&buf11, &buf[22], 2);
  memcpy(&buf12, &buf[24], 2);
  memcpy(&buf13, &buf[26], 2);
  memcpy(&buf14, &buf[28], 2);
  memcpy(&buf15, &buf[30], 2);

  pr_info("buf4: %d\n", (int)buf4);

  iowrite16(buf0, (u16*)virt_mem + 0);
  iowrite16(buf1, (u16*)virt_mem + 1);
  iowrite16(buf2, (u16*)virt_mem + 2);
  iowrite16(buf3, (u16*)virt_mem + 3);
  iowrite16(buf4, (u16*)virt_mem + 4);
  iowrite16(buf5, (u16*)virt_mem + 5);
  iowrite16(buf6, (u16*)virt_mem + 6);
  iowrite16(buf7, (u16*)virt_mem + 7);
  iowrite16(buf8, (u16*)virt_mem + 8);
  iowrite16(buf9, (u16*)virt_mem + 9);
  iowrite16(buf10, (u16*)virt_mem + 10);
  iowrite16(buf11, (u16*)virt_mem + 11);
  iowrite16(buf12, (u16*)virt_mem + 12);
  iowrite16(buf13, (u16*)virt_mem + 13);
  iowrite16(buf14, (u16*)virt_mem + 14);
  iowrite16(buf15, (u16*)virt_mem + 15);

  return 0;
}

/* Called when a process opens our device */
static int dev_open(struct inode *inode, struct file *file) {
  /* If device is open, return busy */
  if (dev_open_count) {
    return -EBUSY;
  }
  ++dev_open_count;
  try_module_get(THIS_MODULE);
  return 0;
}

/* Called when a process closes our device */
static int dev_release(struct inode *inode, struct file *file) {
  /* Decrement the open counter and usage count. Without this, the module would not unload. */
  --dev_open_count;
  module_put(THIS_MODULE);
  return 0;
}

module_init(mem_init);
module_exit(mem_exit);
