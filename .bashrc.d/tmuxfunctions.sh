##
# tmux bash functions
##

function tmuxremote {
   # Connect to a remote system and run tmux

   # Add any ssh command options you wish to use.
   # SSHOPTS="-o PasswordAuthentication=no,PubkeyAuthentication=yes,VisualHostKey=no"
   SSHOPTS="-o ConnectTimeout=2"

   # Invocation method #1: tmuxremote mysystem mytmuxsession
   if [ "$#" -eq "2" ] ; then
      TMUXSESSION="-t $2"
      tmuxcmd="tmux attach ${TMUXSESSION}"

   # Invocation method #2: tmuxremote mysystem
   # This method will try a simple tmux attach first. If it fails, then
   # there's no auto session defined in the remote tmux.conf, so we call
   # simply tmux in order to have tmux create our session.
   elif [ "$#" -eq "1" ] ; then
      tmuxcmd="tmux attach || tmux"
   fi

   remote="$1"
   # ssh command; note that -t (open a tty) is MANDATORY for tmux.
   sshcmd="/usr/bin/ssh -o ConnectTimeout=2 -Mt ${remote}"
   finalcmd="${sshcmd} -- ${tmuxcmd}"
   # Finally, call the command
   $finalcmd
}

## Send the same command to all **panes** on the same window
tmall () {   # tmall = short for tmux all
  tmux list-panes -F '#P' | xargs -n1 -P0 -i tmux send-keys -t {} "$@
"

#C## Original (serial) implementation
### _tmux_send_keys_all_panes_ () {
### for _pane in $(tmux list-panes -F '#P'); do
###      tmux send-keys -t ${_pane} "$@"
### done
}

## Send the same command to all **windows** (DANGEROUS!)
tmallw () {   # tmallw = short for tmux all windows
  theargs="$@"
  echo "Please confirm with YES that you want to run this in all tmux WINDOWS"
  echo "'$theargs'"
  read -p "(y/N)> " CONFIRMATION
  if [ "${CONFIRMATION//Y/y}" != "y" ]; then return 0; fi
  # Get a list of all windows and panes in the format @<window_id>.<pane_id>
  # Note: pane_ids start at zero
  tmux list-windows -F '#{window_panes}#{window_id}' | \
    awk -F@ '{ windowcount++; panecount+=$1; for(idx=0;idx<$1;idx++){
                  print "@"$2"."idx
               }
             }' | \
   xargs -n1 -P0 -i tmux send-keys -t {} "$@
"
}


tmclear () {   # tmux clear all panes on the same window
  tmall 'clear'
}

tmux-colors () {  # Shows a list of tmux colors
   ( for i in {0..16} {232..255}; do
       printf "\x1b[38;5;${i}mcolour%.2d\x1b[0m\n" $i
   done ) | column -x  -c ${COLUMNS:-150}
   ( for i in {17..231}; do
       printf "\x1b[38;5;${i}mcolour%.2d\x1b[0m\n" $i
   done ) | column -c 150
}

tmkillothers () {  # Kill all other windows
   # Ensure we have 1 window showing as active
   local activecount="$(tmux list-windows | fgrep '(active)' -c)"
   if [ "$activecount" -ne "1" ]
   then
      echo "Number of active windows is not 1, see:" >&2
      echo "tmux list-windows | fgrep '(active)'"    >&2
      tmux list-windows | fgrep '(active)'           >&2
      return 1
   fi
   
   while :;
   do
	   local otherwindows=( $(tmux list-windows |fgrep -v '(active)' | cut -f1 -d':' ) )
	   if [ "${#otherwindows[@]}" -eq "0" ]
	   then
             echo 'done!'
	     break
           else
	      echo "windows to go: ${otherwindows[*]}"
	      local tbk=${otherwindows[0]}
	      tmux kill-window -t $tbk
	   fi
   done
}
