#!/usr/bin/ruby
#iDOLM@STER JSON test script

require 'json'
require 'date'
FILE_PATH = "../data/765pro.json"

idols = JSON.parse(File.read(FILE_PATH), object_class: OpenStruct).idols;
lang = ((ENV["LANG"].downcase.include? "jp") ? "jp" : "en")

puts "Welcome! This script tests our idolmaster JSON data!"

puts "Enter an idol's name for their information:"
name = gets.chomp.downcase
while name.strip==""
	puts "Please type a name."
	name = gets.chomp.downcase;
end
#Figure out which idol they queried
main_idol = nil
if name.split(/\w/).count > 1 then
	#They probably entered a full name
	idols.each do |idol|
		if idol.name.western.downcase == name || idol.name.translit.downcase == name then
			main_idol = idol;
		end
	end
	if !main_idol then
		puts "Could not find idol: #{name}."
		exit
	end
else
	#They entered a first or last name (probably first but whatever) or kanji
	idols.each do |idol|
		if idol.name.western.downcase.split(" ").include?(name) || idol.name.kana.split("　").include?(name) || idol.name.kanji.value == name || idol.name.kanji.value.include?(name) then
			main_idol = idol;
		end
	end
	if !main_idol then
		puts "Could not find idol: #{name}."
		exit
	end
end

idol = main_idol
p_pronoun = (idol.gender == "female" ? "her" : "his")
o_pronoun = (idol.gender == "female" ? "her" : "him")
s_pronoun = (idol.gender == "female" ? "she" : "he")
birthday = Date.strptime(idol.birthday.format, "%m-%d")
puts "#{idol.name.western} is #{idol.age} years old. #{p_pronoun.capitalize} birthday is on #{birthday.strftime('%B %-d')}."
puts "#{s_pronoun.capitalize} is #{idol.height} tall and weighs #{idol.weight}. #{p_pronoun.capitalize} blood type is #{idol.bloodtype}."
puts "#{idol.name.western.split(" ")[0]}'s voice actor is #{idol.seiyuu.name.western} (aka #{idol.seiyuu.nicknames[0].translit})."
puts "#{idol.name.western.split(" ")[0]}'s hobbies include: #{idol.hoobies.join(", ")}."
puts
puts "#{idol.name.kanji.value}は#{idol.age_str}です。誕生日が#{idol.birthday.format_jp}です。"
puts "身長#{idol.height}で、体重は#{idol.weight}です。血液型が#{idol.bloodtype}です。"
puts "#{idol.name.kanji.fname}の声優は#{idol.seiyuu.name.kanji.value}（#{idol.seiyuu.nicknames[0].jp}）です。"
puts "#{idol.name.kanji.fname}の趣味は#{idol.hobbies.join("と")}です。"
