#!/usr/bin/env ruby

gdir = ENV['GDIR']
gworktree = ENV['GWORKTREE']


list = {}
note = {}
last = {}
hash = nil
char = "•"
args = "--oneline --name-status --date=format:'%Y-%m-%d %H:%M:%S' --format='%h %cd#{char}%s' . | grep ."

Dir.chdir(`git --git-dir=#{gdir} --work-tree=#{gworktree} rev-parse --show-toplevel`.chomp)

`git --git-dir=#{gdir} --work-tree=#{gworktree} ls-files`      .split("\n").each {|e| list[e     ] = '  '    }
`git --git-dir=#{gdir} --work-tree=#{gworktree} status -suno .`.split("\n").each {|e| list[e[3..]] = e[0, 2] }
`git --git-dir=#{gdir} --work-tree=#{gworktree} log #{args}`   .split("\n").each {|e| e.split(/\s+/,2); $& == " " ? note[hash = $`] = $' : last[$'.split("\t",2).last] ||= hash }

list.each {|path, stat| puts [stat, path, hash=last[path], note[hash]] * char }

