require 'Anki2'
require 'csv'

class Deck
    def initialize(deck_name, dump_path)
        @name = deck_name
        @dump_path = dump_path
        @deck = Anki2.new({
            css: '.kanji { font-size: 88px; }',
            name: @name,
            output_path: @dump_path
        })
    end


    def new_card(kanji, meaning)
        @deck.add_card(('<span class="kanji">'+ kanji.force_encoding('utf-8') +'</span>'), meaning)
    end

    def save_deck
        @deck.save
    end
    
end
# It's going to be sort of a command line tool for now... so just normal print statements will do for now. 
def get_data(csv_path) 
    # Gets table of data to use 
    return CSV.parse(File.read(csv_path), encoding: 'IBM437:utf-8', headers: true)
end

# maybe move this to a function as well

newdeck = Deck.new("Radicals reference", '.\decks\Radicals reference.apkg') 
data = get_data('.\data\Kanji Radicals Reference - Kanji Radicals.csv')
for row in data
    newdeck.new_card(row['Kanji'], row['Meaning']) 
end
newdeck.save_deck
