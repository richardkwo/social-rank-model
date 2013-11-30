consistent.count <- 0
tie.count <- 0
inconsistent.count <- 0

for (i in 1:(N-1)) {
    for (j in (i+1):N) {
        if (A[i,j]==1 & A[j,i]==0) {
            # i -> j
            if (R.estimate[j]>R.estimate[i]) {
                consistent.count <- consistent.count + 1
            } else {
                inconsistent.count <- inconsistent.count + 1
            }
        } else if (A[j,i]==1 & A[i,j]==0) {
            # j -> i
            if (R.estimate[i]>R.estimate[j]) {
                consistent.count <- consistent.count + 1
            } else {
                inconsistent.count <- inconsistent.count + 1
            }
        }
    }
}


