%%%%% Brief summary:
%%%%% This function converts a nonnegative integer k into its binary representation
%%%%% as a length-N row vector (most significant bit first).
function s = Bin(k, N)
  base = 2.^(N-1:-1:0);
  b = floor(k ./ base);
  s = mod(b, 2);
endfunction

