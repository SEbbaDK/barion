class GitRepo
    getter path : Path, git : Path
    
    def initialize(path : Path)
        @path = path
        @git = path / ".git"
    end
    
    # Finds a repo by searching upwards
    # throws an error if not a repo
    def self.find(search_path : Path)
        path = search_path.expand
        paths = [ path ] + path.parents.reverse
        git_dir = nil
        paths.each do |p|
            git_path = p / ".git"
            if File.directory? git_path
                return GitRepo.new p
            end
        end
        
        raise "No git-repo found"
    end
    
    def head
        File.read(@git / "HEAD").sub(/[\n\r]*$/, "")
    end
    
    def config
        File.read(@git / "config")
    end
    
    def head_abbrev
        head.sub("ref: refs/heads/", "")
    end
    
    def status
        `git status --porcelain`
    end
    
    def status_abbrev
        staged = 0
        changed = 0
        added = 0
        removed = 0
		self.status.each_line do |l|
    		header = l[0,2]
    		
    		if header[0] != '?' && header[0] != ' '
        		staged += 1
    		end
    		
        	case header
    		when "MM", " M"
        		changed += 1
    		when "??"
        		added += 1
    		when "DD", " D"
        		removed += 1
        	else
            	puts "unkown git statusline »#{l[0,2]}«"
            end
		end
		output = ""
		output += " #{staged}×" if staged != 0
		output += " #{changed}¤" if changed != 0
		output += " #{added}+" if added != 0
		output += " #{removed}-" if removed != 0
		output
    end
    
    # We check if the current head has a remote by checking .git/config
    def has_remote?
		config =~ /\[branch "#{head_abbrev}"\][^]]+remote/ != nil
    end
    
end

