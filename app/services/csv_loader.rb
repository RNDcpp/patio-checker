require 'csv'
module CsvLoader
  class << self
    def instance(type:, screen_name: nil)
      case type
      when 'twitter'
        TwitterCsv.new(screen_name: screen_name)
      when 'twilog'
        TwilogCsv.new
      else
        raise NotImplementedError
      end
    end
  end

  class Base
    def load_csv(file_name)
      CSV.foreach(file_name, **csv_load_options) do |row|
        begin
          attributes = attributes_from_row(row)
          Tweet.create(attributes)
        rescue ArgumentError => e
          puts e.message
        end
      end
    end

    private

    def attributes_from_row(row)
      raise NotImplementedError
    end

    def csv_load_options
      {}
    end
  end

  class TwitterCsv < Base
    def initialize(screen_name:)
      @user = User.find_or_create_by(name: screen_name)
      super()
    end

    def attributes_from_row(row)
      raise ArgumentError unless row[1]
      raise ArgumentError unless row.length == 5
      
      {user: @user, text: row[2], posted_at: Time.parse(row[1] + '+0900')}
    end

    def csv_load_options
      {headers: true, return_headers: false}
    end
  end

  class TwilogCsv < Base
    def attributes_from_row(row)
      {user: user(row), text: row[1], posted_at: Time.parse(row[2])}
    end
    def user(row)
      if @user && @user.name == row[0]
        @user
      else
        @screen_name = row[0]
        @user = User.find_or_create_by(name: row[0])
      end
    end
  end
end
