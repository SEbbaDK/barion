class GitDiff
    property changed : UInt16 = 0
    property added   : UInt16 = 0
    property removed : UInt16 = 0
    property renamed : UInt16 = 0
    
    def to_s(s : IO)
		s << "#{changed}♦" if changed != 0
		s << " " if (changed != 0) && added != 0
		s << "#{added}+" if added != 0
		s << " " if (changed != 0 || added != 0) && removed != 0
		s << "#{removed}-" if removed != 0
		s << " " if (changed != 0 || added != 0 || removed != 0) && renamed != 0
		s << "#{renamed}➤" if renamed != 0
    end
    
    def to_s
        String.build do |s|
            to_s s
        end
    end
    
    def none?
        (changed + added + removed + renamed) == 0
    end
end

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
        working = GitDiff.new
        staged = GitDiff.new
		self.status.each_line do |l|
        	case l[0]
    		when ' ', '?'
        		# Do nothing
        	when 'M'
            	staged.changed += 1
        	when 'A'
            	staged.added += 1
        	when 'D'
            	staged.removed += 1
            when 'R'
                staged.renamed += 1
        	else
            	puts "unkown staging git status »#{l[0,2]}«"
        	end
        	
        	case l[1]
        	when ' '
            	# Do nothing
    		when 'M'
        		working.changed += 1
    		when '?'
        		working.added += 1
    		when 'D'
        		working.removed += 1
        	else
            	puts "unkown working git statusline »#{l[0,2]}«"
        	end
        	
		end
		if staged.none?
    		working.to_s
		else
    		"#{working} [#{staged}]"
		end
    end
    
    # We check if the current head has a remote by checking .git/config
    def has_remote?
		config =~ /\[branch "#{head_abbrev}"\][^]]+remote/ != nil
    end
    
end

