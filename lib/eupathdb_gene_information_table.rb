
class EuPathDBGeneInformationTable
  include Enumerable

  def initialize(io)
    @io = io
  end

  def each
    while g = next_gene
      yield g
    end
  end

  # Returns a EuPathDBGeneInformation object with all the data you could
  # possibly want.
  def next_gene
    info = EuPathDBGeneInformation.new

    # first, read the table, which should start with the ID column
    line = @io.readline.strip
    while line == ''
      return nil if @io.eof?
      line = @io.readline.strip
    end

    while line != ''
      if matches = line.match(/^(.*?)\: (.*)$/)
        info.add_information(matches[1], matches[2])
      else
        raise Exception, "EuPathDBGeneInformationTable Couldn't parse this line: #{line}"
      end
      
      line = @io.readline.strip
    end

    # now read each of the tables, which should start with the
    # 'TABLE: <name>' entry
    line = @io.readline.strip
    table_name = nil
    headers = nil
    data = []
    while line != '------------------------------------------------------------'
      if line == ''
        # add it to the stack unless we are just starting out
        info.add_table(table_name, headers, data) unless table_name.nil?

        # reset things
        table_name = nil
        headers = nil
        data = []
      elsif matches = line.match(/^TABLE\: (.*)$/)
        # name of a table
        table_name = matches[1]
      elsif line.match(/^\[.*\]/)
        # headings of the table
        headers = line.split("\t").collect do |header|
          header.gsub(/^\[/,'').gsub(/\]$/,'')
        end
      else
        # a proper data row
        data.push line.split("\t")
      end
      line = @io.readline.strip
    end

    # return the object that has been created
    return info
  end
end

class EuPathDBGeneInformation
  def info
    @info
  end

  def get_info(key)
    @info[key]
  end
  alias_method :[], :get_info

  def get_table(table_name)
    @tables[table_name]
  end

  def add_information(key, value)
    @info ||= {}
    @info[key] = value
    "Added info #{key}, now is #{@info[key]}"
  end

  def add_table(name, headers, data)
    @tables ||= {}
    @tables[name] = []
    data.each do |row|
      final = {}
      row.each_with_index do |cell, i|
        final[headers[i]] = cell
      end
      @tables[name].push final
    end
  end
end
