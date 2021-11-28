require 'rubygems'
require 'anki2'
require 'csv'
require 'optparse'


class Deck
    def initialize(deck_name, headers_array)
        @name = deck_name
        @headers = headers_array.drop(1) # This omits the first header which I assume is "Kanji"
        @dump_path = "./decks/"+ deck_name + ".apkg"
        @deck = Anki2.new({
            css: '      .card {
                font-family: mincho;
                font-size: 88px;
                text-align: center;
                color: black;
               }
             .kanji {font-family: "Kozuka Mincho Pr6N"}
             ',
            name: @name,
            output_path: @dump_path
        })
        # Not quite sure if this will work or not 
        @base = ""
        for header in @headers
            @base = @base + header + " %s" +"\n" # header and newline 
        end

        puts @base

    end



    def new_card(row)
        keyword = row.headers()[0]
        kanji = row["Kanji"] # For now let's keep it like this, I am only studying Japanese for now and for sure it will be Kanji!       
        
        temp = ""
        counter = 0 # Init counter to zero
        len = @headers.length() # Get the length of the headers array.
        row.drop(1).each do |field|
            """
            This modulus division is a hack, but it works for the format I use. 
            Counts up from zero, then indexes the headers array by modulus dividing the count by how many headers we have.
            This way we iterate through that array in sync with parsing the row. 

            This is definitely a bit of a hack but I will see what I can do later on.

            """
            count = counter.modulo(len) # Modulus division
            
            temp = temp + "#{@headers[count]}: #{field[1]} \n"
            
            counter += 1 # Increment the counter
        end
        
        
        @deck.add_card(('<span class="kanji">'+ row[keyword].force_encoding('utf-8') +'</span>'), temp.to_s.force_encoding('utf-8'))
    end

    def save_deck
        @deck.save
    end
    
end
# It's going to be sort of a command line tool for now... so just normal print statements will do for now. 
def get_data(csv_path) 
    # Gets table of data to use 
    return CSV.parse(File.read(csv_path), encoding: 'utf-8', headers: true).by_row
end

# maybe move this to a function as well

"""
I thought about making this dynamic, but I think specifying the deck name in the data folder, as well as the name 
you'd like it to be dumped with is the best option here. Don't want to be creating decks en masse or anything...
TODO: this may change though or be added as another functionality 
"""

optparse = OptionParser.new do |parser|
    parser.on("-c", "--create DECK", "The name of the deck.") do |create|
        name = create.split(".")[0]

        t1 = Time.now
        data = get_data("./#{create}" )
        # puts data.class
        headers = data.headers # Gets the headers
        newdeck = Deck.new("#{name}", headers) 
        data.each do |row|
            newdeck.new_card(row) 
        end
        newdeck.save_deck
        t2 = Time.now 
        puts (t2-t1)

    end
end
      
optparse.parse! 
