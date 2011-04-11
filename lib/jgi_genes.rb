require 'bio'







# 
class JgiGenesGff
  
  # 
  def initialize(path)
    @jgi_file = File.open(path, "r")
    @next_gff = read_record
  end
  
  # Return a enhanced_gene object or nil if none exists
  def next_gene
    # Parse the first line into data structures for current gene
    cur = @next_gff
    if !cur
      return nil
    end
    
    # Make sure the assumption that the first one is an exon is true
    if cur.feature==='exon'
      seqname = cur.seqname
      strand = cur.strand
      source = cur.source
      name = parse_name(cur.attributes)
      
      f = Bio::Location.new
      f.from = cur.start
      f.to = cur.end
      exons = [f]
      cds = []
      protein_id = nil #Unknown until we have a CDS line in the file
      
      # Continue reading until finished gene or finished file
      finished_gene = false
      while !finished_gene and (cur = read_record)
        
        
        # if still in the same gene
        if parse_name(cur.attributes) === name
          if cur.strand != strand or cur.seqname != seqname or cur.source != source
            puts "EXCEPTION !!!!!!!!!!!!!!!!!!!"
            raise Exception, 'Data bug in JGI file or parsing is being done incorrectly'
          end
          f = Bio::Location.new
          f.from = cur.start
          f.to = cur.end
          case cur.feature
          when 'exon'
            exons.push f
          when 'CDS'
            cds.push f
            protein_id = parse_protein_id(cur.attributes)
          when 'start_codon' #meh
          when 'stop_codon'
          else
            puts "EXCEPTION !!!!!!!!!!!!!!!!!!!"
            raise Exception, "Unknown feature type #{cur.feature} found."
          end
        else 
          finished_gene = true
        end
      end
      
      #make ready for the next gene
      @next_gff = cur
      
      #create a new positioned gene with the useful characteristics
      #      puts "Returning gene:"
      #      p exons.length
      #      p cds.length
      g = PositionedGene.new
      g.seqname = seqname
      g.name = name
      g.strand = strand
      g.start = exons[0].from
      g.exons = exons
      g.cds = cds
      g.protein_id = protein_id
      return g
    else
      p cur.feature
      # I'm not sure if this is detrimental or not, but to be safe..
      raise Exception, "Assumption failed: exon is not first feature in the gene"
    end
    
  end
  
  def distance_iterator
    return JgiGenesIterator.new(self)
  end
  
  private
  # Read a line from the file, and create the next gff object,
  # or nil if none exists
  def read_record
    line = ""
      
    while line.lstrip.rstrip.empty?
      line = @jgi_file.gets
      if !line
        return nil
      end
    end
    
    
    whole = JgiGffRecord.new(line)
    return whole
  end
  
  
  # Return the name of the gene, given the attributes hash
  def parse_name(attributes)
    name = attributes['name'].gsub('"','')
    return name
  end
  
  
  def parse_protein_id(attributes)
    return attributes['proteinId'].to_i
  end
end



# A gene as read from the gff file.
# cds and exons are assumed to be in increasing order in terms of their 
# positions
# along the positive strand.
class PositionedGene
  attr_accessor :seqname, :name, :strand, :start, :exons, :cds, :protein_id
  
  # Return the position of the cds end
  def cds_start
    # If gene has no coding regions, I guess
    if !@cds[0]
      return nil
    end
    return @cds[0].from
  end
  
  def cds_end
    # If gene has no coding regions, I guess
    if !@cds[@cds.length-1]
      return nil
    end
    return @cds[@cds.length-1].to
  end
  
  def positive_strand?
    return @strand === '+'
  end
end





# Fixes up JGI to GFF problems. I don't mean to blame anyone but
# they just don't seem to go together
class JgiGffRecord < Bio::GFF::Record
  
  SEQNAME_COL = 0
  SOURCE_COL = 1
  FEATURE_COL = 2
  START_COL = 3
  END_COL = 4
  SCORE_COL = 5
  STRAND_COL = 6
  FRAME_COL = 7
  ATTRIBUTES_COL = 8
  
  def initialize(line)
    @line = line
    
    parts = line.split("\t");
    if parts.length != 9 and parts.length != 8
      raise Exception, "Badly formatted GFF line - doesn't have correct number of components '#{line}"
    end

    
    parse_mandatory_columns(parts)
    
    parse_attributes(parts[ATTRIBUTES_COL])
    
  end
  
  
  # Given an array of 8 strings, parse the columns into something
  # that can be understood by this object
  def parse_mandatory_columns(parts)
    @seqname = parts[SEQNAME_COL]
    @source = parts[SOURCE_COL]
    @feature = parts[FEATURE_COL]
    @start = parts[START_COL]
    @end = parts[END_COL]
    @score = parts[SCORE_COL]
    @strand = parts[STRAND_COL]
    @frame = parts[FRAME_COL]
  end
  
  
  # parse the last part of a line into a hash contained in attributes
  # global variable
  def parse_attributes(attribute_string)
    @attributes = Hash.new #define empty attributes even if there are none
    
    if attribute_string
      #let the fancy parsing begin
      aparts = attribute_string.split '; '
      
      aparts.each do |bit|
        hbits = bit.split ' '
        if !hbits or hbits.length != 2
          raise Exception, "Failed to parse attributes in line: #{line}"
        end
        str = hbits[1].gsub(/\"/, '').rstrip.lstrip
        @attributes[hbits[0]] = str
      end
    end
  end
  
  
  def to_s
    @line
  end
end





class JgiGenesIterator
  
  
  def initialize(jgiGenesGffObj)
    @genbank = jgiGenesGffObj
    
    # Setup cycle for iterator
    @cur_gene = @genbank.next_gene
    @next_gene = @genbank.next_gene
    @next_is_first = true
  end
  
  def has_next_distance
    return !@next_gene.nil?
  end
  
  # Return the next gene to be worked on
  def next_gene
    return @cur_gene
  end
  
  # Return the upstream distance between one gene and another
  def next_distance
    # if the first gene in the list
    if @next_is_first
      # cycle has already been setup in initialisation
      @next_is_first = false;
    else
      #cycle through things
      if !@cur_gene #if nothing is found
        raise Exception, 'Unexpected nil cur_gene - a software coding error?'
      end
      @prev_gene = @cur_gene
      @cur_gene = @next_gene
      @next_gene = @genbank.next_gene
    end
    
    if !@cur_gene
      raise Exception, 'Overrun iterator - no more genes available. Use has_next_distance'
    end
    
    
    
    # We look at the current gene, and return its upstream distance
    if @cur_gene.positive_strand?
      # so we want the distance between cur and last then
      
      # if last gene undefined or on a different scaffold, return nothing
      if !@prev_gene or @prev_gene.seqname != @cur_gene.seqname
        return nil
      end
      return @cur_gene.cds_start.to_i - @prev_gene.cds_end.to_i
    else
      if !@next_gene or @next_gene.seqname != @cur_gene.seqname
        return nil
      end
      return @next_gene.cds_start.to_i - @cur_gene.cds_end.to_i
    end
    
  end
  
end