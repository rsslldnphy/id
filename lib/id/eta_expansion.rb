module Id::EtaExpansion
  def to_proc
    -> data { new data }
  end
end
