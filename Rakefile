# frozen_string_literal: true

require 'yaml'
require 'logger'
require 'fileutils'

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

desc 'convert markdown files to org with pandoc'
task :pandoc do
  Dir['posts/*.markdown', 'posts/*.md'].each do |file|
    outfile = file.sub(/\.(markdown|md)/, '.org')
    logger.info("Converting #{file} to #{outfile}")
    system "pandoc -s --highlight=zenburn --wrap=none -o #{outfile} #{file}"
  end

end

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

desc 'rewrite markdown so it can be parsed by pandoc'
task :rewrite, :infile do |t, args|
  infile = args[:infile]
  logger.info("processing #{infile}")

  text = File.read(infile)
  FileUtils.mv(infile, "#{infile}.bak")

  (_, fm, body) = text.split(/^---$/m)
  fm_hash = YAML.load(fm)
  fm_hash.delete("layout")
  keywords = (Array(fm_hash.delete("categories")) + Array(fm_hash.delete("tags"))).uniq.sort
  outfile = %Q{# #{fm_hash.delete("title")}

- published date: #{fm_hash.delete("date")}
- keywords: #{keywords}
- source: #{fm_hash.delete("source")}
}
  fm_hash.each do |(k, v)|
    outfile += "- #{k}: #{v}\n"
  end

  outfile += "\n"

  modified_body = body.gsub(/{% highlight (.*?) %}/, '```\1')
                    .gsub(/{% endhighlight %}/, '```')

  outfile += modified_body

  File.write(infile, outfile)
  logger.info("wrote #{infile}")
end
