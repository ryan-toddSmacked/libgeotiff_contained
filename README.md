# libgeotiff_contained
Bash script that installs libgeotiff and all its dependencies in a local directory of your choosing.

I worte this bash script, it is very simple, because whenever I just apt installed libgeotiff and then tried to use that library in matlab mex files, I always got errors like "LIBTIFF_4.0" not found when running the mex file linked with /usr/lib64/libgeotiff.so.

Linking this libgeotiff in the specified local directory does not throw that error.

I think the error happens because matlab has an internal libtiff.so that causes conflicts with the apt install libgeotiff.so.

