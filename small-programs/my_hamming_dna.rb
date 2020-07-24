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