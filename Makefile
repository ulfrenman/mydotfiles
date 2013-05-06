install: dotfiles vim

vim:
	make -C myvim

dotfiles:
	ln -sfn ${CURDIR}/PS_COL   ~/.PS_COL
	ln -sfn ${CURDIR}/bashrc   ~/.bashrc
	ln -sfn ${CURDIR}/screenrc ~/.screenrc
