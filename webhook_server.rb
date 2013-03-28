require 'rubygems'
require 'sinatra'
require 'active_record'

def generate_license_key
  rand(9999999)  
end

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :dbfile => 'db/test.sqlite3.db'
)

post '/gumroad-webhook' do
  license_key = generate_license_key 
  Entry.create(
    :email       => params[:email],
    :price       => params[:price],
    :license_key => license_key
  )
  "http://www.license-key.com/this-file/#{license_key}"
  rescue => e
    "Error Occured"
  end
end

get '/this-file/:license_key' do |key|
  entry = Entry.find_by_license_key(key)
  return "Invalid Key" unless entry.present?
  send_file('download_file.txt')
  rescue => e
    "Error Occured"
  end
end

class Entry < ActiveRecord::Base
end
