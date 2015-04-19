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
      { :next => episode['next'] }.to_json
    else
      404
    end
  end
end

class XFilesEpisode
  def self.find_by_name(name)
    Psych.load_file('./db/episodes.yml')[name.downcase]
  end
end
