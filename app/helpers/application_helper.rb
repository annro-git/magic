module ApplicationHelper
  include Pagy::Frontend

  def pretty_checkbox(name, options = {})
    # TODO : recup args dans un hash
    # puis faire un delete de pretty class/label et passer le reste au helper checkbox
    content_tag(:div,
      check_box_tag(name, options[:value], options[:checked], id: options[:id], class: options[:class].presence) +
      content_tag(:div, content_tag(:label, options[:label]), class: "state p-#{options[:pretty_class]}"),
      class: "pretty p-default")
  end

  def mana_img_path(c)
    if c.to_s.to_i.to_s == c
      "card_symboles/#{c}.png"
    else
      case c.to_s
      when 'u'
        'card_symboles/u.png'
      when 'b'
        'card_symboles/b.png'
      when 'r'
        'card_symboles/r.png'
      when 'g'
        'card_symboles/g.png'
      when 'w'
        'card_symboles/w.png'
      else
        "card_symboles/#{c}.png"
      end
    end
  end

  def sort_deck_cards(cards)
    { 'Créatures' => cards.creatures.decorate, 'Autres' => cards.others.decorate, 'Terrains' => cards.land.decorate }.reject { |k, v| v.none? }
  end
end
