#!/bin/bash
#
# Auto Sonde Decoder build script.
#

# Build rs_detect.
cd ../scan/
gcc rs_detect.c -lm -o rs_detect
gcc reset_usb.c -o reset_usb


# Build rs92 and rs41 decoders
cd ../rs_module/
gcc -c rs_datum.c
gcc -c rs_demod.c
gcc -c rs_bch_ecc.c
gcc -c rs_rs41.c
gcc -c rs_rs92.c
gcc -c rs_main41.c
gcc rs_main41.o rs_rs41.o rs_bch_ecc.o rs_demod.o rs_datum.o -lm -o rs41mod
gcc -c rs_main92.c
gcc rs_main92.o rs_rs92.o rs_bch_ecc.o rs_demod.o rs_datum.o -lm -o rs92mod

cd ../demod/
gcc -c demod.c
gcc -c demod_dft.c
gcc rs92dm.c demod.o -lm -o rs92ecc -I../ecc/ -I../rs92
gcc rs41dm_dft.c demod_dft.o -lm -o rs41ecc -I../ecc/ -I../rs41

# Copy all necessary files into this directory.
cd ../auto_rx/
cp ../scan/rs_detect .
cp ../scan/reset_usb .
cp ../rs_module/rs41mod .
cp ../rs_module/rs92mod .
cp ../demod/rs92ecc .
cp ../demod/rs41ecc .

echo "Done!"
