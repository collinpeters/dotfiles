alias vssh="ssh intouch@33.33.33.2"

export INTOUCH_VAGRANT="~/code/i/intouch/scripts/vagrant"
alias vup="cd $INTOUCH_VAGRANT; vagrant up localdev"
alias vdown="cd $INTOUCH_VAGRANT; vagrant halt localdev"
alias vdestroy="cd $INTOUCH_VAGRANT; vagrant destroy localdev"
alias vrestart="vdown; vup;"
