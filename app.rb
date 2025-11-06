require 'sinatra'
require 'slim'
require 'sinatra/reloader'

get('/') do
    slim(:start)

end

get('/bye') do
    slim(:bye)
    
end