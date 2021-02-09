Timeload
========
A small collection of tools for timeing the loading speed of a device
connected to a CBM 8-Bit computer. As of now C64 and C128 are implemented.

Usage:
------
There are two options: using a SYS command for timing the load, or a version
that hijacks the load vector. Both of these options are available in a C64
and C128 version. All variants display a short message after starting with
RUN.

A defined load payload is also included. Those are available in variants as
well. The standard is mem64check50k or mem128check50k both can be run and
will display any memory addresses that have not been loaded correctly. There
are also larger versions available, but the C64 version can only be loaded
using fastloads that access the RAM "under" the I/O area like Action Replay.
The large C128 Version can be loaded as well, but those results could not be
compared to the C64 as easy.

The `bin` directory comtains the binaries (mem*check* was written using a
direct assembler). `images` contains the floppy images in different flavors,
the D64 images containing "i(number)" are written with a different sector
interleave as compared to the default of 10.

Credits:
--------
- Tokra: timeload128sys.s
- SvOlli: rest

