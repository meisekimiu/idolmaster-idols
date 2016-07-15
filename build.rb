#!/usr/bin/ruby
#Idol Data Build Script
#Combines and minfies different JSON modules into one handy package.
require 'json'
DATA_DIR = Dir.pwd+"/data/"

def usage
	puts "Usage: #{$0} [modules] [options]"
	puts ""
	puts "Modules:"
	Dir.entries(DATA_DIR).each do |mod|
		if mod.include?(".json")
			puts "\t#{mod.split(".json")[0]}"
		end
	end
	puts "\tall"
	puts ""
	puts "Options:"
	puts "  --help\tDisplay this help message."
	puts "  --stdout\tOutput results of build to standard output instead of a file."
end

def parse_modules(mods)
	modules = mods
	mod_list = Array.new
	modules.each do |mod|
		if mod == "all" then
			Dir.entries(DATA_DIR).each do |m|
				if m != "." && m != ".."
					mod_list.push m
				end
			end
		elsif mod == "--stdout" then
			#do nothing

		#TODO:Add cg-all module eventually
		else
			mod_list.push "#{mod}.json"
		end
	end
	return mod_list.uniq
end

if ARGV.length<1 || ARGV.include?("--help") then
	usage
	exit
end

stdout = ARGV.include?("--stdout")
modules = parse_modules ARGV
idols = Array.new

if !stdout then
	puts "Building modules:"
end

modules.each do |mod|
	if File.exists?(DATA_DIR+mod) then
		if !stdout then
			puts " #{mod}"
		end
		jsondata = File.read(DATA_DIR+mod)
		idoldata = JSON.parse(jsondata)["idols"]
		idoldata.each do |idol|
			idols.push idol
		end
	else
		STDERR.puts "Error: Module `#{mod}` not found. Exiting script."
		exit
	end
end

out = {"idols"=>idols}

if stdout then
	puts JSON.generate(out)
else
	File.write("idols.json",JSON.generate(out))
	puts "Output to "+Dir.pwd+"/idols.json"
end
