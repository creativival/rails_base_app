module UsersHelper

  def display_avatar_large(user)
    begin
      user.avatar.variant(resize_to_fill: [240, 240]).processed
    rescue ActiveStorage::FileNotFoundError => e
      '/unknown/icon240.png'
    rescue ActiveStorage::InvariableError => e
      '/unknown/icon240.png'
    end
  end

  def display_avatar_middle(user)
    begin
      user.avatar.variant(resize_to_fill: [120, 120]).processed
    rescue ActiveStorage::FileNotFoundError => e
      '/unknown/icon120.png'
    rescue ActiveStorage::InvariableError => e
      '/unknown/icon120.png'
    end
  end

  def display_avatar_small(user)
    begin
      user.avatar.variant(resize_to_fill: [80, 80]).processed
    rescue ActiveStorage::FileNotFoundError => e
      '/unknown/icon80.png'
    rescue ActiveStorage::InvariableError => e
      '/unknown/icon80.png'
    end
  end
end
