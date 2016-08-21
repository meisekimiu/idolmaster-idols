# idolmaster-idols
このリポジトリには、アイドルマスターのアイドルのJSONファイルがあります。どうぞ。

In this repository there are JSON files containing data about the idols from the iDOLM@STER. Do with them as you wish.

##Building
This project really contains only JSON files, so technically you can just use all the data in the `data/` directory if you wish. However, to make files easier to edit, the basic JSON files in that directory are not minified. It's recommended you use the `build.rb` script to combine different JSON modules and minify the results.

For example, if you want to get a data file for the core 765 Production idols only, you can simply run the command `./build.rb 765pro`. A minified file you can use in your projects will be generated in the directory. If you want to get a single data file for both the core 765 Production idols *and* the 876 Production idols, you can run the command `./build.rb 765pro dearly-stars`. To combine all available JSON modules into one giant file, you can run the command `./build.rb all`.

##Credits
このデータが[project-imas wiki](http://www.project-imas.com/wiki/)よりです。

A lot of this data comes from the [project-imas wiki](http://www.project-imas.com/wiki/ "Now they can use this data for their wiki!").
