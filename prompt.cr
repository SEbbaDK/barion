require "git"
require "system"

output = "NEW"

def format (format, text)
   "\e[#{format}m #{text} \e[0m"
end

output += format "1;30;43", (ENV["name"]? || "nix-shell") if ENV["IN_NIX_SHELL"]?
output += format "1;30;41", ENV["USER"]
output += format "1;30;45", ENV["HOSTNAME"]? || System.hostname
output += format "1;30;42", ENV["PWD"].sub(ENV["HOME"], "~")

begin
    repo = Git::Repo.open("./")
    empty = true
    repo.branches.each do |ref|
        empty = false
    end
    
    if empty
        gitstring = "new" 
    else
        gitstring = repo.head?.to_s
    end
    
    output += format "1;30;44", gitstring
rescue e : Git::Error
    # We are not in a git repo so ignore whatever
    raise e
end

puts output
