require 'helper'
require 'eupathdb_species_data'

class EuPathDBSpeciesDataTest < Test::Unit::TestCase
  def base_dir
    '/home/ben/phd/data'
  end
  
  def test_method_missing
    spd = EuPathDBSpeciesData.new('Plasmodium yoelii')
    assert_equal 'yoelii', spd.directory
  end
  
  def test_nickname
    spd = EuPathDBSpeciesData.new('Plasmodium yoelii').fasta_file_species_name
    assert_equal spd, EuPathDBSpeciesData.new('yoelii').fasta_file_species_name
    assert_equal spd, EuPathDBSpeciesData.new('P. yoelii').fasta_file_species_name #check for not exactly the last name but close enough
  end
  
  def test_protein_data_path
    spd = EuPathDBSpeciesData.new('Plasmodium yoelii', base_dir)
    assert_equal "/home/ben/phd/data/Plasmodium yoelii/genome/PlasmoDB/#{EuPathDBSpeciesData::SOURCE_VERSIONS['PlasmoDB']}/PyoeliiAnnotatedProteins_PlasmoDB-#{EuPathDBSpeciesData::SOURCE_VERSIONS['PlasmoDB']}.fasta",
    spd.protein_fasta_path
  end
  
  def test_one_word_name
    spd = EuPathDBSpeciesData.new('Plasmodium chabaudi')
    assert_equal 'Pchabaudi', spd.one_word_name
  end
  
  def test_download_directory
    spd = EuPathDBSpeciesData.new('Plasmodium chabaudi')
    assert_equal "http://plasmodb.org/common/downloads/release-#{EuPathDBSpeciesData::SOURCE_VERSIONS['PlasmoDB']}/Pchabaudi", spd.eu_path_db_download_directory
  end
  
  def test_transcript_path_default
    spd = EuPathDBSpeciesData.new('Plasmodium chabaudi', base_dir)
    assert_equal "/home/ben/phd/data/Plasmodium chabaudi/genome/PlasmoDB/#{EuPathDBSpeciesData::SOURCE_VERSIONS['PlasmoDB']}/PchabaudiAnnotatedTranscripts_PlasmoDB-#{EuPathDBSpeciesData::SOURCE_VERSIONS['PlasmoDB']}.fasta",
    spd.transcript_fasta_path
  end
  
  def test_transcript_fasta_filename
    spd = EuPathDBSpeciesData.new('falciparum')
    assert_equal "Pfalciparum_PlasmoDB-#{EuPathDBSpeciesData::SOURCE_VERSIONS['PlasmoDB']}.gff",
    spd.gff_filename
  end
  
  def test_gzfile_path_toxo
    spd = EuPathDBSpeciesData.new('gondii', base_dir)
    assert_equal "/home/ben/phd/data/Toxoplasma gondii/genome/ToxoDB/#{EuPathDBSpeciesData::SOURCE_VERSIONS['ToxoDB']}/TgondiiME49Gene_ToxoDB-#{EuPathDBSpeciesData::SOURCE_VERSIONS['ToxoDB']}.txt.gz",
    spd.gene_information_gzfile_path
  end
  
  def test_gzfile_path_default
    spd = EuPathDBSpeciesData.new('falciparum', base_dir)
    assert_equal "/home/ben/phd/data/Plasmodium falciparum/genome/PlasmoDB/#{EuPathDBSpeciesData::SOURCE_VERSIONS['PlasmoDB']}/PfalciparumGene_PlasmoDB-#{EuPathDBSpeciesData::SOURCE_VERSIONS['PlasmoDB']}.txt.gz",
    spd.gene_information_gzfile_path
  end
  
  def test_gzfile_filename_default
    spd = EuPathDBSpeciesData.new('falciparum')
    assert_equal "PfalciparumGene_PlasmoDB-#{EuPathDBSpeciesData::SOURCE_VERSIONS['PlasmoDB']}.txt.gz",
    spd.gene_information_gzfile_filename
  end
  
  def test_directories_for_mkdir
    spd = EuPathDBSpeciesData.new('gondii', base_dir)
    assert_equal [
      '/home/ben/phd/data',
      '/home/ben/phd/data/Toxoplasma gondii',
      '/home/ben/phd/data/Toxoplasma gondii/genome',
      '/home/ben/phd/data/Toxoplasma gondii/genome/ToxoDB',
      "/home/ben/phd/data/Toxoplasma gondii/genome/ToxoDB/#{EuPathDBSpeciesData::SOURCE_VERSIONS['ToxoDB']}"
    ],
    spd.directories_for_mkdir
  end
  
  def test_one_word_name
    assert_equal 'NeosporaCaninum', EuPathDBSpeciesData.new('Neospora caninum').one_word_name
    spd = EuPathDBSpeciesData.new('Plasmodium falciparum')
    assert_equal 'Pfalciparum', spd.one_word_name
  end
  
  def test_genomic_filename
    spd = EuPathDBSpeciesData.new('falciparum')
    assert_equal "PfalciparumGenomic_PlasmoDB-#{EuPathDBSpeciesData::SOURCE_VERSIONS['PlasmoDB']}.fasta",
    spd.genomic_fasta_filename
  end
  
  def test_transcripts_name_without_block
    spd = EuPathDBSpeciesData.new('Babesia bovis')
    assert_equal "BbovisT2BoAnnotatedTranscripts_PiroplasmaDB-#{EuPathDBSpeciesData::SOURCE_VERSIONS['PiroplasmaDB']}.fasta",
    spd.transcript_fasta_filename
  end
  
  def test_behind_usage_policy
    spd = EuPathDBSpeciesData.new('Plasmodium chabaudi')
    assert_equal "http://plasmodb.org/common/downloads/release-#{EuPathDBSpeciesData::SOURCE_VERSIONS['PlasmoDB']}/Pchabaudi/fasta/data",
    spd.eu_path_db_fasta_download_directory
 end
 
 def test_behind_usage_policy
    spd = EuPathDBSpeciesData.new('Plasmodium vivax')
    assert_equal "http://plasmodb.org/common/downloads/release-#{EuPathDBSpeciesData::SOURCE_VERSIONS['PlasmoDB']}/Pvivax/fasta",
    spd.eu_path_db_fasta_download_directory
 end
end
