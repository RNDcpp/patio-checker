class Config
  def self.root_path(path)
    File.expand_path("../#{path}", __FILE__)
  end

  def self.load_yaml(path)
    YAML::load(ERB.new(IO.read(root_path(path))).result)
  end
end
