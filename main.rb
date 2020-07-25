require 'Anki2'
require 'csv'

# It's going to be sort of a command line tool for now... so just normal print statements will do for now. 
def get_data(csv_path) 
    # Gets table of data to use 
    return CSV.parse(File.read(csv_path), encoding: 'IBM437:utf-8', headers: true)
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


data = get_data('.\data\Kanji Radicals Reference - Kanji Radicals.csv')
puts data[0]["Kanji"].encoding

@anki.add_card(('<span class="kanji">'+ data[0]["Kanji"].force_encoding('utf-8') +'</span>'), data[0]["Meaning"])
@anki.save