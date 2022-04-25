#!/bin/bash
./tinyrd \
	--kernel-version 5.16.18-gentoo-dist \
	--modules virtio_blk,virtio_scsi \
	--compress zstd \
	--force tinyrd.img
