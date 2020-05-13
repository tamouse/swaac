#!/usr/bin/env ruby
require "pathname"
require "fileutils"
require "csv"
require "pry"
require "awesome_print"
def new_filename(filename)
  oldname = Pathname.new(filename)
  basename = oldname.basename
  if basename.to_s.end_with? '.org.markdown'
    basename = basename.to_s.sub(%r{\.org.markdown\z}, '.md')
  end
  basename
end

def creation_date(filename)
  filepath = Pathname.new(filename)
  dirname = filepath.dirname.to_s
  basename = filepath.basename.to_s
  full_date = /\A(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/.match(basename)
  if !full_date.nil? && full_date.named_captures === Hash
    full_date["day"] = "01" unless full_date.has_key?("day")
  else
    full_date = { "year" => "", "month" => "", "day" => "01"}
    year, month = dirname.split("/")
    full_date["year"] = year.nil? || year == '.' ? "2020" : year
    full_date["month"] = month.nil? ? "01" : month
  end
  full_date = full_date.map do |k, v|
    [k.to_sym, v.to_i]
  end.to_h
  Time.utc(full_date[:year], full_date[:month], full_date[:day]).strftime("%F")
rescue ArgumentError => e
  ap({ filename: filename, dirname: dirname, basename: basename, full_date: full_date })
  raise e  
end

def post_title(filename)
  filename.gsub(/[^[:alnum:]]+/, " ")
end


def rename_file(source, target)
  FileUtils.cp(source, "#{dest_dir}/#{target}")
end

def dest_dir
  @dest_dir ||= ARGV.first
end

def files
  @files ||= ARGV[1..-1]
end

def big_move(csv_file)
  files.each do |file|
    data = {
      "Name" => File.basename(new_filename(file), '.*'),
      "Title" => post_title(file),
      "Create Date" => creation_date(file),
      "Tags" => "",
      "Original Name" => file,
      "Location" => "#{dest_dir}/#{new_filename(file)}"
    }

    ap data
    csv_file.add_row(data.values)
    puts "Renaming #{file} to #{dest_dir}/#{new_filename(file)}"
    rename_file(file, new_filename(file))
  end
end

def run
  csv_file = "#{dest_dir}.csv"
  ap csv_file
  CSV.open(csv_file, "wb") do |csv|
    csv.add_row(["Name", "Title", "Create Date", "Tags", "Original Name", "Location"])
    big_move(csv)
  end
end

run
