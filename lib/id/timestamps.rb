module Id::Timestamps
  def self.included(base)
    base.field :created_at
    base.field :updated_at
  end

  def initialize(_data = {})
    now = Time.now
    super ({ created_at: now, updated_at: now }).merge(_data)
  end

  def set(update)
    super update.merge(updated_at: Time.now)
  end

  def unset(update)
    super.set({})
  end

end
