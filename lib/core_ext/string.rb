class String
  def titleize
    self.gsub("_", " ").capitalize
  end
end