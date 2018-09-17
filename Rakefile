# frozen_string_literal: true

require 'logger'
require 'fileutils'

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

desc 'move org files into posts/YYYY/MM/ directories from posts/'
task :move_posts do
  org_posts = Dir['posts/*.org']

  org_posts.each do |post|
    m = post.match(%r{\Aposts\/(\d{4})-(\d{2})-(\d{2})-(.*)\z})
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
end

desc 'build indexes at each level in the tree'
task :build_indexes do
  File.write(
    'posts/index.org',
    Dir['posts/**/*.org', 'posts/**/*.markdown', 'posts/**/*.md']
      .sort
      .uniq
      .reject { |f| f.match(%r{index.org}) }
      .map { |f| "- [[./#{f}]]" }
      .join("\n")
  )

  Dir['posts/*/'].each do |year|
    Dir.chdir(year) do |dir|
      logger.debug "In dir #{dir}"
      File.write(
        'index.org',
        Dir['./**/*.org']
          .sort
          .uniq
          .reject {|f| f.match(%r{index.org}) }
          .map { |f| "- [[#{f}]]".tap { |l| logger.debug "link: #{l}" } }
          .join("\n")
      )
    end
  end

  # don't need indexes for the leaf directories

end
