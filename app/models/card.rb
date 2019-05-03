# == Schema Information
#
# Table name: cards
#
#  id               :bigint(8)        not null, primary key
#  name_fr          :string
#  name             :string
#  extension_set_id :integer
#  card_type        :integer
#  detailed_type    :string
#  rarity           :integer
#  text             :text
#  cmc              :integer
#  mana_cost        :string
#  color_ids        :integer          is an Array
#  image            :string
#  power            :integer
#  defense          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  artist_name      :string
#  number_in_set    :integer
#  gatherer_link    :string
#  gatherer_id      :integer
#  name_clean       :string
#  name_fr_clean    :string
#  image_fr         :string
#  type_fr          :string
#  text_fr          :text
#  flavor_text      :text
#  flavor_text_fr   :text
#  power_str        :string
#  defense_str      :string
#  color_indicator  :string
#  loyalty          :integer
#

class Card < ApplicationRecord

  # TODO : ajouter bitfield pour le format (https://github.com/grosser/bitfields)

  scope :only_green,              -> { where(color_ids: [Color.green]) }
  scope :only_red,                -> { where(color_ids: [Color.red])   }
  scope :only_blue,               -> { where(color_ids: [Color.blue])  }
  scope :only_white,              -> { where(color_ids: [Color.white]) }
  scope :only_black,              -> { where(color_ids: [Color.black]) }
  scope :gold,                    -> { where("array_length(color_ids, 1) >= 2") }
  scope :colorless,               -> { where('color_ids is ?', nil) }
  scope :red,                     -> { where("? = ANY(color_ids)", Color.red)}
  scope :blue,                    -> { where("? = ANY(color_ids)", Color.blue)}
  scope :black,                   -> { where("? = ANY(color_ids)", Color.black)}
  scope :green,                   -> { where("? = ANY(color_ids)", Color.green)}
  scope :white,                   -> { where("? = ANY(color_ids)", Color.white)}
  scope :colorless_artefact,      -> { where('color_ids is ?', nil).also_artefacts }
  scope :also_artefacts,          -> { where(card_type: [5, 6]) }
  scope :colorless_non_artefact,  -> { colorless.where("cards.card_type NOT IN (2, 5, 6) OR cards.card_type IS NULL") }

  enum card_type: {
    instant:            1,
    land:               2,
    sorcery:            3,
    creature:           4,
    artifact:           5,
    creature_artifact:  6,
    enchantement:       7,
    planeswalker:       8,
    tribal:             9,
    other:              10,
  }

  enum rarity: {
    common:   1,
    uncommon: 2,
    rare:     3,
    mythic:   4
  }

  belongs_to :extension_set

  has_one :alternative
  has_one :alternative_card, through: :alternative

  has_many :reprints, foreign_key: :card_id, dependent: :destroy
  has_many :reprint_cards, through: :reprints

  before_create :set_colors, :clean_names
  before_save   :set_colors, :set_type

  mount_uploader :image,    CardImageUploader
  mount_uploader :image_fr, CardImageUploader

  def has_alternative?
    alternative.present?
  end

  def is_alternative?
    Alternative.where(alternative_card: id).any?
  end

  def icone_url
    case rarity
    when 'commun'
      extension_set.commun_logo&.url
    when 'uncommun'
      extension_set.uncommun_logo&.url
    when 'rare'
      extension_set.rare_logo&.url
    when 'mythic'
      extension_set.mythic_logo&.url
    else
      extension_set.commun_logo&.url
    end
  end

  def colorless?
    !color_ids.present?
  end

  def colors
    return [] unless color_ids.present?
    colors = []
    color_ids.each do |id|
      colors << Color::COLORS_MAPPING.invert[id].to_s
    end
    colors
  end

  def card_ids
    reprint_cards.collect(&:id) << id
  end

  def basic_land?
    ['Snow-Covered Island',
    'Snow-Covered Swamp',
    'Snow-Covered Mountain',
    'Snow-Covered Forest',
    'Snow-Covered Plains',
    'Island',
    'Swamp',
    'Mountain',
    'Forest',
    'Plains'].include?(name)
  end

  private

  def set_colors
    c_ids = []
    if color_indicator.present?
      color_indicator.downcase.split(',').each do |color|
        c_ids << Color.__send__(color.gsub(' ', ''))
      end
    else
      Color::MANA_COST_MAPPING.each do |mana_c, colors|
        if mana_cost&.include?(mana_c.to_s)
          Array.wrap(colors).each do |color|
            c_ids << Color.__send__(color)
          end
        end
      end
    end
    self['color_ids'] = c_ids.any? ? c_ids.uniq : nil
  end

  def clean_names
    self[:name_fr_clean] = I18n.transliterate(name_fr || '').downcase
    self[:name_clean]    = I18n.transliterate(name || '').downcase
  end

  def set_type
    self.card_type = :creature_artifact if self.detailed_type&.include?('Artifact Creature')
    self.card_type = :artifact          if self.detailed_type&.include?('Artifact')
    self.card_type = :land              if self.detailed_type&.include?('Land')
  end
end
