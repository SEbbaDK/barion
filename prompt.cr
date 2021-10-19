#!/usr/bin/env -S crystal run

require "git"
require "system"
require "path"
require "file"

output = ""

def format (format, text)
   "\e[#{format}m #{text} \e[0m"
end

output += format "1;30;43", (ENV["name"]? || "nix-shell") if ENV["IN_NIX_SHELL"]?
output += format "1;30;41", ENV["USER"]
output += format "1;30;45", ENV["HOSTNAME"]? || System.hostname
output += format "1;30;42", ENV["PWD"].sub(ENV["HOME"], "~")

# find repo by searching upwards
path = Path.new("./").expand
paths = [ path ] + path.parents.reverse
repo = nil
paths.each do |p|
    begin
        repo = Git::Repo.open p.to_native.to_s
        # We found a repo
        break
    rescue Git::Error
        # Ignore
    end
end

# make git output
if !repo.nil?
    empty = true
    repo.branches.each do |ref|
        empty = false
    end
        
    if empty
        # libgit2.cr does not yet allow us to view unborn repos
        headfile = File.read(Path[repo.workdir] / Path[".git/HEAD"])
        gitstring = headfile.sub("ref: refs/heads/", "").sub("\n", "")
    else
        gitstring = repo.head.name.sub(/refs\/[^(]*\//, "")
        
        diff = repo.head
        puts repo.status do |file, data|
            puts file
        end
    end
    
    output += format "1;30;44", gitstring
end

puts output
