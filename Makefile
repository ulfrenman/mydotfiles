install: submodules dotfiles vim

submodules:
	git submodule init
	git submodule update

vim:
	make -C myvim

dotfiles:
	ln -sfn ${CURDIR}/PS_COL   ~/.PS_COL
	ln -sfn ${CURDIR}/bashrc   ~/.bashrc
	ln -sfn ${CURDIR}/screenrc ~/.screenrc
