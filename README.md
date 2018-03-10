# idolmaster-idols
このリポジトリには、アイドルマスターのアイドルについてJSONファイルがあります。どうぞ。

In this repository there are JSON files containing data about the idols from the iDOLM<span></span>@<span></span>STER. Do with them as you wish.

## Building
This project really contains only JSON files, so technically you can just use all the data in the `data/` directory if you wish. However, to make files easier to edit, the basic JSON files in that directory are not minified. It's recommended you use the `build.rb` script to combine different JSON modules and minify the results.

The `build.rb` script takes the specific JSON modules you pass as arguments and combines them into a minified file that goes to the `dist/` directory. For example, if you want to get a single data file for both the core 765 Production idols *and* the 876 Production idols, you can run the command `./build.rb 765pro dearly-stars`. To combine all available JSON modules into one giant file, you can run the command `./build.rb all`. Run `./build.rb --help` for more information on various modules and other command line arguments.

## How to use the Data
The data is free to use as you wish, however, depending on your needs, it is recommended you run the build command with the `--master` flag passed in. This command combines the `--assoc` flag and the `--modinf` flag. The `--assoc` flag will cause the script to output an object (or associate array or dictionary depending on how you plan to consume the JSON). The `--modinf` flag adds a "module" field to each idol to identify which module they belong to, which is useful if you used the `all` flag but you still want to identify idols based on which specific module (and as a result, which series) they came from.

At this point, you can simply consume the JSON and look up an idol by their identifier:
```
import Idols from './idols.json'

console.log(Idols["baba_konomi"].name.kanji.value) //Outputs "馬場このみ"
console.log(Idols["futami_ami"].age === Idols["futami_mami"].age) //Outputs "true"
console.log("%c"+Idols["amami_haruka"].name.western,"color: "+Idols["amami_haruka"].color) //Outputs Haruka's name in her color
```

### Data Structure Specification (Kind of)
The data might not be formatted the most intuitively (why are there so many fields for names???) so please read the specifics below for clarifications. Also, while all characters have *some* fields they all share, due to some outliers in the series, some characters may be missing fields that others do have.

#### Idol and Seiyuu Names
Every named idol and seiyuu in this data set has a *lot* of different fields for their names. Let's go through them.

##### name.kanji
The `name.kanji` structure stores information about how a character's name is stored in kanji, as well as the way their name is canonically written in Japanese. If a character has a given name and a family name, the kanji for said names will be stored in `name.kanji.fname` and `name.kanji.lname`. `name.kanji.value` stores the characters **canonical Japanese name**, as it is when written out in media. For most characters, this is just their name in kanji, but some characters like Roco have special "canonical" names that are different from their name written out in just kanji. `name.kanji.value` is the only field that is guaranteed to exist on this object, but for the majority of characters, the `name.kanji.fname` and `name.kanji.lname` fields will also exist.

##### name.kana
This field stores the character's name written out in Hiragana or Katakana with a space between family and given name.

##### name.translit
This field stores a romanized version of the character's name. Note that this maintains Japanese name order for any Japanese names.

##### name.western
This field stores a "westernized" version of the character's name. In most cases this is just the `name.translit` field but with the name put into standard western order instead ("Konomi Baba" instead of "Baba Konomi"). The reason why these are two different fields is for characters who *do* have western-style names. For example, Emily Stewart's `name.translit` and `name.western` fields are identical. While getting a westernized name pragmatically by simply reversing the `name.translit` feature would work for most idols, there are always outliers so you should always use the `name.western` field if you need a western name.

#### Idol age
Due to a few outliers, we can't reliably store all idols' ages as pure numbers. For *most* idols though, the `age` field stores the idol's age as an integer. However, the `age_str` field is the only one guaranteed to be on each idol's profile. For most idols, it is simply a string version of their age with the "歳" counter added. However, certain characters (think of a certain eternally 17 year old alien from planet Usamin) have no definite age and only have string descriptors for their age.

Seiyuu do not have an age value since if we do actually know their age, we can get it pragmatically from their `birthday` structure.

#### Three sizes
Much like age, while most idols have their three sizes provided, there are a few idols whose sizes aren't actually specified. While all idols have a `sizes` structure, not *all* have the corresponding numeric `sizes.b`, `sizes.w`, and `sizes.h` fields on them. However, they do all have the `sizes.value` field, which is just a string formatted version of their three sizes, whether they are actual sizes or not.

#### Hobbies
Idols' hobbies are stored in two separate arrays, `hobbies` and `hoobies`, for Japanese and English values respectively. `hobbies` is technically the *only* source for actual canonical information, taken straight from official resources. `hoobies` is named after an old meme and is sourced mainly from the Project-Imas wiki translations, unless the ones they provided were particularly horrible.

## Credits
このデータは[project-imas wiki](http://www.project-imas.com/wiki/)と[ニコニコ大百科](http://dic.nicovideo.jp)よりです。

A lot of this data comes from the [project-imas wiki](http://www.project-imas.com/wiki/ "Now they can use this data for their wiki!"). However, the Nico Nico Pedia  ([ニコニコ大百科](http://dic.nicovideo.jp)) has also been incredibly helpful, especially for original Japanese data ~~and actually providing the correct kanji unlike the other site I mentioned.~
