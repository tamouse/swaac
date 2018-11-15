# frozen_string_literal: true

require 'yaml'
require 'erb'
require 'time'
require 'logger'
require 'fileutils'

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

desc "prepare for publishing"
task prep: [:build_indexes, :mkfeed]

desc 'build indexes at each level in the tree'
task :build_indexes do
  Dir.chdir('posts') do |postsDir|
    File.write(
      'index.org',
      Dir['**/*.org']
        .sort
        .reverse
        .uniq
        .reject { |f| f.match(%r{index.org}) }
        .map { |f| "- [[./#{f}]]" }
        .join("\n")
    )

  end


  Dir['posts/*/'].each do |year|
    Dir.chdir(year) do |dir|
      logger.debug "In dir #{dir}"
      File.write(
        'index.org',
        Dir['./**/*.org']
          .sort
          .reverse
          .uniq
          .reject {|f| f.match(%r{index.org}) }
          .map { |f| "- [[#{f}]]".tap { |l| logger.debug "link: #{l}" } }
          .join("\n")
      )
    end
  end

  # don't need indexes for the leaf directories

end

desc 'create atom feed of most recent updates'
task :mkfeed do

  feed = {
    id: "https://github.com/tamouse/swaac",
    title: "Tamouse's Software as a Craft blog",
  }

  posts = Dir['posts/**/*.org'].map do |file|
    { entry: Entry.new(file).entry }
  end.sort_by{|entry| entry[:entry][:updated]}.reverse.take(10)

  feed[:updated] = posts.first[:entry][:updated]
  feed[:entries] = posts
  feed_xml = Feed2Xml.new(feed).xml
  File.write("docs/feed.xml", feed_xml)
  logger.info "Wrote docs/feed.xml"

end

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



class Entry
  attr_accessor :entry

  def initialize(file)
    @entry = {
      id: createid(file),
      updated: moddate(file),
      title: findtitle(file),
      content: getcontent(file),
      author: {
        name: "Tamara Temple",
        email: "tamara@tamouse.org"
      }
    }
  end

  def createid(file)
    "https://github.com/tamouse/swaac/blob/master/#{file}"
  end

  def moddate(file)
    File.mtime(file)
  end

  def findtitle(file)
    lines = getcontent(file).split("\n")
    title = lines.grep(/^#+TITLE/).first.to_s.sub(/^#+TITLE +/, '')
    title = title.empty? ? lines.grep(/^\* /).first.to_s.sub(/^\* +/, '') : title
    title = title.empty? ?  File.basename(file, '.*') : title
    title
  end

  def getcontent(file)
    @contents ||= File.read(file)
  end

end


class Feed2Xml
  attr_reader :feed

  def initialize(feed)
    @feed = feed
  end

  def xml
    header +
      hash2xml(feed, root: "feed")
  end

  def header
    "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
  end

  def hash2xml(h, options={})
    root = options[:root]
    indent = options[:indent] || 0
    out = ""
    if (root)
      out += "#{" "*indent}<#{root == "feed" ? "feed xmlns=\"http://www.w3.org/2005/Atom\"" : root}>\n"
    end

    indent += 2

    h.each do |(k, v)|
      case v
      when Array
        out += array2xml(v, indent: indent, root: k)
      when Hash
        out += hash2xml(v, indent: indent, root: k)
      when Time
        out += "#{" "*indent}<#{k}>#{v.xmlschema}</#{k}>\n"
      else
        out += "#{" "*indent}<#{k}>#{ERB::Util.h(v)}</#{k}>\n"
      end
    end

    indent -= 2

    if (root)
      out += "#{" "*indent}</#{root}>\n"
    end
    out
  end

  def array2xml(a, options={})
    root = options[:root]
    indent = options[:indent]

    out = ""

    a.each do |entry|
      case entry
      when Array
        out += array2xml(entry, indent: indent)
      when Hash
        out += hash2xml(entry, indent: indent)
      when Time
        out += "#{" "*indent}<item>#{Time.xmlschema(entry)}</item>\n"
      else
        out += "#{" "*indent}<item>#{ERB::Util.h(entry)}</item>\n"
      end
    end
    out
  end



end
