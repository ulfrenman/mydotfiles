install: submodules update_modules dotfiles vim

submodules:
	git submodule init
	git submodule update

vim:
	make -C myvim

dotfiles:
	ln -sfn ${CURDIR}/PS_COL   ~/.PS_COL
	ln -sfn ${CURDIR}/bashrc   ~/.bashrc
	ln -sfn ${CURDIR}/screenrc ~/.screenrc
	ln -sfn ${CURDIR}/Xdefaults ~/.Xdefaults
	ln -sfn ${CURDIR}/Xdefaults ~/.Xresources
	ln -sfn ${CURDIR}/gitconfig ~/.gitconfig
	ln -sfn ${CURDIR}/psqlrc ~/.psqlrc

update_modules:
	git submodule foreach git pull origin master
