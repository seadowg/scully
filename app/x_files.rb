require 'sinatra'
require 'psych'
require 'json'

class XFiles < Sinatra::Base
  set :public_folder, 'public'
  
  get'/' do
    File.read(File.join('public', 'index.html'))
  end

  get '/episodes/search' do
    content_type :json
    episode = XFilesEpisode.find_by_name(params[:name])
    
    if episode
      { :episode => episode['next'] }.to_json
    else
      404
    end
  end
end

class XFilesEpisode
  def self.find_by_name(name)
    Psych.load_file('./db/episodes.yml')[name.downcase]
  end

  def self.find_by_id(id)
    result = Psych.load_file('./db/episodes.yml').select { |name, episode|
      episode['id'] == id.to_i
    }

    if result.length > 0
      result.first[1]
    else
      nil
    end
  end
end