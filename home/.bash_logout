# .bash_logout file for bash logout

# ssh-agent
if [ ${SSH_AGENT_PID:-NoDefine} != "NoDefine" ] ; then
  eval `ssh-agent -k`
fi
