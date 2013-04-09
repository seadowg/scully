require 'sinatra'
require 'psych'
require 'json'

class XFiles < Sinatra::Base
  set :public_folder, 'public'
  
  get'/' do
    File.read(File.join('public', 'index.html'))
  end

  get '/episodes/search' do
    episode = XFilesEpisode.find_by_name(params[:name])

    content_type :json
    
    if episode
      { :episode => episode['next'] }.to_json
    else
      redirect "/404"
    end
  end

  get '/404' do
    redirect 'http://www.fbi.gov'
  end
  
  not_found do
    redirect '/404'
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