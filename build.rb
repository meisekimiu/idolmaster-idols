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
	puts ""
	puts "Special modules:"
	puts "\tmillion-stars (Both million-live and million-live-theater-days modules)"
	puts "\tall-idols (All of the main idol modules. No Kotori...)"
	puts "\tall (All of the provided modules)"
	puts ""
	puts "Options:"
	puts "  --help\tDisplay this help message."
	puts "  --stdout\tOutput results of build to standard output instead of a file."
	puts "  --assoc\tOutputs results as an object/associative array"
	puts "  --modinf\tAdds module info fields to idol data"
	puts "  --master\tCombines --assoc and --modinf options for best results"
end

def parse_modules(mods)
	modules = mods
	mod_list = Array.new
	modules.each do |mod|
		if mod == "all" || mod == "all-idols" then
			Dir.entries(DATA_DIR).each do |m|
				if m != "." && m != ".."
					if mod != "all-idols" || m != "kotori"
						mod_list.push m
					end
				end
			end
		elsif mod == "million-stars" then
			mod_list.push "million-live.json","million-live-theater-days.json"
		elsif mod == "--stdout" || mod == "--assoc" || mod == "--modinf" || mod == "--master" then
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
idols_assoc = Hash.new

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
			if ARGV.include?("--modinf") || ARGV.include?("--master") then
				idol["module"] = mod.split(".")[0]
			end
			if ARGV.include?("--assoc") || ARGV.include?("--master") then
				hash = idol["name"]["translit"].downcase.gsub(" ","_")
				idols_assoc[hash] = idol
			else
				idols.push idol
			end
		end
	else
		STDERR.puts "Error: Module `#{mod}` not found. Exiting script."
		exit
	end
end

if ARGV.include?("--assoc") || ARGV.include?("--master") then
	out = idols_assoc
else
	out = {"idols"=>idols}
end

if stdout then
	puts JSON.generate(out)
else
	File.write(File.dirname(__FILE__)+"/dist/idols.json",JSON.generate(out))
	puts "Output to "+File.dirname(__FILE__)+"/dist/idols.json"
end
