class Deck::CreateFromList
  include Interactor

  def call
    user_id   = context.user_id
    list      = context.list.split("\r\n")
    @deck_id  = nil

    list.each do |entry|
      if (name_match = entry.match(%r{\/\/ NAME \: (.+)}))
        @deck_id = Deck::Create.call(name: name_match[1], user_id: user_id).deck_id
      end
      next if entry.include?('//')

      @deck_id = Deck::Create.call(name: nil, user_id: user_id).deck_id if @deck_id.nil?
      if card_match = entry.match(/(SB:\s)?(\d+)\s?x?\s(.+)/)
        add_in     = card_match[1].present? ? :sideboard : :main_deck
        occurences = card_match[2].to_i
        if card = Card.where(name: card_match[3].gsub('’', "'")).first
          (0..occurences - 1).each do |n|
            Deck::AddCard.call(deck_id: @deck_id, card_id: card.id, in: add_in)
          end
        else
          # FIXME CARD MISSING DO SOMETHING !!
        end
      end
    end
    deck = Deck.find(@deck_id)
    deck.save
    context.deck = deck
  end
end
