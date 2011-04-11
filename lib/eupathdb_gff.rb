
require 'rubygems'
require 'bio'
require 'jgi_genes'
require 'cgi'

# Unlike JGI genes files, ApiDB files have several differences:
#  - genes on the reverse strand appear in order of their exons, and so
#    the exons are not all in the correct order with respect to the underlying
#    sequence.
class EupathDBGFF < JgiGenesGff
  attr_accessor :features_to_ignore
  
  def initialize(path)
    @file = File.open path, 'r'
    @next_gff = read_record
    @features_to_ignore = [
      'rRNA',
      'tRNA',
      'snRNA',
      'transcript'
    ]
  end
  
  def next_gene
    cur = @next_gff

    if !cur
      return nil
    end
    
    # Ignore the supercontigs at the start of the file
    while ignore_line?(cur) or ignore_record?(cur)
      @next_gff = read_record
      cur = @next_gff
      if !cur
        return nil
      end
    end
    
    if cur.feature != 'gene'
      raise Exception, "Badly parsed apidb line: #{cur}. Expected gene first."
    end
    
    # save line so can set these values later,
    # i
    gene_line = cur
      
      
    # First mRNA
    cur = read_record
    
    if cur.feature != 'mRNA'
      # skip rRNA type genes because they are not relevant
      if ignore_record?(cur)
        # skip forward to the next gene
        while cur.feature != 'gene'
          cur = read_record
          return nil if cur.nil? # we have reached the end on an ignored gene
        end
        @next_gff = cur
        if cur
          return next_gene
        else
          return nil
        end
      else
        raise Exception, "Badly parsed apidb line: #{cur}. Expected mRNA next."
      end
    end
    
    # Setup the gene in itself
    gene = setup_gene_from_first_line gene_line
    
    # setup stuff from mRNA line
    ids = cur.attributes['Ontology_term']
    if ids
      gene.go_identifiers = ids.split ','
    end
    
    # Next CDS
    cur = read_record
    if cur.feature != 'CDS'
      raise Exception, "Badly parsed apidb line: #{cur}. Expected CDS next."
    end
    gene.cds = []
    while cur.feature == 'CDS'
      f = Bio::Location.new
      f.from = cur.start
      f.to = cur.end
      gene.cds.push f
        
      cur = read_record
    end
      
    #next exons
    if cur.feature != 'exon'
      raise Exception, "Badly parsed apidb line: #{cur}. Expected exon next."
    end
    gene.exons = []
    while cur and cur.feature == 'exon'
      f = Bio::Location.new
      f.from = cur.start
      f.to = cur.end
      gene.exons.push f
        
      cur = read_record
    end
      
    @next_gff = cur

    return gene
  end
  
  # ignore this line when parsing the file
  def ignore_line?(cur)
    return ['supercontig', 'introgressed_chromosome_region'].include?(cur.feature)
  end
  
  # Certain things I don't want uploaded, like apicoplast genome, etc.
  def ignore_record?(record)
    if !record or !record.seqname or
        @features_to_ignore.include?(record.feature) or 
        record.seqname.match(/^apidb\|NC\_/) or
        record.seqname.match(/^apidb\|API_IRAB/) or
        record.seqname.match(/^apidb\|M76611/) or
        record.seqname.match(/^apidb\|X95276/) #or
#        record.seqname.match(/^apidb\|Pf/)
      return true
    else
      return false
    end
  end
  
  private
  def read_record
    line = ""
      
    # while blank or comment lines, skip, except for ##Fasta, which
    # means all the genes have already been defined
    while line.lstrip.rstrip.empty? or line.match(/^\#/)

      line = @file.gets

      if !line or line.match(/^\#\#FASTA/)
        return nil
      end
    end
    
    
    whole = EupathDBGFFRecord.new(line)
    return whole
  end
  
  # Given a line describing a gene in an apidb gff file, setup all the
  # stuff associated with the 'gene' line
  def setup_gene_from_first_line(gene_line)
    gene = PositionedGeneWithOntology.new
    gene.start = gene_line.start
    gene.strand = gene_line.strand
    aliai = gene_line.attributes['Alias']
    if aliai
      aliai.chomp!
      gene.alternate_ids = aliai.split ','
    end
    
    # make description proper
    description = gene_line.attributes['description']
    gene.description = CGI::unescape(description) # yey for useful functions I didn't write
    
    # name - remove the 'apidb|' bit
    match = gene_line.attributes['ID'].match('apidb\|(.*)')
    if !match or !match[1] or match[1] === ''
      raise Exception, "Badly parsed gene name: #{gene_line}.attributes['ID']}."
    end
    gene.name = match[1]
    gene.seqname = gene_line.seqname
    
    return gene
  end
end



class EupathDBGFFRecord < JgiGffRecord
  # eg. ID=apidb|X95275;Name=X95275;description=Plasmodium+falciparum+complete+gene+map+of+plastid-like+DNA+%28IR-A%29.
  def parse_attributes(attributes_string)
    @attributes = Hash.new
    parts = attributes_string.split ';'
    if parts
      parts.each {|couple|
        cs = couple.split '='
        #deal with attributes like 'Note=;' by ignoring them
        # I once found one of these in the yeast genome gff
        next if cs.length == 1 and couple.match(/=/)
        if cs.length != 2
          raise Exception, "Badly handled attributes bit in api db gff: '#{cs}' from '#{attributes_string}'"
        end
        @attributes[cs[0]] = cs[1]
      }
    end
  end
end


class PositionedGeneWithOntology < PositionedGene
  attr_accessor :alternate_ids, :description
  attr_writer :go_identifiers
  
  def go_identifiers
    return nil if !@go_identifiers
    return @go_identifiers.sort.uniq
  end
end

