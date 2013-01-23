require 'sinatra'
require 'psych'

class XFiles < Sinatra::Base
  get'/' do
    'The truth is out there...'
  end

  get '/episodes/search' do
    episode = XFilesEpisode.find_by_name(params[:name])

    if episode
      redirect "/episodes/#{episode['id']}/next"
    else
      status 404
      redirect "/404"
    end
  end

  get '/episodes/:id/next' do
    XFilesEpisode.find_by_id(params[:id])["next"]
  end
end

class XFilesEpisode
  def self.find_by_name(name)
    Psych.load_file('episodes.yml')[name.downcase]
  end

  def self.find_by_id(id)
    Psych.load_file('episodes.yml').select { |name, episode|
      episode['id'] == id.to_i
    }.first[1]
  end
end