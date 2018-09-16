#!/usr/bin/env ruby
require "logger"
require "fileutils"

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

ORG_POSTS = Dir['posts/*.org']

ORG_POSTS.each do |post|
  m = post.match(/\Aposts\/(\d{4})-(\d{2})-(\d{2})-(.*)\z/)
  year = m[1]
  month = m[2]
  day = m[3]
  title = m[4]
  logger.debug "post: #{post}, year: #{year}, month: #{month}, day: #{day}, title: #{title}"
  dir = "posts/#{year}/#{month}"
  file = "#{dir}/#{title}"
  logger.debug "dir: #{dir}, file: #{file}"
  FileUtils.mkdir_p(dir)
  FileUtils.cp(post, file, verbose: true)
end
