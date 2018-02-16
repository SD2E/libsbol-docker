FROM ubuntu:16.04

RUN apt-get update

RUN apt-get install -y git \
    curl \
    build-essential \
    libxml2-dev \
    gcc-multilib \
    g++-multilib \
    libraptor2-dev \
    libjsoncpp-dev \
    swig python-dev \
    python3 \
    python3-dev

# libSBOL requires a later cmake than what comes with ubuntu 16.04
# because of a SWIG feature it uses.
RUN curl -SL https://cmake.org/files/v3.10/cmake-3.10.2.tar.gz \
    | tar -xzC /tmp \
    && cd /tmp/cmake-3.10.2 \
    && ./bootstrap \
    && make \
    && make install

RUN git clone https://github.com/SynBioDex/libSBOL.git \
    && cd libSBOL \
    && git checkout v2.3.0.0 \
    && git submodule update --init --recursive \
    && cmake -DCMAKE_INSTALL_PREFIX=~/install_x64 -DSBOL_BUILD_SHARED=ON \
        -DSBOL_BUILD_PYTHON3=ON \
    && make
    && make install

# One unit test fails with python 3. Once that is fixed, the unit
# tests can be incorporated as:
#
# cd ~/install_x64/wrapper/sbol
# python unit_tests.py
