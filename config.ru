configure :production do
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://ggcennoctzrruk:ueFg4ZVGq-Y9lPQMb0QRlmoSZL@ec2-54-221-255-192.compute-1.amazonaws.com:5432/d72fe54392av9j')

  ActiveRecord::Base.establish_connection(
      :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8'
  )
end