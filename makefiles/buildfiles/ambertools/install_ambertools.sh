#!/bin/sh

# Note: this is a modified version of the script from https://github.com/Amber-MD/install_ambertools
# Modifications from original:
# 1) Add "-q" flag to suppress output
# 2) Remove python package installation (jupyter etc.)

set -e


print_help() {
    echo "bash `basename $0` [options]"
    echo ""
    echo ""
    echo "Example"
    echo "-------"
    echo "# Install AmberTools with Python 2.7 from Miniconda distribution"
    echo "bash `basename $0` --prefix \$HOME -v 2 "
    echo ""
    echo "# Install AmberTools and use user's Python"
    echo "bash `basename $0` --prefix \$HOME --non-conda"
    echo ""
    echo "Options"
    echo "-------"
    echo "    -h, --help    Print this message and exit"
    echo "    -q, --quiet   Less output"
    echo "    -v VERSION, --version VERSION"
    echo "                  What version of Python do you want?"
    echo "                  can be either 2 (default 2.7) or 3 (3.6)."
    echo "    -p PREFIX, --prefix PREFIX"
    echo "                  Install everything to <PREFIX>/$amberfolder"
    echo "    --amber-version VERSION"
    echo "                  Install the given version (choices: 16, 17 [default])"
    echo "    --non-conda"
    echo "                  If given, only download and unpack AmberTools"
    echo "                  Else, install compatible Python from Miniconda distribution "
    echo "                  and install all Python requirements (numpy, scipy, matplotlib, nglview ...)"
    exit 1
}


message_source_amber(){
    amberhome=$prefix/$amberfolder
    echo "Congratulations."
    echo "----------------------------------------------------------------------"
    echo "Environment resource files are provided to set the proper environment"
    echo "variables to use AMBER and AmberTools."
    echo ""
    echo "If you use a Bourne shell (e.g., bash, sh, zsh, etc.), source the"
    echo "$amberhome/amber.sh file in your shell. Consider adding the line"
    echo "  source $amberhome/amber.sh"
    echo "to your startup file (e.g., ~/.bashrc)"
    echo ""
    echo "If you use a C shell (e.g., csh, tcsh), source the"
    echo "$amberhome/amber.csh file in your shell. Consider adding the line"
    echo "  source $amberhome/amber.csh"
    echo "to your startup file (e.g., ~/.cshrc)"
    echo ""
}

summarize(){
    echo "prefix=$prefix"
    echo "install_python=$install_python"
}

# defaults
at_version=17
install_python=True
pyver=2
quiet=false
MINICONDA_VERSION=4.3.11
channel="http://ambermd.org/downloads/ambertools/conda/"
osname=`python -c 'import sys; print(sys.platform)'`


if [ $# -le 1 ]; then
    print_help
fi

# Process command-line
while [ $# -ge 1 ]; do
    case "$1" in
        -h|--help)
            print_help
            ;;
        -v|--version)
            shift;
            if [ $# -lt 1 ]; then
                print_help
            fi
            pyver=$1
            ;;
        -q|--quiet)
            quiet=true;
            ;;
        -p|--prefix)
            shift;
            if [ $# -lt 1 ]; then
                print_help
            fi
            prefix=$1
            ;;
        --non-conda)
            install_python=False
            ;;
        --amber-version)
            shift;
            if [ $# -lt 1 ]; then
                print_help
            fi
            at_version=$1
            ;;
        *)
            echo "Unsupported argument: $1"
            print_help
            ;;
    esac
    shift
done


amberfolder="amber"$at_version
ambertools_fn="ambertools.$at_version.binary.tar.bz2"


if [ "$quiet" = "true" ]; then
   wget_quiet="-nv"
   curl_quiet="-sS"
   qflag="-q"
else
   wget_quiet=""
   qflag=""
   curl_quiet=""
fi



check_existing_amber(){
    if [ -d $prefix/$amberfolder ]; then
        echo "ERROR: $prefix/$amberfolder already exists. Please change your prefix."
        exit 1
    fi
}


install_amber_conda(){
    echo "Install AmberTools with Miniconda"
    check_existing_amber
    # should work for both osx and linux
    if [ $osname = "darwin" ]; then
        echo "https://repo.continuum.io/miniconda/Miniconda${pyver}-${MINICONDA_VERSION}-MacOSX-x86_64.sh"
        curl ${curl_quiet} \
         -# https://repo.continuum.io/miniconda/Miniconda${pyver}-${MINICONDA_VERSION}-MacOSX-x86_64.sh > \
                            miniconda.sh
    else
        wget ${wget_quiet} \
         https://repo.continuum.io/miniconda/Miniconda${pyver}-${MINICONDA_VERSION}-Linux-x86_64.sh \
          -O miniconda.sh;
    fi
    
    echo "Install Miniconda and AmberTools to $prefix/$amberfolder"
    echo ""
    
    bash miniconda.sh -b -p $prefix/$amberfolder
    
    export PATH=$prefix/$amberfolder/bin:$PATH
    conda update ${qflag} --all -y
    conda install --yes ${qflag} conda-build jinja2 pip cython numpy nomkl pytest
    conda install --yes ${qflag} scipy
    $prefix/$amberfolder/bin/pip ${qflag} install pip --upgrade
    
    # TODO: change to ambermd channel
    conda install ${qflag} --yes ambertools=$at_version -c $channel
    conda clean ${qflag} --all --yes
    
    # alias
    cwd=`pwd`
    cd $prefix/$amberfolder/bin
    ln -sf python amber.python || error "Linking Amber's Miniconda Python"
    ln -sf conda amber.conda || error "Linking Amber's Miniconda conda"
    ln -sf pip amber.pip || error "Linking Amber's Miniconda pip"
    cd $cwd
    
    # Write resource files
    amberhome=`$prefix/$amberfolder/bin/python -c "import sys; print(sys.prefix)"`
    cat > $prefix/$amberfolder/amber.sh << EOF
export AMBERHOME="$amberhome"
export PATH="\${AMBERHOME}/bin:\${PATH}"
EOF

cat > $prefix/$amberfolder/amber.csh << EOF
setenv AMBERHOME "$amberhome"
setenv PATH "\${AMBERHOME}/bin:\${PATH}"
EOF
    
}


install_amber_non_conda(){
    echo "Install AmberTools with user's Python"
    if [ "${at_version}" = "16" ]; then
       amber_download_url="http://ambermd.org/cgi-bin/AmberTools${at_version}-get.pl"
    else
       amber_download_url="http://ambermd.org/cgi-bin/AmberTools${at_version}-binary-get.pl"
    fi
    amber_url="${amber_download_url}?Name=bot&Institution=NA&City=NA&State=NA&Country=NA&OS="
    check_existing_amber
    cd $prefix
    if [ $osname = "darwin" ]; then
        curl ${curl_quiet} ${amber_url}osx-64 --output $ambertools_fn
    else
        wget ${wget_quiet} ${amber_url}linux-64 -O $ambertools_fn
    fi
    tar -xf $ambertools_fn
    cat >>amber${at_version}/amber.sh <<EOF

if [ -L \$AMBERHOME/bin/amber.python ]; then
    rm \$AMBERHOME/bin/amber.python
fi
ln -s \`which python\` \$AMBERHOME/bin/amber.python
# chmod +x \$AMBERHOME/bin/amber.python
EOF
}

summarize
if [ "$install_python" = "True" ]; then
    install_amber_conda
else
    install_amber_non_conda
fi

message_source_amber
