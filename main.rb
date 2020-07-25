require 'Anki2'
require 'csv'

# It's going to be sort of a command line tool for now... so just normal print statements will do for now. 
def get_data(csv_path) 
    # Gets table of data to use 
    return CSV.parse(File.read(csv_path), headers: true)
end
# Using CSV library 


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

# I'm going to need to make a function which grabs the question and answer from a .csv file. 
@anki.add_card('<span class="kanji">時</span>', 'Big')
@anki.save

puts get_data('.\data\Kanji Radicals Reference - Kanji Radicals.csv')