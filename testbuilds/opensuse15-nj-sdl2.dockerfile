FROM opensuse/leap:15.2
ARG no_check=false
ARG no_install=false
# -DMAKE_INSTALL_PREFIX:PATH=/usr

RUN zypper mr --no-gpgcheck repo-oss repo-update
RUN zypper refresh repo-oss
RUN zypper install -r repo-oss -y gcc zlib-devel python3 cmake unzip zip gzip tar  libSDL2-devel ninja

RUN mkdir src
COPY CMakeLists.txt README COPYING.LIB ChangeLog src/
COPY CMakeScripts src/CMakeScripts
COPY bins src/bins
COPY docs src/docs
COPY test src/test
COPY SDL src/SDL
COPY zzipwrap src/zzipwrap
COPY zzip src/zzip

RUN mkdir src/build
RUN cd src/build && cmake .. -GNinja
RUN cd src/build && ninja
RUN $no_check || (cd src/build && ninja check VERBOSE=1)
RUN $no_install || (cd src/build && ninja install)
