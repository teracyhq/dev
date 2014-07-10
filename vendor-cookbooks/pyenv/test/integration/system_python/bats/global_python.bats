#!/usr/bin/env bats

global_python="2.7.6"
https_url="https://google.com"

setup() {
  source /etc/profile.d/pyenv.sh
}

@test "installs $global_python" {
  run pyenv versions --bare
  [ $status -eq 0 ]
  [ $(echo "$output" | grep "^$global_python$") = "$global_python" ]
}

@test "sets $global_python as the global Python" {
  run pyenv global
  [ $status -eq 0 ]
  [ $output = "$global_python" ]
}
