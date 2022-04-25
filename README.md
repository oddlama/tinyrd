## What is tinyrd?

Tinyrd is a lightweight initramfs builder. It provides only the bare minimum
to get a system running. By default it includes a few common modes of operation
for classic desktop systems () or virtual machines.

If you instead require a well-maintained and modular initramfs, please have a look at the [dracut](https://github.com/dracutdevs/dracut) project.

## Usage

Creating an initramfs using tinyrd is simple.
Just clone this repository and execute `tinyrd`:

```bash
git clone https://github.com/oddlama/tinyrd
cd tinyrd

./tinyrd /boot/tinyrd.img
./tinyrd --keymap de-latin1 --modules virtio_blk,virtio_scsi /boot/tinyrd.img
```

It's not necessary to run `tinyrd` as root, and you
can avoid to compile busybox using elevated privileges by doing so.

By default, tinyrd supports these kernel command line parameters:

#### `root=<device-spec>`

Specifies the root device for the new system root.

#### `ro`

If given, mount the root device read-only.

#### `overlay=<device-spec>`

This will mount the given device as an overlayfs
on top of the system root before switing to the new system.
If given, the underlying root device will be mounted read-only.
(Useful for virtual machines that share common system root)

## Hacking

Feel free to modify tinyrd to your liking. Even though both the build
and init script follow a pedantic code style, they are still tiny.
In the following we will provide a small overview of what the initramfs
is doing, but we recommend you to just read the script directly. Both are
well commented.

The `tinyrd` script is the initramfs generator and roughly does the following:

- Parse command line arguments
- Create a temporary directory (for busybox compilation and initramfs contents)
- Clone and compile busybox using the provided configuration
- Copy busybox and the init script to the initramfs
- (Optional) Add a keymap to be loaded in the initramfs
- (Optional) Add kernel modules to the initramfs
- Create the (compressed) initramfs cpio archive

The initramfs itself will follow these steps:

- (Optional) Load a keymap
- (Optional) Include and load specific modules (and their dependencies)
- Process the kernel command line to find the root device by UUID (recommended), LABEL or path
- Mount the system root
- (Optional) Mount a writable overlay over the root fs
- Switch root

Be sure to execute `./test.sh` after modifying something to ensure that
the init script is compatible with busyboxes `sh` implementation.

## License

I hereby release tinyrd into the public-domain. See the provided [CC0 license](./LICENSE) for details.
Note that the resulting initramfs image will also include a busybox binary
compiled from your machine, which is licensed under the GPLv2 as stated [here](https://busybox.net/license.html).
