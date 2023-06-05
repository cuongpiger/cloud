from typing import List

original_array = []
T = 0

def solve(candidate_array: List[int], original_idx: int) -> int:
    sm: int = sum(candidate_array)
    if sm > T:
        return -1
    
    if sm == T:
        return 1
    
    new_candidate: List[int] = candidate_array + 
    
    
    