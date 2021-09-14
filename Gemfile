source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
gem 'pry-byebug'
gem 'faker'
gem 'rspec'
