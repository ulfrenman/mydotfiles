mydotfiles
==========

Some general configuration files


Install
=======
Go to your home and clone the repo (it will create a new directory named
`mydotfiles` by default). Jump into that directory and type make!

    cd ~
    git clone git@github.com:ulfrenman/mydotfiles.git
    cd mydotfiles
    make

Done

Pushing local updates
=====================
If I make changes to `vimrc` in the submodule `myvim` there is some fiddling
to get things working again.

    # Add the changes I made to vimrc
    cd myvim
    git commit -a
    git push
    cd ..
    # See if some other submodule has been updated
    make
    # During make some summodules of myvim was updated so push thies
    cd myvim
    git commit -am "Update of submodule"
    git push
    cd ..
    # Push info that myvim has been changed
    git commit -am "Update of submodule"
    git push
