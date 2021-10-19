#!/usr/bin/env -S crystal run

require "system"
require "path"
require "file"

require "./gitrepo"

output = ""

def format (format, text)
   "\e[#{format}m #{text} \e[0m"
end

# NIX SHELL BAR
output += format "1;30;43", (ENV["name"]? || "nix-shell") if ENV["IN_NIX_SHELL"]?

# BASE BARS
output += format "1;30;41", ENV["USER"]? || "no $USER"
output += format "1;30;45", ENV["HOSTNAME"]? || System.hostname
output += format "1;30;42", ENV["PWD"].sub(ENV["HOME"], "~")

# GIT BAR
begin
    repo = GitRepo.find(Path.new("./"))
    output += format "1;30;44", repo.head_abbrev + repo.status_abbrev + (!repo.has_remote? ? " ↟" : "")
rescue ex
    nil
end

# PREVIOUS COMMAND BAR
status = ARGV[0]? || "0"
output += format "1;30;41", status if status != "0"

puts output
