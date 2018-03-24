# Building libSBOL and pySBOL on Ubuntu 16

The pySBOL team say they are going to be releasing Unix wheels
"soon". See https://github.com/SynBioDex/pySBOL/issues/72. They also
have a wiki page that outlines how they are building those wheels. See
https://github.com/SynBioDex/pySBOL/wiki/Uploading-Wheels-(pip). Those
will be the right long term solution. Until then, we have to build our
own.  While the pySBOL team is concerned with building wheels for lots
of Linux distributions (via "manylinux") we only need them for Ubuntu
16 at the moment.


# Build libSBOL

We have to build libSBOL twice, once for Python 2 and once for Python
3.  libSBOL uses cmake to generate Makefiles. I had to install
cmake-3.10, but there are indications that they may have rolled back
that dependency. My work to create a build environment is available at
https://github.com/SD2E/libsbol-docker

You can follow the [libSBOL build
instructions](http://synbiodex.github.io/libSBOL/installation.html)
but they are focused on cmake gui tools, which seems silly if you're
building from source.

Here's (more or less) what I did:

```
git clone https://github.com/SynBioDex/libSBOL.git
cd libSBOL

# checkout whatever branch or commit or tag you need

git submodule update --init --recursive
cmake -DCMAKE_INSTALL_PREFIX=~/install_x64 -DSBOL_BUILD_PYTHON3=ON
make
make install
```

A few notes:

* Don't do a shared build (-DSBOL_BUILD_SHARED), that adds a
  dependency on the hared library
* The install directory (CMAKE_INSTALL_PREFIX) has to be writable
  during the make phase, not just make install


# Building pySBOL

Now you take the results of the above, in ~/install_x64, and build
pySBOL from that. I added an Ubuntu section to the pySBOL setup.py in
my fork at https://github.com/tcmitchell/pySBOL. You'll need to use
that version of pySBOL.

```
git clone https://github.com/tcmitchell/pySBOL
cd pySBOL

# Use the ubuntu branch
git checkout ubuntu

# Copy the sbol directory out of the libSBOL install
cp -r ~/install_x64/wrapper/sbol Ubuntu_16.04_64_3/

# Now build the wheel, adjusting the python-tag as appropriate
python3 setup.py bdist_wheel --python-tag=cp35

# Your wheel will be in Ubuntu_16.04_64_3/dist
```


# Lather, rinse, repeat

Now do that over again for Python 2.7 and Python 3.6.


# Caveats

* I'm sure there are missing steps, apologies in advance
* I couldn't get a decent Python 3.6 installation when building from
  source. There were oddities that I couldn't explain, it just never
  felt quite right.
