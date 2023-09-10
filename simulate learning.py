import matplotlib.pyplot as plt

def compound_interest_with_contributions(P, r, PMT, t):
    return P*(1 + r)**t + PMT*((1 + r)**t - 1)/r

def wealth_accumulation(r, PMT, years):
    P = 0
    accumulation = []
    for year in years:
        P = compound_interest_with_contributions(P, r, PMT, 1)
        accumulation.append(P)
    return accumulation

# Parameters
r = 0.08  # Annual interest rate
PMT = 6500  # Annual contribution

# Calculate wealth accumulation
years_25_to_65 = list(range(24, 66))
years_31_to_65 = list(range(31, 66))

wealth_24_start = wealth_accumulation(r, PMT, years_25_to_65)
wealth_31_start = [0]*(31-24) + wealth_accumulation(r, PMT, years_31_to_65)

# Plot
plt.figure(figsize=(10, 6))
plt.plot(years_25_to_65, wealth_24_start, label='Start at 24', color='blue')
plt.plot(years_25_to_65, wealth_31_start, label='Start at 31', color='red')

# Add wealth values at the tip of each line
plt.annotate(f"${wealth_24_start[-1]:,.2f}", 
             (years_25_to_65[-1], wealth_24_start[-1]), 
             textcoords="offset points", 
             xytext=(0,10),
             ha='center')
plt.annotate(f"${wealth_31_start[-1]:,.2f}", 
             (years_25_to_65[-1], wealth_31_start[-1]), 
             textcoords="offset points", 
             xytext=(0,10),
             ha='center')

plt.xlabel('Age')
plt.ylabel('Wealth Accumulated ($)')
plt.title('Wealth Accumulation Over Time with Compound Interest')
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()
