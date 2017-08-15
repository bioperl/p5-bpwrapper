if [[ $0 == ${BASH_SOURCE[0]} ]] ; then
    echo "This script should be *sourced* rather than run directly through bash"
    exit 1
fi
gh_dir=$(pwd)
short_name=$(basename $gh_dir)
perl_list=$(perlbrew list | sed -e 's/[ *] perl-//')
cd /tmp && rm -fr p5-bpwrapper; git clone $gh_dir
cd /tmp/$short_name
for perl in $perl_list ; do echo $perl; perlbrew use $perl && perl ./Build.PL >/dev/null && ./Build installdeps && ./Build && make check | grep '^Result:'; echo '---'; done
cd $gh_dir
