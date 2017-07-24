class CommandRoute
  def self.extract_command(request)
    if text = request.params['text']
      text.split.first
    else
      nil
    end
  end

  def self.matches?(request)
    commands.include? extract_command(request)
  end
end

class MissingContent < CommandRoute
  def self.commands
    ["", nil]
  end
end

class DisplayHelp < CommandRoute
  def self.commands
    ["h", "-h", "help", "i", "info"]
  end
end

