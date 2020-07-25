require 'Anki2'

puts 'Enter the name of your new Anki deck: '
deck_name = gets.chop

path = "../generated_decks/#{deck_name}.apkg"
sprintf(path)

puts path
@anki = Anki2.new({
    css: '.kanji { font-size: 88px; }',
    name: deck_name,
    output_path: path
})
@anki.add_card('<span class="kanji">時</span>', 'Big')
@anki.save