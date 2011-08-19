
# A class dedicated to recording 'administrative' data about the databases, 
# answering questions such as "which species are recorded in ToxoDB?" for instance.
#
# It is also meant for dealing with locally cached version of the files, where
# all the data is stored in a base directory with a specified structure.
#
# TODO: functions for the info and the local caching should probably be separated
# into separate classes, and the directory structure of the local versions shouldn't
# be forced on the user.
class EuPathDBSpeciesData
  @@data = {
    'Plasmodium falciparum' => {
      :name => 'Plasmodium falciparum',
      :source => 'PlasmoDB',
      :fasta_file_species_name => 'Plasmodium_falciparum_3D7',
      :sequencing_centre_abbreviation => 'psu',
      :behind_usage_policy => true,
    },
    'Plasmodium yoelii' => {
      :directory => 'yoelii',
      :name => 'Plasmodium yoelii',
      :sequencing_centre_abbreviation => 'TIGR',
      :fasta_file_species_name => 'Plasmodium_yoelii_yoelii_str._17XNL',
      :proteins_fasta_filename => lambda {|version| "PyoeliiAnnotatedProteins_PlasmoDB-#{version}.fasta"},
      #:transcripts_fasta_filename => lambda {|version| "PyoeliiAllTranscripts_PlasmoDB-#{version}.fasta"},
      :source => 'PlasmoDB'
    },
    'Plasmodium vivax' => {
      :name => 'Plasmodium vivax',
      :sequencing_centre_abbreviation => 'gb',
      :fasta_file_species_name => 'Plasmodium_vivax_SaI-1',
      :proteins_fasta_filename => lambda {|version| "PvivaxAnnotatedProteins_PlasmoDB-#{version}.fasta"},
      :source => 'PlasmoDB'
    },
    'Plasmodium berghei' => {
      :name => 'Plasmodium berghei',
      :sequencing_centre_abbreviation => 'psu',
      :fasta_file_species_name => 'Plasmodium_berghei_str._ANKA',
      :proteins_fasta_filename => lambda {|version| "PbergheiAnnotatedProteins_PlasmoDB-#{version}.fasta"},
      #:transcripts_fasta_filename => lambda {|version| "PbergheiAllTranscripts_PlasmoDB-#{version}.fasta"},
      :source => 'PlasmoDB'
    },
    'Plasmodium chabaudi' => {
      :name => 'Plasmodium chabaudi',
      :sequencing_centre_abbreviation => 'psu',
      :fasta_file_species_name => 'Plasmodium_chabaudi_chabaudi',
      :proteins_fasta_filename => lambda {|version| "PchabaudiAnnotatedProteins_PlasmoDB-#{version}.fasta"},
      :source => 'PlasmoDB',
      :behind_usage_policy => true,
    },
    'Plasmodium knowlesi' => {
      :name => 'Plasmodium knowlesi',
      :sequencing_centre_abbreviation => 'psu',
      :fasta_file_species_name => 'Plasmodium_knowlesi_strain_H',
      :source => 'PlasmoDB',
      :behind_usage_policy => true,
    },
    'Neospora caninum' => {
      :name => 'Neospora caninum',
      :sequencing_centre_abbreviation => 'psu',
      :fasta_file_species_name => 'Neospora_caninum',
      :database_download_folder => 'NeosporaCaninum',
      :proteins_fasta_filename => lambda {|version| "NeosporaCaninumAnnotatedProteins_ToxoDB-#{version}.fasta"},
      :transcripts_fasta_filename => lambda {|version| "NeosporaCaninumAnnotatedTranscripts_ToxoDB-#{version}.fasta"},
      :source => 'ToxoDB',
      :behind_usage_policy => true,
    },
    'Eimeria tenella' => {
      :name => 'Eimeria tenella',
      :sequencing_centre_abbreviation => 'GeneDB',
      :fasta_file_species_name => 'EtenellaHoughton',
      :source => 'ToxoDB',
      :database_download_folder => 'EtenellaHoughton',
      :behind_usage_policy => true,
    },
    'Toxoplasma gondii' => {
      :name => 'Toxoplasma gondii',
      :sequencing_centre_abbreviation => 'gb',
      :fasta_file_species_name => 'Toxoplasma_gondii_ME49',
      :database_download_folder => 'TgondiiME49',
      :gene_information_filename => lambda {|version| "TgondiiME49Gene_ToxoDB-#{version}.txt"},
      :proteins_fasta_filename => lambda {|version| "TgondiiME49AnnotatedProteins_ToxoDB-#{version}.fasta"},
      :transcripts_fasta_filename => lambda {|version| "TgondiiME49AnnotatedTranscripts_ToxoDB-#{version}.fasta"},
      :gff_filename => lambda {|version| "TgondiiME49_ToxoDB-#{version}.gff"},
      :genomic_fasta_filename => lambda {|version| "TgondiiME49Genomic_ToxoDB-#{version}.fasta"},
      :source => 'ToxoDB'
    },
    'Cryptosporidium parvum' => {
      :name => 'Cryptosporidium parvum',
      :sequencing_centre_abbreviation => 'gb',
      :fasta_file_species_name => 'Cryptosporidium_parvum',
      :proteins_fasta_filename => lambda {|version| "CparvumAnnotatedProteins_CryptoDB-#{version}.fasta"},
      :transcripts_fasta_filename => lambda {|version| "CparvumAnnotatedTranscripts_CryptoDB-#{version}.fasta"},
      #:gff_filename => lambda {|version| "c_parvum_iowa_ii.gff"}, #changed as of version 4.3
      :source => 'CryptoDB'
    },
    'Cryptosporidium hominis' => {
      :name => 'Cryptosporidium hominis',
      :sequencing_centre_abbreviation => 'gb',
      :fasta_file_species_name => 'Cryptosporidium_hominis',
      :proteins_fasta_filename => lambda {|version| "ChominisAnnotatedProteins_CryptoDB-#{version}.fasta"},
      :transcripts_fasta_filename => lambda {|version| "ChominisAnnotatedTranscripts_CryptoDB-#{version}.fasta"},
      #:gff_filename => lambda {|version| "c_hominis_tu502.gff"}, #changed as of version 4.3
      :source => 'CryptoDB'
    },
    'Cryptosporidium muris' => {
      :name => 'Cryptosporidium muris',
      :sequencing_centre_abbreviation => 'gb',
      :fasta_file_species_name => 'Cryptosporidium_muris',
      :proteins_fasta_filename => lambda {|version| "CmurisAnnotatedProteins_CryptoDB-#{version}.fasta"},
      :transcripts_fasta_filename => lambda {|version| "CmurisAnnotatedTranscripts_CryptoDB-#{version}.fasta"},
      #:gff_filename => lambda {|version| "c_muris.gff"}, #changed as of version 4.3
      :source => 'CryptoDB'
    },
    
    'Theileria annulata' => {
      :name => 'Theileria annulata',
      :database_download_folder => 'TannulataAnkara',
      :sequencing_centre_abbreviation => 'Genbank',
      :fasta_file_species_name => 'Theileria_annulata_strain_Ankara',
      :source => 'PiroplasmaDB',
    },
    'Theileria parva' => {
      :name => 'Theileria parva',
      :database_download_folder => 'TparvaMuguga',  
      :sequencing_centre_abbreviation => 'Genbank',
      :fasta_file_species_name => 'Theileria_parva_strain_Muguga',
      :source => 'PiroplasmaDB', 
    },
    'Babesia bovis' => {
      :name => 'Babesia bovis',
      :database_download_folder => 'BbovisT2Bo',
      :sequencing_centre_abbreviation => 'Genbank',
      :fasta_file_species_name => 'Babesia_bovis_T2Bo',
      :source => 'PiroplasmaDB',
    },
  }
  # Duplicate so both the species name and genus-species name work
  @@data.keys.each do |key|
    # name is full name of the species by default
    @@data[key][:name] ||= key
    
    # the species name without genus can also be used
    splits = key.split(' ')
    raise unless splits.length == 2
    raise if @@data[splits[1]]
    @@data[splits[1]] = @@data[key]
  end
  
  SOURCE_VERSIONS = {
    'PlasmoDB' => '7.2',#
    'ToxoDB' => '6.4',#'7.0',#
    'CryptoDB' => '4.4',#'4.5',#
    'PiroplasmaDB' => '1.0',#'1.1',#
  }
  DATABASES = SOURCE_VERSIONS.keys
  
  # Create a new object about one particular species. The species can be specified 
  # by a nickname, which is either the full binomal name of the specie e.g. 
  # "Plasmodium falciparum", or by simply the second part (the species name without
  # the genus name) e.g. 'falciparum'.
  #
  # base_data_directory is the directory where locally cached version of the downloaded
  # files are stored.
  def initialize(nickname, base_data_directory=nil)
    @species_data = @@data[nickname] # try the full name
    @species_data ||= @@data[nickname.capitalize.gsub('_',' ')] #try replacing underscores
    if @species_data.nil? # try using just the second word
      splits = nickname.split(' ')
      if splits.length == 2
        @species_data = @@data[splits[1]]
      end
    end
    
    @base_data_directory = base_data_directory
    
    raise Exception, "Couldn't find species data for #{nickname}" unless @species_data
  end
  
  def method_missing(symbol)
    answer = @species_data[symbol]
    return answer unless answer.nil?
    super
  end
  
  # The path to the EuPathDB gene information table (stored as a gzip)
  def gene_information_gzfile_path
    "#{local_download_directory}/#{gene_information_gzfile_filename}"
  end
  
  # The path to the EuPathDB gene information table (stored as a gzip)
  def gene_information_gzfile_filename
    "#{gene_information_filename}.gz"
  end  
  
  def gene_information_path
    "#{local_download_directory}/#{gene_information_filename}"
  end
  
  def gene_information_filename
    f = @species_data[:gene_information_filename]
    if f
      "#{f.call(version)}"
    else
      # TgondiiME49Gene_ToxoDB-5.2.txt.gz
      # PfalciparumGene_PlasmoDB-6.1.txt.gz
      "#{one_word_name}Gene_#{database}-#{version}.txt"
    end
  end
  
  def version
    SOURCE_VERSIONS[@species_data[:source]]
  end
  
  def protein_fasta_filename
    if @species_data[:proteins_fasta_filename]
      return "#{@species_data[:proteins_fasta_filename].call(version)}"
    else
      return "#{one_word_name}AnnotatedProteins_#{database}-#{version}.fasta"
    end
  end
  
  def protein_fasta_path
    return File.join(local_download_directory,protein_fasta_filename)
  end

  def protein_blast_database_path
    "/blastdb/#{protein_fasta_filename}"
  end
  
  def transcript_fasta_filename
    if @species_data[:transcripts_fasta_filename]
      return "#{@species_data[:transcripts_fasta_filename].call(version)}"
    else
      return "#{one_word_name}AnnotatedTranscripts_#{database}-#{version}.fasta"
    end
  end
  
  def transcript_fasta_path
    File.join(local_download_directory,transcript_fasta_filename)
  end
  
  def genomic_fasta_filename
    genomic = @species_data[:genomic_fasta_filename]
    if genomic
      return "#{genomic.call(version)}"
    else
      return "#{one_word_name}Genomic_#{database}-#{version}.fasta"
    end
  end
  
  def gff_filename
    if @species_data[:gff_filename]
      return @species_data[:gff_filename].call(version)
    else
      return "#{one_word_name}_#{database}-#{version}.gff"
    end
  end
  
  def gff_path
    File.join(local_download_directory,gff_filename)
  end
  
  def database
    @species_data[:source]
  end
  
  def eu_path_db_download_directory
    directories = {
      'PlasmoDB' => "http://plasmodb.org/common/downloads/release-#{SOURCE_VERSIONS['PlasmoDB']}",
      'ToxoDB' => "http://toxodb.org/common/downloads/release-#{SOURCE_VERSIONS['ToxoDB']}",
      'CryptoDB' => "http://cryptodb.org/common/downloads/release-#{SOURCE_VERSIONS['CryptoDB']}",
      'PiroplasmaDB' => "http://piroplasmadb.org/common/downloads/release-#{SOURCE_VERSIONS['PiroplasmaDB']}",
    }
    return "#{directories[database]}/#{one_word_name}"
  end
  
  def eu_path_db_fasta_download_directory
    path = "#{eu_path_db_download_directory}/fasta"
    path = "#{path}/data" if @species_data[:behind_usage_policy]
    path
  end
    
  def eu_path_db_gff_download_directory
    path = "#{eu_path_db_download_directory}/gff"
    path = "#{path}/data" if @species_data[:behind_usage_policy]
    path
  end
    
  def eu_path_db_txt_download_directory
    path = "#{eu_path_db_download_directory}/txt"
    path = "#{path}/data" if @species_data[:behind_usage_policy]
    path
  end
  
  # Plasmodium chabaudi => Pchabaudi
  def one_word_name
    return @species_data[:database_download_folder] unless @species_data[:database_download_folder].nil?
    splits = @species_data[:name].split(' ')
    raise unless splits.length == 2
    return "#{splits[0][0..0]}#{splits[1]}"
  end
  
  def local_download_directory
    s = @species_data
    "#{@base_data_directory}/#{s[:name]}/genome/#{s[:source]}/#{SOURCE_VERSIONS[s[:source]]}"
  end
  
  # an array of directory names. mkdir is called on each of them in order,
  # otherwise mkdir throws errors because there isn't sufficient folders
  # to build on.
  def directories_for_mkdir
    s = @species_data
    components = [
      @base_data_directory,
    s[:name],
      'genome',
    s[:source],
    SOURCE_VERSIONS[s[:source]]
    ]
    
     (0..components.length-1).collect do |i|
      components[0..i].join('/')
    end
  end
  
  # Return a list of the species names that are included in the EuPathDB database
  def self.species_data_from_database(database_name)
    species = @@data.select {|name, info|
    info[:source].downcase == database_name.downcase
    }
    species.collect do |name_info|
      SpeciesData.new(name_info[0])
    end
  end
end
