# Calculate the Hamming difference between two DNA strands.

# A mutation is simply a mistake that occurs during the creation or
# copying of a nucleic acid, in particular DNA. Because nucleic acids are
# vital to cellular functions, mutations tend to cause a ripple effect
# throughout the cell. Although mutations are technically mistakes, a very
# rare mutation may equip the cell with a beneficial attribute. In fact,
# the macro effects of evolution are attributable by the accumulated
# result of beneficial microscopic mutations over many generations.

# The simplest and most common type of nucleic acid mutation is a point
# mutation, which replaces one base with another at a single nucleotide.

# By counting the number of differences between two homologous DNA strands
# taken from different genomes with a common ancestor, we get a measure of
# the minimum number of point mutations that could have occurred on the
# evolutionary path between the two strands.

# This is called the 'Hamming distance'.

# It is found by comparing two DNA strands and counting how many of the
# nucleotides are different from their equivalent in the other string.

# GAGCCTACTAACGGGAT
# CATCGTAATGACGGCCT
# ^ ^ ^  ^ ^    ^^

# The Hamming distance between these two DNA strands is 7.

# Your function will return an integer
# Given 2 strings with the exact number of characters, count how many characters are different at the same position. if they don't share the exact number of characters, return -1.
# if the two arguments are not the same size, you will return -1

def my_hamming_dna(dna_1, dna_2)
  hammingDistance = 0
  if dna_1.length == dna_2.length
    i = 0
    while dna_1[i]
      if dna_1[i] != dna_2[i]
        hammingDistance += 1
      end
      i += 1
    end
  else
    return -1
  end
  return hammingDistance
end

# puts hamming_dna("GGACTGA", "GGACTGA")
# puts hamming_dna("ACCAGGG", "ACTATGG")
# puts hamming_dna("GGACGGATTCTG", "AGG")
# puts hamming_dna("", "")