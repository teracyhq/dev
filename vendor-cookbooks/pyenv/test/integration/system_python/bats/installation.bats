#!/usr/bin/env bats

@test "creates profile.d file" {
  [ -f "/etc/profile.d/pyenv.sh" ]
}

@test "creates pyenv directory" {
  [ -d "/usr/local/pyenv" ]
}

@test "loads environment" {
  source /etc/profile.d/pyenv.sh
  [ "$(type pyenv | head -1)" = "pyenv is a function" ]
}
