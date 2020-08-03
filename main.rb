require 'Anki2'
require 'csv'
require 'optparse'


class Deck
    def initialize(deck_name, dump_path, headers_array)
        @name = deck_name
        @headers = headers_array.drop(1) # This omits the first header which I assume is "Kanji"
        @dump_path = dump_path
        @deck = Anki2.new({
            css: '.kanji { font-size: 88px; }',
            name: @name,
            output_path: @dump_path
        })
        # Not quite sure if this will work or not 
        @base = ""
        for header in @headers
            @base = @base + header + " %s" +"\n" # header and newline 
        end

    end


    def new_card(data)
        kanji = data['Kanji'] # For now let's keep it like this, I am only studying Japanese for now and for sure it will be Kanji!       
        meaning = data['Meaning']  
        radicals = data['Radicals']
        temp = @base
        for col in data
            # Repeatedly fills out all the %s with all of the different columns! 
            temp = temp % col 
        end 
            
        @deck.add_card(('<span class="kanji">'+ kanji.force_encoding('utf-8') +'</span>'), 'Meaning: '+meaning + '\nRadicals: '+ radicals.force_encoding('utf-8'))
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

optparse = OptionParser.new do |parser|
    parser.on("-c", "--create DECK", "The name of the deck.") do |create|
        puts create
        t1 = Time.now
        data = get_data('.\data\Kanji Radicals Reference - Kanji Radicals.csv')
        headers= data.headers # Gets the headers
        newdeck = Deck.new("Radicals reference", '.\decks\abss.apkg', headers) 
        for row in data
            newdeck.new_card(row) 
        end
        newdeck.save_deck
        t2 = Time.now 
        puts (t2-t1)
    end
end
      
optparse.parse! 