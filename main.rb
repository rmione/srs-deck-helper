require 'Anki2'

# It's going to be sort of a command line tool for now... so just normal print statements will do for now. 

puts 'Enter the name of your new Anki deck: '
deck_name = gets.chop

# Real basic string formatting here. 
# going to make a YAML file that gets your configuration i.e where you want to save it, some of the config like font size etc
path = "../generated_decks/#{deck_name}.apkg"
puts path

@anki = Anki2.new({
    css: '.kanji { font-size: 88px; }',
    name: deck_name,
    output_path: path
})
@anki.add_card('<span class="kanji">時</span>', 'Big')
@anki.save