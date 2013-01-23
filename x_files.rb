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
      redirect "/404"
    end
  end

  get '/episodes/:id/next' do
    episode = XFilesEpisode.find_by_id(params[:id])

    if episode
      episode['next']
    else
      redirect "/404"
    end
  end

  get '/404' do
    redirect 'http://www.fbi.gov'
  end
end

class XFilesEpisode
  def self.find_by_name(name)
    Psych.load_file('episodes.yml')[name.downcase]
  end

  def self.find_by_id(id)
    result = Psych.load_file('episodes.yml').select { |name, episode|
      episode['id'] == id.to_i
    }

    if result.length > 0
      result.first[1]
    else
      nil
    end
  end
end