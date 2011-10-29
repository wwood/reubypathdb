

module Bio
  class EuPathDB
    # Looks like EuPathDB databases have settled on something like
    # >gb|TGME49_000380 | organism=Toxoplasma_gondii_ME49 | product=myb-like DNA binding domain-containing protein | location=TGME49_chrVIII:6835359-6840923(-) | length=1528
    # where the species name differs but the rest is mostly constant
    class FastaParser
      attr_accessor :species_name
      
      # The species name is what should show up in the 2nd bracket, so something
      # like 'Toxoplasma_gondii_ME49' for
      # >gb|TGME49_000380 | organism=Toxoplasma_gondii_ME49 | product=myb-like DNA binding domain-containing protein | location=TGME49_chrVIII:6835359-6840923(-) | length=1528
      # for instance
      def initialize(species_name, filename)
        @species_name = species_name
        @filename = filename
      end
      
      # Enumerate through fasta file entries
      def each
        @flat = Bio::FlatFile.open(Bio::FastaFormat, @filename)
        n = next_entry
        while !n.nil?
          yield n
          n = next_entry
        end
      end

      # Return the entry in the fasta file, or nil if there is no more or the
      # fasta file could not be opened correctly.
      def next_entry
        return nil if !@flat
        n = @flat.next_entry
        return nil if !n
        
        s = parse_name(n.definition)
        s.sequence = n.seq
        return s
      end
      
      def parse_name(definition)
        s = FastaAnnotation.new
        
        regex = /^(\S+)\|(.*?) \| organism=#{@species_name} \| product=(.*?) \| location=(.*) \| length=\d+$/
        matches = definition.match(regex)
        
        if !matches
          raise Exception, "Definition line has unexpected format: `#{definition}'. Trying to match this line to the regular expression `#{regex.inspect}'"
        end
        
        matches2 = matches[4].match(/^(.+?)\:/)
        if !matches2
          raise ParseException, "Definition line has unexpected scaffold format: #{matches[4]}"
        end
        s.sequencing_centre = matches[1]
        s.scaffold = matches2[1]
        s.gene_id = matches[2]
        s.annotation = matches[3]
        return s
      end
    end
    
    class FastaAnnotation
      attr_accessor :gene_id, :sequence, :annotation, :scaffold, :sequencing_centre
    end
    
    class ParseException < Exception; end
  end
end
