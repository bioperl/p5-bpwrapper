FROM ubuntu:bionic

LABEL name bpwrapper
LABEL src "https://github.com/bioperl/p5-bpwrapper"
LABEL creator rocky
LABEL desc "command-line utilites for Bio::Perl"

RUN apt update \
  && apt upgrade -y \
  && apt install -y git perl cpanminus make gcc libexpat1-dev

RUN cpanm --notest Module::Build rlib XML::Parser XML::DOM::XPath Test::More Bio::Restriction::Analysis

RUN git clone --depth=10 https://github.com/bioperl/p5-bpwrapper.git p5-bpwrapper \
 && cd p5-bpwrapper && perl ./Build.PL && ./Build && make install
ENV PATH="/usr/local/bin:${PATH}"
CMD /bin/bash
