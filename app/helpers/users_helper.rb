module UsersHelper

  def display_avatar_large(user)
    begin
      user.avatar.variant(gravity: :center, resize:"240x240^", crop:"240x240+0+0").processed
    rescue ActiveStorage::FileNotFoundError => e
      'unknown.png'
    rescue ActiveStorage::InvariableError => e
      'unknown.png'
    end
  end

  def display_avatar_middle(user)
    begin
      user.avatar.variant(gravity: :center, resize:"120x120^", crop:"120x120+0+0").processed
    rescue ActiveStorage::FileNotFoundError => e
      'unknown.png'
    rescue ActiveStorage::InvariableError => e
      'unknown.png'
    end
  end

  def display_avatar_small(user)
    begin
      user.avatar.variant(gravity: :center, resize:"80x80^", crop:"80x80+0+0").processed
    rescue ActiveStorage::FileNotFoundError => e
      'unknown.png'
    rescue ActiveStorage::InvariableError => e
      'unknown.png'
    end
  end
end
