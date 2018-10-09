class CardDecorator < Draper::Decorator
  delegate_all

  def cost
    return '' unless mana_cost
    result = ''
    mana_cost.each_char do |c|
      result << h.image_tag(mana_img_path(c))
    end
    result.html_safe
  end

  private

  def mana_img_path(c)
    if c.to_i.to_s == c
      "mana/#{c}.jpg"
    else
      case c
      when 'u'
        'mana/blue.jpg'
      when 'b'
        'mana/black.jpg'
      when 'r'
        'mana/red.jpg'
      when 'g'
        'mana/green.gif'
      when 'w'
        'mana/white.gif'
      end
    end
  end
end
